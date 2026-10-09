# E-14: Printability options

**Handle:** Printability options. Three opt-in parameters that remove the
overhangs a support-free print still has: the tops of the wall openings, the
bottom edge fillet, and the bridging layers in each Gridfinity foot.

**Status:** Spec, written 2026-10-08. Not started.
**Effort:** S to M, as three independent S parts.
**Depends on:** [E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md)
phase A for part 14c; phase A is merged. Ships after 2.0.0, as 2.1.0. See the
release plan below.

## Why

Most of the model already prints without supports. The magnet bosses run up
from the floor, the seam teeth stay within 45 degrees of vertical, and E-12
phase A gave the box solid feet with 45 degree sides. A code read on
2026-10-08 found three places that still overhang, or that work only at one
slicer setting.

- **Side openings.** `m_opening` builds each opening as a hull of four
  circles. With the default fully rounded ends, the top of each opening is a
  semicircle. Near its top the arc is flatter than 45 degrees, over a height of
  `r * (1 - cos 45)`, about `0.29 * r`. That is 1.5 mm at the default 10 mm
  width and 3.5 mm at 24 mm, the widest preset opening. All nine presets use
  fully rounded ends, at widths from 12 to 24 mm. A slicer prints that part of
  the arc as an overhang anchored on one side, and that is where strands droop.
- **Bottom edge fillet.** `m_edge_treated_shell` sweeps `Bottom_Edge_Fillet`
  with `os_circle()`, so the fillet meets the bed almost horizontally.
  `docs/PRINTING.md` already warns that its lowest layers overhang the bed.
- **Gridfinity bridging.** Above each foot's magnet pocket, two stepped layers
  carry the pocket's ceiling. Their height is the hidden constant
  `GF_BRIDGE_LAYER = 0.2`. Slicers sample each layer near its middle height, so
  a 0.2 mm step can fall between the samples of a 0.28 mm layer. The slicer
  then drops that step, and the bridging no longer works. The Risks section
  says how the rc.1 print confirms this.

## Considered and dropped: a stabilizer slope guard

On 2026-10-08 a fourth part was proposed: an advisory echo when
`Stabilizer_Depth` exceeds `Stabilizer_Height`. The reasoning was that the fin
would then overhang past 45 degrees. That reasoning was wrong.
`m_stabilizer_fin` puts the full `Stabilizer_Depth` rectangle on the floor and
narrows to a line on the wall at the top. Each layer sits inside the layer
below it, so the sloped face points upward like a ramp. A shallow fin shows
visible steps on that face, but it never overhangs. No change is needed.

## Proposed decisions (2026-10-08)

These need the maintainer's agreement before implementation starts.

1. **Every new parameter defaults to today's geometry.** The defaults are
   `"Round"`, `"Fillet"`, and `0.2`. Under
   [E-10 (versioning)](E-10_versioning.md), a parameter whose default preserves
   output is a minor bump, so E-14 ships as 2.1.0.
2. **A teardrop opening keeps its typed height.** The flat cap sits exactly
   where the round top is today. Part 14a explains why.
3. **One global opening style, with no per-wall overrides.**
   [E-03 (openings array)](E-03_openings-array.md) replaces the per-wall
   opening block, so every per-wall parameter added now is one more that E-03
   has to migrate.
4. **The layer-height parameter gets a general name, `Print_Layer_Height`.**
   Today only the Gridfinity bridging reads it. A narrower name would need a
   rename when a second feature reads it, and a rename is a major bump.
5. **Default changes wait for E-03.** Making `Teardrop` the default changes
   output for unchanged inputs, which is a major bump. E-03 is already the
   planned major that breaks the opening interface, so the default changes
   there at no extra cost.

## 14a. Teardrop tops for side openings

**Parameter.** `All_Opening_Top_Style`, in the Openings tab, with the values
`["Round", "Teardrop"]` and the default `"Round"`.

**Shape.** `Round` is today's hull. `Teardrop` replaces each of the hull's two
top corner circles with a capped teardrop: the circle, two 45 degree flanks,
and a flat cap at the height of the circle's top. The two bottom circles stay
round, because the bottom of a hole needs no support.

| Opening | Top today | Top with `Teardrop` |
|---|---|---|
| Fully rounded, `r = w / 2` (the default) | A semicircle | Two 45 degree flanks and a flat cap `2 * (sqrt(2) - 1) * r` wide, about `0.41 * w` |
| Partial radius, `0 < r < w / 2` | Two quarter arcs and a straight bridge `w - 2 * r` wide | Two 45 degree flanks; the straight bridge grows to `w - 2 * r + 0.83 * r` |
| Square, `r = 0` | A straight bridge | Unchanged |

The flat cap is a bridge anchored at both ends, which slicers print well. At
the preset widths it is 5.0 mm wide at 12 mm and 9.9 mm wide at 24 mm.

