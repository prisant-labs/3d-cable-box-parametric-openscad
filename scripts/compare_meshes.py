#!/usr/bin/env python3
"""Compare meshes from two revisions of the model, canonically.

A regenerated STL is not byte-stable: OpenSCAD emits the same geometry in a
different facet order from one run to the next, so a byte diff proves nothing
either way. This renders the same configurations from two revisions of
`cable-box-parametric.scad` and compares the canonical meshes, the way
`scripts/build_library.py` does for its GLBs.

It exists for the "no regression" question a geometry change has to answer: do
the parts a change was not meant to touch still come out identical?

Usage:
  python scripts/compare_meshes.py --baseline main [--filter NAME]

Requires trimesh and numpy, the same optional dependency build_library.py uses
for its GLBs.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MODEL = "cable-box-parametric.scad"

# Configurations that a Gridfinity change must leave alone. Each is a name and
# the -D arguments that select it.
CASES: list[tuple[str, list[str]]] = [
    ("plug_lid", ['Part_To_Render="Lid Only"']),
    ("skirt_lid", ['Part_To_Render="Lid Only"', 'Lid_Style="Skirt"']),
    ("lid_with_magnets", ['Part_To_Render="Lid Only"', "Enable_Lid_Magnets=true"]),
    ("lid_relief_tab", ['Part_To_Render="Lid Only"', 'Lid_Relief_Style="Tab"']),
    ("sliced_lid_piece_1", ['Part_To_Render="Lid Only"', "Enable_Slicing=true",
                            "Slice_Count=2", "Slice_Piece_To_Render=1"]),
    ("box", ['Part_To_Render="Box Only"']),
    ("box_and_lid", ['Part_To_Render="Box and Lid"']),
    ("edge_treated_box", ['Part_To_Render="Box Only"', "Bottom_Edge_Fillet=0.8",
                          "Top_Edge_Chamfer=0.6"]),
]


def find_openscad() -> str:
    env_bin = shutil.which("openscad")
    if env_bin:
        return env_bin
    for candidate in (r"C:\Program Files\OpenSCAD\openscad.exe", "/usr/bin/openscad"):
        if Path(candidate).exists():
            return candidate
    sys.exit("OpenSCAD not found; put it on PATH.")


def render(scad_bin: str, src: Path, out: Path, defines: list[str]) -> bool:
    cmd = [scad_bin, "-o", str(out), str(src)]
    for d in defines:
        cmd += ["-D", d]
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=1800)
    return proc.returncode == 0 and out.exists()


def fingerprint(path: Path) -> str:
    """A hash of the mesh with vertex and face order removed."""
    import hashlib

    import numpy as np
    import trimesh

    mesh = trimesh.load(path, force="mesh")
    mesh.merge_vertices()
    order = np.lexsort((mesh.vertices[:, 2], mesh.vertices[:, 1], mesh.vertices[:, 0]))
    remap = np.empty(len(order), dtype=np.int64)
    remap[order] = np.arange(len(order))
    faces = remap[mesh.faces]
    roll = faces.argmin(axis=1)
    faces = np.take_along_axis(faces, (np.arange(3)[None, :] + roll[:, None]) % 3, axis=1)
    faces = faces[np.lexsort((faces[:, 2], faces[:, 1], faces[:, 0]))]
    verts = np.round(mesh.vertices[order], 6)
    digest = hashlib.sha256()
    digest.update(verts.tobytes())
    digest.update(faces.astype(np.int64).tobytes())
    return digest.hexdigest()[:16]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--baseline", default="main", help="git revision to compare against")
    ap.add_argument("--filter", default="", help="only cases whose name contains this")
    args = ap.parse_args()

    cases = [c for c in CASES if args.filter in c[0]]
    if not cases:
        sys.exit("no cases matched")

    scad_bin = find_openscad()
    work = Path(tempfile.mkdtemp(prefix="cbp-compare-"))
    baseline_src = work / "baseline.scad"
    blob = subprocess.run(["git", "show", f"{args.baseline}:{MODEL}"],
                          cwd=REPO, capture_output=True, text=True)
    if blob.returncode != 0:
        sys.exit(f"could not read {MODEL} at {args.baseline}")
    baseline_src.write_text(blob.stdout, encoding="utf-8", newline="")

    print(f"baseline: {args.baseline}")
    print(f"working:  {MODEL}\n")

    differed = 0
    try:
        for name, defines in cases:
            out_a = work / f"{name}_baseline.stl"
            out_b = work / f"{name}_working.stl"
            ok_a = render(scad_bin, baseline_src, out_a, defines)
            ok_b = render(scad_bin, REPO / MODEL, out_b, defines)
            if not (ok_a and ok_b):
                print(f"  ERROR {name}: baseline={ok_a} working={ok_b}")
                differed += 1
                continue
            fa, fb = fingerprint(out_a), fingerprint(out_b)
            if fa == fb:
                print(f"  same  {name} ({fa})")
            else:
                print(f"  DIFFER {name}: {fa} -> {fb}")
                differed += 1
    finally:
        shutil.rmtree(work, ignore_errors=True)

    print(f"\n{len(cases) - differed} identical, {differed} different")
    return 1 if differed else 0


if __name__ == "__main__":
    sys.exit(main())
