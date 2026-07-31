#!/usr/bin/env python3
"""Regenerate the preset library: configs, STLs, preview renders, and the index.

Presets are defined here as data, so adding one is a dict entry. Everything
downstream (config.json, STLs, PNGs, notes, and library/README.md) is generated,
which is what keeps the library from going stale the way the hand-made v1
artifacts did.

Presets are organised by what the user physically has, not by dimensions,
because nobody knows they need 260 x 100 x 60.

Usage:
  python scripts/build_library.py [--only NAME] [--no-stl] [--no-png]
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
LIB = REPO / "library"

# Every preset inherits model defaults and overrides only what matters.
PRESETS = [
    {
        "name": "desk-compact",
        "title": "Compact desk tidy",
        "fits": "A short power strip plus 3 or 4 cables. Minimal desk footprint.",
        "params": {"Box_Width": 140, "Box_Depth": 80, "Box_Height": 55,
                   "All_Opening_Width": 14, "All_Opening_Height": 32},
    },
    {
        "name": "laptop-brick",
        "title": "Laptop brick and cables",
        "fits": "One laptop charger up to ~150 x 75 x 40 mm, plus 3 cables.",
        "params": {"Box_Width": 175, "Box_Depth": 105, "Box_Height": 70,
                   "All_Opening_Width": 16, "All_Opening_Height": 38,
                   "Stabilizers_Front_Back_Count": 4},
    },
    {
        "name": "usb-charger",
        "title": "Multi-port USB-C charger",
        "fits": "A GaN multi-port charger and 4 to 6 USB-C cables.",
        "params": {"Box_Width": 120, "Box_Depth": 75, "Box_Height": 45,
                   "All_Opening_Width": 12, "All_Opening_Height": 26,
                   "Post_Diameter": 12},
    },
    {
        "name": "monitor-junction",
        "title": "Dual-monitor cable junction",
        "fits": "Two monitor power bricks and their signal cables.",
        "params": {"Box_Width": 210, "Box_Depth": 95, "Box_Height": 62,
                   "All_Opening_Width": 18, "All_Opening_Height": 36,
                   "Stabilizers_Front_Back_Count": 4},
    },
    {
        "name": "surge-strip-6",
        "title": "Six-outlet surge protector",
        "fits": "A standard 6-outlet strip up to ~250 x 60 mm, with its cord.",
        "params": {"Box_Width": 265, "Box_Depth": 100, "Box_Height": 62,
                   "All_Opening_Width": 20, "All_Opening_Height": 38,
                   "Stabilizers_Front_Back_Count": 5},
        "note": "Wider than many print beds. See the sliced preset below if that "
                "is a problem.",
    },
    {
        "name": "surge-strip-6-sliced",
        "title": "Six-outlet strip, split for a 180 mm bed",
        "fits": "Same as surge-strip-6, printed in two halves that clip together.",
        "params": {"Box_Width": 265, "Box_Depth": 100, "Box_Height": 62,
                   "All_Opening_Width": 20, "All_Opening_Height": 38,
                   "Stabilizers_Front_Back_Count": 5,
                   "Enable_Slicing": True, "Slice_Count": 2, "Clips_Per_Edge": 3},
        "note": "Export each half with Slice_Piece_To_Render=1 then 2. The "
                "preview STL here shows both halves laid out side by side.",
    },
    {
        "name": "gridfinity-module",
        "title": "Gridfinity desk module",
        "fits": "Sits in a Gridfinity baseplate on a 3 x 2 cell footprint.",
        "params": {"Box_Width": 140, "Box_Depth": 100, "Box_Height": 55,
                   "Enable_Gridfinity_Bottom": True,
                   "Enable_Gridfinity_Lid_Top": True,
                   "Closed_Post": True,
                   "All_Opening_Width": 14, "All_Opening_Height": 30},
        "note": "Gridfinity bottom requires Closed_Post. Total height is "
                "Box_Height plus 4.75 mm of base.",
    },
    {
        "name": "router-shelf",
        "title": "Router and modem shelf tidy",
        "fits": "A small router or modem plus its PSU. Tall openings for stiff "
                "coax and ethernet.",
        "params": {"Box_Width": 230, "Box_Depth": 130, "Box_Height": 75,
                   "All_Opening_Width": 22, "All_Opening_Height": 45,
                   "Stabilizers_Front_Back_Count": 4,
                   "Stabilizers_Left_Right_Count": 2},
        "note": "Powered equipment generates heat. PLA softens around 55 C; "
                "prefer PETG for anything left running.",
    },
    {
        "name": "under-desk-passthrough",
        "title": "Under-desk pass-through",
        "fits": "A junction box where cables enter one side and leave the other. "
                "No post, so the interior is one clear channel.",
        "params": {"Box_Width": 180, "Box_Depth": 85, "Box_Height": 50,
                   "Enable_Post": False,
                   "All_Opening_Width": 24, "All_Opening_Height": 34,
                   "Opening_On_Front": False, "Opening_On_Back": False,
                   "Stabilizers_Front_Back_Count": 3},
    },
]

VIEWS = [
    ("box-only", "Box Only", "0,0,0,55,0,25"),
    ("lid-only", "Lid Only", "0,0,0,55,0,25"),
    ("box-and-lid", "Box and Lid", "0,0,0,55,0,25"),
]


def find_openscad() -> str:
    env = os.environ.get("OPENSCAD_BIN")
    if env and (shutil.which(env) or Path(env).exists()):
        return env
    found = shutil.which("openscad")
    if found:
        return found
    for c in (r"C:\Program Files\OpenSCAD\openscad.exe", "/usr/bin/openscad"):
        if Path(c).exists():
            return c
    sys.exit("OpenSCAD not found. Set OPENSCAD_BIN.")


def defines(params: dict) -> list[str]:
    out = []
    for k, v in params.items():
        if isinstance(v, bool):
            out += ["-D", f"{k}={str(v).lower()}"]
        elif isinstance(v, str):
            out += ["-D", f'{k}="{v}"']
        else:
            out += ["-D", f"{k}={v}"]
    return out


def render(scad: str, out: Path, params: dict, extra: list[str]) -> bool:
    out.parent.mkdir(parents=True, exist_ok=True)
    cmd = [scad, "-o", str(out), str(MODEL)] + defines(params) + extra
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    if p.returncode != 0:
        err = next((l for l in (p.stdout + p.stderr).splitlines() if "ERROR" in l), "")
        print(f"      FAILED: {err[:130]}")
        return False
    return True


def stl_stats(path: Path) -> tuple[float, float, float]:
    xs, ys, zs = [], [], []
    with path.open(errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("vertex"):
                _, x, y, z = line.split()
                xs.append(float(x)); ys.append(float(y)); zs.append(float(z))
    return (max(xs) - min(xs), max(ys) - min(ys), max(zs) - min(zs))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", default="")
    ap.add_argument("--no-stl", action="store_true")
    ap.add_argument("--no-png", action="store_true")
    args = ap.parse_args()

    scad = find_openscad()
    presets = [p for p in PRESETS if not args.only or args.only in p["name"]]
    print(f"OpenSCAD: {scad}\nBuilding {len(presets)} preset(s)\n")

    index_rows = []
    for preset in presets:
        name = preset["name"]
        base = LIB / name
        print(f"  {name}")
        (base / "stl").mkdir(parents=True, exist_ok=True)
        (base / "images").mkdir(parents=True, exist_ok=True)

        # config.json carries every override, so it is unambiguous and survives
        # a change to the model defaults.
        cfg = {"fileFormatVersion": "1",
               "parameterSets": {name: {k: str(v) for k, v in preset["params"].items()}}}
        (base / "config.json").write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")

        # Gridfinity features live on the underside of both parts, so a
        # top-down render shows none of them. Add a view from below.
        views = list(VIEWS)
        if preset["params"].get("Enable_Gridfinity_Bottom") or \
           preset["params"].get("Enable_Gridfinity_Lid_Top"):
            views.append(("underside", "Box and Lid", "0,0,0,125,0,25"))

        dims = None
        for slug, part, cam in views:
            params = dict(preset["params"], Part_To_Render=part)
            if slug != "underside":
                stl = base / "stl" / f"{name}_{slug}.stl"
                if not args.no_stl:
                    if render(scad, stl, params, []) and slug == "box-only":
                        dims = stl_stats(stl)
                elif slug == "box-only" and stl.exists():
                    # Reuse the existing STL so a --no-stl rebuild still gets
                    # dimensions for the notes and the index table.
                    dims = stl_stats(stl)
            if not args.no_png:
                png = base / "images" / f"{name}_{slug}.png"
                render(scad, png, params,
                       ["--imgsize=1000,750", "--colorscheme=Tomorrow",
                        "--viewall", "--autocenter", f"--camera={cam},0"])
        if dims:
            print(f"      box {dims[0]:.1f} x {dims[1]:.1f} x {dims[2]:.1f} mm")

        notes = [f"# {preset['title']}", "",
                 preset["fits"], ""]
        if preset.get("note"):
            notes += [f"**Note:** {preset['note']}", ""]
        if dims:
            notes += [f"Printed box envelope: `{dims[0]:.1f} x {dims[1]:.1f} x {dims[2]:.1f} mm`", ""]
        notes += ["## Parameters", "", "| Parameter | Value |", "|---|---|"]
        notes += [f"| `{k}` | `{v}` |" for k, v in sorted(preset["params"].items())]
        notes += ["", "Everything not listed uses the model default.", "",
                  "## Rebuild", "", "```bash",
                  f"python scripts/build_library.py --only {name}", "```", ""]
        (base / "notes.md").write_text("\n".join(notes), encoding="utf-8")

        size = f"{dims[0]:.0f} x {dims[1]:.0f} x {dims[2]:.0f}" if dims else "n/a"
        index_rows.append((name, preset["title"], preset["fits"], size))

    readme = ["# Preset Library", "",
              "Ready-to-print configurations for common jobs. Each preset carries a",
              "complete `config.json`, STLs, preview renders, and notes.", "",
              "Everything here is generated by `scripts/build_library.py`, so presets",
              "cannot drift from the model the way hand-made artifacts do.", "",
              "| Preset | For | Fits | Box size (mm) |", "|---|---|---|---|"]
    for name, title, fits, size in index_rows:
        readme.append(f"| [`{name}`]({name}/) | {title} | {fits} | {size} |")
    readme += ["", "## Using a preset", "",
               "Load the parameter set directly:", "", "```bash",
               "openscad -o out.stl cable-box-parametric.scad \\",
               "  -p library/<preset>/config.json -P <preset>", "```", "",
               "Or open `cable-box-parametric.scad` in OpenSCAD, open the Customizer",
               "(F3), and load the preset's `config.json` from the preset dropdown.", "",
               "## Adding a preset", "",
               "Add an entry to `PRESETS` in `scripts/build_library.py` and rerun it.",
               "Do not hand-edit generated files.", ""]
    (LIB / "README.md").write_text("\n".join(readme), encoding="utf-8")
    print(f"\nWrote {len(index_rows)} presets and library/README.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
