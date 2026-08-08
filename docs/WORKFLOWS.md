# Workflows and Tuning Guide

This guide focuses on repeatable workflows for configuring, printing, and validating the parametric cable box.

## 1) Quick Start Workflow

1. Open `cable-box-parametric.scad` in OpenSCAD.
2. Open Customizer (`Window -> Customizer`, or `F3`).
3. Configure dimensions in sections: `Overall`, `Box`, `Post`, `Lid`, and `Openings`.
4. Press `F6` (full render).
5. Export STL for the current `Part_To_Render` value.
6. Repeat for `Box Only` and `Lid Only` if needed.

### Starting from a preset instead of the defaults

`cable-box-parametric.json` sits beside the model and carries all nine presets,
so the Customizer's preset dropdown lists them as soon as the model is open.
Pick the closest one and adjust from there rather than starting from scratch.

From the command line:

```bash
openscad -o out.stl cable-box-parametric.scad \
  -p cable-box-parametric.json -P desk-compact
```

This is OpenSCAD's native parameter-set format, so a set saved from the
Customizer can be loaded straight back in, or sent to someone else, or attached
to a bug report.

## 2) Dimensional Planning Workflow

Before changing parameters, measure:

- Largest cable connector width and height.
- Cable bend radius requirement near wall openings.
- Power brick footprint (if stored inside).
- Mounting/placement envelope on desk, shelf, or wall.

Translate measurements:

- `Box_Width` and `Box_Depth` from footprint plus clearance.
- `Box_Height` from tallest interior object plus routing margin.
- `All_Opening_Width` from thickest cable/connector dimension plus slack.
- `All_Opening_Height` from number of cables per wall and routing spread.

## 3) Lid Fit Calibration Workflow

### Objective
Achieve a consistent, repeatable friction fit across your printer/material profile.

### Steps

1. Start with default `Lid_Lip_Gap=0.1`.
2. Print a draft pair at final layer height and wall count.
3. Test fit after cooling to room temperature.
4. If too tight, increase by `0.05`.
5. If too loose, decrease by `0.05`.
6. Re-test until desired fit is reached.
7. Record your final value per filament type.

### Typical ranges

- PLA: `0.10` to `0.20`
- PETG: `0.15` to `0.30`
- ABS/ASA: `0.20` to `0.35`

Use these as starting points only.

## 4) Side Opening Workflow

### Baseline pattern

1. Set global values: `All_Opening_Width`, `All_Opening_Height`.
2. Enable walls using `Opening_On_*` toggles.
3. Use `All_Openings_Right` and `All_Openings_Up` for global shifts.

### Per-side refinement

1. Set side override width/height (`Override_Opening_*`) only when needed.
2. Use side-local offsets (`Move_Opening_*`) for asymmetry.
3. Keep overrides at `0` when global values are sufficient.

### Validation checklist

- Confirm openings do not intersect rounded corners too aggressively.
- Verify opening height still satisfies model assertion (`height > width` globally).
- Verify opening placement does not conflict with stabilizer zones unless intended.

## 5) Stabilizer Workflow

### When to enable

Use stabilizers when:

- Box walls are tall/thin.
- Internal loads are non-trivial.
- Opening cutouts remove too much wall stiffness.

### Configuration sequence

1. Enable `Enable_Stabilizers=true`.
2. Set geometry: `Stabilizer_Width`, `Stabilizer_Depth`, `Stabilizer_Height`.
3. Configure front/back count and alignment.
4. Configure left/right count and alignment.
5. Enable opening avoidance toggles for affected walls.

### Practical tuning

- Increase count before increasing depth for less interior intrusion.
- Keep depth moderate if routing many cables internally.
- Use `Distributed` with margins to avoid corner crowding.

## 6) Bottom Openings Workflow

### Strategy

Define geometry first, then placement.

1. Set `Enable_Bottom_Openings=true`.
2. Set geometry: width, depth, orientation, corner radius.
3. Choose arrangement axis (`Bottom_Opening_Axis`).
4. Choose primary/secondary alignments.
5. Set spacing (`0` for auto, or explicit value).
6. Apply margins for `Start`, `End`, or `Custom` modes.

### Post interaction

If center post is enabled and `Bottom_Opening_Avoid_Post=true`, openings are split around the post clearance region. This overrides centered behavior for post-safe placement.

