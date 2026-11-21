#!/usr/bin/env python3
"""Render the README and landing-page images from the model.

These images were once rendered by hand, so nothing recorded how, and they
drifted: after 2.0.0 they still showed openings flush with the floor and the
retired Gridfinity lid studs. Declaring each scene here makes them reproducible
the same way the library previews and the options guide already are.

Two kinds of output:

- Renders. Most scenes render the model directly. The showcase scenes render
  scripts/showcase/scenes.scad, which includes the model and draws the parts
  as they are used: closed, cut open, and pulled apart.
- Composites. The preset gallery and the variations grid are assembled from
  images that other scripts already render, so they cost no OpenSCAD time.
  Rebuild them with --composites-only after build_library.py or
  build_options_guide.py changes those images.

Usage:
  python scripts/build_readme_images.py [--only STEM ...] [--composites-only]
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_options_guide import CAM_ISO, defines, find_openscad  # noqa: E402

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
SHOWCASE = REPO / "scripts" / "showcase" / "scenes.scad"
IMG_DIR = REPO / "docs" / "images"
LIBRARY = REPO / "library"
OPTIONS_IMG = IMG_DIR / "options"

# Looks at a cut face square on, from slightly above.
CAM_SECTION = "0,0,0,72,0,12"

# Each entry: (file stem, (width, height), camera, library preset or None,
# {param overrides}, file to render). A preset is loaded from
# library/<name>/config.json with OpenSCAD's own -p/-P, so the image tracks the
# preset rather than a copy of it.
SCENES = [
    ("hero_box-and-lid", (1600, 900), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid"}, MODEL),
    ("feature_stabilizers", (900, 600), CAM_ISO, None,
     {"Stabilizers_Front_Back_Alignment": "Distributed",
      "Stabilizers_Left_Right_Count": 2,
      "Stabilizers_Left_Right_Alignment": "Distributed",
      "Enable_Bottom_Openings": True,
      "Bottom_Opening_Axis": "Along X"}, MODEL),
    ("feature_slicing", (900, 600), CAM_ISO, "surge-strip-6-sliced",
     {"Part_To_Render": "Box Only"}, MODEL),
    # Shot from above rather than below since E-12 phase B. The lid now exports
    # turned over, with its baseplate pockets on top, so an underside view
    # shows the box's feet and nothing of the lid but its filled plug.
    ("feature_gridfinity", (900, 600), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid",
      "Enable_Gridfinity_Bottom": True,
      "Enable_Gridfinity_Lid_Top": True,
      "Closed_Post": True,
      "Enable_Gridfinity_Magnet_Screw": True}, MODEL),
    ("feature_finishing", (900, 600), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid",
      "Bottom_Edge_Fillet": 1.5,
      "Top_Edge_Chamfer": 0.8,
      "Lid_Relief_Style": "Tab",
      "Enable_Lid_Magnets": True}, MODEL),
    # The link preview that chat apps and social sites show for the docs site.
    # 1200 x 630 is the size they crop to.
    ("social-card", (1200, 630), CAM_ISO, None,
     {"Part_To_Render": "Box and Lid"}, MODEL),

    # Showcase scenes. The cut views turn the left and right openings off: the
    # cut runs through the middle of those walls, exactly where the openings
    # sit, and would show a wall with a hole in it.
    ("showcase_exploded", (900, 600), "0,0,0,62,0,25", None,
     {"Scene": "exploded", "Enable_Lid_Magnets": True, "Explode_Gap": 45}, SHOWCASE),
    ("showcase_exploded-sliced", (900, 600), "0,0,0,60,0,25", None,
     {"Scene": "exploded-sliced", "Enable_Slicing": True}, SHOWCASE),
    ("showcase_section", (900, 600), CAM_SECTION, None,
     {"Scene": "section", "Opening_On_Left": False, "Opening_On_Right": False},
     SHOWCASE),
    ("showcase_section-magnets", (900, 600), "0,0,0,80,0,8", None,
     {"Scene": "section-magnets", "Enable_Lid_Magnets": True}, SHOWCASE),
    ("showcase_section-gridfinity", (900, 600), CAM_SECTION, None,
     {"Scene": "section", "Enable_Gridfinity_Bottom": True,
      "Enable_Gridfinity_Lid_Top": True, "Closed_Post": True,
      "Enable_Gridfinity_Magnet_Screw": True,
      "Opening_On_Left": False, "Opening_On_Right": False}, SHOWCASE),
]

# The variations grid: one image per thing the model can change. Each is
# already rendered by build_options_guide.py, at the same camera as its
# default box.
VARIATIONS = [
    ("box-wide", "200 mm wide"),
    ("radius-25", "Soft corners"),
    ("open-teardrop", "Teardrop openings"),
    ("stab-distributed", "Five fins"),
    ("bottom-on", "Floor openings"),
    ("gf-bottom", "Gridfinity feet"),
    ("slice-3", "Three pieces"),
    ("lid-magnets", "Magnet corners"),
]


def render(scad: str, only: list[str] | None) -> int:
    failed = 0
    for stem, (w, h), cam, preset, params, source in SCENES:
        if only and stem not in only:
            continue
        out = IMG_DIR / f"{stem}.png"
        preset_args = []
        if preset:
            preset_args = ["-p", str(LIBRARY / preset / "config.json"), "-P", preset]
        # The showcase file includes the model, which would otherwise draw its
        # own full_render() under the scene.
        include_args = ["-D", "Render_On_Include=false"] if source != MODEL else []
        # A trimmed scene renders larger, so the crop is scaled down to the
        # frame rather than up, which would blur it.
        k = OVERSAMPLE if stem in TRIMMED else 1
        cmd = ([scad, "-o", str(out), str(source)] + preset_args + include_args +
               defines(params) +
               [f"--imgsize={w * k},{h * k}", "--colorscheme=Tomorrow",
                "--viewall", "--autocenter", f"--camera={cam},0"])
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
        if p.returncode != 0:
            err = next((l for l in (p.stdout + p.stderr).splitlines() if "ERROR" in l), "")
            print(f"  FAILED {stem}: {err[:110]}")
            failed += 1
        else:
            # --viewall frames the scene with a wide margin, and a cut or
            # exploded view leaves most of the frame empty. The older images
            # keep OpenSCAD's framing, so re-rendering them changes nothing.
            if stem in TRIMMED:
                fill_frame(out, (w, h))
            print(f"  wrote docs/images/{stem}.png")
    return failed


# Scenes whose render is cropped to the parts and scaled to the frame. They
# render OVERSAMPLE times larger, since the parts fill about half the frame.
TRIMMED = {s[0] for s in SCENES if s[5] == SHOWCASE} | {"social-card"}
OVERSAMPLE = 3

BACKGROUND_CUTOFF = 240  # renders sit on a #F8F8F8-ish ground


def content_box(im) -> tuple[int, int, int, int]:
    """Bounding box of everything darker than the render's background."""
    grey = im.convert("L").point(lambda v: 255 if v < BACKGROUND_CUTOFF else 0)
    return grey.getbbox() or (0, 0, im.width, im.height)


