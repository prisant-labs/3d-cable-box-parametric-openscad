# Parameter Reference

This document is the canonical reference for every Customizer section and parameter in `cable-box-parametric.scad`.

## Scope and Source of Truth

- Model source: `cable-box-parametric.scad`
- Repository: `https://github.com/prisant-labs/3d-cable-box-parametric-openscad`
- License: `MIT`
- Third-party attribution: `THIRD_PARTY_NOTICES.md`

If this document and the SCAD file ever disagree, treat the SCAD file as the functional source and update this document.

## Conventions

- Units: millimeters unless stated otherwise.
- `0` as override value usually means "use default/global value".
- "Primary" alignment means along the arrangement axis.
- "Secondary" alignment means perpendicular to the arrangement axis.

## Section Index

1. Overall
2. Box
3. Post
4. Lid
5. Openings
6. Left Openings Overrides
7. Right Openings Overrides
8. Back Openings Overrides
9. Front Openings Overrides
10. Stabilizers - Main Settings
11. Stabilizers - Front/Back Walls
12. Stabilizers - Left/Right Walls
13. Bottom Openings - Main
14. Bottom Openings - Alignment
15. Bottom Openings - Custom Margins
16. Slicing - For Smaller Print Beds
17. Gridfinity
18. Hidden

## 1) Overall

| Parameter | Type | Default | Allowed values | Description | Notes |
|---|---|---:|---|---|---|
| `Part_To_Render` | enum | `"Box Only"` | `"Box Only"`, `"Lid Only"`, `"Box and Lid"` | Chooses which model body is generated. | In non-slicing mode, box and lid are separated in view for export. |

### `Part_To_Render` options

| Option | Behavior |
|---|---|
| `"Box Only"` | Renders only the box body. |
| `"Lid Only"` | Renders only the lid. |
| `"Box and Lid"` | Renders both bodies in one scene. |

## 2) Box

| Parameter | Type | Default | Description | Practical guidance |
|---|---|---:|---|---|
| `Box_Width` | number | `100` | Outer box width (X axis). | Increase for longer cable bundles or power bricks. |
| `Box_Depth` | number | `75` | Outer box depth (Y axis). | Increase for front/back routing space. |
| `Box_Height` | number | `50` | Outer box height (Z axis). | Set high enough for cable bend radius and connectors. |
| `Box_Corner_Radius` | number | `8.1` | Roundness of outer vertical edges. | Effective ceiling is `(min(Box_Width, Box_Depth) - Wall_Thickness*2) / 2`, set by the inner cavity rather than the outer shell. Larger values are clamped and reported via `echo`. |
| `Wall_Thickness` | number | `1.85` | Wall thickness for shell and post walling. | Typical FDM baseline: `1.2` to `2.4` depending nozzle/material. |

## 3) Post

| Parameter | Type | Default | Description | Interactions |
|---|---|---:|---|---|
| `Enable_Post` | boolean | `true` | Adds a center post for cable organization. | Affects bottom opening post-avoid behavior and lid post interface. |
| `Closed_Post` | boolean | `false` | Makes the post floor solid instead of open through the box bottom. | When `false` the post is a tube open at both ends. When `true` the bore starts above the floor, leaving a `Wall_Thickness` base. |
| `Post_Diameter` | number | `15` | Outer post diameter. | Also drives center clearance used by bottom post-avoid logic. |

## 4) Lid

| Parameter | Type | Default | Description | Tuning strategy |
|---|---|---:|---|---|
| `Lid_Height` | number | `8.1` | Height of lid wall above top plane. | Increase for stronger lid walls and clip volume in sliced mode. |
| `Lid_Lip_Gap` | number | `0.1` | Fit clearance between lid and box mating walls. | Tight fit: reduce by `0.05`; loose fit: increase by `0.05`. |
| `Lid_Lip_Gap_Height` | number | `3` | Height of inner engagement lip. | Taller lip improves hold; too tall may increase insertion force. |

## 5) Openings