## 7) Slicing Workflow (Small Print Beds)

### Use case

Enable slicing when full box/lid dimensions exceed your print bed width.

### Steps

1. Set `Enable_Slicing=true`.
2. Set `Slice_Count` to fit your bed dimensions.
3. Keep `Slice_Piece_To_Render=0` to preview all slices.
4. Switch `Slice_Piece_To_Render` to each index and export STLs one at a time.
5. Print and test one mating seam before full production.

### Clip tuning

- Tight assembly: increase `Clip_Tolerance` by `0.05`.
- Loose assembly: decrease `Clip_Tolerance` by `0.05`.
- Weak seam: increase `Clips_Per_Edge` or `Clip_Tab_Width`.

## 8) Printing Baseline

### Suggested starting profile (FDM)

- Nozzle: `0.4`
- Layer height: `0.2`
- Perimeters/Walls: `3+`
- Infill: `15%` to `25%`
- Top/Bottom layers: `4+`

### Orientation

- Box: open side up.
- Lid: top cosmetic surface orientation based on visual preference.
- Sliced parts: orient to maximize seam accuracy and clip strength.

## 9) CI Smoke Workflow

### GitHub Actions

- Workflow file: `.github/workflows/scad-smoke.yml`
- Trigger: push affecting `.scad` files or manual dispatch
- Runs OpenSCAD smoke renders on Ubuntu

### Local

- Windows: run `scripts/scad-smoke.ps1`
- Linux/macOS: run `bash scripts/scad-smoke.sh`
- If needed on Bash environments, set `OPENSCAD_BIN` to your OpenSCAD executable path.

Smoke checks include:

- Baseline render
- Lid-only render
- Slicing preview render
- Expected fail case (`Slice_Piece_To_Render` out of range while slicing is enabled)

## 10) Troubleshooting Matrix

| Symptom | Likely cause | Action |
|---|---|---|
| Lid too tight | `Lid_Lip_Gap` too low | Increase by `0.05` and re-test. |
| Lid too loose | `Lid_Lip_Gap` too high | Decrease by `0.05` and re-test. |
| Side openings misaligned | Global + local offsets stacking | Reset one offset layer, then reapply intentionally. |
| Stabilizers intersect opening area | Avoid toggles disabled or margins too small | Enable avoid toggles and/or increase margins. |
| Floor openings collide with post | Post avoid disabled | Set `Bottom_Opening_Avoid_Post=true`. |
| Slice clips too hard to join | `Clip_Tolerance` too low | Increase tolerance incrementally. |
| Slice clips sloppy | `Clip_Tolerance` too high | Reduce tolerance and reprint seam test. |

## 11) Documentation and Contribution Workflow

When you add or change parameters:

1. Update `cable-box-parametric.scad` comments.
2. Update `docs/PARAMETER_REFERENCE.md`.
3. Update `docs/FAQ.md` for new troubleshooting cases.
4. Update `README.md` if user workflow changes.
5. If sharing user-generated builds or forks, place them in `community/`.

Do not hand-add files to `library/`. Everything there is generated: add an entry
to `PRESETS` in `scripts/build_library.py` and rerun it, which regenerates that
preset's `config.json`, STLs, GLB previews, renders and notes, plus
`library/README.md`, the machine-readable `library/index.json`, and the merged
`cable-box-parametric.json`. Hand-edited files there are overwritten on the next
build, and the point of generating them is that a preset cannot drift from the
model.

`library/index.json` is what the docs site's preset browser reads. It records
each preset's overrides and printed envelope, and the model's full parameter
defaults once at the top, so the effective parameter set is the defaults with
the overrides applied. It carries a `schema` number; bump `INDEX_SCHEMA` in
`scripts/build_library.py` when its shape changes incompatibly, and the site
refuses a version it does not know rather than rendering it wrong.

The GLB previews need [trimesh](https://trimesh.org) (`pip install trimesh`).
It is optional: without it the conversion is skipped with a note and everything
else builds normally. Skip it with `--no-glb`.

The conversion canonicalises each mesh before writing it. OpenSCAD emits the
same geometry in a different facet order on every run, so a straight conversion
produced a different GLB each rebuild and dirtied 27 tracked binaries that had
not changed. Sorting vertices and faces into one defined order removes that
exactly, which is why an unchanged model reconverts to byte-identical files.
