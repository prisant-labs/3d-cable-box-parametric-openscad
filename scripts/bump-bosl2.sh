#!/usr/bin/env bash
# Move the pinned BOSL2 version and prove the geometry did not change.
#
# CI pins BOSL2 to a commit (BOSL2_REF in .github/workflows/scad-smoke.yml) so an
# upstream change cannot silently alter what this model produces. That pin is
# only useful if moving it is a deliberate, verified act, which is what this
# script makes it.
#
# The risk is specific and has already bitten once. Upgrading from the embedded
# 2022 BOSL2 to 2.0.747 exposed a latent coplanar-face problem: the lid's lip
# ring and post collar met the panel with zero overlap, the old kernel fused
# them and the new one did not, and the lid started exporting as three detached
# solids. Nothing errored. Only a geometry comparison catches that class.
#
# Usage:
#   bash scripts/bump-bosl2.sh                 # report current pin and what is available
#   bash scripts/bump-bosl2.sh <ref>           # try a ref, compare, do not write
#   bash scripts/bump-bosl2.sh <ref> --apply   # ...and update the workflow if clean
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

WORKFLOW=".github/workflows/scad-smoke.yml"
MODEL="cable-box-parametric.scad"
SCAD_BIN="${OPENSCAD_BIN:-openscad}"
[ -x "$SCAD_BIN" ] || command -v "$SCAD_BIN" >/dev/null 2>&1 || {
  for c in "/c/Program Files/OpenSCAD/openscad.exe" "/usr/bin/openscad"; do
    [ -x "$c" ] && SCAD_BIN="$c" && break
  done
}

# Locate the installed BOSL2 so we can check out refs against it.
LIBDIR=""
for d in "$HOME/Documents/OpenSCAD/libraries" "$HOME/.local/share/OpenSCAD/libraries" \
         "/usr/share/openscad/libraries"; do
  [ -d "$d/BOSL2/.git" ] && LIBDIR="$d" && break
done
[ -n "$LIBDIR" ] || { echo "BOSL2 git checkout not found in any OpenSCAD library dir"; exit 1; }
BOSL2="$LIBDIR/BOSL2"

CURRENT=$(grep -oE '^\s*BOSL2_REF:\s*\S+' "$WORKFLOW" | awk '{print $2}')
echo "Current pin:  $CURRENT"
echo "BOSL2 clone:  $BOSL2"

# Verify the clone we are about to check out is the library OpenSCAD actually
# loads. On Windows with Documents redirected to OneDrive these differ silently,
# and every render below would then test a version this script never touched.
PROBE="$(mktemp -d)/probe.scad"
printf 'include <BOSL2/version.scad>\necho(str("V ", BOSL_VERSION));\n' > "$PROBE"
# `|| true` on both pipelines: when the probe finds nothing, that IS the
# mismatch case and must reach the report below, not be swallowed by set -e as
# a silent non-zero exit.
LOADED=$({ "$SCAD_BIN" -o "${PROBE%.scad}.stl" "$PROBE" 2>&1 \
          | grep -oE 'V \[[0-9, ]+\]' | grep -oE '[0-9]+, *[0-9]+, *[0-9]+' \
          | tr -d ' ' | tr ',' '.'; } || true)
CLONE_VERSION=$({ grep -m1 -oE 'BOSL_VERSION *= *\[[0-9, ]+\]' "$BOSL2/version.scad" \
          | grep -oE '[0-9]+, *[0-9]+, *[0-9]+' | tr -d ' ' | tr ',' '.'; } || true)
echo "Clone version: ${CLONE_VERSION:-unknown}"
echo "OpenSCAD loads: ${LOADED:-unknown}"
if [ "$LOADED" != "$CLONE_VERSION" ]; then
  echo
  echo "MISMATCH. OpenSCAD is loading a different BOSL2 than the clone this"
  echo "script manages, so any comparison below would be meaningless."
  echo "Set OPENSCADPATH to the folder containing the managed clone:"
  echo "  export OPENSCADPATH=\"$LIBDIR\""
  exit 1
fi