| Parameter | Type | Default | Description | Interactions |
|---|---|---:|---|---|
| `All_Opening_Width` | number | `10` | Default opening width on enabled side walls. | Used unless side-specific width override is greater than `0`. |
| `All_Opening_Height` | number | `30` | Default opening height on enabled side walls. | Must be `> 0` and `<= Box_Height`. This is the true opening height; the cut is anchored at its bottom edge, not centered on the box floor. |
| `All_Opening_Corner_Radius` | number | `-1` | Default corner radius for side openings. | `-1` keeps fully rounded ends; `0` is square; positive values are clamped to valid half-extents. |
| `All_Openings_Right` | number | `0` | Global side-opening offset along each wall's local left/right direction. | Combines with each side-local `Move_Opening_*_to_Right` parameter. |
| `All_Openings_Up` | number | `0` | Height of each side opening's bottom edge above the box floor. | `0` sits the opening flush with the box bottom, so a cable resting on the desk passes straight in. Raise it to lift openings off the surface. Combines with side-specific vertical offsets. |
| `Opening_On_Right` | boolean | `true` | Enables right wall opening. | Uses global size unless right override is set. |
| `Opening_On_Left` | boolean | `true` | Enables left wall opening. | Uses global size unless left override is set. |
| `Opening_On_Front` | boolean | `true` | Enables front wall opening. | Uses global size unless front override is set. |
| `Opening_On_Back` | boolean | `true` | Enables back wall opening. | Uses global size unless back override is set. |

## 6) Left Openings Overrides

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `Override_Opening_Width_Left` | number | `0` | Left opening width override; `0` keeps global width. |
| `Override_Opening_Height_Left` | number | `0` | Left opening height override; `0` keeps global height. |
| `Override_Opening_Corner_Radius_Left` | number | `-1` | Left opening corner radius override; `-1` keeps global corner radius. |
| `Move_Opening_Left_to_Right` | number | `0` | Left wall opening depth shift; positive moves toward front (`-Y`). |
| `Move_Opening_Left_Up` | number | `0` | Left opening vertical offset. |

## 7) Right Openings Overrides

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `Override_Opening_Width_Right` | number | `0` | Right opening width override; `0` keeps global width. |
| `Override_Opening_Height_Right` | number | `0` | Right opening height override; `0` keeps global height. |
| `Override_Opening_Corner_Radius_Right` | number | `-1` | Right opening corner radius override; `-1` keeps global corner radius. |
| `Move_Opening_Right_to_Right` | number | `0` | Right wall opening depth shift; positive moves toward back (`+Y`). |
| `Move_Opening_Right_Up` | number | `0` | Right opening vertical offset. |

## 8) Back Openings Overrides

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `Override_Opening_Width_Back` | number | `0` | Back opening width override; `0` keeps global width. |
| `Override_Opening_Height_Back` | number | `0` | Back opening height override; `0` keeps global height. |
| `Override_Opening_Corner_Radius_Back` | number | `-1` | Back opening corner radius override; `-1` keeps global corner radius. |
| `Move_Opening_Back_to_Right` | number | `0` | Back wall opening lateral shift; positive moves toward left (`-X`). |
| `Move_Opening_Back_Up` | number | `0` | Back opening vertical offset. |

## 9) Front Openings Overrides

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `Override_Opening_Width_Front` | number | `0` | Front opening width override; `0` keeps global width. |
| `Override_Opening_Height_Front` | number | `0` | Front opening height override; `0` keeps global height. |
| `Override_Opening_Corner_Radius_Front` | number | `-1` | Front opening corner radius override; `-1` keeps global corner radius. |
| `Move_Opening_Front_to_Right` | number | `0` | Front wall opening lateral shift; positive moves toward right (`+X`). |
| `Move_Opening_Front_Up` | number | `0` | Front opening vertical offset. |

## 10) Stabilizers - Main Settings

