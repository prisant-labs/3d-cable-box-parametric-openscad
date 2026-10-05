#!/usr/bin/env python3
"""Export and check the calibration coupons in calibration/.

Each coupon is a small parameter set in calibration/config.json that isolates
one feature that a full box would otherwise be the first print of: the lid fit,
the magnet pockets, both Gridfinity interfaces, both seam clip styles, the edge
treatment, and a side opening. This script renders each one with OpenSCAD's own
-p/-P, so the STL tracks the parameter set rather than a copy of it, and then
checks it the way the regression suite checks a scenario: exit code, a clean
log, and the number of separate bodies.

The body count matters most. A coupon that is meant to be a box and a lid must
be exactly two pieces, and a sliced coupon must be exactly two halves with
their clips fused on. An extra body is detached geometry, which a slicer prints
as a loose fragment.

Usage:
  python scripts/build_calibration.py             # export every coupon
  python scripts/build_calibration.py --only lid-fit magnet-boss
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_options_guide import find_openscad  # noqa: E402

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
CAL = REPO / "calibration"
CONFIG = CAL / "config.json"
STL_DIR = CAL / "stl"

# Expected separate bodies per coupon. A coupon added to config.json without an
# entry here fails, so nothing ships unchecked.
EXPECTED_BODIES = {
    "lid-fit": 2,
    "lid-fit-plug": 2,
    "magnet-boss": 2,
    "magnet-boss-plug": 2,
    "gridfinity-base-1x1": 1,
    "gridfinity-lid-socket-1x1": 1,
    "snap-clip-pair": 2,
    "tab-clip-pair": 2,
    "edge-treatment": 1,
    "side-opening": 1,
}

VOLUMES_RE = re.compile(r"Volumes:\s+(\d+)")
SIMPLE_RE = re.compile(r"Simple:\s+(yes|no)")


def body_count(log: str, stl: Path) -> int | None:
    """Separate solids in the export. CGAL prints "Volumes: N", which counts the
    infinite outer volume too. The Manifold backend prints no summary, so fall
    back to splitting the mesh with trimesh when it is installed."""
    m = VOLUMES_RE.search(log)
    if m:
        return int(m.group(1)) - 1
    try:
        import trimesh
    except ImportError:
        return None
    return len(trimesh.load(stl, force="mesh").split(only_watertight=False))


def stl_extent(stl: Path) -> tuple[float, float, float]:
    """Overall x, y, z size of an ASCII STL, for the summary."""
    lo = [float("inf")] * 3
    hi = [float("-inf")] * 3
    with stl.open(errors="replace") as fh:
        for line in fh:
            parts = line.split()
            if parts and parts[0] == "vertex":
                for i, v in enumerate(map(float, parts[1:4])):
                    lo[i] = min(lo[i], v)
                    hi[i] = max(hi[i], v)
    return tuple(round(hi[i] - lo[i], 1) for i in range(3))


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--only", nargs="+", metavar="NAME",
                    help="export only these coupons")
    args = ap.parse_args()

    sets = json.loads(CONFIG.read_text(encoding="utf-8"))["parameterSets"]
    names = args.only or list(sets)
    unknown = [n for n in names if n not in sets]
    if unknown:
        sys.exit(f"not in calibration/config.json: {', '.join(unknown)}")

    scad = find_openscad()
    STL_DIR.mkdir(parents=True, exist_ok=True)
    failed = 0
    for name in names:
        out = STL_DIR / f"{name}.stl"
        cmd = [scad, "-o", str(out), str(MODEL), "-p", str(CONFIG), "-P", name]
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
        log = p.stdout + p.stderr
        problems = []
        if p.returncode != 0:
            err = next((l for l in log.splitlines() if "ERROR" in l), "")
            problems.append(f"exit code {p.returncode}. {err[:110]}")
        else:
            for bad in ("WARNING", "DEPRECATED"):
                line = next((l.strip() for l in log.splitlines() if bad in l), None)
                if line:
                    problems.append(f"log contains {bad}: {line[:110]}")
            simple = SIMPLE_RE.search(log)
            if simple and simple.group(1) == "no":
                problems.append("not a valid 2-manifold (CGAL 'Simple: no')")
            want = EXPECTED_BODIES.get(name)
            got = body_count(log, out)
            if want is None:
                problems.append("no expected body count in EXPECTED_BODIES")
            elif got is None:
                print(f"  NOTE {name}: body count unchecked "
                      "(no CGAL summary and trimesh not installed)")
            elif got != want:
                problems.append(f"{got} separate bodies, expected {want}")

        if problems:
            failed += 1
            print(f"  FAILED {name}: " + "; ".join(problems))
        else:
            x, y, z = stl_extent(out)
            print(f"  wrote calibration/stl/{name}.stl  ({x} x {y} x {z} mm)")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