if [ $# -eq 0 ]; then
  echo
  echo "Latest upstream commits:"
  git -C "$BOSL2" fetch -q origin 2>/dev/null || true
  git -C "$BOSL2" log -5 --format='  %h  %cs  %s' origin/HEAD 2>/dev/null \
    || git -C "$BOSL2" log -5 --format='  %h  %cs  %s'
  echo
  echo "Re-run with a ref to test it:  bash scripts/bump-bosl2.sh <ref> [--apply]"
  exit 0
fi

TARGET="$1"
APPLY="${2:-}"

# Scenarios to compare. Deliberately includes the lid and the Gridfinity
# interfaces, which are where coplanar-face joins live.
declare -a CASES=(
  'Part_To_Render="Box Only"'
  'Part_To_Render="Lid Only"'
  'Part_To_Render="Box and Lid"'
  'Closed_Post=true'
  'Enable_Bottom_Openings=true'
  'Enable_Gridfinity_Bottom=true;Closed_Post=true'
  'Enable_Gridfinity_Lid_Top=true;Part_To_Render="Lid Only"'
  'Enable_Slicing=true;Slice_Count=2;Slice_Piece_To_Render=0;Part_To_Render="Box and Lid"'
  'Clip_Style="Snap";Enable_Slicing=true;Slice_Count=2;Slice_Piece_To_Render=0;Part_To_Render="Box Only"'
)

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

render_all() {  # $1 = output prefix
  local i=0
  for c in "${CASES[@]}"; do
    local args=()
    IFS=';' read -ra parts <<< "$c"
    for p in "${parts[@]}"; do args+=(-D "$p"); done
    "$SCAD_BIN" -o "$TMP/$1_$i.stl" "$MODEL" "${args[@]}" >/dev/null 2>&1 || echo "    (case $i failed to render)"
    i=$((i+1))
  done
}

volume() {  # signed-tetrahedron sum; the invariant that actually matters
  python3 - "$1" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1])
if not p.exists():
    print("MISSING"); raise SystemExit
v=[]; tot=0.0
with p.open(errors="replace") as fh:
    for l in fh:
        l=l.strip()
        if l.startswith("vertex"):
            v.append(tuple(map(float, l.split()[1:4])))
            if len(v)==3:
                (a,b,c),(d,e,f),(g,h,i)=v
                tot += (a*(e*i-f*h) - b*(d*i-f*g) + c*(d*h-e*g))/6.0
                v=[]
print(f"{abs(tot):.4f}")
PY
}

ORIGINAL_HEAD=$(git -C "$BOSL2" rev-parse HEAD)
restore() { git -C "$BOSL2" checkout -q "$ORIGINAL_HEAD" 2>/dev/null || true; }
trap 'restore; rm -rf "$TMP"' EXIT

echo
echo "Rendering against current pin $CURRENT ..."
git -C "$BOSL2" checkout -q "$CURRENT" 2>/dev/null || { echo "cannot check out $CURRENT"; exit 1; }
render_all before

echo "Rendering against target  $TARGET ..."
git -C "$BOSL2" fetch -q origin 2>/dev/null || true
git -C "$BOSL2" checkout -q "$TARGET" 2>/dev/null || { echo "cannot check out $TARGET"; exit 1; }
NEW_VERSION=$(grep -m1 -oE 'BOSL_VERSION *= *\[[0-9, ]+\]' "$BOSL2/version.scad" | grep -oE '[0-9]+, *[0-9]+, *[0-9]+' | tr -d ' ' | tr ',' '.')
render_all after

echo
printf '  %-58s %14s %14s %s\n' "case" "before" "after" "delta"
fail=0
i=0
for c in "${CASES[@]}"; do
  b=$(volume "$TMP/before_$i.stl")
  a=$(volume "$TMP/after_$i.stl")
  if [ "$b" = "MISSING" ] || [ "$a" = "MISSING" ]; then
    printf '  %-58s %14s %14s  RENDER FAILED\n' "${c:0:58}" "$b" "$a"; fail=1
  else
    d=$(python3 -c "print(f'{float('$a')-float('$b'):+.4f}')")
    flag=$(python3 -c "print('' if abs(float('$a')-float('$b'))<1e-3 else '  <-- CHANGED')")
    [ -n "$flag" ] && fail=1
    printf '  %-58s %14s %14s %s%s\n' "${c:0:58}" "$b" "$a" "$d" "$flag"
  fi
  i=$((i+1))
done

echo
echo "Running the geometry suite against $TARGET ..."
if OPENSCAD_BIN="$SCAD_BIN" python3 tests/run_tests.py >"$TMP/tests.log" 2>&1; then
  echo "  $(tail -1 "$TMP/tests.log")"
else
  echo "  SUITE FAILED:"; grep -E "FAIL|failed" "$TMP/tests.log" | head -20; fail=1
fi

echo
if [ "$fail" -ne 0 ]; then
  echo "NOT CLEAN. Investigate before bumping."
  echo "A volume change is a real geometry change. A suite failure may be a latent"
  echo "defect the new version exposed rather than a new bug; check what changed."
  exit 1
fi

echo "Clean: volumes unchanged and the suite passes against BOSL2 $NEW_VERSION."
if [ "$APPLY" = "--apply" ]; then
  sed -i "s|^\(\s*BOSL2_REF:\s*\).*|\1$TARGET|" "$WORKFLOW"
  echo "Updated $WORKFLOW to $TARGET"
  echo "Remember to note the bump in CHANGELOG.md."
else
  echo "Re-run with --apply to update $WORKFLOW."
fi
