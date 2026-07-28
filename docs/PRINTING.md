# Printing Guide

## Baseline FDM Settings

- Nozzle: `0.4 mm`
- Layer height: `0.20 mm`
- Walls/perimeters: `3+`
- Top/bottom layers: `4+`
- Infill: `15%` to `25%`
- Material: PLA or PETG recommended for first-fit calibration

## Orientation

- Box: print with opening facing upward.
- Lid: orient based on desired cosmetic face quality.
- Sliced parts: orient to maximize split-edge dimensional accuracy.

## Fit Calibration Procedure

1. Print one box/lid pair at target material and settings.
2. Test fit after full cooling.
3. Adjust `Lid_Lip_Gap` by `0.05 mm` increments.
4. Repeat until fit target is met.

## Slicing Mode Print Procedure

1. Enable slicing and choose `Slice_Count`.
2. Export each piece with `Slice_Piece_To_Render=1..Slice_Count`.
3. Print one seam pair first.
4. Tune `Clip_Tolerance` by `0.05 mm` as needed.
5. Print full set only after seam validation.

## Common Print Quality Notes

- If walls feel weak, increase `Wall_Thickness` or perimeter count.
- If clips fracture, increase `Clip_Tab_Width` or use tougher material.
- If top corners warp (ABS/ASA), use enclosure and bed adhesion aids.
- If openings bridge poorly, reduce bridge speed and increase cooling.

## Post-Processing

- Deburr opening edges lightly before cable routing.
- Dry-fit lid and seams before full cable load.
- If required, lightly sand mating features; avoid over-removal.
