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

Builds lid shell, lip geometry, and optional center-post mating features.

Behavior:

- Uses `Lid_Height`, `Lid_Lip_Gap`, and `Lid_Lip_Gap_Height`
- Handles post opening if `Enable_Post=true`

Used by:

- non-sliced render path
- `m_lid_slice()`

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

Creates one male clip tab for box slice seams.

### `m_floor_clip_female()`

Creates one female clip pocket using `Clip_Tolerance` and `SPACER` clearances.

### `m_place_floor_clips(x_pos, is_male)`

Places floor seam clips across depth based on `Clips_Per_Edge`.

### `m_place_lid_clips(x_pos, is_male)`

Places lid seam clips with lid-specific Z and depth extents.

### `m_box_slice(slice_num)`

Cuts the box into one slice and applies seam clip logic.

### `m_lid_slice(slice_num)`

Cuts the lid into one slice and applies seam clip logic.

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
| `"lip"` | the engagement lip that drops into the box |

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
