# Module Reference

This page describes each custom module in `cable-box-parametric.scad`, what it builds, and where it is used.

## Top-Level Render Flow

- Entry point: `full_render()`
- Main branches:
  - Slicing disabled: render `m_box_with_openings()` and/or `m_lid()`
  - Slicing enabled: render `m_box_slice(i)` and/or `m_lid_slice(i)`

## Core Box and Lid

### `m_box_base()`

Builds base box solids and subtractive cavities before side openings are cut.

Includes:

- Outer shell and inner hollow shell
- Optional center post outer/inner solids
- Optional stabilizers
- Optional bottom openings subtract

Used by:

- `m_box_with_openings()`

### `m_box_with_openings()`

Wraps `m_box_base()` and subtracts side openings for enabled walls.

Behavior:

- Applies global offsets and per-side offsets
- Uses per-side width/height overrides when override values are greater than `0`

Used by:

- non-sliced render path
- `m_box_slice()`

### `m_lid()`

Builds the lid: the body from `m_lid_body()`, plus the optional center-post
collar and socket, magnet pockets, Gridfinity lid top, and finger relief.

Behavior:

- Handles the post socket if `Enable_Post=true`. The socket bore is
  `Post_Diameter + 2*Lid_Lip_Gap`, so the post has the same clearance as the
  lip.

Used by:

- non-sliced render path
- `m_lid_slice()`

### `m_lid_body()`

Builds the lid's slab and its lip, in the style `Lid_Style` selects. Both
styles share the footprint `Lid_Outer_Width` x `Lid_Outer_Depth` and the total
height `Lid_Height + Lid_Lip_Gap_Height`.

- `Skirt`: one shell with a pocket cut into its top `Lid_Lip_Gap_Height`. The
  pocket is the box's outline plus `Lid_Lip_Gap` per side, so the skirt wraps
  the outside of the wall.
- `Plug`: a slab with a ring on top. The ring's outside is the box interior
  minus `Lid_Lip_Gap` per side, it is `Wall_Thickness` thick, and it is
  notched around the magnet bosses when `Enable_Lid_Magnets=true`.

Before 2.0.0-rc.5 the lip was a ring that overlapped the outer half of the box
wall, so the lid stood on the rim. The `assembly_*` scenarios seat the lid on
the box through `tests/assembly/lid_seated.scad` and fail on any overlap.

### `m_opening(side, width, height, corner_radius)`

Generates a side opening profile and extrudes through wall thickness.

Behavior:

- Orientation depends on `side`
- `corner_radius < 0` uses fully rounded slot ends
- `corner_radius = 0` produces a square-corner opening
- `corner_radius > 0` produces a rounded rectangle (clamped to valid half-extents)
- Works with vertical, horizontal, and square dimensions

## Stabilizers

### `m_stabilizer_fin(width, depth, height)`

Creates one triangular-wedge fin as a polyhedron.

### `m_stabilizers_front_back()`

Places stabilizers on front/back walls.

Key logic:

- Alignment modes: `Centered`, `Distributed`, `Custom`
- `Centered`/`Custom` pitch is controlled by `Stabilizer_FB_Spacing`
- Optional opening avoid zones per wall
- Avoid fallback: if all candidate positions are suppressed and distributed positions exist, it falls back to distributed

### `m_stabilizers_left_right()`

Places stabilizers on left/right walls with matching alignment/avoid behavior.

Key logic:

- Alignment modes: `Centered`, `Distributed`, `Custom`
- `Centered`/`Custom` pitch is controlled by `Stabilizer_LR_Spacing`
- Optional opening avoid zones per wall
- Avoid fallback: if all candidate positions are suppressed and distributed positions exist, it falls back to distributed

### `m_stabilizers()`

Wrapper that dispatches both stabilizer placement modules when enabled.

## Bottom Openings

### `m_bottom_opening_shape(width, length, corner_radius)`

Builds one bottom opening footprint with optional rounded corners.

### `m_bottom_openings()`

Primary dispatcher for bottom openings.

Chooses:

- arrangement axis handling (`Along X`, `Along Y`)
- secondary-axis alignment
- post-avoid path vs normal path

When post-avoid is enabled, primary and secondary alignment settings still apply while openings are kept outside the post-clearance zone.

### `m_place_openings_along_x(opening_size, y_pos, available_x)`

Places arrayed bottom openings along X with primary alignment logic.

### `m_place_openings_along_y(opening_size, x_pos, available_y)`

Places arrayed bottom openings along Y with primary alignment logic.

### `m_place_openings_avoid_post_x(opening_size, y_pos)`

Splits opening placement around center post clearance when arranged along X.

### `m_place_openings_avoid_post_y(opening_size, x_pos)`

Splits opening placement around center post clearance when arranged along Y.

## Slicing and Clips

### `m_floor_clip_male()`

Creates one male clip tab for box slice seams. `m_place_floor_clips` stands it
on `z=0`, so it spans z 0 to `Clip_Tab_Height` and the piece sits flat on its
floor. Before 2.0.0-rc.5 it was centred on the floor and hung 0.575 mm below
it.

### `m_floor_clip_female()`

Creates one female clip pocket using `Clip_Tolerance` and `SPACER` clearances.

### `m_place_floor_clips(x_pos, is_male)`

Places floor seam clips across depth based on `Clips_Per_Edge`.

### `m_edge_treated_shell(size, fillet, chamfer)`

The outer shell of the box or the lid slab. With both treatments at `0` it is
the `cuboid()` it has always been, which is how an untreated model is guaranteed
unchanged rather than merely expected to be. With a treatment it becomes a BOSL2
`offset_sweep()` over the same rounded rectangle, which resolves how a
horizontal fillet meets the vertical corner radius. `offset_sweep` expresses "no
profile" by omitting the argument, so the cases are enumerated rather than
passed a flat value.

