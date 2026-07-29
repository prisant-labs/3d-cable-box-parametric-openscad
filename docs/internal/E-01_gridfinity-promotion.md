# E-01: Gridfinity promotion

**Handle:** Gridfinity promotion. Ship the already-prototyped Gridfinity
interfaces on the box underside and the lid topside.

**Status:** prototype complete, unmerged
**Effort:** S (promotion and documentation, not construction)
**Depends on:** nothing. Benefits from [E-09 (testing automation)](E-09_testing-automation.md).

## Why this is first

This is not a greenfield feature. A working candidate already exists at
`_local/AGENTS/codex/WORKING/gridfinity/2026-02-12_12-38/`, deferred from v1.0.0
only because you wanted more review time before the first public release. It
contains:

- Gridfinity parameter groups (main toggles, bottom interface, lid-top
  interface, magnet and screw options)
- 42 mm grid layout helpers with centred clipping for non-multiple dimensions
- Five modules already integrated into `m_box_base()` and `m_lid()`:
  `m_gridfinity_bottom_adapter_solid()`,
  `m_gridfinity_bottom_adapter_cavities()`,
  `m_gridfinity_bottom_magnet_screw_cuts()`,
  `m_gridfinity_lid_top_interface()`,
  `m_gridfinity_lid_top_magnet_screw_cuts()`
- A mutual-exclusivity assert against bottom openings
- Slicing-mode support
- Seven smoke scenarios with logs, STLs, and renders, including a deliberate
  expected-fail case

The candidate is 1,039 lines against a 1,134-line contemporaneous baseline, so
it is a real implementation, not a sketch.

## Scope

**In scope**

- **Box underside**: Gridfinity base profile so the box drops into a standard
  42 mm baseplate. This is what makes the box live in a Gridfinity drawer or on
  a Gridfinity desk mat.
- **Lid topside**: Gridfinity baseplate profile on the lid so other Gridfinity
  bins stack on top of the closed box. This turns the lid into usable surface
  area, which is the whole point on a desk.
- Optional magnet and screw pockets on both interfaces.
- Independent toggles. The two interfaces must be usable separately; plenty of
  people want a stackable lid without a gridded base, or the reverse.

**Out of scope**

- Gridfinity bin dividers or internal gridding. Different feature, see
  [E-03 (openings array)](E-03_openings-array.md) and the dividers backlog item.
- Non-42 mm grid variants. The prototype locked 42 mm; keep it.

## Design notes carried from the prototype

- **Self-contained geometry.** The prototype deliberately avoids an external
  Gridfinity library dependency. Keep that even after
  [E-02 (BOSL2 migration)](E-02_bosl2-migration.md), because a second external
  dependency would complicate MakerWorld publishing, which permits only
  bundled libraries.
- **Non-multiple dimensions.** Box sizes are arbitrary and rarely land on 42 mm
  multiples. The prototype centres a clipped grid, which is the right call: it
  keeps the box usable at any size and degrades gracefully rather than forcing
  the user's dimensions.
- **Conflict handling.** Bottom Gridfinity and bottom openings are mutually
  exclusive, enforced by assertion. That is correct. The lid-top interface has
  no equivalent conflict.

## Open questions to resolve during promotion

1. **Does the lid-top interface survive slicing?** The prototype claims slicing
   support, but the smoke matrix should be re-read to confirm the lid-top
   profile is cut correctly across a seam, not just the bottom adapter.
2. **Magnet pocket sizing.** Confirm which magnet the pockets target
   (6 x 2 mm is the Gridfinity convention). Expose diameter and depth rather
   than hardcoding.
3. **Does the bottom adapter interact with `Closed_Post`?** An open post bore
   plus a Gridfinity base could leave the post opening into a grid cavity.
4. **Height implications.** A Gridfinity base adds height below the floor.
   Decide whether `Box_Height` stays the outer total or becomes the box body
   with the adapter added on top of it. Document whichever you pick; this is
   exactly the kind of ambiguity that produced the opening-height bug.

## Acceptance criteria

- [ ] Both interfaces toggle independently and default to off.
- [ ] Box underside mates with a standard 42 mm Gridfinity baseplate.
- [ ] Lid topside accepts a standard Gridfinity bin.
- [ ] Bottom Gridfinity plus bottom openings asserts with a model-level message.
- [ ] All existing smoke scenarios still pass unchanged with Gridfinity off.
- [ ] Geometry with Gridfinity off is byte-identical (normalised) to the
      pre-merge model. This is the key regression guard; see
      [E-09 (testing automation)](E-09_testing-automation.md).
- [ ] Parameter reference, FAQ, and validation rules updated in the same commit.
- [ ] At least one library preset added showing the feature.

## Human smoke test (cannot be automated)

- [ ] Print the box underside and seat it in a real Gridfinity baseplate.
- [ ] Print the lid and stack a real Gridfinity bin on it.
- [ ] Verify magnets seat flush and hold.
- [ ] Check the underside grid does not make the box rock on a flat desk.

## Risks

- **Print-time cost.** A Gridfinity base adds significant bottom geometry and
  render time. Measure and note it in `PRINTING.md`.
- **Overhangs.** Gridfinity base profiles have chamfers that print
  support-free only in the correct orientation. Document the orientation.
