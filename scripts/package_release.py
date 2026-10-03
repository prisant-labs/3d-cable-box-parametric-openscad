#!/usr/bin/env python3
"""Assemble release assets into dist/release/ (or --out).

Pulls together everything a release attaches, without touching the things
that produce the inputs (build_bundle.py, build_library.py): this script
only fails loudly when those have not been run, or have gone stale.

Assets written:
  cable-box-parametric.scad       repo root copy, requires BOSL2
  cable-box-parametric.json       all presets' parameter sets, for Customizer
  cable-box-standalone-bundle.zip dist/ bundle + its builtins.scad sidecar(s)
                                   + a short README saying to keep them together
  cable-box-presets.zip           every preset's config.json, notes.md, STLs
                                   (no GLB, no PNG) -- library/index.json is
                                   the manifest, so a preset missing a file
                                   fails the build instead of shipping short
  cable-box-calibration.zip       calibration/config.json, README.md, STLs --
                                   only when calibration/ exists; printed as a
                                   note (not an error) when it does not, since
                                   that directory is built by other work that
                                   may land after this script does

Zips are built byte-for-byte reproducible: entries sorted by name, a fixed
timestamp and permission bits, and a fixed "create system" byte, so that
running this twice against unchanged inputs produces identical files
regardless of iteration order or which OS built them. `ZipFile.write()` is
avoided throughout because it stamps the source file's mtime; every entry
goes in via `writestr()` with an explicit `ZipInfo` instead.

Usage:
  python scripts/package_release.py [--out dist/release]
"""

from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import sys
import zipfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DIST = REPO / "dist"
BUNDLE_NAME = "cable-box-parametric-bundled.scad"

# Fixed so two runs against the same inputs produce byte-identical zips
# regardless of wall-clock time, OS, or which account built them.
ZIP_DATE_TIME = (1980, 1, 1, 0, 0, 0)  # zip's own epoch; earlier is invalid
ZIP_UNIX_FILE = 0o100644 << 16  # regular file, rw-r--r--
ZIP_CREATE_SYSTEM_UNIX = 3


def _human_size(n: float) -> str:
    size = float(n)
    for unit in ("B", "KB", "MB", "GB"):
        if size < 1024 or unit == "GB":
            return f"{size:.0f} {unit}" if unit == "B" else f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} GB"


