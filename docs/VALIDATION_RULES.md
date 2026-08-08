# Validation Rules

This page documents every model assertion in `cable-box-parametric.scad`, what
triggers it, and how to resolve it.

## Why the model asserts at all

OpenSCAD will happily render geometry that cannot be printed. A stabilizer fin
taller than the box, an opening taller than the wall it cuts, or a post wider
than the box all produce a valid mesh and exit code `0`. The assertions below
convert that class of silent nonsense into an actionable message, and replace
low-level BOSL2 errors with ones that name the parameter you actually typed.

## Box and Wall

### Box dimensions must be positive

```scad
assert(Box_Width > 0 && Box_Depth > 0 && Box_Height > 0,
       "Box_Width, Box_Depth, and Box_Height must be > 0");
```

Why: a non-positive extent produces a degenerate solid, and BOSL2 aborts with an
internal `all_positive(size)` message that does not name the parameter.

Fix: set all three above `0`.

### Wall thickness must be positive and must fit

```scad
assert(Wall_Thickness > 0, "Wall_Thickness must be > 0");
assert(Wall_Thickness * 2 < min(Box_Width, Box_Depth),
       "Wall_Thickness is too large for the box footprint; Inner_Width and Inner_Depth would be <= 0");
```

Why: `Inner_Width` and `Inner_Depth` are derived as the outer size minus two
walls. If the walls meet or cross, the interior inverts and every placement
calculation downstream operates on a negative span.

Fix: keep `Wall_Thickness` below half the smaller footprint dimension.

### Corner radius must be non-negative

```scad
assert(Box_Corner_Radius >= 0, "Box_Corner_Radius must be >= 0");
```

Why: negative rounding has no geometric meaning.

Fix: use `0` for square vertical edges, or any positive value.

