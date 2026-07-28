#!/usr/bin/env bash
set -euo pipefail

SCAD_FILE="cable-box-parametric.scad"
OUT_DIR="ci-smoke-out"
mkdir -p "$OUT_DIR"
OPENSCAD_BIN="${OPENSCAD_BIN:-openscad}"

if ! command -v "$OPENSCAD_BIN" >/dev/null 2>&1; then
  if [ -x "/mnt/c/Program Files/OpenSCAD/openscad.exe" ]; then
    OPENSCAD_BIN="/mnt/c/Program Files/OpenSCAD/openscad.exe"
  elif [ -x "/c/Program Files/OpenSCAD/openscad.exe" ]; then
    OPENSCAD_BIN="/c/Program Files/OpenSCAD/openscad.exe"
  else
    echo "OpenSCAD executable not found. Set OPENSCAD_BIN or add openscad to PATH."
    exit 127
  fi
fi

"$OPENSCAD_BIN" -o "$OUT_DIR/01_baseline.stl" "$SCAD_FILE"
"$OPENSCAD_BIN" -o "$OUT_DIR/02_lid_only.stl" "$SCAD_FILE" -D 'Part_To_Render="Lid Only"'
"$OPENSCAD_BIN" -o "$OUT_DIR/03_slicing_preview.stl" "$SCAD_FILE" -D 'Enable_Slicing=true' -D 'Slice_Count=2' -D 'Slice_Piece_To_Render=0' -D 'Part_To_Render="Box and Lid"'

# expected fail
set +e
"$OPENSCAD_BIN" -o "$OUT_DIR/04_expected_fail.stl" "$SCAD_FILE" -D 'Enable_Slicing=true' -D 'Slice_Count=2' -D 'Slice_Piece_To_Render=3'
expected_rc=$?
set -e

if [ "$expected_rc" -eq 0 ]; then
  echo "Expected failure case exited with success unexpectedly"
  exit 1
fi

if [ -f "$OUT_DIR/04_expected_fail.stl" ]; then
  echo "Expected failure case produced STL unexpectedly"
  exit 1
fi

echo "SCAD smoke checks completed"
