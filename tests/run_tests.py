#!/usr/bin/env python3
"""Geometry regression harness for cable-box-parametric.scad.

OpenSCAD will happily render geometry that cannot be printed, and return 0 while
doing it. Every defect fixed in v1.1.0 exited 0 with a valid mesh. This harness
exists to catch that class: it asserts on things a successful render does not
guarantee.

Checks per scenario:

  rc       exit code (a scenario may legitimately expect a failure)
  message  assertion text, for scenarios that must fail with a specific message
  solids   number of disconnected solid bodies, parsed from OpenSCAD's
           "Volumes: N" summary (N includes the infinite outer volume, so
           solids = N - 1). This alone catches detached geometry, which is
           invisible in a render and fatal in a slicer.
  clean    no WARNING or DEPRECATED in OpenSCAD's output
  probes   boolean point probes: intersect the exported STL with a small box
           and assert material present or absent at that coordinate

Usage:
  python tests/run_tests.py [--filter SUBSTRING] [--keep] [--verbose]
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SCENARIOS = Path(__file__).resolve().parent / "scenarios.json"
SCAD_SRC = REPO / "cable-box-parametric.scad"

VOLUMES_RE = re.compile(r"Volumes:\s+(\d+)")
SIMPLE_RE = re.compile(r"Simple:\s+(yes|no)")
ASSERT_RE = re.compile(r'failed:\s*"([^"]*)"')


def find_openscad() -> str:
    """Locate the OpenSCAD binary, honouring OPENSCAD_BIN."""
    env = os.environ.get("OPENSCAD_BIN")
    if env and (shutil.which(env) or Path(env).exists()):
        return env
    found = shutil.which("openscad")
    if found:
        return found
    for candidate in (
        r"C:\Program Files\OpenSCAD\openscad.exe",
        r"C:\Program Files\OpenSCAD (Nightly)\openscad.exe",
        "/usr/bin/openscad",
    ):
        if Path(candidate).exists():
            return candidate
    sys.exit("OpenSCAD not found. Set OPENSCAD_BIN or put openscad on PATH.")


def native(path: Path) -> str:
    """Return a path OpenSCAD's import() can resolve.

    OpenSCAD on Windows is a native binary and cannot resolve MSYS-style
    /tmp/... paths. Passing one makes import() silently yield nothing, which
    reads as a passing 'empty' probe. Convert when cygpath is available.
    """
    if sys.platform.startswith("win") or shutil.which("cygpath"):
        try:
            out = subprocess.run(
                ["cygpath", "-m", str(path)], capture_output=True, text=True, timeout=10
            )
            if out.returncode == 0 and out.stdout.strip():
                return out.stdout.strip()
        except (OSError, subprocess.SubprocessError):
            pass
    return str(path)


def render(scad_bin: str, src: Path, out_stl: Path, defines: list[str]) -> tuple[int, str]:
    cmd = [scad_bin, "-o", str(out_stl), str(src)]
    for d in defines:
        cmd += ["-D", d]
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
    return proc.returncode, (proc.stdout or "") + "\n" + (proc.stderr or "")


def report_bosl2(scad_bin: str) -> str:
    """Print which BOSL2 OpenSCAD actually loads, and where from.

    Not decoration. On a Windows machine where Documents is redirected to
    OneDrive, a `git clone` into ~/Documents/OpenSCAD/libraries lands somewhere
    OpenSCAD never looks, while a stale copy under OneDrive keeps being used.
    The result is a full local test run that passes against a different library
    version than CI, and a real bug shipping because the local run was green.
    That happened; hence this.
    """
    probe = Path(tempfile.gettempdir()) / "_bosl2_probe.scad"
    probe.write_text(
        'include <BOSL2/version.scad>\n'
        'echo(str("BOSL2_VERSION_IS ", BOSL_VERSION));\n',
        encoding="utf-8",
    )
    out = subprocess.run([scad_bin, "-o", str(probe.with_suffix(".stl")), str(probe)],
                         capture_output=True, text=True, timeout=120)
    text = (out.stdout or "") + (out.stderr or "")
    m = re.search(r"BOSL2_VERSION_IS \[([0-9, ]+)\]", text)
    version = ".".join(p.strip() for p in m.group(1).split(",")) if m else "unknown"
    # OpenSCAD reports the resolved path in any warning it emits from the library.
    where = ""
    wm = re.search(r"in file (\S*BOSL2[^,\s]*)", text)
    if wm:
        where = f"  from {wm.group(1)}"
    print(f"BOSL2:    {version}{where}")
    if version == "unknown":
        print("          WARNING: could not determine the loaded BOSL2 version.")
        print("          Set OPENSCADPATH to the library folder OpenSCAD should use.")
    return version


def stl_bbox(path: Path) -> list[tuple[float, float]]:
    """Return [(xmin,xmax),(ymin,ymax),(zmin,zmax)] for an ASCII STL."""
    lo = [float("inf")] * 3
    hi = [float("-inf")] * 3
    with path.open(errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("vertex"):
                for i, v in enumerate(map(float, line.split()[1:4])):
                    if v < lo[i]:
                        lo[i] = v
                    if v > hi[i]:
                        hi[i] = v
    if lo[0] == float("inf"):
        raise ValueError("no vertices in STL")
    return [(lo[i], hi[i]) for i in range(3)]


def probe(scad_bin: str, stl: Path, workdir: Path, translate, size) -> str:
    """Return 'material' or 'empty' for a box region of the exported solid."""
    probe_scad = workdir / "_probe.scad"
    probe_out = workdir / "_probe.stl"
    probe_scad.write_text(
        "intersection() {{\n"
        '  import("{stl}", convexity=10);\n'
        "  translate([{tx}, {ty}, {tz}]) cube([{sx}, {sy}, {sz}]);\n"
        "}}\n".format(
            stl=native(stl),
            tx=translate[0], ty=translate[1], tz=translate[2],
            sx=size[0], sy=size[1], sz=size[2],
        ),
        encoding="utf-8",
    )
    rc, out = render(scad_bin, probe_scad, probe_out, [])
    if "Can't open import" in out or "WARNING: Can't open" in out:
        raise RuntimeError(f"probe could not import {stl} (path resolution failed)")
    return "empty" if "top level object is empty" in out.lower() else "material"


def run_scenario(scad_bin: str, sc: dict, workdir: Path, verbose: bool) -> list[str]:
    """Run one scenario. Returns a list of failure strings (empty means pass)."""
    failures: list[str] = []
    expect = sc.get("expect", {})
    stl = workdir / f"{sc['name']}.stl"
    # Most scenarios render the model directly. Anchor tests need a wrapper that
    # includes it as a library and attaches a marker, so they name their own
    # source and pass Render_On_Include=false.
    src = REPO / sc["source"] if "source" in sc else SCAD_SRC
    if not src.exists():
        return [f"source not found: {src}"]
    rc, out = render(scad_bin, src, stl, sc.get("defines", []))

    if verbose:
        print(f"    cmd rc={rc}")

    want_rc = expect.get("rc", 0)
    if rc != want_rc:
        first_err = next((l for l in out.splitlines() if "ERROR" in l), "")
        failures.append(f"exit code {rc}, expected {want_rc}. {first_err[:110]}")
        # A failed render produces no geometry, so downstream checks are moot.
        if want_rc == 0:
            return failures

    # Plain substring match on OpenSCAD's output, for cases that are not
    # assertion failures. `message` deliberately only matches assertion text.
    if "output_contains" in expect:
        if expect["output_contains"] not in out:
            failures.append(f"output does not contain {expect['output_contains']!r}")

    if "message" in expect:
        found = ASSERT_RE.search(out)
        got = found.group(1) if found else ""
        if expect["message"] not in got:
            failures.append(f'assertion message {got!r} does not contain {expect["message"]!r}')

    # Manifoldness. CGAL reports "Simple: no" when the solid has a degeneracy
    # such as a zero-thickness tangency, which a slicer will choke on. This is
    # checked by default because it is cheap and the failure is invisible in a
    # render.
    if expect.get("manifold", True) and rc == 0:
        m = SIMPLE_RE.search(out)
        if m and m.group(1) == "no":
            failures.append("solid is not a valid 2-manifold (CGAL 'Simple: no')")

    if expect.get("clean", True) and rc == 0:
        for bad in ("WARNING", "DEPRECATED"):
            if bad in out:
                line = next((l.strip() for l in out.splitlines() if bad in l), bad)
                failures.append(f"output contains {bad}: {line[:110]}")

    if "solids" in expect:
        m = VOLUMES_RE.search(out)
        if not m:
            failures.append("no 'Volumes:' line in output; cannot count solids")
        else:
            solids = int(m.group(1)) - 1  # exclude the infinite outer volume
            if solids != expect["solids"]:
                failures.append(
                    f"{solids} disconnected solid(s), expected {expect['solids']}"
                    " (extra bodies mean detached geometry)"
                )

    # Bounding box. Solid counts and probes both miss whole-part orientation
    # errors: a clip rotated onto the wrong axis still renders, still fuses, and
    # still passes every point probe not aimed exactly at it. Extents catch it.
    if "bbox" in expect and rc == 0:
        try:
            got = stl_bbox(stl)
        except (OSError, ValueError) as exc:
            failures.append(f"could not read bbox: {exc}")
        else:
            tol = expect.get("bbox_tolerance", 0.05)
            for axis, want in expect["bbox"].items():
                i = "xyz".index(axis)
                for j, edge in enumerate(("min", "max")):
                    if want[j] is None:
                        continue
                    if abs(got[i][j] - want[j]) > tol:
                        failures.append(
                            f"bbox {axis}-{edge} is {got[i][j]:.3f}, expected "
                            f"{want[j]:.3f} (tolerance {tol})")

    for p in expect.get("probes", []):
        if rc != 0:
            break
        try:
            got = probe(scad_bin, stl, workdir, p["translate"], p["size"])
        except RuntimeError as exc:
            failures.append(str(exc))
            break
        if got != p["expect"]:
            failures.append(f"probe {p.get('why', p['translate'])}: {got}, expected {p['expect']}")

    return failures


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--filter", default="", help="only run scenarios whose name contains this")
    ap.add_argument("--keep", action="store_true", help="keep rendered STLs for inspection")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    scad_bin = find_openscad()
    bosl2 = report_bosl2(scad_bin)
    scenarios = json.loads(SCENARIOS.read_text(encoding="utf-8"))["scenarios"]
    if args.filter:
        scenarios = [s for s in scenarios if args.filter in s["name"]]
    if not scenarios:
        sys.exit("no scenarios matched")

    print(f"OpenSCAD: {scad_bin}")
    print(f"Model:    {SCAD_SRC.name}")
    print(f"Running {len(scenarios)} scenario(s)\n")

    workdir = Path(tempfile.mkdtemp(prefix="cbp-tests-"))
    passed = failed = 0
    failures_by_scenario: dict[str, list[str]] = {}

    try:
        for sc in scenarios:
            fails = run_scenario(scad_bin, sc, workdir, args.verbose)
            if fails:
                failed += 1
                failures_by_scenario[sc["name"]] = fails
                print(f"  FAIL  {sc['name']}")
                for f in fails:
                    print(f"          {f}")
            else:
                passed += 1
                print(f"  pass  {sc['name']}")
    finally:
        if args.keep:
            print(f"\nrendered files kept in {workdir}")
        else:
            shutil.rmtree(workdir, ignore_errors=True)

    print(f"\n{passed} passed, {failed} failed")
    if failed:
        print("\nFailing scenarios:")
        for name, fails in failures_by_scenario.items():
            print(f"  {name}")
            for f in fails:
                print(f"    - {f}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