def sha256_of(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def write_deterministic_zip(zip_path: Path, entries: list[tuple[str, Path | bytes]]) -> None:
    """Write entries (arcname, Path-or-bytes), sorted, with fixed metadata."""
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    ordered = sorted(entries, key=lambda e: e[0])
    with zipfile.ZipFile(zip_path, "w") as zf:
        for arcname, source in ordered:
            data = source.read_bytes() if isinstance(source, Path) else source
            zi = zipfile.ZipInfo(arcname, date_time=ZIP_DATE_TIME)
            zi.compress_type = zipfile.ZIP_DEFLATED
            zi.external_attr = ZIP_UNIX_FILE
            zi.create_system = ZIP_CREATE_SYSTEM_UNIX
            zf.writestr(zi, data)


def add_tree(entries: list[tuple[str, Path | bytes]], prefix: str, files: list[tuple[str, Path]]) -> None:
    """Append (prefix/name, path) pairs to entries, as POSIX arcnames."""
    for name, path in files:
        arcname = (f"{prefix}/{name}" if prefix else name).replace("\\", "/")
        entries.append((arcname, path))


def fail(msg: str) -> "NoReturn":
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def bundle_is_stale(scad_file: Path, bundle_file: Path) -> bool:
    """True if the model source was edited after the bundle was built.

    The bundle's "Model version:" header cannot answer this: an edit that
    leaves Model_Version alone still makes the bundle stale. A build-vs-edit
    mtime comparison catches any edit, and it is cheap.
    """
    try:
        return scad_file.stat().st_mtime > bundle_file.stat().st_mtime
    except OSError:
        return False


def package(repo: Path, out_dir: Path) -> int:
    dist = repo / "dist"

    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True)

    summary: list[tuple[str, int, str]] = []  # name, size, sha256

    def record(path: Path, label: str | None = None) -> None:
        summary.append((label or path.name, path.stat().st_size, sha256_of(path)))

    # --- 1 & 2: plain copies -------------------------------------------
    scad_src = repo / "cable-box-parametric.scad"
    json_src = repo / "cable-box-parametric.json"
    for src in (scad_src, json_src):
        if not src.exists():
            fail(f"{src.relative_to(repo)} not found at repo root")
        dest = out_dir / src.name
        dest.write_bytes(src.read_bytes())
        record(dest)

    # --- 3: standalone bundle zip ---------------------------------------
    bundle = dist / BUNDLE_NAME
    if not bundle.exists():
        fail(
            "standalone bundle not built. Run:\n"
            "  python scripts/build_bundle.py"
        )

    if bundle_is_stale(scad_src, bundle):
        fail(
            f"dist/{BUNDLE_NAME} is older than cable-box-parametric.scad. Rebuild it:\n"
            "  python scripts/build_bundle.py"
        )

    sidecars = sorted(p for p in dist.glob("*.scad") if p.name != BUNDLE_NAME)
    if not sidecars:
        fail(
            f"no sidecar .scad file (e.g. builtins.scad) found next to dist/{BUNDLE_NAME}. "
            "Rebuild the bundle:\n  python scripts/build_bundle.py"
        )

    readme_txt = (
        "cable-box-parametric-bundled.scad needs the sidecar file(s) listed\n"
        "below in THE SAME FOLDER. BOSL2 is inlined into the bundle itself,\n"
        "but these are loaded separately with `use <...>` at render time:\n\n"
        + "\n".join(f"  - {s.name}" for s in sidecars)
        + "\n\nMove the whole folder together, or the bundle will fail to render.\n"
    ).encode("utf-8")

    bundle_entries: list[tuple[str, Path | bytes]] = [
        (BUNDLE_NAME, bundle),
        ("README.txt", readme_txt),
    ]
    for s in sidecars:
        bundle_entries.append((s.name, s))

    bundle_zip = out_dir / "cable-box-standalone-bundle.zip"
    write_deterministic_zip(bundle_zip, bundle_entries)
    record(bundle_zip)

    # --- 4: presets zip ---------------------------------------------------
    index_path = repo / "library" / "index.json"
    if not index_path.exists():
        fail("library/index.json not found")
    index = json.loads(index_path.read_text(encoding="utf-8"))

    preset_entries: list[tuple[str, Path | bytes]] = []
    for preset in index.get("presets", []):
        name = preset["name"]
        pdir = repo / "library" / name
        wanted = [preset["config"]["path"], preset["notes"]["path"]]
        wanted += [part["stl"]["path"] for part in preset.get("parts", [])]
        missing = []
        for rel in wanted:
            p = repo / "library" / rel
            if not p.exists():
                missing.append(f"library/{rel}")
                continue
            preset_entries.append((rel, p))
        if missing:
            fail(f"preset '{name}' is missing files listed in library/index.json: " + ", ".join(missing))
        if not pdir.is_dir():
            fail(f"preset '{name}' has no directory at library/{name}")

    if not preset_entries:
        fail("library/index.json lists no presets")

    presets_zip = out_dir / "cable-box-presets.zip"
    write_deterministic_zip(presets_zip, preset_entries)
    record(presets_zip)

    # --- 5: calibration zip (optional) ------------------------------------
    calib_dir = repo / "calibration"
    if calib_dir.is_dir():
        cfg = calib_dir / "config.json"
        readme = calib_dir / "README.md"
        stl_dir = calib_dir / "stl"
        stls = sorted(stl_dir.glob("*.stl")) if stl_dir.is_dir() else []
        missing = [str(p.relative_to(repo)) for p in (cfg, readme) if not p.exists()]
        if not stls:
            missing.append("calibration/stl/*.stl")
        if missing:
            fail("calibration/ exists but is missing: " + ", ".join(missing))

        calib_entries: list[tuple[str, Path | bytes]] = [
            ("config.json", cfg),
            ("README.md", readme),
        ]
        add_tree(calib_entries, "stl", [(s.name, s) for s in stls])

        calib_zip = out_dir / "cable-box-calibration.zip"
        write_deterministic_zip(calib_zip, calib_entries)
        record(calib_zip)
    else:
        # The coupons are a tracked part of the repository and every release
        # promises them, so a tree without them is a broken checkout.
        fail("calibration/ not found at the repo root; every release attaches "
             "cable-box-calibration.zip")

    # --- summary ------------------------------------------------------
    print(f"\nRelease assets in {out_dir.relative_to(repo) if out_dir.is_relative_to(repo) else out_dir}:")
    name_w = max(len(n) for n, _, _ in summary)
    size_w = max(len(_human_size(s)) for _, s, _ in summary)
    for name, size, digest in summary:
        print(f"  {name:<{name_w}}  {_human_size(size):>{size_w}}  sha256:{digest}")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--out", default=str(REPO / "dist" / "release"))
    args = ap.parse_args()

    out_dir = Path(args.out)
    if not out_dir.is_absolute():
        out_dir = REPO / out_dir

    return package(REPO, out_dir)


if __name__ == "__main__":
    sys.exit(main())
