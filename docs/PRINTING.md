# Printing Guide

Settings, orientation, and fit tuning for printing the box and lid, plus the
small calibration prints that check a fit before you commit to a full box.

## Baseline FDM Settings

- Nozzle: `0.4 mm`
- Layer height: `0.20 mm`
- Walls/perimeters: `3+`
- Top/bottom layers: `4+`
- Infill: `15%` to `25%`
- Material: PLA or PETG recommended for first-fit calibration

## Orientation

- Box: print it as exported, open top facing up.
- Lid: print it as exported. The lid turns over in use, so the face on the bed
  becomes the top of the closed box and gets the bed's finish. The lip, the
  magnet pockets, and the post socket all face up and print without support.
- Sliced parts: print each piece as exported, so the seam faces stay vertical
  and the clips keep their designed dimensions.

## Fit Test Box

A small box made with your own settings checks a fit before you spend the
filament on a full box. Start from your configuration and change only the
size and the extras:

- `Box_Width=50`, `Box_Depth=50`, `Box_Height=12`, and `Lid_Height=4`
- `Enable_Post=false`, `Enable_Stabilizers=false`, and every `Opening_On_*`
  set to `false`
- `Part_To_Render="Box and Lid"`, so both parts export together

Keep every value that affects the fit: `Wall_Thickness`, `Box_Corner_Radius`,
`Lid_Style`, `Lid_Lip_Gap`, and `Clip_Tolerance`.

To test one feature, turn on only that feature. Use `Enable_Lid_Magnets=true`
for the magnets. For a seam, use `Box_Width=80`, `Box_Height=15`,
`Enable_Slicing=true`, `Slice_Count=2`, and `Slice_Piece_To_Render=0`, which
exports both halves side by side. For Gridfinity, test a one-cell box against
real Gridfinity parts.

## Fit Calibration Procedure

1. Print a [fit test box](#fit-test-box), or one full box and lid pair, in
   the target material and with your usual settings.
2. Test the fit after the parts cool fully.
3. Adjust `Lid_Lip_Gap` by `0.05 mm` increments.
4. Repeat until the fit is right, then use the same value for the real box.

The default `Lid_Lip_Gap` of `0.15 mm` fitted well with both lid styles, with
and without magnets, on a Bambu Lab P1S printing PLA+.

## Slicing Mode Print Procedure

1. Enable slicing and choose `Slice_Count`.
2. Export each piece with `Slice_Piece_To_Render=1..Slice_Count`.
3. Print one seam pair first: a two-slice [fit test box](#fit-test-box), or
   the two pieces that share a seam.
4. Tune `Clip_Tolerance` by `0.05 mm` as needed. It sets the clearance of
   both the clips and the seam teeth.
5. Print the full set only after the seam fits.
6. Push the pieces together along the seam. The teeth hold them level, and the
   floor clips hold them in line. For a permanent box, put cyanoacrylate glue
   on the tooth faces before joining; the 45 degree faces give about 1.4 times
   the glue area of a flat seam.

Every piece sits flat on its floor, so sliced pieces print without support.
The seam teeth are at most 45 degrees from vertical, so they need no support
either.
Releases up to and including 2.0.0-rc.4 centred each male floor clip on the
floor, and 0.575 mm of it hung below the piece. A slicer then stood the whole
piece on its clips. Re-export any sliced pieces from those releases.

## Gridfinity

- The box base is hollow from below. The ceiling of each cell's hollow prints
  as a bridge about 37 mm wide, so good bridging settings matter more here than
  anywhere else on the model.
- The lid socket opens onto the bed when the lid prints as exported, so it
  needs no support. Its floor, about 37 mm across, prints as a bridge. In test
  prints that bridge sagged, and a sagging floor makes the socket shallower, so
  tune bridging here too.
- The box body is wider than the base block below it, and its underside prints
  as an unsupported ledge about 4 mm wide on each side. In test prints that
  ledge printed as loose loops. Use supports under it, or accept the rough
  underside.
- `Gridfinity_Profile_Clearance` (0.25 mm) is a chosen number, not a measured
  one. Test a one-cell box against real Gridfinity parts before a full box.

## Magnets

- Pockets open at the box rim and at the lid's mating face, so both print
  facing up and the magnets go in after printing. No pause is needed.
- Each pocket takes one magnet: a nominal 6 mm disc up to 2.4 mm thick.
- Insert the magnets with opposing poles facing. The pockets are symmetric, so
  the model cannot enforce polarity. Glue one pair at a time and check that the
  pair attracts before the adhesive sets.
- If a press fit cracks a boss, raise `Lid_Magnet_Diameter` slightly or
  thicken `Lid_Magnet_Wall`.

## Edge Treatment

- `Bottom_Edge_Fillet` curves the box's bottom edge inward toward the bed, so
  its lowest layers overhang the bed slightly. Look at those layers on a
  small test box before you use a large fillet on a full box.
- `Top_Edge_Chamfer` faces up and prints without support.

## Common Print Quality Notes

- If walls feel weak, increase `Wall_Thickness` or perimeter count.
- If clips fracture, increase `Clip_Tab_Width` or use tougher material.
- If top corners warp (ABS/ASA), use enclosure and bed adhesion aids.
- If openings bridge poorly, reduce bridge speed and increase cooling.

## Post-Processing

- Deburr opening edges lightly before cable routing.
- Dry-fit lid and seams before full cable load.
- If required, lightly sand mating features; avoid over-removal.
