#!/usr/bin/env python3
"""Regenerate the preset library: configs, STLs, preview renders, and the index.

Presets are defined here as data, so adding one is a dict entry. Everything
downstream (config.json, STLs, PNGs, notes, library/README.md, and the merged
cable-box-parametric.json beside the model) is generated, which is what keeps
the library from going stale the way the hand-made v1 artifacts did.

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
import zlib
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

# (slug, part, camera rotation, fixed_scale)
#
# A fixed_scale view is rendered without --viewall so every preset shares one
# camera distance and the library reads as a size comparison. --viewall zooms
# each model to fill the frame, which made a 265 mm strip and a 120 mm charger
# occupy identical space. Five of the nine presets differ only in dimensions,
# so that flag was hiding the only difference they have.
VIEWS = [
    ("box-only", "Box Only", "55,0,25", False),
    ("lid-only", "Lid Only", "55,0,25", False),
    ("box-and-lid", "Box and Lid", "55,0,25", True),
]

# Calibrated against the widest preset (surge-strip-6, 552 mm across box and
# lid) so it frames with margin to spare. If a wider preset is ever added the
# build warns rather than silently cropping it; raise both values then.
SCALE_DIST = 1300
SCALE_MAX_SPAN = 600.0


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


def stl_bbox(path: Path):
    """Axis-aligned bounds as ((x0,x1),(y0,y1),(z0,z1))."""
    xs, ys, zs = [], [], []
    with path.open(errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if line.startswith("vertex"):
                _, x, y, z = line.split()
                xs.append(float(x)); ys.append(float(y)); zs.append(float(z))
    return (min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))


def bbox_size(b) -> tuple[float, float, float]:
    return tuple(hi - lo for lo, hi in b)


def bbox_centre(b) -> tuple[float, float, float]:
    return tuple((lo + hi) / 2 for lo, hi in b)


def as_param(v) -> str:
    """Serialise one value for a Customizer parameter set.

    The format stores everything as strings, but OpenSCAD still type-checks
    them on load. Python's str(True) is "True", which OpenSCAD rejects with
    'conversion of data to type "b" failed' and then discards the entire
    parameter set, so booleans have to be lowercased.
    """
    if isinstance(v, bool):
        return "true" if v else "false"
    return str(v)


# OpenSCAD rasterises through OpenGL, so pixels along polygon edges land
# differently from one run to the next. The images are identical to look at but
# not byte-equal, and git compares bytes: without a guard every rebuild reports
# every render as modified, so a real change drowns in noise and the diff stops
# being worth reading.
#
# Measured on a 1000x750 render, 2,250,750 bytes of pixel data:
#
#   identical input, back-to-back renders     0 to 6 bytes differ
#   identical input, across separate runs     up to 993
#   Box_Width 140 -> 140.5 (smallest change)  11,508
#   Box_Width 140 -> 145                      17,696
#
# Noise and signal are an order of magnitude apart, so the threshold sits in the
# gap. Re-measure before moving it; the numbers are specific to this image size.
PNG_NOISE_BYTES = 4000


def png_payload(path: Path) -> bytes | None:
    """The decompressed image stream of a PNG, or None if it cannot be read.

    OpenSCAD writes a bare IHDR/IDAT/IEND file with no metadata chunks, so this
    is image content and nothing else. No timestamp to strip.
    """
    try:
        d = path.read_bytes()
        if d[:8] != b"\x89PNG\r\n\x1a\n":
            return None
        i, idat = 8, []
        while i + 8 <= len(d):
            ln = int.from_bytes(d[i:i + 4], "big")
            if d[i + 4:i + 8] == b"IDAT":
                idat.append(d[i + 8:i + 8 + ln])
            i += 12 + ln
        return zlib.decompress(b"".join(idat)) if idat else None
    except (OSError, zlib.error):
        return None


def is_same_picture(fresh: Path, previous: bytes | None) -> bool:
    """Whether a new render differs from the old one only by rasteriser noise."""
    if previous is None:
        return False
    new = png_payload(fresh)
    if new is None or len(new) != len(previous):
        return False
    if new == previous:
        return True
    delta = 0
    for a, b in zip(new, previous):
        if a != b:
            delta += 1
            if delta > PNG_NOISE_BYTES:   # real change, stop counting
                return False
    return True


def camera_args(rot: str, bbox, label: str) -> list[str]:
    common = ["--imgsize=1000,750", "--colorscheme=Tomorrow"]
    if bbox is None:
        return common + ["--viewall", "--autocenter", f"--camera=0,0,0,{rot},0"]

    cx, cy, cz = bbox_centre(bbox)
    span = max(bbox_size(bbox))
    if span > SCALE_MAX_SPAN:
        print(f"      WARNING: {label} spans {span:.0f} mm, past the "
              f"{SCALE_MAX_SPAN:.0f} mm that SCALE_DIST={SCALE_DIST} frames. "
              f"Raise both or this render is cropped.")
    # --autocenter is deliberately absent as well as --viewall: it stops
    # centring once --viewall is gone, so aim at the bounding box centre
    # directly. "Box and Lid" puts the lid at +x, so that centre is not 0.
    return common + [f"--camera={cx:.2f},{cy:.2f},{cz:.2f},{rot},{SCALE_DIST}"]


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
    png_written = png_kept = 0
    for preset in presets:
        name = preset["name"]
        base = LIB / name
        print(f"  {name}")
        (base / "stl").mkdir(parents=True, exist_ok=True)
        (base / "images").mkdir(parents=True, exist_ok=True)

        # config.json carries every override, so it is unambiguous and survives
        # a change to the model defaults.
        cfg = {"fileFormatVersion": "1",
               "parameterSets": {name: {k: as_param(v) for k, v in preset["params"].items()}}}
        (base / "config.json").write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")

        # Gridfinity features live on the underside of both parts, so a
        # top-down render shows none of them. Add a view from below.
        views = list(VIEWS)
        if preset["params"].get("Enable_Gridfinity_Bottom") or \
           preset["params"].get("Enable_Gridfinity_Lid_Top"):
            views.append(("underside", "Box and Lid", "125,0,25", False))

        dims = None
        for slug, part, rot, fixed in views:
            params = dict(preset["params"], Part_To_Render=part)
            bbox = None
            if slug != "underside":
                stl = base / "stl" / f"{name}_{slug}.stl"
                if not args.no_stl:
                    render(scad, stl, params, [])
                # Read back what we need: box-only gives the printed envelope
                # for the notes and index, and a fixed-scale view needs its own
                # bounds to aim the camera. Reusing an existing STL is what lets
                # --no-stl still produce both.
                if stl.exists() and (fixed or slug == "box-only"):
                    bbox = stl_bbox(stl)
                    if slug == "box-only":
                        dims = bbox_size(bbox)
            if not args.no_png:
                png = base / "images" / f"{name}_{slug}.png"
                previous = png_payload(png) if png.exists() else None
                # Render beside the target, then keep the old file if the new
                # one is the same picture. The suffix stays .png because
                # OpenSCAD picks its output format from the extension.
                tmp = png.with_name("_tmp_" + png.name)
                if render(scad, tmp, params,
                          camera_args(rot, bbox if fixed else None, f"{name}/{slug}")):
                    if is_same_picture(tmp, previous):
                        tmp.unlink()
                        png_kept += 1
                    else:
                        tmp.replace(png)
                        png_written += 1
                elif tmp.exists():
                    tmp.unlink()
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

    # One merged parameter-set file next to the model. OpenSCAD's Customizer
    # reads named sets from JSON, so this offers every preset in the dropdown
    # without hunting for a per-preset file, and it is what a web customizer
    # can load too. Built from PRESETS rather than the filtered list, so
    # --only cannot silently truncate it to a single entry.
    merged = {"fileFormatVersion": "1",
              "parameterSets": {p["name"]: {k: as_param(v) for k, v in p["params"].items()}
                                for p in PRESETS}}
    (REPO / "cable-box-parametric.json").write_text(
        json.dumps(merged, indent=2) + "\n", encoding="utf-8")

    readme = ["# Preset Library", "",
              "Ready-to-print configurations for common jobs. Each preset carries a",
              "complete `config.json`, STLs, preview renders, and notes.", "",
              "Everything here is generated by `scripts/build_library.py`, so presets",
              "cannot drift from the model the way hand-made artifacts do.", "",
              "| Preset | For | Fits | Box size (mm) |", "|---|---|---|---|"]
    for name, title, fits, size in index_rows:
        readme.append(f"| [`{name}`]({name}/) | {title} | {fits} | {size} |")
    readme += ["", "## Using a preset", "",
               "Every preset is also collected into `cable-box-parametric.json` beside",
               "the model, so opening `cable-box-parametric.scad` in OpenSCAD and then",
               "the Customizer (F3) offers all of them in the preset dropdown.", "",
               "From the command line, against the merged file:", "", "```bash",
               "openscad -o out.stl cable-box-parametric.scad \\",
               "  -p cable-box-parametric.json -P <preset>", "```", "",
               "Or against a single preset's own copy:", "", "```bash",
               "openscad -o out.stl cable-box-parametric.scad \\",
               "  -p library/<preset>/config.json -P <preset>", "```", "",
               "Both files are the Customizer's native parameter-set format, so a set",
               "saved by desktop OpenSCAD can be dropped straight back in.", "",
               "## Adding a preset", "",
               "Add an entry to `PRESETS` in `scripts/build_library.py` and rerun it.",
               "Do not hand-edit generated files.", ""]
    (LIB / "README.md").write_text("\n".join(readme), encoding="utf-8")
    print(f"\nWrote {len(index_rows)} presets, library/README.md, "
          f"and cable-box-parametric.json ({len(PRESETS)} sets)")
    if not args.no_png:
        print(f"Renders: {png_written} written, {png_kept} unchanged and left alone")
    return 0


if __name__ == "__main__":
    sys.exit(main())
