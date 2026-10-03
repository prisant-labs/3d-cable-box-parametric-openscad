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

## Calibration Coupons

Several 2.0.0 features render cleanly and pass the geometry suite but have not
yet been confirmed on a printer: both Gridfinity interfaces, snap clips, the
edge treatment, and the magnet pockets. Further print validation would be
helpful. The
[calibration coupons](https://github.com/prisant-labs/3d-cable-box-parametric-openscad/tree/main/calibration)
are small prints that each isolate one of those fits, so you can settle a
clearance before you commit to a full box. Each release also attaches them as
`cable-box-calibration.zip`.

| Coupon | Checks |
|---|---|
| `lid-fit` | Lid friction fit, tuned with `Lid_Lip_Gap` |
| `magnet-boss` | Magnet pockets and corner bosses |
| `gridfinity-base-1x1` | Base fit in a standard Gridfinity baseplate |
| `gridfinity-lid-socket-1x1` | A standard 1 x 1 bin seated in the lid socket |
| `snap-clip-pair`, `tab-clip-pair` | Seam clip fit, tuned with `Clip_Tolerance` |
| `edge-treatment` | Bottom fillet and top chamfer |
| `side-opening` | The default side opening on its 5 mm sill |

The coupon README explains how to tune each one and how to report a result.

## Fit Calibration Procedure

1. Print the `lid-fit` coupon, or one full box and lid pair, in the target
   material and with your usual settings.
2. Test the fit after the parts cool fully.
3. Adjust `Lid_Lip_Gap` by `0.05 mm` increments.
4. Repeat until the fit is right, then use the same value for the real box.

## Slicing Mode Print Procedure

1. Enable slicing and choose `Slice_Count`.
2. Export each piece with `Slice_Piece_To_Render=1..Slice_Count`.
3. Print one seam pair first: the `snap-clip-pair` or `tab-clip-pair` coupon,
   or the two pieces that share a seam.
4. Tune `Clip_Tolerance` by `0.05 mm` as needed.
5. Print the full set only after the seam fits.

**Known issue.** Each male floor clip is 3 mm tall but centred on the 1.85 mm
floor, so 0.575 mm of it hangs below the bottom of the piece. Slicers usually
drop a part until its lowest point touches the bed, which leaves the rest of
the floor 0.575 mm above the bed. Check the sliced preview before printing a
full sliced box, and print a clip coupon first to see how your printer handles
it.

## Gridfinity

- The box base is hollow from below. The ceiling of each cell's hollow prints
  as a bridge about 37 mm wide, so good bridging settings matter more here than
  anywhere else on the model.
- The lid socket opens onto the bed when the lid prints as exported, so it
  needs no support.
- `Gridfinity_Profile_Clearance` (0.25 mm) is a chosen number, not a measured
  one. Print the two Gridfinity coupons against real Gridfinity parts before a
  full box.

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
  its lowest layers overhang the bed slightly. Look at those layers on the
  `edge-treatment` coupon before you use a large fillet on a full box.
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
