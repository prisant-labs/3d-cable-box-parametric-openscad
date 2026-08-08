# E-02 Phase 2: snap-fit seam clips

**Parent:** [E-02 (BOSL2 migration)](E-02_bosl2-migration.md), phase 2
**Handle:** Snap clips. Replace the hand-rolled rectangular seam tabs with real
cantilever snap-fit joints from BOSL2's `joiners.scad`.

**Status:** Shipped in v1.4.0 (2026-08-03). `Clip_Style` takes `"Snap"`, backed
by BOSL2 `rabbit_clip`, with `Clip_Snap_Length`, `Clip_Snap`,
`Clip_Arm_Thickness`, `Clip_Compression` and `Clip_Lock` to tune it.

**The default is still `"Tab"`**, and that is the only part left. Clip
correctness is the one thing here that rendering cannot establish: a joint too
tight to assemble passes every automated scenario. The default flips once a
print says it should, which is itself a major bump and belongs with 2.0.0.
**Effort:** M
**Depends on:** E-02 phase 1 (landed in v1.3.0)

## Problem

The slicing feature splits an oversized box into pieces that clip together. The
clips are currently plain rectangular tabs:

```scad
module m_floor_clip_male()   { cube([Clip_Tab_Depth, Clip_Tab_Width, Clip_Tab_Height], center=true); }
module m_floor_clip_female() { cube([Clip_Tab_Depth + Clip_Tolerance*2 + SPACER, ...], center=true); }
```

A rectangle in a slightly larger rectangular hole. It holds by **friction
alone**. That has three consequences:

1. **No detent.** Nothing resists pull-out. The joint holds only as hard as the
   interference fit, which is exactly the dimension hardest to print accurately.
2. **Tolerance is the only tuning knob.** `Clip_Tolerance` trades "will not go
   in" against "falls apart" with no middle ground, which is why `PRINTING.md`
   has to tell people to print one seam and iterate.
3. **No compliance.** A rigid tab in a rigid hole either fits or does not. A
   cantilever arm flexes, absorbing dimensional error instead of jamming.

## What BOSL2 provides

`joiners.scad` has `rabbit_clip()`, a proper cantilever snap:

```scad
rabbit_clip(type="pin"|"socket"|"double", length, width, thickness, depth,
            snap, compression, clearance, lock, lock_clearance,
            anchor, spin, orient);
```

Relevant semantics, from the BOSL2 docs:

| Argument | Meaning |
|---|---|
| `length` | nominal total length of the clip along its travel |
| `width` | nominal width at the base |
| `thickness` | thickness of the clip's curved arm, which sets its stiffness |
| `depth` | extrusion depth of the 2D clip profile |
| `snap` | depth of the engagement bump. This is the detent the current design lacks. |
| `compression` | widens the ears for a tighter fit |
| `clearance` | space added to the **socket**, for print inaccuracy |
| `lock` | makes the joint effectively irreversible |

Two notes carried from the docs that matter for implementation:

- **The socket must be deeper than the pin**, by roughly `0.4 mm`, or insertion
  binds at the bottom.
- Pins default to `orient=UP`, sockets to `orient=DOWN`.

## Scope

**In scope**

