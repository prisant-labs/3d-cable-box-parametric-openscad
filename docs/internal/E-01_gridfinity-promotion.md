# E-01: Gridfinity promotion

**Handle:** Gridfinity promotion. Ship the already-prototyped Gridfinity
interfaces on the box underside and the lid topside.

**Status:** Shipped in v1.2.0 (2026-07-30). The lid interface was reworked from
a stud to a socket in 2.0.0, which resolves the profile-direction question below.
Both interfaces remain **unvalidated by print**; `v2.0.0-rc.2` is the artifact
to print.
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

## Resolved during promotion

1. **Height convention: ADD, not carve.** Carving would have required a separate
   `Floor_Thickness` threaded through stabilizer, bottom-opening, clip, and post
   placement, all of which treat `Wall_Thickness` as the floor. Adding is a pure
   union below the existing solid and touches none of them. The box is lifted by
   the base height at render so the export still sits on z=0.
2. **The lid interface was on the wrong face.** The prototype placed it at
   `Lid_Height + Lid_Lip_Gap_Height`. Mapping the lid's cross-section showed its
   solid panel spans z 0..Lid_Height with the lip ring above it at the perimeter
   only. The lip is the mating face, so z=0 is the exposed top. As prototyped the
   profile would have been buried inside the closed box. It now grows downward
   from z=0 with the lid lifted to match.
3. **Post interaction.** An open post bore would be blocked by the base, so
   Gridfinity bottom now asserts `Closed_Post`.
4. **Empty grid.** A box too small for one cell omits the interface, and the
   render-time lift is suppressed with it, otherwise the box floated 4.75mm
   above z=0. Covered by a test.
5. **Parameter surface.** The prototype exposed 30 Gridfinity parameters. The
   spec dimensions are now hidden `GF_*` constants, since changing one produces
   a part that no longer mates with anyone else's gear. Eight user-facing
   parameters remain.

## Open questions still to resolve

**Profile direction on the lid. RESOLVED in 2.0.0: socket.** v1.2.0 shipped a
positive two-stage stud (39.4 then 37.2), which is what the prototype built.
That was the wrong half. The lid inverts in use, so its exposed face is the top
of a closed box, and a stud there points Gridfinity feet at the ceiling with
nothing able to rest on them. `Enable_Gridfinity_Lid_Top` now renders a 4.75 mm
baseplate with a mating socket per cell, which is the reading this document gave
originally and the one the parameter's own doc comment always described.

The socket mouth is sized from `GF_BASE_CELL` (41.5) plus clearance, not from
`GF_CAVITY_ENTRY_SIZE` (39.4). The latter describes the cavity hollowed *into*
the box base, which is the inside of the male half; a mouth that size holds
every part 1.85 mm proud. That error is invisible in a render and was caught by
arithmetic.

The clearance is 0.25 mm and remains a chosen number, not a measurement.

## Acceptance criteria

- [x] Both interfaces toggle independently and default to off.
- [ ] Box underside mates with a standard 42 mm Gridfinity baseplate. **Print test.**
- [ ] Lid topside behaves as intended: a Gridfinity bin foot seats in a lid
      socket. **Print test.** Profile direction is settled (socket, 2.0.0); what
      the print decides is the 0.25 mm clearance.
- [x] Bottom Gridfinity plus bottom openings asserts with a model-level message.
- [x] All existing smoke scenarios still pass unchanged with Gridfinity off (48/48).
- [x] Geometry with Gridfinity off is byte-identical (normalised) to the
      pre-merge model, across all three `Part_To_Render` modes.
- [x] Parameter reference and FAQ updated in the same commit.
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
