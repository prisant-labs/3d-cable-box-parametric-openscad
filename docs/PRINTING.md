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
real Gridfinity parts: set `Box_Width=41.5` and `Box_Depth=41.5`, because the
base rounds a 50 mm box up to 2 x 2 cells.

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

## Side Openings

- Round tops, the default, flatten near the top of each arc, and that part
  prints as an overhang anchored on one side. It spans about 1.5 mm of height
  at the default 10 mm width, and about 3.5 mm at 24 mm.
- `All_Opening_Top_Style=Teardrop` turns each rounded top corner into a 45
  degree flank with a short flat cap, so the top prints without support. The
  opening keeps its typed width and height. The cap is a bridge about 0.41
  times the opening's width, 4 mm at the default, and slicers print a bridge
  anchored at both ends well.
- A square opening, `All_Opening_Corner_Radius=0`, already has a straight
  bridge for a top, so `Teardrop` leaves it unchanged.

## Gridfinity

- The box's feet are solid and stand on the bed. Their sides lean out at 45
  degrees or rise straight, so they need no support. Releases through
  2.0.0-rc.5 hollowed the base from below and left a 37 mm bridge in every
  cell.
- With the base on, the footprint rounds up to whole cells, so the box's walls
  stand directly on the outer feet and no ledge overhangs them. Releases
  through 2.0.0-rc.5 left a flat ledge of 4 mm or more around the base, which
  printed as loose loops without supports.
- Foot magnet pockets open onto the bed, so the magnets go in after printing.
  Above each pocket, two bridging layers carry the pocket's ceiling across the
  screw hole. Each is `Print_Layer_Height` tall, 0.2 mm by default. Set it to
  the layer height you slice at. A slicer samples each layer near its middle
  height, so a step shorter than your real layers can be skipped, which
  defeats the technique.
- The lid socket opens onto the bed when the lid prints as exported, so it
  needs no support. Its floor, about 37 mm across, prints as a bridge. In test
  prints that bridge sagged, and a sagging floor makes the socket shallower, so
  tune bridging here.
- The feet are built to the spec's numbers, and a spec foot leaves 0.25 mm all
  round in a spec baseplate pocket. Test a one-cell box against a real
  baseplate before a full box anyway.

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

- With the default `Bottom_Edge_Style=Fillet`, `Bottom_Edge_Fillet` curves the
  box's bottom edge inward toward the bed, so its lowest layers overhang the
  bed slightly. Look at those layers on a small test box before you use a
  large fillet on a full box.
- `Bottom_Edge_Style=Teardrop` keeps the rounded look but finishes in a 45
  degree chamfer at the bed, so the first layers do not overhang.
  `Bottom_Edge_Style=Chamfer` is a plain 45 degree bevel, which also hides
  elephant's foot.
- `Top_Edge_Chamfer` faces up and prints without support.

## Common Print Quality Notes

- If walls feel weak, increase `Wall_Thickness` or perimeter count.
- If clips fracture, increase `Clip_Tab_Width` or use tougher material.
- If top corners warp (ABS/ASA), use enclosure and bed adhesion aids.
- If the tops of rounded openings droop, set `All_Opening_Top_Style=Teardrop`.
  If a square opening's top bridge sags, reduce bridge speed and increase
  cooling.

## Post-Processing

- Deburr opening edges lightly before cable routing.
- Dry-fit lid and seams before full cable load.
- If required, lightly sand mating features; avoid over-removal.
