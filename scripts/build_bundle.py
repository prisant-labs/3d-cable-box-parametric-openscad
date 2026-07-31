#!/usr/bin/env python3
"""Inline the BOSL2 dependency to produce a standalone single-file model.

The repo copy of the model depends on BOSL2, which keeps it reviewable and works
on MakerWorld (which bundles BOSL2 and forbids custom library uploads). But
"download one .scad and open it" is still the workflow most people expect, and
some platforms have no library support at all.

This resolves BOSL2's include graph, concatenates it, and emits a file that
needs nothing installed. Attached to each release.

Usage:
  python scripts/build_bundle.py [--out dist/cable-box-parametric-bundled.scad]
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
# The model includes <BOSL2/std.scad>, but BOSL2's own files include their
# siblings by bare name (include <version.scad>). Match both, and resolve each
# against the including file's directory first.
#
# `use` is deliberately NOT inlined. BOSL2 uses it for exactly one file,
# builtins.scad, which wraps OpenSCAD builtins:
#
#     module _translate(v) translate(v) children();
#
# `use` gives that file its own scope, so `translate` there resolves to the
# BUILTIN. BOSL2's transforms.scad defines its own `translate` that calls
# `_translate`. Inline builtins.scad with `include` and its body starts
# resolving to BOSL2's override instead, producing infinite recursion between
# translate and _translate. A truly single-file bundle is therefore not
# possible; builtins.scad ships alongside, and `use <builtins.scad>` resolves
# relative to the bundle.
INCLUDE_RE = re.compile(r'^\s*include\s*<\s*([^>]+?)\s*>\s*;?\s*$')
USE_RE = re.compile(r'^\s*use\s*<\s*([^>]+?)\s*>\s*;?\s*$')


def library_root() -> Path:
    env = os.environ.get("OPENSCADPATH")
    candidates = []
    if env:
        candidates += [Path(p) for p in env.split(os.pathsep) if p]
    candidates += [
        Path.home() / "Documents" / "OpenSCAD" / "libraries",
        Path.home() / ".local" / "share" / "OpenSCAD" / "libraries",
        Path("/usr/share/openscad/libraries"),
    ]
    for c in candidates:
        if (c / "BOSL2" / "std.scad").exists():
            return c
    sys.exit("BOSL2 not found. Set OPENSCADPATH or install it into your "
             "OpenSCAD libraries folder.")


sidecars: set[Path] = set()


def resolve(ref: str, base: Path, root: Path, seen: set[str], out: list[str]) -> None:
    """Depth-first inline of an include, emitting each file at most once.

    `base` is the directory of the file doing the including, so BOSL2's internal
    bare-name includes resolve correctly. Falls back to the library root so the
    model's own <BOSL2/std.scad> works.
    """
    for cand in (base / ref, root / ref):
        if cand.exists():
            path = cand.resolve()
            break
    else:
        print(f"    warning: {ref} not found, skipping")
        return

    key = str(path)
    if key in seen:
        return
    seen.add(key)

    try:
        label = path.relative_to(root)
    except ValueError:
        label = path.name
    out.append(f"\n// ===== inlined: {label} =====\n")
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        m = INCLUDE_RE.match(line)
        u = USE_RE.match(line)
        if m:
            resolve(m.group(1), path.parent, root, seen, out)
        elif u:
            # Rewrite to a bare relative use; the file is emitted beside the
            # bundle. See the note on USE_RE for why it cannot be inlined.
            name = Path(u.group(1)).name
            sidecars.add((path.parent / u.group(1)).resolve()
                         if (path.parent / u.group(1)).exists()
                         else (root / u.group(1)).resolve())
            out.append(f"use <{name}>")
        else:
            out.append(line)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="dist/cable-box-parametric-bundled.scad")
    args = ap.parse_args()

    root = library_root()
    version = "unknown"
    vf = root / "BOSL2" / "version.scad"
    if vf.exists():
        m = re.search(r"BOSL_VERSION\s*=\s*\[([0-9, ]+)\]", vf.read_text(errors="replace"))
        if m:
            version = ".".join(p.strip() for p in m.group(1).split(","))
    print(f"BOSL2 {version} from {root}")

    model = MODEL.read_text(encoding="utf-8", errors="replace").splitlines()
    model_version = next((l.split('"')[1] for l in model[:80]
                          if l.startswith("Model_Version")), "unknown")

    header = [
        "/*",
        "Parametric Cable Management Box (OpenSCAD) - BUNDLED SINGLE FILE",
        f"Model version: {model_version}",
        "",
        "BOSL2 is inlined, so nothing needs installing. Keep builtins.scad in",
        "the same folder as this file: BOSL2 wraps OpenSCAD's builtins there and",
        "it must stay a separate `use` file or translate/_translate recurse.",
        "",
        "Generated; do not edit. Edit cable-box-parametric.scad in the repository",
        "and regenerate with scripts/build_bundle.py.",
        "",
        "Repository: https://github.com/prisant-labs/3d-cable-box-parametric-openscad",
        "Model license: MIT",
        "",
        f"Bundled: BOSL2 {version}, BSD-2-Clause,",
        "Copyright (c) 2017-2019 Revar Desmera and the BOSL2 contributors.",
        "Upstream: https://github.com/BelfrySCAD/BOSL2",
        "The BOSL2 license text is reproduced at the end of this file.",
        "*/",
        "",
    ]

    body: list[str] = []
    seen: set[str] = set()
    for line in model:
        m = INCLUDE_RE.match(line)
        if m:
            print(f"  inlining {m.group(1)}")
            resolve(m.group(1), MODEL.parent, root, seen, body)
        else:
            body.append(line)

    lic = root / "BOSL2" / "LICENSE"
    tail = []
    if lic.exists():
        tail = ["", "/*", "===== BOSL2 LICENSE (BSD-2-Clause) =====", ""]
        tail += lic.read_text(encoding="utf-8", errors="replace").splitlines()
        tail += ["*/", ""]

    out = Path(args.out)
    if not out.is_absolute():
        out = REPO / out
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(header + body + tail) + "\n", encoding="utf-8")

    # Files pulled in with `use` cannot be inlined (see USE_RE), so they ship
    # beside the bundle and are referenced by bare name.
    for s in sorted(sidecars):
        dest = out.parent / s.name
        dest.write_text(s.read_text(encoding="utf-8", errors="replace"), encoding="utf-8")
        print(f"  sidecar  {dest.relative_to(REPO)} ({dest.stat().st_size/1024:.1f} KB)")

    kb = out.stat().st_size / 1024
    print(f"\n  {len(seen)} BOSL2 files inlined, {len(sidecars)} sidecar(s)")
    print(f"  wrote {out.relative_to(REPO)} ({kb:.0f} KB)")
    if sidecars:
        print("  NOTE: keep the sidecar file(s) in the same folder as the bundle.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
