# Options Guide

Visual reference for every parameter, rendered from the model at `unknown`.

A self-contained HTML version with the images embedded is at [`options-guide.html`](options-guide.html); it works offline.

For the exhaustive parameter tables, see [`PARAMETER_REFERENCE.md`](PARAMETER_REFERENCE.md).

## Overall

What gets generated.

### Box Only

`Part_To_Render=Box Only`

![Box Only](images/options/part-box.png)

### Lid Only

`Part_To_Render=Lid Only`

![Lid Only](images/options/part-lid.png)

### Box and Lid

`Part_To_Render=Box and Lid`

![Box and Lid](images/options/part-both.png)

## Box

Shell dimensions and wall.

### Default 100 x 75 x 50

![Default 100 x 75 x 50](images/options/box-default.png)

### Wide: 200 x 75 x 50

`Box_Width=200`

![Wide: 200 x 75 x 50](images/options/box-wide.png)

### Tall: 100 x 75 x 90

`Box_Height=90`

![Tall: 100 x 75 x 90](images/options/box-tall.png)

### Corner radius 2 (crisp)

`Box_Corner_Radius=2`

![Corner radius 2 (crisp)](images/options/radius-2.png)

### Corner radius 8.1 (default)

![Corner radius 8.1 (default)](images/options/radius-8.png)

### Corner radius 25 (soft)

`Box_Corner_Radius=25`

![Corner radius 25 (soft)](images/options/radius-25.png)

### Wall 1.2 mm

`Wall_Thickness=1.2`

![Wall 1.2 mm](images/options/wall-thin.png)

### Wall 3.0 mm

`Wall_Thickness=3.0`

![Wall 3.0 mm](images/options/wall-thick.png)

## Centre post

The cable-wrapping core.

### Post enabled (default)

![Post enabled (default)](images/options/post-on.png)

### Post disabled

`Enable_Post=False`

![Post disabled](images/options/post-off.png)

### Post diameter 30

`Post_Diameter=30`

![Post diameter 30](images/options/post-wide.png)

### Closed_Post: solid floor under the post

`Closed_Post=True`

![Closed_Post: solid floor under the post](images/options/post-closed.png)

## Lid

Fit and engagement.

### Default lid

`Part_To_Render=Lid Only`

![Default lid](images/options/lid-default.png)

### Lid_Height 16

`Part_To_Render=Lid Only`, `Lid_Height=16`

![Lid_Height 16](images/options/lid-tall.png)

### Lid_Lip_Gap_Height 8

`Part_To_Render=Lid Only`, `Lid_Lip_Gap_Height=8`

![Lid_Lip_Gap_Height 8](images/options/lid-deep-lip.png)

## Side openings

Where cables enter and leave.

### Default: 10 wide x 30 tall, flush with the floor

![Default: 10 wide x 30 tall, flush with the floor](images/options/open-default.png)

### Width 30

`All_Opening_Width=30`

![Width 30](images/options/open-wide.png)

### Height 15

`All_Opening_Height=15`

![Height 15](images/options/open-short.png)

### All_Openings_Up 12: lifted off the floor

`All_Openings_Up=12`

![All_Openings_Up 12: lifted off the floor](images/options/open-up.png)

### Corner radius 0: square corners

`All_Opening_Corner_Radius=0`

![Corner radius 0: square corners](images/options/open-square.png)

### Corner radius -1: fully rounded (default)

![Corner radius -1: fully rounded (default)](images/options/open-round.png)

### Front and back only

`Opening_On_Left=False`, `Opening_On_Right=False`

![Front and back only](images/options/open-two-sides.png)

### Per-side override: wide front opening

`Override_Opening_Width_Front=40`, `Override_Opening_Height_Front=20`

![Per-side override: wide front opening](images/options/open-override.png)

## Stabilizer fins

Interior ribs that stiffen the walls.

### Disabled

`Enable_Stabilizers=False`

![Disabled](images/options/stab-off.png)

### 3 fins, centred (default)

![3 fins, centred (default)](images/options/stab-default.png)

### 5 fins, distributed

`Stabilizers_Front_Back_Count=5`, `Stabilizers_Front_Back_Alignment=Distributed`

![5 fins, distributed](images/options/stab-distributed.png)

### All four walls

`Stabilizers_Left_Right_Count=2`

![All four walls](images/options/stab-allwalls.png)

### Taller and deeper fins

`Stabilizer_Height=44`, `Stabilizer_Depth=22`

![Taller and deeper fins](images/options/stab-tall.png)

## Floor openings

Cutouts through the box floor.

### Disabled (default)

![Disabled (default)](images/options/bottom-off.png)

### 3 openings along X

`Enable_Bottom_Openings=True`

![3 openings along X](images/options/bottom-on.png)

### Arranged along Y

`Enable_Bottom_Openings=True`, `Bottom_Opening_Axis=Along Y`

![Arranged along Y](images/options/bottom-y.png)

### 6 openings, distributed

`Enable_Bottom_Openings=True`, `Bottom_Openings_Count=6`, `Bottom_Opening_Alignment_Primary=Distributed`

![6 openings, distributed](images/options/bottom-many.png)

## Slicing for small beds

Split the model into clipping pieces.

### 2 pieces, preview layout

`Enable_Slicing=True`, `Slice_Count=2`, `Part_To_Render=Box Only`

![2 pieces, preview layout](images/options/slice-2.png)

### 3 pieces

`Enable_Slicing=True`, `Slice_Count=3`, `Part_To_Render=Box Only`

![3 pieces](images/options/slice-3.png)

### Exporting a single piece

`Enable_Slicing=True`, `Slice_Count=2`, `Slice_Piece_To_Render=1`, `Part_To_Render=Box Only`

![Exporting a single piece](images/options/slice-one.png)

### 4 clips per seam

`Enable_Slicing=True`, `Slice_Count=2`, `Clips_Per_Edge=4`, `Part_To_Render=Box Only`

![4 clips per seam](images/options/slice-clips.png)

## Gridfinity

Optional interfaces, both shown from below.

### Disabled (default)

`Closed_Post=True`

![Disabled (default)](images/options/gf-off.png)

### Base under the box

`Enable_Gridfinity_Bottom=True`, `Closed_Post=True`

![Base under the box](images/options/gf-bottom.png)

### Profile on the lid

`Enable_Gridfinity_Lid_Top=True`, `Part_To_Render=Lid Only`

![Profile on the lid](images/options/gf-lid.png)

### Both, with magnet and screw holes

`Enable_Gridfinity_Bottom=True`, `Enable_Gridfinity_Lid_Top=True`, `Closed_Post=True`, `Enable_Gridfinity_Magnet_Screw=True`

![Both, with magnet and screw holes](images/options/gf-both.png)

---

Generated by `scripts/build_options_guide.py`. Rebuild after model changes.
