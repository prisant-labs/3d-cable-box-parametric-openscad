# E-12: Gridfinity to spec

**Handle:** Gridfinity to spec. Rebuild both Gridfinity interfaces on the
standard's swept profile, so the box seats in a real baseplate and both parts
print without supports.

**Status:** Scoped 2026-10-07. Not started. Replaces the geometry of
[E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md); E-01's two toggles
and its user-facing parameters stay.
**Effort:** M
**Depends on:** nothing. Ships in the 2.0.0 release-candidate series together
with [E-13 (seam joints)](E-13_seam-joints.md).

## Why

The rc.5 prints and a check of the code on 2026-10-07 found three defects.

1. **The base cannot enter a standard baseplate.** Each cell is a
   square-cornered 41.5 mm block. Its corners reach 29.35 mm from the cell
   centre, but the pocket's rounded corner reaches only 28.04 mm. The pocket
   also narrows to 37.7 mm within 2.15 mm of its top. This settles
   [backlog item 15 (Gridfinity base seating)](BACKLOG.md) by arithmetic,
   without needing a print.
2. **Both interfaces print poorly**, as
   [backlog item 18 (Gridfinity printability)](BACKLOG.md) records. The base is
   hollowed from below, with a 90 degree step and a 37.45 mm ceiling. The lid
   prints face-down, so each socket floor is a 37.45 mm bridge. The box body
   also overhangs its feet with a flat ledge. The ledge was 4.25 mm on the
   50 mm coupon. On the default 100 by 75 mm box it is 8.25 mm on two sides
   and 16.75 mm on the other two.
3. **The base's magnet and screw holes hold nothing.** They sit inside the
   hollow cavity's footprint, so they cut only its 0.45 mm ceiling. This was
   found by arithmetic on `m_gridfinity_bottom_holes`, not by a print.

The research behind this effort is local to the maintainer's checkout:
`_local/research/2026-10-06_gridfinity-spec-and-projects.md`, and the saved
spec and generator sources in `_local/research/gridfinity-reference/`. The spec
numbers below were checked on 2026-10-07 against both the spec diagram and
kennetek's `standard.scad`.

## Decisions (2026-10-07)

1. **Build to the spec profile, solid.** Every reviewed generator builds feet
   and pockets solid by default. A hollow base is always a separately named
   option in those projects, never the default.
2. **The base footprint rounds up to whole cells.** When
   `Enable_Gridfinity_Bottom` is on, the box's outer width and depth become
   the smallest `N * 42 - 0.5` mm that is at least the typed size. The model
   echoes the size it used. This reverses E-01's choice to centre a clipped
   grid under a box of any size.
   - The reason: a box wider than its feet must overhang them, and nothing can
     fill the space under that overhang. Once the box is seated, the
     neighbouring baseplate pockets occupy it.
   - The overhang also blocks those neighbouring pockets, so rounding up costs
     no baseplate area. A 75 mm deep box overhangs 16.75 mm on each side and
     blocks three rows of cells. Rounded up to 83.5 mm, it fills exactly two.
   - Rejected: a 45 degree bevel on the box's bottom edge, which is as tall as
     the margin (up to about 25 mm) and takes a wedge out of the interior.
   - Rejected: a flat ledge printed with supports.
3. **A Gridfinity lid prints pocket-side up, with a solid plug.** When
   `Enable_Gridfinity_Lid_Top` is on, the exported lid is flipped, so its
   pockets face up and print with no bridge.
   - The lid's underside then sits on the bed, so the plug ring is filled
     solid. Otherwise the panel would bridge the whole box opening.
   - A plug that is solid in the model prints as infill, so it costs little
     filament.
   - A Skirt lid gets the same fill and becomes a groove lid.
   - Rejected: Gridfinity feet under the lid with a stacking lip on the box
     rim, as in vector76's `base_lid()`. It suits only grid-sized boxes, and a
     lip on a 1.85 mm wall needs a support wedge.
   - Rejected: catches or hinges, as in the three reference models the
     maintainer named. They abandon the drop-in lid.
4. **One effort with two phases.** The base and the lid share the profile code
   and one fit test, so splitting them would buy nothing.
5. **Ships in the 2.0.0 release-candidate series.** Both phases change the
   output for unchanged inputs, which
   [E-10 (versioning)](E-10_versioning.md) classes as major. Landing them
   before 2.0.0 lets one major version absorb them.

## Spec dimensions

All values are in millimetres. They come from the gridfinity.xyz spec diagram
(CC BY-NC-SA), cross-checked against kennetek's MIT `standard.scad`.
Dimensions are facts, so the geometry is written here from the numbers alone.

| Feature | Value |
|---|---|
| Grid pitch | 42 |
| Foot, top footprint per cell | 41.5 square, 3.75 corner radius |
| Foot profile, from the bottom | 0.8 at 45 degrees, 1.8 vertical, 2.15 at 45 degrees (4.75 tall) |
| Foot, bottom footprint | 35.6 square, 0.8 corner radius |
| Baseplate pocket, top footprint per cell | 42 square, 4.0 corner radius |
| Baseplate pocket profile, from the bottom | 0.7 at 45 degrees, 1.8 vertical, 2.15 at 45 degrees (4.65 tall) |
| Magnet pocket | 6.5 diameter, 2.4 deep |
| Hole offset from the cell centre | 13 on each axis |

## Phase A: box feet

- Replace `m_gridfinity_bottom_solid` and `m_gridfinity_bottom_cavities` with
  one solid swept foot per cell.