**Why the cap stays at the typed height.** The teardrop stays inside the typed
width and height, so `opening_top(side)` does not change. Three things read
it:

- The rim-notch echo, which reports an opening whose top edge is above the
  rim.
- `opening_reaches_rim()`, which skips a lid relief on any wall whose opening
  reaches the rim.
- `box_seam_bands()`, where the E-13 (seam joints) teeth skip the height
  band, up to `opening_top(side)`, of any front or back opening that crosses a
  seam. Teeth through an opening would cut slivers against its edges.

A pointed teardrop would rise `(sqrt(2) - 1) * r` above the typed height,
about 5 mm at 24 mm wide. It would silently change which openings reach the
rim. A pointed teardrop that lowers its circle to keep the height was also
rejected. It removes the cap's bridge, but it narrows the upper part of the
opening that the user sized for cables.

**Build.** The two top corners are BOSL2 `teardrop(h, r, ang = 45, cap_h = r)`.
BOSL2's `teardrop()` extrudes along Y with its point toward +Z, which fits the
front and back walls. The left and right walls add `spin = 90`. The corners
are hulled with the two bottom `cyl()` corners, as today. The build uses no
`intersection()`, so preview's CSG tree stays small. Still export a preview
PNG of a box with all four openings set to `Teardrop`, because E-12 phase A
blanked the preview with a cutter that repeated for each hole.

**Openings this does not change.** An opening that reaches the rim is a notch,
so it has no top to change. Bottom openings lie on the bed, so they keep their
shape.

**Validation.** Assert that `All_Opening_Top_Style` is `"Round"` or
`"Teardrop"`, naming the parameter, in the style of the `Lid_Style` assert at
line 545.

**Tests.**

- `opening_top_teardrop_cuts_shoulders`: the default box with
  `All_Opening_Top_Style="Teardrop"`. For the default front opening, the top
  circle has `r = 5` and its centre at z = 30, and the cap is at z = 35. A probe
  in the front wall at x = 2.2 and z = 34.7 is outside the circle, 5.19 mm from
  its centre, and inside the flank, whose half-width there is 2.37. Expect
  empty; `Round` leaves material there, so the scenario fails against `main`.
  In the same scenario, a material probe at x = 0 and z = 35.2 proves that the
  cap did not rise.
- `opening_top_teardrop_partial_radius`: `All_Opening_Corner_Radius=3` on a
  20 mm opening. One shoulder probe at a top corner, worked out the same way.
- Both scenarios expect one solid.

## 14b. Bottom edge style

**Parameter.** `Bottom_Edge_Style`, next to `Bottom_Edge_Fillet`, with the
values `["Fillet", "Teardrop", "Chamfer"]` and the default `"Fillet"`.
`Bottom_Edge_Fillet` keeps its name and sets the size for every style. A
rename would be a major bump.

**Shape.** Each style is a bottom profile for the `offset_sweep()` calls in
`m_edge_treated_shell`, chosen by one helper function.

| Style | BOSL2 profile | Inset at the bed | Height |
|---|---|---|---|
| `Fillet` | `os_circle(r = Bottom_Edge_Fillet)`, as today | `r` | `r` |
| `Teardrop` | `os_teardrop(r = Bottom_Edge_Fillet)` | `2 * (1 - sqrt(2) / 2) * r`, about `0.59 * r` | `r` |
| `Chamfer` | `os_chamfer(width = Bottom_Edge_Fillet)` | `r` | `r` |

`os_teardrop` is a one-eighth arc down from the wall, followed by a 45 degree
chamfer to the bed. Above `0.29 * r` it matches the fillet, so it keeps the
rounded look. `Chamfer` also serves as elephant's-foot relief. Both functions
exist at the pinned `BOSL2_REF` (`afe82db`).

**Scope.** This changes only the box's bottom edge. The lid's edges use
`Top_Edge_Chamfer`, which is already 45 degrees. With the Gridfinity base on,
`Bottom_Fillet_Effective` is 0, so every style is suppressed, as the fillet is
today. The existing asserts still bound every style, because each style's
inset and height are at most `r`: `Bottom_Edge_Fillet <= Wall_Thickness`, and
`Bottom_Edge_Fillet + Top_Edge_Chamfer < Box_Height`.

**Validation.** Assert that `Bottom_Edge_Style` is one of the three values,
naming the parameter. Gate the assert on `Bottom_Edge_Fillet > 0`, because the
style means nothing without a fillet.

**Tests.** At the default 1.85 mm wall, the fillet is capped at 1.85 mm, and
the differences between styles are only tenths of a millimetre. The scenarios
therefore set `Wall_Thickness=3` and `Bottom_Edge_Fillet=3`. The insets below
are measured in from the outer face, along a straight side.

