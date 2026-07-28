# SCAD Architecture

This document explains how the primary model is structured and how data flows from Customizer values to final geometry.

## File Structure

The primary SCAD is organized in this order:

1. Header and licensing block
2. Customizer parameter sections
3. Hidden constants and validation assertions
4. Derived dimensions and helper functions
5. Feature modules:
   - Stabilizers
   - Bottom openings
   - Slicing clips
   - Box/Lid assembly
6. Render dispatcher (`full_render()`)
7. Embedded BOSL2 utilities

## Coordinate System and Axes

- X: left/right across box width
- Y: front/back across box depth
- Z: vertical

Side-opening directional conventions are intentionally wall-relative, not globally symmetric:

- Front `Move_Opening_Front_to_Right`: positive toward `+X`
- Back `Move_Opening_Back_to_Right`: positive toward `-X`
- Right `Move_Opening_Right_to_Right`: positive toward `+Y`
- Left `Move_Opening_Left_to_Right`: positive toward `-Y`

## Parameter Layers

### 1) Global sizing

Controls overall shell dimensions and base topology:

- `Box_Width`, `Box_Depth`, `Box_Height`
- `Wall_Thickness`, `Box_Corner_Radius`

### 2) Feature toggles

Enable/disable major geometry branches:

- `Enable_Post`
- `Enable_Stabilizers`
- `Enable_Bottom_Openings`
- `Enable_Slicing`

### 3) Placement and offsets

Refine location and distribution:

- Side-opening global/per-side offsets
- Stabilizer alignments and margins
- Bottom opening axis/alignment/margins

### 4) Slice join mechanics

Define seam mechanics for split builds:

- `Slice_Count`
- `Clip_*` parameters
- `Slice_Piece_To_Render`

## Derived Values

Key computed values used across modules:

- `Slice_Width = Box_Width / Slice_Count`
- `Inner_Width = Box_Width - Wall_Thickness * 2`
- `Inner_Depth = Box_Depth - Wall_Thickness * 2`

These drive placement math for stabilizers, bottom openings, and slice clipping extents.

## Geometry Composition Pattern

Core pattern is constructive solid geometry (CSG):

- `union()` for additive solids
- `difference()` for cavities, openings, and clip sockets
- `hull()` for rounded slot-like opening shapes

The model generally builds robust base solids first, then subtractive features.

## Render Modes

### Non-sliced

- box path: `m_box_with_openings()`
- lid path: `m_lid()`
- selected by `Part_To_Render`

### Sliced preview (`Slice_Piece_To_Render = 0`)

- Iterates `i = 1..Slice_Count`
- Places each slice with preview spacing
- Renders box and/or lid depending on `Part_To_Render`

### Sliced single part (`Slice_Piece_To_Render > 0`)

- Renders only selected index
- Useful for export and printing

## Validation Philosophy

Assertions block combinations that produce broken geometry or ambiguous output.
The bar for adding one is that the bad input would otherwise render successfully
and exit `0`, since that is the failure mode a user cannot detect without
inspecting the mesh.

Current assertions enforce:

- positive box, wall, and opening dimensions
- wall thickness that leaves a real interior
- post diameter that both has a wall and fits inside the box
- stabilizer height, depth, width, and counts that fit the box
- side opening height within box height
- bottom opening count and dimensions when the feature is enabled
- non-negative per-side override values and corner radius sentinels
- valid slice index range and minimum slicing and clip constraints
- positive clip geometry dimensions

Two constraints are clamped instead of asserted, because the correct
interpretation is unambiguous: an over-large `Box_Corner_Radius` is reduced to
what the inner cavity allows, and a seam clip landing inside the post opening is
moved clear of it. Both report via `echo` rather than failing.

See `docs/VALIDATION_RULES.md` for each rule with its trigger and resolution.

## BOSL2 Embedding

The file includes embedded BOSL2 utility content under its original BSD-2-Clause terms.

Implications:

- The custom model logic is near top/mid file.
- Search and edits should target your modules before the BOSL2 block.
- Attribution is tracked in `THIRD_PARTY_NOTICES.md`.

## Maintenance Workflow Recommendation

For safe iteration:

1. Change one feature branch at a time.
2. Verify unsliced rendering first.
3. Verify sliced rendering with both preview and single-slice modes.
4. Run smoke scripts.
5. Update docs and assertions together when behavior changes.