- Build the sweep with BOSL2's `offset_sweep()` and an `os_profile()` point
  list, if it renders acceptably on OpenSCAD 2021.01 with CGAL. Otherwise, use
  a hand-written sweep, as kennetek does. Benchmark this first, on the largest
  library preset.
- Derive the rounded footprint once, near the top of the model. Every
  reference to `Box_Width` or `Box_Depth` that shapes the box must use the
  derived pair. The echo that reports a changed size must avoid the words
  `WARNING` and `DEPRECATED`, which the suite fails on.
- Cut magnet pockets up from each foot's bottom face, at 13 mm from the cell
  centre on each axis. At the defaults, the effective pocket must be 6.5 mm
  across. Today's parameters give 6.2 + 0.25 = 6.45 mm.
- Screw holes pass up through the foot. Where a magnet pocket sits over a
  screw hole, its ceiling uses stepped bridging layers, so it prints without
  supports. kennetek's `make_hole_printable()` (MIT) shows the technique.
- Keep the existing asserts against bottom openings and the open post, and
  keep the render-time lift by `Gridfinity_Base_Offset`.
- `Gridfinity_Edge_Keepout` no longer affects the base. It still sets the lid
  top's margin when the base is off.

## Phase B: lid-top baseplate

- Cut spec baseplate pockets down into a solid slab. Each pocket's floor is the
  flat top of solid material, the way vector76's `base_lid()` builds it.
- Lid-top magnet pockets go down from each pocket floor, as they do now.
- **Cell count.** When the base is also on, the lid holds the same cells as the
  base, so a second box stacks on the first. The lid's outer footprint is then
  `N * 42 + 3.5` mm, which leaves 1.75 mm beside the outermost pockets. When
  only the lid top is on, the keepout rule stays.
- **Solid plug.** Fill the plug (or, for a Skirt lid, the region inside the
  skirt) solid to `Lid_Lip_Gap_Height`. The magnet-boss notches and the post
  socket stay as cuts. They become short bridges of about 12 mm and 15 mm.
- **Flip.** Export the lid rotated 180 degrees about X, so the plug's face sits
  on z = 0. The preview layout and the `lid-face` anchor in `m_lid_part` must
  follow the flip.
- **Seam clips.** On a sliced lid, the flip moves the seam clips off the bed.
  They must start on the bed in the flipped orientation. Coordinate this with
  [E-13 (seam joints)](E-13_seam-joints.md).

## Tests

Write each scenario first, and confirm it fails against rc.5, as `AGENTS.md`
requires.

- **Conformance to the standard, not only to itself.** A new assembly test
  builds a reference foot and a reference pocket from the spec numbers typed
  into the test file, independent of the model's constants. The rc.4 coupon
  seated in the model's own socket, which proved only that the model agreed
  with itself.
  - The model's feet seated in the reference pocket overlap nothing, and a
    "seated" probe shows they reach full depth.
  - The reference foot seated in the model's lid pocket overlaps nothing, and
    reaches full depth.
- **Stacking.** One box's feet seated in another box's lid-top pockets overlap
  nothing.
- **Profile probes.** Material and empty probes check the foot's width at the
  profile's corners: 0.8, 2.6, and 4.75 mm above the foot's bottom.
- **Footprint.** Bounding-box checks show the rounded size, for example
  75 mm typed giving 83.5 mm.
- **Solids.** The box with feet and the lid with pockets each export as one
  solid, sliced and unsliced.
- **No regression.** With both toggles off, every part is mesh-identical to
  rc.5 under the canonical comparison that `build_library.py` uses.

## Acceptance criteria

- [ ] The model's feet seat fully in a spec-built reference pocket with no
      overlap.
- [ ] A spec-built reference foot seats fully in the lid-top pocket with no
      overlap.
- [ ] One box's feet seat in another box's lid-top pockets.
- [ ] The base footprint rounds up to whole cells, and the model echoes the
      size it used.
- [ ] Neither part has a flat overhang or bridge wider than about 15 mm in its
      print orientation.
- [ ] The magnet pockets are 6.5 by 2.4 mm at the defaults.
- [ ] With both toggles off, every part is mesh-identical to rc.5.
- [ ] `docs/VALIDATION_RULES.md`, `docs/PARAMETER_REFERENCE.md`,
      `docs/PRINTING.md` (print orientation), and `docs/FAQ.md` change in the
      same commit as the model.

## Human print test (rc.6)

- [ ] A box with Gridfinity feet seats in a real baseplate, either bought or
      printed from kennetek's generator.
- [ ] A standard Gridfinity bin seats in the lid-top pockets.
- [ ] Both parts print without supports on the maintainer's P1S.
- [ ] The solid-plug lid still fits its box at the default 0.15 mm gap.

## Risks

- **Render time.** `offset_sweep()` across many cells may be slow under CGAL on
  2021.01, which CI uses. The fallback is a hand-written sweep.
- **The footprint touches every size reference.** One derived pair, a search
  for every `Box_Width` and `Box_Depth` use, and the full suite contain this.
- **The flip changes the lid's frame.** Relief, magnets, seam clips, and
  slicing are all written in the face-down frame. Scenarios for a Gridfinity
  lid need probes written in the flipped frame.

## Licensing

Dimensions come from the spec diagram, which is CC BY-NC-SA. The geometry is
written here from those numbers, not copied. Techniques may come from kennetek's
and vector76's MIT projects. ostat's project has been GPLv3 since 2024-12-26,
so it is for reading only.