def expand_to_aspect(box, aspect: float, margin: float, limit) -> tuple[int, int, int, int]:
    """Grow a box by a margin and then to an aspect ratio, kept inside limit."""
    l, t, r, b = box
    w, h = (r - l) * (1 + 2 * margin), (b - t) * (1 + 2 * margin)
    if w / h < aspect:
        w = h * aspect
    else:
        h = w / aspect
    cx, cy = (l + r) / 2, (t + b) / 2
    W, H = limit
    w, h = min(w, W), min(h, H)
    l = min(max(cx - w / 2, 0), W - w)
    t = min(max(cy - h / 2, 0), H - h)
    return round(l), round(t), round(l + w), round(t + h)


def fill_frame(path: Path, size: tuple[int, int], margin: float = 0.06) -> None:
    """Crop a render to its parts plus a margin, then scale it to size."""
    from PIL import Image
    im = Image.open(path).convert("RGB")
    box = expand_to_aspect(content_box(im), size[0] / size[1], margin, im.size)
    im.crop(box).resize(size, Image.LANCZOS).save(path, optimize=True)


def font(size: int):
    """A TrueType face if one is installed, else Pillow's bundled one, so the
    composites build anywhere. The committed images used Segoe UI."""
    from PIL import ImageFont
    for name in ("segoeui.ttf", "DejaVuSans.ttf", "Arial.ttf", "Helvetica.ttc"):
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            continue
    return ImageFont.load_default(size=size)


