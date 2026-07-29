# E-04: Quick wins

**Handle:** Quick wins. Edge treatment, lid removal relief, and magnetic lid
retention. Three small independent changes with high value per unit of effort.

**Effort:** S total
**Depends on:** nothing. Cheaper after
[E-02 (BOSL2 migration)](E-02_bosl2-migration.md) but does not require it.

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