### `m_lid_relief(is_cut)`

Finger relief on the lid's outer face, one shape per enabled wall, at the wall
centre. `is_cut = true` yields the scallop, a cylinder whose axis lies on the
face so the groove is a half cylinder and `Lid_Relief_Depth` is both its depth
and its half width. `is_cut = false` yields the tab, a rounded block centred on
the face so it overlaps rather than merely touching, for the same reason the
seam clips overlap their slice.

### `m_magnet_corner_positions()`

Places children at the four inside corners, each pushed `WELD` into the two
walls it sits against. The positions are symmetric in both axes, which is what
makes box and lid pockets align however the lid is flipped.

### `m_box_magnet_bosses()`, `m_box_magnet_pockets()`, `m_lid_magnet_pockets()`

The magnet features. Bosses run the full box height rather than stopping under
the rim, so they print from the bed up instead of overhanging, and stiffen the
corner. The box pocket opens at the rim; the lid pocket opens on the face that
meets it and reaches down into the slab, leaving the lid's exposed face solid.

### `m_place_lid_clips(x_pos, is_male)`

Places lid seam clips with lid-specific Z and depth extents.

The clip sits `SPACER` (0.04 mm) below the top of the lid panel rather than
flush with it. Flush, the clip's top face and the panel's top face are one
coplanar face, and on the slice seam the clip's corners become extra collinear
vertices along a straight edge; OpenSCAD then tessellates zero-area triangles
there, which slicers tolerate but CGAL rejects on re-import. Male and female
clips share the offset, so the fit is unaffected.

### `m_box_slice(slice_num)`

Cuts the box into one slice and applies seam clip logic. With
`Seam_Tooth_Depth > 0` each seam is cut by `m_seam_cutter` using
`box_seam_bands`; at `0` it takes the original flat cube cutters unchanged.

### `m_lid_slice(slice_num)`

Cuts the lid into one slice and applies seam clip logic, using
`lid_seam_bands` for its seam teeth.

### `m_seam_cutter(x_seam, keep_left, bands, z_lo, z_hi, reach)`

Removes everything on one side of a seam: the right side when `keep_left` is
true, the left side otherwise. Its edge is a profile in the XZ plane, extruded
along Y. Inside each `[s, e]` band of z the edge is a 45 degree sawtooth,
closed off by 45 degree lines at both ends; outside the bands it is a straight
vertical cut. The two pieces' edges sit `Clip_Tolerance` apart inside the
bands.

The sawtooth has no undercut, so the pieces still engage by pushing together
along X, as the floor clips do. A jigsaw or dovetail cut would only slide
together along Y, which the floor clips cannot.

### `box_seam_bands(x_seam)` and `lid_seam_bands(x_seam)`

Return the z bands that carry teeth at a seam.

- Box: the walls from the floor's top face to the rim, less the height range
  of any front or back opening that crosses the seam's tooth strip.
- Lid: the slab below the band the lid's seam clips occupy, or no bands when a
  front or back lid relief sits on the seam.

Bands shorter than one tooth depth are dropped.

## Attachment Interface

`m_box()` and `m_lid_part()` expose the box and lid as BOSL2 attachables, so
accessories can be placed against a named feature rather than a coordinate
expression.

```scad
Render_On_Include = false;   // or pass -D Render_On_Include=false
include <cable-box-parametric.scad>

m_box()
    attach("wall-back")
        my_bracket();
```

### `m_box(anchor, spin, orient)`

Defaults to `anchor=BOTTOM`, which reproduces the standard placement with the
box sitting on `z=0`. The declared envelope includes any Gridfinity base.

| Anchor | Where it is |
|---|---|
| standard `TOP`, `BOTTOM`, `LEFT`, `RIGHT`, `FRONT`, `BACK` | the outer bounding volume |
| `"floor"` | interior floor surface, pointing up |
| `"rim"` | top of the wall, pointing up |
| `"wall-front"`, `"wall-back"`, `"wall-left"`, `"wall-right"` | inner face of that wall at floor level, pointing into the interior |
| `"post-top"` | top of the centre post, pointing up |

### `m_lid_part(anchor, spin, orient)`

| Anchor | Where it is |
|---|---|
| `"lid-face"` | the face that ends up **exposed** when the box is closed, pointing away from the lid |
| `"lip"` | the free edge of the engagement lip, a skirt or a plug, which meets the box |

`"lid-face"` is worth understanding. The lid prints face-down: its engagement
lip points up, into the box, so the exposed face is the model's `z=0` face and
anything mounted on it grows downward. Getting this backwards is a real bug this
project has already shipped once, in the v1.2.0 Gridfinity lid interface. The
anchor exists so nobody has to re-derive it.

## Final Dispatcher

### `full_render()`

This is the only top-level renderer called at file end.

Behavior summary:

- If `Enable_Slicing=false`:
  - render unsliced box/lid by `Part_To_Render`
- If `Enable_Slicing=true` and `Slice_Piece_To_Render=0`:
  - preview all slices spaced by `Slice_Preview_Spacing`
- If `Enable_Slicing=true` and `Slice_Piece_To_Render>0`:
  - render only selected slice index

## Practical Change Guidance

When editing geometry, validate in this order:

1. `m_box_base()` and `m_lid()` produce valid unsliced solids
2. Side openings subtract correctly in `m_box_with_openings()`
3. Sliced paths still produce manifold outputs (`m_box_slice`, `m_lid_slice`)
4. Assertions still guard invalid states
5. Run smoke scripts after every behavior change