| Parameter | Type | Default | Description | Interactions |
|---|---|---:|---|---|
| `Enable_Stabilizers` | boolean | `true` | Enables interior support fins. | If `false`, all stabilizer parameters are ignored. |
| `Stabilizer_Width` | number | `1.5` | Fin thickness along wall direction. | Increasing count and width together can reduce usable interior area. |
| `Stabilizer_Depth` | number | `15` | Fin extension from wall into interior. | Larger values add stiffness but can obstruct cable routing. |
| `Stabilizer_Height` | number | `35` | Fin height from floor upward. | Keep below full box height if upper interior clearance is needed. |

## 11) Stabilizers - Front/Back Walls

| Parameter | Type | Default | Allowed values | Description |
|---|---|---:|---|---|
| `Stabilizers_Front_Back_Count` | integer | `3` | `0+` | Number of fins on each of front and back walls. |
| `Stabilizers_Front_Back_Alignment` | enum | `"Centered"` | `"Centered"`, `"Distributed"`, `"Custom"` | Placement strategy for front/back fins. |
| `Stabilizer_FB_Spacing` | number | `3` | `>= 0` | Gap between adjacent front/back fins in `Centered` and `Custom` modes. |
| `Stabilizer_FB_Margin_Left` | number | `15` | any | Left margin used in `Distributed` and `Custom`. |
| `Stabilizer_FB_Margin_Right` | number | `15` | any | Right margin used in `Distributed` and `Custom`. |
| `Stabilizer_Avoid_Front_Opening` | boolean | `true` | true/false | Skips front-wall fin positions that overlap opening area. |
| `Stabilizer_Avoid_Back_Opening` | boolean | `true` | true/false | Skips back-wall fin positions that overlap opening area. |

### `Stabilizers_Front_Back_Alignment` options

| Option | Behavior |
|---|---|
| `"Centered"` | Builds a centered fin cluster using `Stabilizer_FB_Spacing`. |
| `"Distributed"` | Distributes fins between left/right margins. |
| `"Custom"` | Starts from the custom start margin and uses fixed pitch (`Stabilizer_Width + Stabilizer_FB_Spacing`) when it fits; otherwise falls back to distributed placement inside margins. |

## 12) Stabilizers - Left/Right Walls

| Parameter | Type | Default | Allowed values | Description |
|---|---|---:|---|---|
| `Stabilizers_Left_Right_Count` | integer | `0` | `0+` | Number of fins on each of left and right walls. |
| `Stabilizers_Left_Right_Alignment` | enum | `"Centered"` | `"Centered"`, `"Distributed"`, `"Custom"` | Placement strategy for left/right fins. |
| `Stabilizer_LR_Spacing` | number | `3` | `>= 0` | Gap between adjacent left/right fins in `Centered` and `Custom` modes. |
| `Stabilizer_LR_Margin_Front` | number | `15` | any | Front margin used in `Distributed` and `Custom`. |
| `Stabilizer_LR_Margin_Back` | number | `15` | any | Back margin used in `Distributed` and `Custom`. |
| `Stabilizer_Avoid_Left_Opening` | boolean | `true` | true/false | Skips left-wall fin positions that overlap opening area. |
| `Stabilizer_Avoid_Right_Opening` | boolean | `true` | true/false | Skips right-wall fin positions that overlap opening area. |

### `Stabilizers_Left_Right_Alignment` options

| Option | Behavior |
|---|---|
| `"Centered"` | Builds a centered fin cluster using `Stabilizer_LR_Spacing`. |
| `"Distributed"` | Distributes fins between front/back margins. |
| `"Custom"` | Starts from the custom start margin and uses fixed pitch (`Stabilizer_Width + Stabilizer_LR_Spacing`) when it fits; otherwise falls back to distributed placement inside margins. |

## 13) Bottom Openings - Main