def grid(tiles: list[tuple[Path, str, str]], cols: int, tile: tuple[int, int],
         out: Path) -> None:
    """Lay tiles out in a labelled grid. Each tile is (image, title, detail).

    Every tile is cut from its source by the same crop box, the smallest one
    that holds the parts in all of them, and scaled by the same factor. So
    images rendered at one camera distance keep their relative sizes, and the
    empty margin they share is gone."""
    from PIL import Image, ImageDraw
    tw, th = tile
    label_h = 62
    rows = (len(tiles) + cols - 1) // cols
    sources = [Image.open(src).convert("RGB") for src, _, _ in tiles]
    boxes = [content_box(im) for im in sources]
    union = (min(b[0] for b in boxes), min(b[1] for b in boxes),
             max(b[2] for b in boxes), max(b[3] for b in boxes))
    crop = expand_to_aspect(union, tw / th, 0.04, sources[0].size)
    sheet = Image.new("RGB", (cols * tw, rows * (th + label_h)), (247, 247, 247))
    draw = ImageDraw.Draw(sheet)
    title_font, detail_font = font(22), font(17)
    for i, (im, (_, title, detail)) in enumerate(zip(sources, tiles)):
        x, y = (i % cols) * tw, (i // cols) * (th + label_h)
        sheet.paste(im.crop(crop).resize((tw, th), Image.LANCZOS), (x, y))
        draw.text((x + 14, y + th + 4), title, fill=(27, 26, 24), font=title_font)
        if detail:
            draw.text((x + 14, y + th + 34), detail, fill=(95, 91, 85), font=detail_font)
    sheet.save(out, optimize=True)
    print(f"  wrote {out.relative_to(REPO).as_posix()}")


def composites() -> None:
    index = json.loads((LIBRARY / "index.json").read_text(encoding="utf-8"))
    tiles = []
    for p in index["presets"]:
        card = next(x for x in p["parts"] if x["slug"] == "box-and-lid")
        size = p.get("assembled_size_mm") or p["box_size_mm"]
        tiles.append((LIBRARY / card["image"]["path"], p["title"],
                      " x ".join(f"{v:g}" for v in size) + " mm"))
    # The library renders box-and-lid at one fixed camera distance, so equal
    # scaling here keeps the nine comparable in size.
    grid(tiles, 3, (400, 300), IMG_DIR / "showcase_presets.png")

    tiles = [(OPTIONS_IMG / f"{slug}.png", label, "") for slug, label in VARIATIONS]
    grid(tiles, 4, (380, 285), IMG_DIR / "showcase_variations.png")


def main() -> int:
    ap = argparse.ArgumentParser(description="Render the README and landing images.")
    ap.add_argument("--only", nargs="+", metavar="STEM",
                    help="render only these images; renders are not byte-stable, "
                         "so re-rendering the rest would churn them for nothing")
    ap.add_argument("--composites-only", action="store_true",
                    help="skip OpenSCAD and rebuild only the composite images")
    args = ap.parse_args()
    known = {s[0] for s in SCENES}
    unknown = sorted(set(args.only or []) - known)
    if unknown:
        sys.exit(f"unknown image stem(s): {', '.join(unknown)}")

    failed = 0
    if not args.composites_only:
        failed = render(find_openscad(), args.only)
    if not args.only:
        composites()
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