- `bottom_edge_teardrop_meets_bed_at_45`: `Bottom_Edge_Style="Teardrop"`. At
  z = 0.05 to 0.1, the fillet's surface is 2.23 mm in and the teardrop's is
  1.66 mm in. A probe 1.9 to 2.0 mm in expects material, and it fails against
  `main`.
- `bottom_edge_chamfer`: `Bottom_Edge_Style="Chamfer"`. At z = 2.0, the
  fillet's surface is 0.17 mm in and the chamfer's is 1.0 mm in. A probe 0.3 to
  0.5 mm in expects empty, and it fails against `main`.
- Both scenarios expect one solid. One sliced variant also expects one solid
  per piece.

## 14c. Print layer height for the Gridfinity bridging

**Parameter.** `Print_Layer_Height`, default `0.2`, in a new Printing tab
placed just before the Hidden section. Its comment says: "The layer height you
slice at. Today only the two bridging steps above each Gridfinity foot's
magnet pocket read it."

**Change.** `Print_Layer_Height` replaces `GF_BRIDGE_LAYER` at every use: the
constant at line 342, the magnet-depth assert at lines 659 to 662, and
`m_gridfinity_bottom_holes` at lines 1749 to 1763. The constant is then
removed. E-12 phase B adds no stepped bridges, according to its plan. If phase
B does need one, it uses the same constant, so that this rename stays
mechanical.

**The rule for users.** Each step must be at least one real layer tall, so the
slicer samples it at least once. Setting `Print_Layer_Height` to the layer
height you slice at meets that rule. A larger value also works, at the cost of
a thicker step. A smaller value can lose a step.

**Validation.** Gate both checks on `Enable_Gridfinity_Bottom` and
`Enable_Gridfinity_Magnet_Screw`, because nothing else reads the value yet.

- `Print_Layer_Height` must be greater than 0 and at most 0.6 mm. A 0.6 mm
  layer is 75 percent of a 0.8 mm nozzle, the largest common size.
- The existing depth assert becomes
  `Gridfinity_Magnet_Depth + 2 * Print_Layer_Height <= GF_BASE_HEIGHT`, and
  its message names both parameters.

**Tests.**

- `gridfinity_bridge_steps_follow_layer_height`: the Gridfinity base with
  magnets and `Print_Layer_Height=0.28`. Measured up from the foot's bottom,
  the slot step spans 2.40 to 2.68 mm and the square step 2.68 to 2.96 mm. Put
  a probe inside the slot's footprint but outside the square's, 2.2 mm from the
  hole centre along the slot, at z = 2.62 to 2.66. It expects empty. At 0.2 mm
  that height falls in the square step and is material, so the scenario fails
  against `main`.
- `validation_print_layer_height_zero`: `Print_Layer_Height=0` with the
  Gridfinity base and magnets on. It expects exit code 1 and a message naming
  `Print_Layer_Height`.
- `validation_gridfinity_magnet_depth_too_deep` keeps passing, because its
  message still names `Gridfinity_Magnet_Depth`.

## Acceptance criteria

- [ ] Each new scenario fails against `main` before its part lands, as
      `AGENTS.md` requires.
- [ ] With every new parameter at its default, every part is mesh-identical
      to `main` under the canonical comparison. Check the seven configurations
      E-12 phase A used: box, lid, box and lid, a slice, an edge-treated box, a
      lid-top-only lid, and the router-shelf preset. The nine library presets
      must also regenerate unchanged.
- [ ] Every non-default style exports as one solid, sliced and unsliced.
- [ ] A preview PNG of a box with four `Teardrop` openings and magnets on
      shows the box. No scenario renders a preview, so this is a manual check.
- [ ] The same change updates `docs/VALIDATION_RULES.md`,
      `docs/PARAMETER_REFERENCE.md`, `docs/PRINTING.md`, `docs/FAQ.md`,
      `docs/MODULE_REFERENCE.md`, and `CHANGELOG.md`. `docs/PRINTING.md`
      replaces its bottom-fillet warning with the new styles, and it adds the
      opening tops and the layer-height rule. `docs/MODULE_REFERENCE.md`
      covers the new bottom-profile helper.
- [ ] `README.md`'s feature table names the three new options.
- [ ] `scripts/build_options_guide.py` gains entries and images for
      `Teardrop` openings and for the `Teardrop` and `Chamfer` bottom edges.
- [ ] `tests/fixtures/missing_bosl2.scad` is regenerated, and the library
      metadata build is re-run.
- [ ] The scenario count is updated wherever it appears: `AGENTS.md`,
      `README.md`, [E-09 (testing automation)](E-09_testing-automation.md), and
      `docs/internal/README.md`.

## Human print test (v2.1.0-rc.1)