| Parameter | Type | Default | Allowed values | Description | Interactions |
|---|---|---:|---|---|---|
| `Enable_Bottom_Openings` | boolean | `false` | true/false | Enables floor cutouts in the box bottom. | If `false`, all bottom opening params are ignored. |
| `Bottom_Openings_Count` | integer | `3` | `1+` recommended | Number of floor openings. | With post avoid enabled, count is split across both sides of post. |
| `Bottom_Opening_Axis` | enum | `"Along X"` | `"Along X"`, `"Along Y"` | Axis used to arrange opening sequence. | Defines which margins are primary vs secondary. |
| `Bottom_Opening_Width` | number | `15` | any positive | Short dimension of each opening. | Combined with orientation to derive actual X/Y footprint. |
| `Bottom_Opening_Depth` | number | `30` | any positive | Long dimension of each opening. | Combined with orientation to derive actual X/Y footprint. |
| `Bottom_Opening_Orientation` | enum | `"Along Y"` | `"Along X"`, `"Along Y"` | Rotates opening shape independent of arrangement axis. | Allows slot rotation without changing arrangement direction. |
| `Bottom_Opening_Corner_Radius` | number | `5` | `>= 0` | Rounding radius for opening corners. | Effective radius is clamped to opening half-extents. |
| `Bottom_Opening_Spacing` | number | `0` | `0+` | Gap between neighboring openings. | `0` enables auto-spacing from alignment mode. |

### `Bottom_Opening_Axis` options

| Option | Behavior |
|---|---|
| `"Along X"` | Places multiple openings across box width. |
| `"Along Y"` | Places multiple openings across box depth. |

### `Bottom_Opening_Orientation` options

| Option | Behavior |
|---|---|
| `"Along X"` | Rotates each opening so long axis points along X. |
| `"Along Y"` | Rotates each opening so long axis points along Y. |

## 14) Bottom Openings - Alignment

| Parameter | Type | Default | Allowed values | Description |
|---|---|---:|---|---|
| `Bottom_Opening_Alignment_Primary` | enum | `"Centered"` | `"Centered"`, `"Distributed"`, `"Start"`, `"End"`, `"Custom"` | Placement mode on arrangement axis. |
| `Bottom_Opening_Alignment_Secondary` | enum | `"Centered"` | `"Centered"`, `"Start"`, `"End"`, `"Custom"` | Placement mode on perpendicular axis. |
| `Bottom_Opening_Avoid_Post` | boolean | `true` | true/false | Splits and offsets openings around post when `Enable_Post=true`. |
| `Bottom_Opening_Post_Margin` | number | `2` | `>= 0` | Minimum gap from post outer wall to nearest opening edge when post avoidance is enabled. |

### `Bottom_Opening_Alignment_Primary` options

| Option | Behavior |
|---|---|
| `"Centered"` | Centers total opening pattern in available area. |
| `"Distributed"` | Evenly distributes openings between computed bounds. |
| `"Start"` | Anchors pattern to start bound (left/front depending axis). |
| `"End"` | Anchors pattern to end bound (right/back depending axis). |
| `"Custom"` | Uses custom margins as explicit primary bounds. |

### `Bottom_Opening_Alignment_Secondary` options

| Option | Behavior |
|---|---|
| `"Centered"` | Centers openings on perpendicular axis. |
| `"Start"` | Anchors openings to start side using relevant margin. |
| `"End"` | Anchors openings to end side using relevant margin. |
| `"Custom"` | Centers the opening line within the custom margin window (left/right or front/back based on axis). |

## 15) Bottom Openings - Custom Margins

| Parameter | Type | Default | Description | Used by |
|---|---|---:|---|---|
| `Bottom_Opening_Margin_Left` | number | `10` | Distance from inner left wall. | `Along X` primary (`Start`/`Custom`), `Along Y` secondary (`Start` and `Custom` window). |
| `Bottom_Opening_Margin_Right` | number | `10` | Distance from inner right wall. | `Along X` primary (`End`/`Custom`), `Along Y` secondary (`End` and `Custom` window). |
| `Bottom_Opening_Margin_Front` | number | `10` | Distance from inner front wall. | `Along Y` primary (`Start`/`Custom`), `Along X` secondary (`Start` and `Custom` window). |
| `Bottom_Opening_Margin_Back` | number | `10` | Distance from inner back wall. | `Along Y` primary (`End`/`Custom`), `Along X` secondary (`End` and `Custom` window). |

## 16) Slicing - For Smaller Print Beds

