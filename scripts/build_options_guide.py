#!/usr/bin/env python3
"""Render every parameter's visual effect and emit a self-contained HTML guide.

Images are rendered from the model and inlined as base64 data URIs, so the
output is a single file that works offline, from a USB stick, or attached to an
email. No CDN, no external assets.

Also emits a Markdown companion at docs/OPTIONS_GUIDE.md that references the
same renders as files, for people reading on GitHub.

Usage:
  python scripts/build_options_guide.py [--no-render]
"""

from __future__ import annotations

import argparse
import base64
import html
import os
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MODEL = REPO / "cable-box-parametric.scad"
IMG_DIR = REPO / "docs" / "images" / "options"
HTML_OUT = REPO / "docs" / "options-guide.html"
MD_OUT = REPO / "docs" / "OPTIONS_GUIDE.md"

CAM_ISO = "0,0,0,55,0,25"
CAM_LOW = "0,0,0,78,0,25"
CAM_UNDER = "0,0,0,125,0,25"

# Each entry: (image slug, caption, camera, {param overrides})
# Grouped into sections that mirror the Customizer's own layout.
SECTIONS = [
    ("overall", "Overall", "What gets generated.", [
        ("part-box", "Box Only", CAM_ISO, {"Part_To_Render": "Box Only"}),
        ("part-lid", "Lid Only", CAM_ISO, {"Part_To_Render": "Lid Only"}),
        ("part-both", "Box and Lid", CAM_ISO, {"Part_To_Render": "Box and Lid"}),
    ]),
    ("box", "Box", "Shell dimensions and wall.", [
        ("box-default", "Default 100 x 75 x 50", CAM_ISO, {}),
        ("box-wide", "Wide: 200 x 75 x 50", CAM_ISO, {"Box_Width": 200}),
        ("box-tall", "Tall: 100 x 75 x 90", CAM_ISO, {"Box_Height": 90}),
        ("radius-2", "Corner radius 2 (crisp)", CAM_ISO, {"Box_Corner_Radius": 2}),
        ("radius-8", "Corner radius 8.1 (default)", CAM_ISO, {}),
        ("radius-25", "Corner radius 25 (soft)", CAM_ISO, {"Box_Corner_Radius": 25}),
        ("wall-thin", "Wall 1.2 mm", CAM_LOW, {"Wall_Thickness": 1.2}),
        ("wall-thick", "Wall 3.0 mm", CAM_LOW, {"Wall_Thickness": 3.0}),
    ]),
    ("post", "Centre post", "The cable-wrapping core.", [
        ("post-on", "Post enabled (default)", CAM_ISO, {}),
        ("post-off", "Post disabled", CAM_ISO, {"Enable_Post": False}),
        ("post-wide", "Post diameter 30", CAM_ISO, {"Post_Diameter": 30}),
        ("post-closed", "Closed_Post: solid floor under the post", CAM_UNDER,
         {"Closed_Post": True}),
    ]),
    ("lid", "Lid", "Fit and engagement.", [
        ("lid-default", "Default lid", CAM_ISO, {"Part_To_Render": "Lid Only"}),
        ("lid-tall", "Lid_Height 16", CAM_ISO,
         {"Part_To_Render": "Lid Only", "Lid_Height": 16}),
        ("lid-deep-lip", "Lid_Lip_Gap_Height 8", CAM_UNDER,
         {"Part_To_Render": "Lid Only", "Lid_Lip_Gap_Height": 8}),
    ]),
    ("openings", "Side openings", "Where cables enter and leave.", [
        ("open-default", "Default: 10 wide x 30 tall, flush with the floor", CAM_ISO, {}),
        ("open-wide", "Width 30", CAM_ISO, {"All_Opening_Width": 30}),
        ("open-short", "Height 15", CAM_ISO, {"All_Opening_Height": 15}),
        ("open-up", "All_Openings_Up 12: lifted off the floor", CAM_ISO,
         {"All_Openings_Up": 12}),
        ("open-square", "Corner radius 0: square corners", CAM_ISO,
         {"All_Opening_Corner_Radius": 0}),
        ("open-round", "Corner radius -1: fully rounded (default)", CAM_ISO, {}),
        ("open-two-sides", "Front and back only", CAM_ISO,
         {"Opening_On_Left": False, "Opening_On_Right": False}),
        ("open-override", "Per-side override: wide front opening", CAM_ISO,
         {"Override_Opening_Width_Front": 40, "Override_Opening_Height_Front": 20}),
    ]),
    ("stabilizers", "Stabilizer fins", "Interior ribs that stiffen the walls.", [
        ("stab-off", "Disabled", CAM_ISO, {"Enable_Stabilizers": False}),
        ("stab-default", "3 fins, centred (default)", CAM_ISO, {}),
        ("stab-distributed", "5 fins, distributed", CAM_ISO,
         {"Stabilizers_Front_Back_Count": 5,
          "Stabilizers_Front_Back_Alignment": "Distributed"}),
        ("stab-allwalls", "All four walls", CAM_ISO,
         {"Stabilizers_Left_Right_Count": 2}),
        ("stab-tall", "Taller and deeper fins", CAM_ISO,
         {"Stabilizer_Height": 44, "Stabilizer_Depth": 22}),
    ]),
    ("bottom", "Floor openings", "Cutouts through the box floor.", [
        ("bottom-off", "Disabled (default)", CAM_UNDER, {}),
        ("bottom-on", "3 openings along X", CAM_UNDER,
         {"Enable_Bottom_Openings": True}),
        ("bottom-y", "Arranged along Y", CAM_UNDER,
         {"Enable_Bottom_Openings": True, "Bottom_Opening_Axis": "Along Y"}),
        ("bottom-many", "6 openings, distributed", CAM_UNDER,
         {"Enable_Bottom_Openings": True, "Bottom_Openings_Count": 6,
          "Bottom_Opening_Alignment_Primary": "Distributed"}),
    ]),
    ("slicing", "Slicing for small beds", "Split the model into clipping pieces.", [
        ("slice-2", "2 pieces, preview layout", CAM_ISO,
         {"Enable_Slicing": True, "Slice_Count": 2, "Part_To_Render": "Box Only"}),
        ("slice-3", "3 pieces", CAM_ISO,
         {"Enable_Slicing": True, "Slice_Count": 3, "Part_To_Render": "Box Only"}),
        ("slice-one", "Exporting a single piece", CAM_ISO,
         {"Enable_Slicing": True, "Slice_Count": 2, "Slice_Piece_To_Render": 1,
          "Part_To_Render": "Box Only"}),
        ("slice-clips", "4 clips per seam", CAM_ISO,
         {"Enable_Slicing": True, "Slice_Count": 2, "Clips_Per_Edge": 4,
          "Part_To_Render": "Box Only"}),
    ]),
    ("gridfinity", "Gridfinity", "Optional interfaces, both shown from below.", [
        ("gf-off", "Disabled (default)", CAM_UNDER, {"Closed_Post": True}),
        ("gf-bottom", "Base under the box", CAM_UNDER,
         {"Enable_Gridfinity_Bottom": True, "Closed_Post": True}),
        ("gf-lid", "Profile on the lid", CAM_UNDER,
         {"Enable_Gridfinity_Lid_Top": True, "Part_To_Render": "Lid Only"}),
        ("gf-both", "Both, with magnet and screw holes", CAM_UNDER,
         {"Enable_Gridfinity_Bottom": True, "Enable_Gridfinity_Lid_Top": True,
          "Closed_Post": True, "Enable_Gridfinity_Magnet_Screw": True}),
    ]),
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


def render(scad: str, slug: str, cam: str, params: dict) -> bool:
    out = IMG_DIR / f"{slug}.png"
    base = {"Part_To_Render": "Box Only"}
    base.update(params)
    cmd = ([scad, "-o", str(out), str(MODEL)] + defines(base) +
           ["--imgsize=760,570", "--colorscheme=Tomorrow",
            "--viewall", "--autocenter", f"--camera={cam},0"])
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    if p.returncode != 0:
        err = next((l for l in (p.stdout + p.stderr).splitlines() if "ERROR" in l), "")
        print(f"    FAILED {slug}: {err[:110]}")
        return False
    return True


def data_uri(slug: str) -> str:
    p = IMG_DIR / f"{slug}.png"
    if not p.exists():
        return ""
    return "data:image/png;base64," + base64.b64encode(p.read_bytes()).decode("ascii")


def model_version() -> str:
    for line in MODEL.read_text(encoding="utf-8", errors="replace").splitlines()[:60]:
        if line.startswith("Model_Version"):
            return line.split('"')[1]
    return "unknown"


CSS = """
*,*::before,*::after{box-sizing:border-box}
:root{
  --bg:#fbfaf8; --surface:#fff; --ink:#1b1a18; --muted:#5f5b55;
  --line:#e6e1da; --accent:#0f766e; --accent-soft:#e6f2f0; --code:#f4f1ec;
  --shadow:0 1px 2px rgba(25,22,18,.05),0 8px 24px -12px rgba(25,22,18,.18);
}
@media (prefers-color-scheme:dark){
  :root{--bg:#16151a; --surface:#1d1c22; --ink:#eceaf2; --muted:#a5a1b0;
        --line:#2f2d38; --accent:#5eead4; --accent-soft:#16302e; --code:#24222b;
        --shadow:0 1px 2px rgba(0,0,0,.4),0 8px 24px -12px rgba(0,0,0,.6);}
}
:root[data-theme="dark"]{--bg:#16151a; --surface:#1d1c22; --ink:#eceaf2; --muted:#a5a1b0;
  --line:#2f2d38; --accent:#5eead4; --accent-soft:#16302e; --code:#24222b;
  --shadow:0 1px 2px rgba(0,0,0,.4),0 8px 24px -12px rgba(0,0,0,.6);}
:root[data-theme="light"]{--bg:#fbfaf8; --surface:#fff; --ink:#1b1a18; --muted:#5f5b55;
  --line:#e6e1da; --accent:#0f766e; --accent-soft:#e6f2f0; --code:#f4f1ec;
  --shadow:0 1px 2px rgba(25,22,18,.05),0 8px 24px -12px rgba(25,22,18,.18);}

body{margin:0;background:var(--bg);color:var(--ink);
  font:16px/1.65 ui-sans-serif,system-ui,-apple-system,"Segoe UI",Inter,sans-serif;
  -webkit-font-smoothing:antialiased}
.wrap{max-width:1180px;margin:0 auto;padding:0 clamp(16px,4vw,40px)}

header.hero{border-bottom:1px solid var(--line);background:var(--surface);
  padding:clamp(40px,7vw,72px) 0 clamp(28px,4vw,44px)}
.eyebrow{font-size:12px;letter-spacing:.14em;text-transform:uppercase;
  color:var(--accent);font-weight:650;margin:0 0 12px}
h1{margin:0 0 14px;font-size:clamp(30px,5vw,46px);line-height:1.1;
  letter-spacing:-.022em;font-weight:680}
.lede{margin:0;color:var(--muted);font-size:clamp(16px,2vw,19px);max-width:64ch}
.meta{margin-top:22px;display:flex;flex-wrap:wrap;gap:8px}
.chip{font-size:12.5px;padding:5px 11px;border-radius:999px;
  background:var(--accent-soft);color:var(--accent);font-weight:600;
  border:1px solid color-mix(in srgb,var(--accent) 22%,transparent)}

nav.toc{position:sticky;top:0;z-index:20;background:color-mix(in srgb,var(--bg) 88%,transparent);
  backdrop-filter:blur(10px);border-bottom:1px solid var(--line)}
nav.toc ul{display:flex;gap:4px;list-style:none;margin:0;padding:10px 0;
  overflow-x:auto;scrollbar-width:thin}
nav.toc a{white-space:nowrap;text-decoration:none;color:var(--muted);
  font-size:14px;font-weight:560;padding:6px 12px;border-radius:8px}
nav.toc a:hover{color:var(--ink);background:var(--code)}

section{padding:clamp(38px,6vw,60px) 0;border-bottom:1px solid var(--line)}
section:last-of-type{border-bottom:0}
h2{margin:0 0 6px;font-size:clamp(22px,3vw,29px);letter-spacing:-.015em;font-weight:670}
.sub{margin:0 0 26px;color:var(--muted)}

.grid{display:grid;gap:20px;
  grid-template-columns:repeat(auto-fill,minmax(min(100%,320px),1fr))}
figure{margin:0;background:var(--surface);border:1px solid var(--line);
  border-radius:14px;overflow:hidden;box-shadow:var(--shadow);
  display:flex;flex-direction:column}
figure img{display:block;width:100%;height:auto;background:#f7f7f7}
@media (prefers-color-scheme:dark){figure img{background:#eee}}
figcaption{padding:12px 15px 14px;font-size:14px;color:var(--ink);
  border-top:1px solid var(--line)}
figcaption code{font-size:12.5px}

code,kbd{font-family:ui-monospace,SFMono-Regular,"SF Mono",Menlo,Consolas,monospace;
  background:var(--code);padding:.15em .42em;border-radius:5px;font-size:.885em}
pre{background:var(--code);padding:15px 17px;border-radius:11px;overflow-x:auto;
  border:1px solid var(--line);font-size:13.5px;line-height:1.55}
pre code{background:none;padding:0}

.tablewrap{overflow-x:auto;border:1px solid var(--line);border-radius:12px;
  background:var(--surface)}
table{border-collapse:collapse;width:100%;font-size:14.5px;min-width:520px}
th,td{text-align:left;padding:11px 15px;border-bottom:1px solid var(--line);
  vertical-align:top}
th{font-weight:640;background:var(--code);font-size:13px;letter-spacing:.02em}
tr:last-child td{border-bottom:0}

.callout{border-left:3px solid var(--accent);background:var(--accent-soft);
  padding:15px 18px;border-radius:0 11px 11px 0;margin:22px 0;font-size:15px}
.callout strong{color:var(--accent)}

footer{padding:40px 0 64px;color:var(--muted);font-size:14px}
footer a{color:var(--accent)}

.themetoggle{position:fixed;right:16px;bottom:16px;z-index:50;
  background:var(--surface);color:var(--ink);border:1px solid var(--line);
  border-radius:999px;padding:9px 15px;font-size:13px;font-weight:600;
  cursor:pointer;box-shadow:var(--shadow)}
@media print{nav.toc,.themetoggle{display:none}figure{break-inside:avoid}}
"""


def build_html(version: str) -> str:
    parts = [
        '<title>Cable Box Options Guide</title>',
        f"<style>{CSS}</style>",
        '<header class="hero"><div class="wrap">',
        '<p class="eyebrow">Parametric Cable Box</p>',
        "<h1>Every option, shown</h1>",
        '<p class="lede">A visual reference for the parametric cable management box. '
        "Each parameter below is rendered from the model itself, so what you see is "
        "what it builds.</p>",
        '<div class="meta">',
        f'<span class="chip">Model {html.escape(version)}</span>',
        '<span class="chip">OpenSCAD 2021.01+</span>',
        '<span class="chip">MIT licensed</span>',
        '<span class="chip">Self-contained, works offline</span>',
        "</div></div></header>",
        '<nav class="toc"><div class="wrap"><ul>',
    ]
    for sid, title, _, _ in SECTIONS:
        parts.append(f'<li><a href="#{sid}">{html.escape(title)}</a></li>')
    parts.append('<li><a href="#start">Getting started</a></li>')
    parts.append("</ul></div></nav>")

    parts.append('<section id="start"><div class="wrap">')
    parts.append("<h2>Getting started</h2>")
    parts.append('<p class="sub">Two ways in, depending on whether you want to '
                 "adjust anything.</p>")
    parts.append(
        "<div class='tablewrap'><table><thead><tr><th>If you want</th><th>Do this</th></tr></thead><tbody>"
        "<tr><td>A ready-to-print file</td><td>Grab an STL from <code>library/</code> "
        "or from the GitHub Releases page. No software needed beyond a slicer.</td></tr>"
        "<tr><td>To change the dimensions</td><td>Open <code>cable-box-parametric.scad</code> "
        "in OpenSCAD, press <kbd>F3</kbd> for the Customizer, adjust, then <kbd>F6</kbd> "
        "to render and export.</td></tr>"
        "<tr><td>To start from a preset</td><td>Load a <code>config.json</code> from "
        "<code>library/</code> in the Customizer's preset dropdown, then tweak.</td></tr>"
        "</tbody></table></div>")
    parts.append(
        '<div class="callout"><strong>Dimensions are outer dimensions.</strong> '
        "<code>Box_Width</code>, <code>Box_Depth</code>, and <code>Box_Height</code> "
        "describe the outside of the shell. Usable interior is smaller by "
        "<code>Wall_Thickness</code> on each side, and smaller again wherever "
        "stabilizer fins sit.</div>")
    parts.append("</div></section>")

    for sid, title, sub, items in SECTIONS:
        parts.append(f'<section id="{sid}"><div class="wrap">')
        parts.append(f"<h2>{html.escape(title)}</h2>")
        parts.append(f'<p class="sub">{html.escape(sub)}</p>')
        parts.append('<div class="grid">')
        for slug, caption, _, _ in items:
            uri = data_uri(slug)
            if not uri:
                continue
            parts.append(
                f'<figure><img loading="lazy" alt="{html.escape(caption)}" src="{uri}">'
                f"<figcaption>{html.escape(caption)}</figcaption></figure>")
        parts.append("</div></div></section>")

    parts.append('<footer><div class="wrap">')
    parts.append(f"<p>Generated from <code>cable-box-parametric.scad</code> "
                 f"{html.escape(version)} by <code>scripts/build_options_guide.py</code>. "
                 "Rebuild it after changing the model so the images stay honest.</p>")
    parts.append('<p>Gridfinity is by Zack Freedman, MIT licensed. '
                 "Geometry here is implemented from the published specification.</p>")
    parts.append("</div></footer>")
    parts.append(
        '<button class="themetoggle" onclick="'
        "var r=document.documentElement,d=r.getAttribute('data-theme');"
        "var m=window.matchMedia('(prefers-color-scheme: dark)').matches;"
        "r.setAttribute('data-theme',(d?d==='dark':m)?'light':'dark');"
        '">Toggle theme</button>')
    return "\n".join(parts)


def build_md(version: str) -> str:
    out = ["# Options Guide", "",
           f"Visual reference for every parameter, rendered from the model at "
           f"`{version}`.", "",
           "A self-contained HTML version with the images embedded is at "
           "[`options-guide.html`](options-guide.html); it works offline.", "",
           "For the exhaustive parameter tables, see "
           "[`PARAMETER_REFERENCE.md`](PARAMETER_REFERENCE.md).", ""]
    for sid, title, sub, items in SECTIONS:
        out += [f"## {title}", "", sub, ""]
        for slug, caption, _, params in items:
            if not (IMG_DIR / f"{slug}.png").exists():
                continue
            out += [f"### {caption}", ""]
            if params:
                shown = ", ".join(f"`{k}={v}`" for k, v in params.items())
                out += [shown, ""]
            out += [f"![{caption}](images/options/{slug}.png)", ""]
    out += ["---", "",
            "Generated by `scripts/build_options_guide.py`. Rebuild after model "
            "changes.", ""]
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-render", action="store_true")
    args = ap.parse_args()

    IMG_DIR.mkdir(parents=True, exist_ok=True)
    version = model_version()

    if not args.no_render:
        scad = find_openscad()
        total = sum(len(i) for _, _, _, i in SECTIONS)
        n = 0
        for sid, title, _, items in SECTIONS:
            print(f"  {title}")
            for slug, caption, cam, params in items:
                n += 1
                print(f"    [{n}/{total}] {slug}")
                render(scad, slug, cam, params)

    HTML_OUT.write_text(build_html(version), encoding="utf-8")
    MD_OUT.write_text(build_md(version), encoding="utf-8")
    kb = HTML_OUT.stat().st_size / 1024
    print(f"\nWrote {HTML_OUT.relative_to(REPO)} ({kb:.0f} KB, self-contained)")
    print(f"Wrote {MD_OUT.relative_to(REPO)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