The coupons are built with the maintainer's calibration tooling in
`_local/calibration/`, which is not in the repository.

- [ ] **Openings.** A short box with 22 mm openings, the router-shelf width,
      printed once with `Round` tops and once with `Teardrop` tops. The
      `Teardrop` tops show no drooped strands. The `Round` box is the control.
- [ ] **Bottom edge.** A 40 x 40 x 15 mm box with `Wall_Thickness=3` and
      `Bottom_Edge_Fillet=3`, printed in each style. `Teardrop` and `Chamfer`
      show no curled or lifted first layers.
- [ ] **Bridging.** A one-cell Gridfinity box with magnets, sliced at 0.28 mm
      with `Print_Layer_Height=0.28`, and again at the default 0.2 as a
      control. Add one sliced at 0.16 mm with `Print_Layer_Height=0.16`. The
      matched pockets bridge cleanly, and a 6 x 2 mm magnet still seats fully.

## Release plan

**Target: 2.1.0.** Under E-10 (versioning), a parameter added with a default
that preserves output is a minor bump. All three defaults preserve output, and
the mesh-identity criterion above proves it rather than assuming it.

1. **Merge this spec.** Implementation waits for the maintainer to agree to
   the proposed decisions.
2. **Finish 2.0.0 first.** That means E-12 phase B, the rc.6 print round for
   E-12 and [E-13 (seam joints)](E-13_seam-joints.md), and then the final
   v2.0.0. E-14's pull requests merge to `main` only after v2.0.0 is tagged.
   Merged earlier, they would sit in `[Unreleased]` and ship inside 2.0.0.
   The work itself can start on branches before then.
3. **One pull request per part, in the order 14a, 14b, 14c.** The parts share
   no model code, so any order works; this order puts the most visible change
   first. Each pull request writes its scenarios first and shows them failing
   against `main`. It runs the full suite on OpenSCAD 2021.01 with CGAL, meets
   the mesh-identity criterion, and updates the docs in the same change.
   Changelog entries go under `[Unreleased]`, in Added.
4. **Cut v2.1.0-rc.1 as a prerelease**, with the maintainer's word. Follow
   `docs/RELEASE.md`: bump `Model_Version` and the changelog section, then tag
   the prerelease. Pushing the tag makes `release.yml` draft the prerelease
   with its assets.
5. **Print the coupons** in the human print test above. If a print fails, fix
   the part and cut rc.2.
6. **Promote to v2.1.0**, with the maintainer's word, following "Promoting a
   release candidate to final" in `docs/RELEASE.md`.

**Later: the default changes.** Making `Teardrop` the default opening top, or
the default bottom edge style, is a major bump under E-10. E-03 (openings
array) is already the planned major that replaces the opening block, so the
opening default changes there, and E-03's opening row gains a top-style field.

**Alternative considered: fold E-14 into the 2.0.0 release-candidate series.**
The defaults could then change inside a major release that is already
happening. This was not chosen, for two reasons. The 2.0.0 series already
waits on E-12 phase B and on two print acceptances. And no print yet shows
that round tops droop at the preset widths.

## Candidate fourth part (proposal, not in scope)

**14d. A teardrop Scallop relief on the lid.** `m_lid_relief` cuts the
`Scallop` as a horizontal cylinder of radius `Lid_Relief_Depth`, 2.5 mm by
default, at half the lid's height. The upper arc of a horizontal cylindrical
cut overhangs whichever way the lid lies on the bed. The same teardrop
treatment would fix it, with the point toward +Z in the lid's print
orientation. E-12 phase B flips that orientation, so this part must come after
the flip, which ships in 2.0.0.

The gain is small. At the default depth, the part of the arc flatter than 45
degrees spans about 0.7 mm of height, and
[E-04 (quick wins)](E-04_quick-wins.md) records the relief as never printed.
Add 14d to 2.1.0 only if the maintainer wants it.

## Risks

- **Slicer sampling.** Part 14c assumes that a slicer samples each layer at
  its middle height. PrusaSlicer, Bambu Studio, and OrcaSlicer do; Cura does
  at its default "Middle" slicing tolerance. The 0.28 mm print in the human
  print test is what confirms the rule.
- **Preview.** Every new cutter must stay free of `intersection()`. E-12 phase
  A showed that an intersection inside a repeated cutter can exceed preview's
  100,000-element limit, and no scenario would notice.
- **More material removed above each opening.** The teardrop shoulders remove
  a little wall above each opening. The cap stays at the typed height, so the
  wall above the opening keeps its height, and the shoulders reach no higher
  than the top of the round version.
- **Default changes are deferred, not free.** Anyone who wants the
  supportless shapes must opt in until E-03 lands. The options guide and
  `docs/PRINTING.md` should point at the new parameters, so users find them.