| Parameter | Type | Default | Description | Constraints and notes |
|---|---|---:|---|---|
| `Enable_Slicing` | boolean | `false` | Enables split-part generation with mating clips. | Recommended when full width exceeds printable bed area. |
| `Slice_Count` | integer | `2` | Number of slices across width. | Must be `>= 2` for meaningful slicing. |
| `Slice_Piece_To_Render` | integer | `0` | `0` previews all pieces; non-zero renders one specific slice index. | Must be an integer in range `0..Slice_Count`. |
| `Clip_Tolerance` | number | `0.2` | Clearance added to female clip geometry. | Increase if clips are too tight. |
| `Clips_Per_Edge` | integer | `2` | Number of clips along each split edge. | Higher values improve alignment but add assembly friction. |
| `Clip_Tab_Width` | number | `10` | Clip extent along split edge. | Increase for strength; reduce if edge space is limited. |
| `Clip_Tab_Depth` | number | `4` | Clip insertion depth. | Deeper clips improve retention but may over-constrain fit. |
| `Clip_Tab_Height` | number | `3` | Clip tab height. | Larger values increase engagement force. |
| `Slice_Preview_Spacing` | number | `5` | Gap between pieces in all-slices preview. | Visual layout only; does not affect exported single-part geometry. |

### Slice rendering behavior

| `Slice_Piece_To_Render` value | Result |
|---|---|
| `0` | Renders all slices in a preview layout. |
| `1..Slice_Count` | Renders only the selected slice index (box and/or lid based on `Part_To_Render`). |

## 17) Gridfinity

Two independent, optional interfaces that let the box join a Gridfinity setup.
Both default to off and change no geometry when disabled.

| Parameter | Type | Default | Description | Interactions |
|---|---|---:|---|---|
| `Enable_Gridfinity_Bottom` | boolean | `false` | Adds a 42 mm Gridfinity base under the box so it drops into a baseplate. | Mutually exclusive with `Enable_Bottom_Openings`. Requires `Closed_Post=true` when the post is enabled. Adds `4.75 mm` to total height. |
| `Enable_Gridfinity_Lid_Top` | boolean | `false` | Adds the Gridfinity profile to the lid's exposed face so the closed box joins a stack. | Adds `4.5 mm` to lid height. |
| `Gridfinity_Profile_Clearance` | number | `0.25` | Fit clearance on mating profiles. | Increase if the base is tight in your baseplate. |
| `Gridfinity_Edge_Keepout` | number | `4` | Margin from the model edge before the first cell. | Prevents thin, fragile cells at the perimeter. Raising it can reduce the cell count. |
| `Enable_Gridfinity_Magnet_Screw` | boolean | `false` | Adds magnet pockets and screw holes to whichever interfaces are enabled. | |
| `Gridfinity_Magnet_Diameter` | number | `6.2` | Magnet pocket diameter. | `6 mm` magnets are the Gridfinity convention; the extra is clearance. |
| `Gridfinity_Magnet_Depth` | number | `2.4` | Magnet pocket depth. | Capped so `0.8 mm` of material always remains above the pocket. |
| `Gridfinity_Screw_Diameter` | number | `3.2` | Through screw hole diameter. | Sized for M3. |

### How the grid is laid out

Box dimensions rarely land on a 42 mm multiple. Rather than forcing your
dimensions, the model fits as many whole cells as it can inside the footprint
minus `Gridfinity_Edge_Keepout` on each side, then centres that array. A box too
small for even one cell renders normally with the interface omitted and an
`echo` explaining why.

At the default `100 x 75` footprint you get a 2 x 1 grid.

### Height convention

The base is **added below** the box, not carved out of the floor. `Box_Height`
continues to describe the box body, so enabling Gridfinity never silently
reduces interior volume; it increases total height instead. The model is lifted
so the exported object still sits on `z=0`.

### Why `Closed_Post` is required

With an open post, the bore runs through the box floor. A Gridfinity base under
that floor would block it, leaving a bore that goes nowhere. Rather than
silently produce that, the model asserts. Set `Closed_Post=true`, or disable the
post.