An over-large radius is clamped rather than rejected. See
[Clamped values rather than assertions](#clamped-values-rather-than-assertions).

## Post

### Post must have a wall, and must fit inside the box

```scad
assert(!Enable_Post || Post_Diameter > Wall_Thickness * 2,
       "Post_Diameter must exceed Wall_Thickness*2 so the post has a wall");
assert(!Enable_Post || Post_Diameter < min(Inner_Width, Inner_Depth),
       "Post_Diameter must fit inside the box interior");
```

Why: the post is an outer cylinder minus a bore of
`Post_Diameter - Wall_Thickness*2`. If that bore is not smaller than the outer
diameter, no post wall remains. If the post is wider than the interior it
consumes the box walls instead of standing inside them, which previously
rendered successfully and produced a collapsed model.

Fix: keep `Post_Diameter` between `Wall_Thickness*2` and the smaller interior span.

## Stabilizers

### Fins must fit inside the box

```scad
assert(!Enable_Stabilizers || Stabilizer_Height + Wall_Thickness <= Box_Height,
       "Stabilizer_Height plus the floor exceeds Box_Height");
assert(!Enable_Stabilizers || Stabilizer_Depth * 2 < min(Inner_Width, Inner_Depth),
       "Stabilizer_Depth is too large for the box interior");
assert(!Enable_Stabilizers || Stabilizer_Width > 0,
       "Stabilizer_Width must be > 0");
```

Why: fins sit on top of the floor, so their usable height is
`Box_Height - Wall_Thickness`. A taller fin protrudes above the rim and stops the
lid seating. A fin deeper than half the interior meets the fin on the opposite wall.

Fix: reduce `Stabilizer_Height` or `Stabilizer_Depth`, or increase the box.

### Fin counts must be non-negative

```scad
assert(Stabilizers_Front_Back_Count >= 0 && Stabilizers_Left_Right_Count >= 0,
       "Stabilizer counts must be >= 0");
```

Why: negative counts were previously treated as zero, which hid the typo.

Fix: use `0` to disable a wall pair, or any positive count.

### Fin spacing must be non-negative

```scad
assert(Stabilizer_FB_Spacing >= 0 && Stabilizer_LR_Spacing >= 0,
       "Stabilizer spacing must be >= 0");
```

Why: negative spacing would overlap adjacent fins into a single mass.

Fix: use `0` for touching fins, or any positive gap.

## Side Openings

### Global opening dimensions must be positive and must fit

```scad
assert(All_Opening_Height > 0 && All_Opening_Width > 0,
       "All_Opening_Height and All_Opening_Width must be > 0");
assert(All_Opening_Height <= Box_Height,
       "All_Opening_Height must not exceed Box_Height");
```

Why: openings must have real dimensions, and an opening taller than the wall
removes the entire wall rather than cutting a slot in it.

Fix: keep the height at or below `Box_Height`. Width may be larger or smaller
than height; vertical, horizontal, and square profiles are all allowed.

### Override dimensions must be non-negative

```scad
assert(Override_Opening_Height_Front >= 0 && Override_Opening_Width_Front >= 0 &&
       Override_Opening_Height_Back >= 0  && Override_Opening_Width_Back >= 0  &&
       Override_Opening_Height_Left >= 0  && Override_Opening_Width_Left >= 0  &&
       Override_Opening_Height_Right >= 0 && Override_Opening_Width_Right >= 0,
       "Height and width overrides must be positive or zero");
```

Why: override values use `0` as the sentinel for "use the global default".

Fix: keep overrides at `0` or any positive number.

### Corner radius values must be at least -1

```scad
assert(All_Opening_Corner_Radius >= -1 &&
       Override_Opening_Corner_Radius_Front >= -1 &&
       Override_Opening_Corner_Radius_Back >= -1 &&
       Override_Opening_Corner_Radius_Left >= -1 &&
       Override_Opening_Corner_Radius_Right >= -1,
       "Corner radius values must be >= -1");
```

Why: `-1` is the sentinel for fully rounded slot ends. Values below it have no
meaning.

Fix: use `-1` for fully rounded, `0` for square, or a positive radius.

## Bottom Openings

### Count must be at least one when enabled

```scad
assert(!Enable_Bottom_Openings || Bottom_Openings_Count >= 1,
       "Bottom_Openings_Count must be >= 1 when bottom openings are enabled");
```

Why: this is the highest-consequence guard in the file. At `0`, the placement
loop `for (i = [0:Bottom_Openings_Count-1])` becomes `[0:-1]`, and OpenSCAD's
deprecated reverse-range behavior iterates it as `-1` then `0`. That cut two
unintended openings straddling the box center, which with the post enabled
undercut the post footprint and detached it from the floor. The result was two
disconnected solids returned at exit code `0`.

Fix: set `Enable_Bottom_Openings=false` to disable the feature, or use a count of
`1` or more.

### Opening dimensions must be positive when enabled

```scad
assert(!Enable_Bottom_Openings || (Bottom_Opening_Width > 0 && Bottom_Opening_Depth > 0),
       "Bottom opening width and depth must be > 0");
```

Why: a zero-extent cutout produces a degenerate subtraction.

Fix: set both above `0`.

### Post margin must be non-negative

```scad
assert(Bottom_Opening_Post_Margin >= 0, "Bottom opening post margin must be >= 0");
```

Why: a negative margin would pull openings toward the post rather than away.

Fix: use `0` for openings that touch the post clearance circle, or a positive gap.

## Slicing and Clips

### Slice index must be a valid integer

```scad
assert(is_int(Slice_Piece_To_Render) &&
       Slice_Piece_To_Render >= 0 &&
       Slice_Piece_To_Render <= Slice_Count,
       "Slice piece to render must be an integer in range 0..slice count");
```

Why: `0` is reserved for the all-slices preview, and `1..Slice_Count` map to
specific outputs. A fractional or out-of-range index has no output to select.

Fix: use `0` or an integer from `1` to `Slice_Count`.

### Slice count must be at least 2 when slicing

```scad
assert(!Enable_Slicing || Slice_Count >= 2,
       "Slice count must be >= 2 when slicing is enabled");
```

Why: slicing into one piece is a no-op with extra clip geometry attached.

Fix: set `Slice_Count >= 2`, or disable slicing.

### Clips per edge must be at least 1 when slicing

```scad
assert(!Enable_Slicing || Clips_Per_Edge >= 1, "Clips per edge must be >= 1");
```

Why: a seam with no clips leaves the printed pieces with nothing to join them.

Fix: keep `Clips_Per_Edge` at `1` or higher.

### Clip tolerance must be non-negative

```scad
assert(Clip_Tolerance >= 0, "Clip tolerance must be >= 0");
```

Why: negative tolerance inverts male and female clearance, producing an
interference fit that cannot be assembled.

Fix: use `0` or a positive tolerance. Start at `0.2` and tune from a test print.

### Clip dimensions must be positive

```scad
assert(Clip_Tab_Width > 0 && Clip_Tab_Depth > 0 && Clip_Tab_Height > 0,
       "Clip tab dimensions must be > 0");
```

Why: zero or negative clip geometry yields invalid seam bodies.

Fix: set all clip dimensions above `0`.

### Edge treatment cannot exceed the wall it cuts into

```scad
assert(Bottom_Edge_Fillet <= Wall_Thickness, ...);
assert(Top_Edge_Chamfer <= Wall_Thickness, ...);
```

Why: the floor and the rim are both `Wall_Thickness` deep. A fillet larger than
that breaches the floor from outside; a chamfer larger than that consumes the
rim the lid seats on.

Fix: reduce the treatment or increase `Wall_Thickness`.

There are two companions: `Bottom_Edge_Fillet + Top_Edge_Chamfer < Box_Height`
so the two treatments cannot meet in the middle of a short box, and
`Top_Edge_Chamfer * 2 < Lid_Height` because both lid faces are chamfered.

### Lid relief must fit the lid

```scad
assert(Lid_Relief_Style != "Scallop" || Lid_Relief_Depth * 2 < Lid_Height, ...);
assert(Lid_Relief_Style == "None" || Lid_Relief_Width < min(Box_Width, Box_Depth) - Corner_Radius * 2, ...);
```

Why: a scallop is a half-cylinder groove, so its diameter is `Lid_Relief_Depth *
2` and a deeper one cuts through both faces of the lid. A relief wider than the
flat part of a wall runs into the rounded corners, where there is no flat face
to cut or build on.

Fix: reduce `Lid_Relief_Depth`, reduce `Lid_Relief_Width`, or reduce
`Box_Corner_Radius`.

### Magnet bosses must fit the cavity and clear the post

```scad
assert(!Enable_Lid_Magnets || Magnet_Boss_Diameter * 2 < min(Box_Width, Box_Depth) - Wall_Thickness * 2, ...);
assert(!Enable_Lid_Magnets || !Enable_Post || <boss and post do not overlap>, ...);
```

Why: four bosses at the inside corners need room to exist without meeting each
other across a small box, or swallowing the centre post. Both would render as a
silent merge rather than an error.

Fix: reduce `Lid_Magnet_Diameter` or `Lid_Magnet_Wall`, reduce `Post_Diameter`,
or enlarge the box.

Two depth rules go with them: the lid must keep `GF_MIN_FLOOR` of material above
its pocket so the magnet is captured rather than showing through the exposed
face, and the box pocket cannot be deeper than the wall is tall.

## Clamped Values Rather Than Assertions

Not every out-of-range input deserves a hard stop. `Box_Corner_Radius` has an
obvious correct interpretation when it is too large, so the model clamps it and
reports what it did:

```scad
Max_Corner_Radius = max(0, (min(Box_Width, Box_Depth) - Wall_Thickness * 2) / 2 - 1e-6);
Corner_Radius     = min(Box_Corner_Radius, Max_Corner_Radius);
```

The ceiling comes from the **inner cavity**, not the outer shell. The same
rounding value is applied to the inner cuboid, which is `Wall_Thickness*2`
smaller on each axis, so a clamp derived from the outer half-extent lets values
through that BOSL2 then rejects with
`rounding radius must be smaller than half the cube width or length`.

When clamping occurs the model emits:

```
ECHO: "Box_Corner_Radius reduced from 40 to 35.65 (limited by the inner cavity at Wall_Thickness=1.85)"
```

Seam clip placement is corrected the same way. A clip whose center falls inside
the post opening has no material to bond to, so its position is pushed clear of
the opening rather than the render being rejected.

## Authoring Guidance for New Assertions

When adding new constraints:

1. Keep the condition narrow and user-actionable.
2. Make the message name the parameter the user typed, not the internal or
   library-level symbol it eventually breaks.
3. Gate the assertion on the relevant feature toggle (`!Enable_X || ...`) so a
   disabled feature never blocks a render.
4. Prefer clamping with an `echo` when the correct interpretation is obvious, and
   assert when it is not.
5. Document it here and in `docs/PARAMETER_REFERENCE.md` in the same commit.
6. Add a smoke scenario if it protects a failure mode that exits `0`.
