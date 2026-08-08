# E-04: Quick wins

**Handle:** Quick wins. Edge treatment, lid removal relief, and magnetic lid
retention. Three small independent changes with high value per unit of effort.

**Status:** Implemented, unreleased (2026-08-07). All three sub-features are in
the model behind opt-in defaults, with nine regression scenarios. Sits in
`[Unreleased]` rather than 2.0.0, because every default leaves existing geometry
untouched and that makes it a minor bump under
[E-10 (versioning)](E-10_versioning.md).

**Not print-validated.** Three items in the human smoke test below still need
hardware: whether the lid comes off one-handed, whether a magnet seats without
cracking its boss, and whether the bottom fillet prints without a droopy first
layer. The last is the one most likely to send a parameter default back for
revision.

**Effort:** S total
**Depends on:** nothing. Cheaper after
[E-02 (BOSL2 migration)](E-02_bosl2-migration.md) but does not require it.

---

## Resolved decisions (2026-08-07)

Three questions this document left open, and how they were settled.

**Versioning: every default leaves existing geometry unchanged.** Under
[E-10 (versioning)](E-10_versioning.md) that makes this a MINOR bump, so it ships
on its own schedule rather than folding into 2.0.0, which is mid print
validation and should not grow. This is enforced structurally, not by matching
numbers: with both edge parameters at zero the code takes the existing
`cuboid()` path unchanged, so "unchanged" is a property of the control flow
rather than a claim to be verified.

**Edge treatment uses `offset_sweep()`, not stacked masks.** BOSL2's
`offset_sweep()` extrudes a 2D region with independent top and bottom edge
profiles, which resolves the fillet-meets-corner-radius interaction itself. That
interaction is the part that is fiddly by hand, and it is the reason this effort
was always cheaper after E-02. Verified available from `BOSL2/std.scad` with no
new include.

**Magnets go in four corner bosses, not distributed along the walls.** The box
rim is `Wall_Thickness` (1.85 mm) wide and a 6 mm magnet does not fit it, which
is the constraint this document flagged as needing resolution. Corners are the
answer because they are structurally free by construction: openings sit on wall
centres, stabilizers carry end margins, the post is central, and slice seams sit
at interior x. Collision avoidance becomes geometry rather than logic, which is
the difference between four bosses and a placement engine that has to know about
every other feature.

Relief placement uses per-side booleans mirroring the existing `Opening_On_*`
block, so it introduces parameters but no new concepts.

---

## 4a. Top and bottom edge treatment

**Problem.** Every `cuboid()` call passes `except = [TOP, BOTTOM]`, so only the
vertical edges are rounded. Every horizontal edge is a hard 90 degrees: the
bottom perimeter, the top rim, the lid edges.

**Why it matters more than it sounds.** This is the single largest gap between
how the model looks and how a commercial product looks, and it is two
parameters. A fillet on the bottom outer edge also visually absorbs elephant
foot, and a chamfer on the top rim removes the sharp edge you touch every time
you take the lid off.

**Proposal.** `Bottom_Edge_Fillet` (default around 1.0) and `Top_Edge_Chamfer`
(default around 0.6). Apply to the box outer bottom, the box top rim, and the
matching lid edges.

**Watch for.** The bottom fillet interacts with
[E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md), which owns the
underside profile. Gridfinity mode should suppress the bottom fillet. Also
verify a bottom fillet does not undercut the first layer into an unprintable
overhang; keep it modest or make it a chamfer instead.

---

## 4b. Lid removal relief

**Problem.** `Lid_Lip_Gap` defaults to `0.1 mm`. That is a deliberately tight
friction fit with no purchase anywhere on the lid. Getting it off will require
fingernails or a tool, repeatedly, forever.

**Proposal.** `Lid_Relief_Style` enum: `None`, `Scallop`, `Tab`.

- `Scallop`: a shallow concave cut in the lid skirt on one or both sides, giving
  a thumb pad. Cosmetically clean.
- `Tab`: a small protruding lip to pull or lever. More effective, less tidy.

Place relative to the wall centre so it does not collide with openings, and skip
placement where it would.

**Why it is worth doing early.** It is the first thing anyone notices when
handling the printed object, and it costs almost nothing.

---

## 4c. Magnetic lid retention

**Problem.** Lid retention is friction only. Bump the box or pick it up by the
lid and it comes off.

**Context.** Backlog items 7 and 8 cover screw-down and hinged lids. Magnets are
the option most printed enclosures actually use, and they are the cheapest of
the three to implement: two mirrored pockets, no moving parts, no fasteners.

**Proposal.** `Enable_Lid_Magnets`, `Magnet_Diameter` (default 6),
`Magnet_Height` (default 2), `Magnet_Count_Per_Side`, `Magnet_Inset`. Cut
matching pockets in the box rim and the lid lip, aligned so they attract when
closed.

**Design notes.**

- Pocket depth should leave a thin ceiling, roughly one or two layers, so the
  magnet is captured rather than exposed. That also gives a clean print surface
  without a bridge over a hole.
- Add a tolerance parameter. Magnet diameters vary by supplier and a press fit
  that is too tight cracks the wall.
- The box rim is only `Wall_Thickness` (1.85 mm default) wide. A 6 mm magnet
  does not fit in it. The pocket needs a local boss, or the magnets need to sit
  in the lid skirt and the box outer wall rather than the rim. **Resolve this
  before implementing**; it is the one non-obvious constraint here.
- Assert that the magnet plus its surround fits the available wall.

**Interaction.** Gridfinity magnet pockets from
[E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md) already establish a
magnet parameter convention. Reuse it rather than inventing a second one.

---

## Acceptance criteria

- [ ] All three default to a state that leaves current geometry unchanged, or
      the change is versioned per [E-10 (versioning)](E-10_versioning.md).
- [ ] Edge treatment suppressed automatically in Gridfinity mode.
- [ ] Lid relief never collides with an opening.
- [ ] Magnet pockets assert when they do not fit the available wall.
- [ ] All three survive slicing mode.

## Human smoke test

- [ ] Lid comes off comfortably one-handed.
- [ ] Magnets seat without cracking the wall and hold when the box is lifted by
      the lid.
- [ ] Bottom fillet prints without a droopy first layer.