## 18) Hidden

| Parameter | Type | Default | Description |
|---|---|---:|---|
| `Model_Version` | string | current release | Echoed at render so an exported STL can be traced back to its source. |
| `$fn` | integer | `40` | Circle/arc resolution for cylinders and rounded geometry. |
| `GF_*` | various | Gridfinity spec | Gridfinity standard dimensions (pitch, cell and cavity sizes, profile stages). Hidden because changing one produces a part that no longer mates with other Gridfinity gear, but still overridable with `-D` if you need to. |
| `SPACER` | number | `0.04` | Internal modeling offset used for robust boolean operations and tiny clearances. |

## Built-In Validation

The model enforces these assertions. `docs/VALIDATION_RULES.md` explains each one
and how to resolve it.

Box and wall:

- `Box_Width`, `Box_Depth`, and `Box_Height` must be `> 0`.
- `Wall_Thickness` must be `> 0` and `Wall_Thickness*2` must be less than `min(Box_Width, Box_Depth)`.
- `Box_Corner_Radius` must be `>= 0`.

Post:

- `Post_Diameter` must exceed `Wall_Thickness*2` so the post has a wall.
- `Post_Diameter` must be less than `min(Inner_Width, Inner_Depth)`.

Stabilizers:

- `Stabilizer_Height + Wall_Thickness` must not exceed `Box_Height`.
- `Stabilizer_Depth*2` must be less than `min(Inner_Width, Inner_Depth)`.
- `Stabilizer_Width` must be `> 0`.
- Stabilizer counts must be `>= 0`.
- `Stabilizer_FB_Spacing` and `Stabilizer_LR_Spacing` must be `>= 0`.

Openings:

- `All_Opening_Height` and `All_Opening_Width` must both be `> 0`.
- `All_Opening_Height` must not exceed `Box_Height`.
- Side opening width/height overrides must be `>= 0`.
- Opening corner radius defaults/overrides must be `>= -1`.

Bottom openings:

- `Bottom_Openings_Count` must be `>= 1` when bottom openings are enabled.
- `Bottom_Opening_Width` and `Bottom_Opening_Depth` must be `> 0` when enabled.
- `Bottom_Opening_Post_Margin` must be `>= 0`.

Slicing and clips:

- `Slice_Piece_To_Render` must be an integer in range `0..Slice_Count`.
- When slicing is enabled, `Slice_Count` must be `>= 2`.
- When slicing is enabled, `Clips_Per_Edge` must be `>= 1`.
- `Clip_Tolerance` must be `>= 0`.
- `Clip_Tab_Width`, `Clip_Tab_Depth`, and `Clip_Tab_Height` must be greater than `0`.

## Clamped Rather Than Asserted

`Box_Corner_Radius` is clamped instead of rejected, because a too-large radius
has an obvious correct interpretation (round the corners as much as the geometry
allows). When clamping occurs the model emits an `echo` naming the requested and
the applied value, so the difference is visible in the OpenSCAD console.

## Recommended Baseline Profiles

### General-purpose desktop cable box

- `Box_Width=120`
- `Box_Depth=80`
- `Box_Height=55`
- `Wall_Thickness=1.8`
- `Lid_Lip_Gap=0.15`
- `Enable_Post=true`

### Power-brick-heavy setup

- `Box_Width=160`
- `Box_Depth=100`
- `Box_Height=60`
- `All_Opening_Width=14`
- `All_Opening_Height=36`
- `Enable_Stabilizers=true`
- `Stabilizers_Front_Back_Count=4`

### Small print bed fallback

- `Enable_Slicing=true`
- `Slice_Count=3`
- `Slice_Piece_To_Render=1` (export each slice individually)
- `Clip_Tolerance=0.25` (start conservative, tune after test print)

## Documentation Maintenance Rules

When parameters are added, removed, renamed, or default values change:

1. Update this file in the same commit as SCAD changes.
2. Update `docs/FAQ.md` if behavior impact is likely user-visible.
3. Update `README.md` if workflow or folder structure changes.
