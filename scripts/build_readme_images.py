#!/usr/bin/env python3
"""Render the README's hero and feature images from the model.

These four images were once rendered by hand, so nothing recorded how, and they
drifted: after 2.0.0 they still showed openings flush with the floor and the
retired Gridfinity lid studs. Declaring each scene here makes them reproducible
the same way the library previews and the options guide already are.

Usage:
  python scripts/build_readme_images.py [--only STEM ...]
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_options_guide import CAM_ISO, CAM_UNDER, defines, find_openscad  # noqa: E402

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
IMG_DIR = REPO / "docs" / "images"

# Each entry: (file stem, (width, height), camera, library preset or None,
# {param overrides}). A preset is loaded from library/<name>/config.json with
# OpenSCAD's own -p/-P, so the image tracks the preset rather than a copy of it.
SCENES = [
    ("hero_box-and-lid", (1600, 900), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid"}),
    ("feature_stabilizers", (900, 600), CAM_ISO, None,
     {"Stabilizers_Front_Back_Alignment": "Distributed",
      "Stabilizers_Left_Right_Count": 2,
      "Stabilizers_Left_Right_Alignment": "Distributed",
      "Enable_Bottom_Openings": True,
      "Bottom_Opening_Axis": "Along X"}),
    ("feature_slicing", (900, 600), CAM_ISO, "surge-strip-6-sliced",
     {"Part_To_Render": "Box Only"}),
    ("feature_gridfinity", (900, 600), CAM_UNDER, None,
     {"Part_To_Render": "Box and Lid",
      "Enable_Gridfinity_Bottom": True,
      "Enable_Gridfinity_Lid_Top": True,
      "Closed_Post": True,
      "Enable_Gridfinity_Magnet_Screw": True}),
    ("feature_finishing", (900, 600), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid",
      "Bottom_Edge_Fillet": 1.5,
      "Top_Edge_Chamfer": 0.8,
      "Lid_Relief_Style": "Tab",
      "Enable_Lid_Magnets": True}),
]


def main() -> int:
    ap = argparse.ArgumentParser(description="Render the README images.")
    ap.add_argument("--only", nargs="+", metavar="STEM",
                    help="render only these images; renders are not byte-stable, "
                         "so re-rendering the rest would churn them for nothing")
    args = ap.parse_args()
    known = {s[0] for s in SCENES}
    unknown = sorted(set(args.only or []) - known)
    if unknown:
        sys.exit(f"unknown image stem(s): {', '.join(unknown)}")

    scad = find_openscad()
    failed = 0
    for stem, (w, h), cam, preset, params in SCENES:
        if args.only and stem not in args.only:
            continue
        out = IMG_DIR / f"{stem}.png"
        preset_args = []
        if preset:
            preset_args = ["-p", str(REPO / "library" / preset / "config.json"), "-P", preset]
        cmd = ([scad, "-o", str(out), str(MODEL)] + preset_args + defines(params) +
               [f"--imgsize={w},{h}", "--colorscheme=Tomorrow",
                "--viewall", "--autocenter", f"--camera={cam},0"])
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
        if p.returncode != 0:
            err = next((l for l in (p.stdout + p.stderr).splitlines() if "ERROR" in l), "")
            print(f"  FAILED {stem}: {err[:110]}")
            failed += 1
        else:
            print(f"  wrote docs/images/{stem}.png")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