- A `Clip_Style` enum: `"Tab"` (today's behaviour) and `"Snap"` (`rabbit_clip`).
- Both floor clips (box seams) and lid clips.
- Mapping the existing `Clip_*` parameters onto the new geometry where the
  meaning genuinely carries over, and adding the ones snap joints need.
- Preserving the post-opening avoidance from v1.1.0. Clips still must not land
  over the open post bore.

**Out of scope**

- Dovetails for dividers. Different feature, see the backlog.
- Changing the default. See below.

## The default stays `"Tab"`, deliberately

`"Snap"` is the better joint on every axis, and it is the entire point of this
phase. It is still not the default in this release.

The reason is that clip geometry is the one part of this model whose
correctness **cannot be established by rendering it**. Manifoldness, solid
counts, and probe assertions all pass for a joint that is far too tight to
assemble or too loose to hold. Only a print tells you. Shipping a changed
default before that print means every existing slicing user gets untested
geometry with no warning.

So: `"Snap"` ships opt-in and documented, gets validated by print, and the
default flips in a follow-up **major** release, because changing the geometry
produced by an unchanged parameter set is a breaking change under
[E-10 (versioning)](E-10_versioning.md).

This also keeps the version arithmetic honest: adding an enum whose default
preserves behaviour is additive, so this is a **minor** release.

## Parameter mapping

| Existing | Role under `"Snap"` |
|---|---|
| `Clip_Tab_Width` | `width`, the clip's base width. Direct carry-over. |
| `Clip_Tab_Depth` | `length`, how far the clip travels into the socket. |
| `Clip_Tab_Height` | `depth`, the extrusion. Direct carry-over. |
| `Clip_Tolerance` | `clearance` on the socket. Same intent, and now only one of several knobs rather than the only one. |
| `Clips_Per_Edge` | unchanged |

New, only meaningful when `Clip_Style="Snap"`:

| New parameter | Default | Why |
|---|---|---|
| `Clip_Snap` | `0.4` | Engagement bump depth. The detent. Larger holds harder and is harder to separate. |
| `Clip_Arm_Thickness` | `1.0` | Arm stiffness. Too thin snaps off, too thick will not flex. |
| `Clip_Compression` | `0.1` | Ear widening for a tighter fit. |
| `Clip_Lock` | `false` | Irreversible joint. Useful for a box that will never be disassembled. |

Defaults are starting points from BOSL2's own examples, scaled to this model's
clip size. They are explicitly a first guess pending the print test.

## What actually went wrong, recorded

Two things, both worth keeping.

**The pin never overlapped its slice.** The existing clip offsets assume a
*centred* cube: `Clip_Tab_Depth/2 - SPACER` pulls a centred tab's near face back
to the seam. A `rabbit_clip` is *base-anchored*: its geometry starts at the
placement point and grows away from the slice, so the same offset left the pin
floating in the gap with nothing to bond to. The offsets are now style-aware.

**It passed locally anyway, for a bad reason.** This machine had two BOSL2
installs. `~/Documents/OpenSCAD/libraries` is redirected to OneDrive on Windows,
so a `git clone` into the literal `~/Documents` path landed somewhere OpenSCAD
never looks, while a stale 2.0.716 copy under OneDrive kept being loaded. Under
2.0.716 the anchor happened to sit 4.19 mm further back, which produced the
overlap by accident. Under the pinned 2.0.747 the pin detaches and the slice
exports in three pieces.

So a full green local run was testing a different library than CI. CI caught it;
local could not have. Two guards now exist:

- `tests/run_tests.py` prints the BOSL2 version OpenSCAD actually loads, on
  every run, before any scenario.
- `scripts/bump-bosl2.sh` refuses to run when the clone it manages is not the
  one OpenSCAD loads, because every comparison it makes would be meaningless.

The bounding-box assertion is what made this diagnosable rather than mysterious:
`x-max 34.968 versus 30.780` located the fault immediately, where the solid count
only said "detached".

## Risks

- **Untested geometry.** Mitigated by the opt-in default and an rc release.
- **`Clip_Tab_Depth` default of 4 mm may be short** for a cantilever that has to
  flex. The tab design did not need travel; a snap does. If the print shows the
  arm cannot deflect, `length` needs its own parameter rather than reusing
  `Clip_Tab_Depth`.
- **Orientation.** The clips protrude along X across the seam, while
  `rabbit_clip` pins default to `orient=UP`. Getting `orient`/`spin` wrong
  produces a clip pointing into the part, which renders fine and is useless.
  Needs a point probe asserting material on the correct side of the seam.
- **Socket depth.** Forgetting the `+0.4 mm` socket depth produces a joint that
  binds. Encode it as a named constant, not a literal.

## Acceptance criteria

- [ ] `Clip_Style="Tab"` produces geometry byte-identical to v1.3.0, verified by
      mesh volume across the slicing scenarios.
- [ ] `Clip_Style="Snap"` renders manifold, with the expected solid count, for
      2 and 3 slices, 1 to 4 clips per edge, box and lid.
- [ ] Snap clips still avoid the open post bore.
- [ ] A point probe confirms the pin protrudes on the correct side of the seam.
- [ ] Socket is deeper than the pin.
- [ ] Parameter reference, FAQ, and printing guide updated.
- [ ] Released as an rc with both styles printable for comparison.

## Human print test

- [ ] Print one seam pair in each style, same printer and material.
- [ ] Snap: does it click, hold, and separate without breaking?
- [ ] Compare assembly force and pull-out resistance against the tab.
- [ ] Try `Clip_Lock=true` on a scrap pair; confirm it is genuinely irreversible.
- [ ] Only then decide whether the default flips.
