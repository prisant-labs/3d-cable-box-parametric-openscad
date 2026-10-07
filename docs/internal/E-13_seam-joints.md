# E-13: Seam joints

**Handle:** Seam joints. Replace the flat slice cut with a 45 degree sawtooth
through the walls, so the halves of a box larger than the bed cannot slide
vertically and their rims meet flush.

**Status:** Implemented 2026-10-07, unreleased; waiting on the rc.6 print
round. The suite passes 104 of 104. It takes up the alignment problem left
open in [E-02-P2 (snap clips)](E-02-P2_snap-clips.md). Both clip styles stay.
**Effort:** S to M
**Depends on:** nothing. Ships in the 2.0.0 release-candidate series together
with [E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md).

## Why

[Backlog item 20 (seam alignment)](BACKLOG.md) records the rc.5 prints. With
either clip style, the halves could slide vertically, and the tab pair's rims
did not meet flush.

The cause is confirmed in the code. `m_place_floor_clips` cuts the female
socket from z -0.2 to 3.2 mm through a 1.85 mm floor, so the socket is open
above and below. Nothing on the seam resists vertical movement.

## Decision (2026-10-07): sawtooth walls, floor clips kept

Four options were compared with renders. The renders are local to the
maintainer's checkout, in `_local/research/seam-options/seam-options-sheet.png`.

| Option | Verdict |
|---|---|
| 45 degree sawtooth through the walls, floor clips kept | **Chosen.** It is only a cut, so it cannot collide with other features, and it prints without supports. |
| Roofed floor sockets, with the two tabs pointing opposite ways | Easiest to print. The roofs need keep-outs from the post and bottom openings, it needs at least two clips per edge, and the wall tops stay free. |
| A second clip near the rim, on an inside rib | The rib lands in the default front and back openings, which sit on the seam of a two-piece box. |
| A lap joint plus glue | Each tongue is half of a 1.85 mm wall, which is fragile, and it holds nothing until the glue cures. |

The seam research also proposed BOSL2's jigsaw and dovetail partition cuts.
Those cuts have an undercut, so they engage only by sliding along Y. The floor
clips engage along X, and one seam cannot use both directions.

**The insertion rule.** Every feature on a seam engages by pushing the halves
together along X. The sawtooth has no undercut, so it follows the rule. The
finished joint restrains each direction as follows:

| Direction | Restrained by |
|---|---|
| Vertical (Z) | The teeth |
| Along the seam (Y) | The floor clips |
| Pull-apart (X) | The Snap clip, or glue |

## Design

- **Profile.** The cut is a profile in the XZ plane, extruded along Y across
  the full depth. Through the floor (z below `Wall_Thickness`) the cut stays
  vertical, so the floor clips keep their positions. Above the floor it is a
  triangle wave with 45 degree flanks. BOSL2's `"sawtooth"` subpath in
  `partitions.scad` has exactly these proportions. A plain polygon needs no new
  include.
- **Parameter.** Add `Seam_Tooth_Depth`, which defaults to 3 mm and gives a
  6 mm tooth period. A value of 0 must take today's cube-cutter path
  unchanged, so a flat cut stays available.
- **Clearance.** The two halves' profiles sit `Clip_Tolerance` apart,
  measured along X. Vertical play is then at most that gap, 0.2 mm at the
  defaults.
- **Phase.** The first flank starts at the floor's top face. A partial tooth
  is acceptable at the rim.
- **Openings on the seam.** All four side openings are on by default and
  centred on their walls. A two-piece box's seam therefore crosses the front
  and back openings, which span 5 to 35 mm up a 50 mm wall. The teeth act only
  where wall remains: 15 mm above the opening and about 3 mm below it. That
  still locks vertical movement. Guard against tooth slivers thinner than
  about 0.8 mm at an opening's rounded edge, either with validation or by
  flattening the profile locally.
- **Other features on the seam.** Stabilizer fins and the post take the same
  profile, which is harmless. The Gridfinity feet below the floor keep a
  vertical cut.
- **Three or more slices.** A middle slice carries the profile on both edges,
  following the existing `is_first_slice` and `is_last_slice` logic.
- **The lid.** The same profile runs across the lid's slab. The cut stays
  vertical in the band where the lid's seam clips sit. At the default 8.1 mm
  slab, that leaves room for about one tooth.
- **Backlog item 19 (lid seam clips below the bed).** Add an assert or a
  clamp, with a scenario that fails first. E-12's flipped Gridfinity lid also
  moves where the lid clips must sit.

## Tests

Write each scenario first, and confirm it fails against rc.5, as `AGENTS.md`
requires.

- **A new assembly test, `tests/assembly/slices_joined.scad`.** It places
  slice 1 and slice 2 in their assembled positions, `SPACER` apart along X.
  The gap keeps the flat floor faces from touching, because CGAL's result for
  touching solids is unreliable. It has three checks:
  - **Overlap:** at the assembled position, the slices overlap nothing. An
    empty export exits 1.
  - **Lifted:** with slice 2 raised 0.5 mm, more than the clearance, the
    slices collide. Against rc.5 this overlap is empty, so the scenario fails
    first, as it must.
  - **Dropped:** with slice 2 lowered 0.5 mm, the slices collide.
- **Solids.** Every slice exports as one solid. The cases include the default
  box, whose openings sit on the seam, and the middle slice of a three-slice
  box.
- **Teeth exist.** Material and empty probes on either side of the seam, at a
  tooth's height, show the zigzag.
- **Flat cut kept.** With `Seam_Tooth_Depth = 0`, every slice is
  mesh-identical to rc.5.
- **The lid.** The lid seam gets the same three checks.

## Acceptance criteria

- [x] Assembled slices overlap nothing.
- [x] Slices offset 0.5 mm up or 0.5 mm down collide, in both directions.
- [x] Every slice exports as one solid, including the default box and the
      middle slice of a three-slice box.
- [x] `Seam_Tooth_Depth = 0` reproduces today's flat cut, mesh-identical.
- [x] No tooth face overhangs more than 45 degrees in print orientation.
- [x] The lid seam passes the same checks, and the backlog item 19 guard is in
      place.
- [x] `docs/PARAMETER_REFERENCE.md`, `docs/VALIDATION_RULES.md`,
      `docs/MODULE_REFERENCE.md`, and `docs/PRINTING.md` (gluing) change in
      the same commit as the model.

## Human print test (rc.6)

- [ ] A sliced box at the default size, with openings on the seam, assembles
      by pushing the halves together. The rims meet flush with no vertical
      play.
- [ ] The teeth print cleanly without supports, including beside an opening's
      rounded top.
- [ ] Glued with cyanoacrylate, the seam holds when the box is lifted by one
      half.
- [ ] The print decides whether `Clip_Style` stays `"Tab"` by default, as
      E-02-P2 left open.

## Risks

- **Slivers beside openings.** A tooth tip cut by an opening's rounded edge
  can leave a thin fragment. The solids check catches a detached one; only a
  print shows whether an attached one is too thin to print.
- **The clearance is a chosen number.** At 45 degrees, a 0.2 mm gap along X
  is 0.14 mm measured across the flank. The print decides whether that is
  enough.
