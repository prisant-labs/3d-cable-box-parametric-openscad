# Calibration Coupons

Small test prints, each isolating one fit that a full box would otherwise be
the first print of. Several 2.0.0 features render cleanly and pass the geometry
suite but have not yet been confirmed on a printer: both lid styles, both
Gridfinity interfaces, both clip styles, and the magnet pockets. Further print
validation would be helpful, and these coupons are the cheapest way to give it,
because each one uses a fraction of a full box's filament and tests one thing.
[Results so far](#results-so-far) records what has been printed.

The STLs are in [`stl/`](stl/), and every release attaches them as
`cable-box-calibration.zip`. The parameter sets they are exported from are in
[`config.json`](config.json).

## The coupons

| Coupon | What it checks | Pieces and size (mm) | Tune with |
|---|---|---|---|
| `lid-fit` | The Skirt lid's friction fit around a box with closed walls. | Box 50 x 50 x 12, lid 54 x 54 x 7 | `Lid_Lip_Gap` |
| `lid-fit-plug` | The same fit with `Lid_Style=Plug`, which fits inside the wall. | Box 50 x 50 x 12, lid 54 x 54 x 7 | `Lid_Lip_Gap` |
| `magnet-boss` | The magnet pockets and the corner bosses that hold them. | Box 50 x 50 x 12, lid 54 x 54 x 7 | `Lid_Magnet_Diameter`, `Lid_Magnet_Depth` |
| `magnet-boss-plug` | The magnets with a Plug lid, whose ring is notched around the bosses. | Box 50 x 50 x 12, lid 54 x 54 x 7 | `Lid_Magnet_Diameter`, `Lid_Magnet_Depth` |
| `gridfinity-base-1x1` | Whether a one-cell base drops into a standard Gridfinity baseplate and sits flat. | One piece, 50 x 50 x 14.8 | `Gridfinity_Profile_Clearance` |
| `gridfinity-lid-socket-1x1` | Whether a standard 1 x 1 Gridfinity bin seats in the lid's socket. | One lid, 54 x 54 x 15.8 | `Gridfinity_Profile_Clearance` |
| `snap-clip-pair` | Two halves joined by snap clips. | Two halves of an 80 x 50 x 15 box | `Clip_Tolerance`, `Clip_Snap`, `Clip_Compression` |
| `tab-clip-pair` | Two halves joined by tab clips. | Two halves of an 80 x 50 x 15 box | `Clip_Tolerance` |
| `edge-treatment` | A 1.5 mm bottom fillet and a 0.6 mm top chamfer. | One piece, 40 x 40 x 10 | `Bottom_Edge_Fillet`, `Top_Edge_Chamfer` |
| `side-opening` | The default 10 x 30 mm opening, standing on its 5 mm sill. | One piece, 60 x 40 x 40 | `All_Opening_Width`, `All_Openings_Up` |

The two-piece coupons export both parts in one STL, side by side. The clip
coupons export both halves the same way, with their clips attached.

Magnets go one per pocket, with a pocket in the box and a matching pocket in
the lid at each corner. Each pocket is 6.2 mm across and 2.4 mm deep, so it
takes a nominal 6 mm disc up to 2.4 mm thick. Insert each pair with opposing
poles facing, because the symmetric pockets cannot enforce polarity.

## Using a coupon

1. Print it in the material and with the settings you will use for the box. A
   fit tuned in PLA does not carry over to PETG.
2. Let it cool fully before you judge the fit, because parts shrink as they
   cool.
3. If the fit is wrong, change the parameter in the "Tune with" column. For
   clearances, `0.05 mm` steps are enough. Re-export and reprint.
4. Use the value you settled on in your real box.

The coupons use the model defaults for everything that affects fit:
`Wall_Thickness`, `Box_Corner_Radius`, `Lid_Lip_Gap` and `Clip_Tolerance`. If
your box changes any of those, change the coupon to match, because the fit
depends on them.

To re-export one coupon, run this from the repository root:

```sh
openscad -o lid-fit.stl -p calibration/config.json -P lid-fit cable-box-parametric.scad
```

To change a value, edit it in `config.json` (or in a copy) and re-export. Do
not pass it with `-D` on the same command: when a parameter set is loaded with
`-P`, OpenSCAD 2021.01 keeps the set's value and ignores the `-D`.

## Reporting a result

A result from your printer is worth reporting even when the fit is right,
because it is the evidence that turns "renders cleanly" into "prints cleanly".
Open an issue and include:

- the coupon name, and the model version printed in OpenSCAD's console
  (`cable-box-parametric 2.0.0`);
- printer, nozzle, layer height, and material;
- the outcome: fits, too tight, or too loose, plus any parameter you changed;
- a photo, if you can.

## Results so far

The rc.4 coupons were printed once, on a Bambu Lab P1S with a 0.4 mm nozzle,
0.2 mm layers, and PLA+. One printer is a first data point, not a tuned
default.

| Coupon | rc.4 result | Status in rc.5 |
|---|---|---|
| `lid-fit` | The lid could not fit. Its lip stood on the box rim, a defect present since 1.0.0. | Fixed: the lid is a Skirt or a Plug. Reprint. |
| `magnet-boss` | The box pocket held a 6 x 2 mm magnet snugly, and the lid pocket let it fall out. The hold could not be tested, because the lid did not seat. | Reprint with the fixed lid. |
| `gridfinity-base-1x1` | The base seated in the model's own lid socket. It has not been tried in a standard baseplate, so the fit to the standard is still open. | Unchanged. Test it against a reference baseplate. |
| `gridfinity-lid-socket-1x1` | It accepted the model's own base. The socket floor printed as a sagging bridge. | The lid footprint grew by 0.2 mm. Reprint. |
| `snap-clip-pair`, `tab-clip-pair` | Both assembled. Each piece stood on its male floor clips, 0.575 mm above the bed, and printed only because supports were on. | Fixed: the clips sit flush with the floor. Reprint without supports. |
| `edge-treatment` | Passed. | Unchanged. |
| `side-opening` | Passed: 10 mm wide, 30 mm tall, 5 mm up, all as specified. | Unchanged. |

## Regenerating

```sh
python scripts/build_calibration.py
python scripts/build_calibration.py --only lid-fit magnet-boss
```

The script exports each coupon from `config.json` and checks it the way the
regression suite checks a scenario. A coupon fails when OpenSCAD exits non-zero,
when the log carries a warning, or when the STL has a different number of
separate bodies than expected. An extra body is detached geometry, which a
slicer prints as a loose fragment.

The committed STLs were exported from model version 2.0.0 with OpenSCAD
2021.01 and BOSL2 2.0.747. The rc.4 STLs of `lid-fit`, `magnet-boss`, the
Gridfinity lid socket, and both clip pairs show the defects above, so take
these from rc.5 or later.
