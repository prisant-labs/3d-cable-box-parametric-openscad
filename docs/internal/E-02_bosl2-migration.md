# E-02: BOSL2 migration

**Handle:** BOSL2 migration. Replace the embedded February 2022 subset with a
real BOSL2 dependency and adopt its attachment system.

**Status:** Shipped. Phase 1 in v1.3.0 (2026-07-31); phases
[2 (snap clips)](E-02-P2_snap-clips.md) and
[3 (attachables)](E-02-P3_attachables.md) in v1.4.0 (2026-08-03). The snap-clip
*default* is the one thing still outstanding, and it waits on a print rather
than on work.
**Effort:** L
**Depends on:** [E-09 (testing automation)](E-09_testing-automation.md), which landed first and proved the migration geometry-neutral.

## Starting state (resolved in v1.3.0)

`cable-box-parametric.scad` embedded a BOSL2 subset copied 27 February 2022,
minified onto **one line of 214,500 characters**, 79 percent of the file by
bytes. It could not be reviewed, diffed, or searched, and froze the project on a
2022 snapshot.

As of v1.3.0 the model declares `include <BOSL2/std.scad>` and is 72 KB.

## What the current version gives you

Verified against current BOSL2 docs:

| Need | Module | Replaces |
|---|---|---|
| Seam clips | `joiners.scad`: `rabbit_clip(type="pin"/"socket", snap, compression, lock)` | Hand-rolled `m_floor_clip_male/female`, which are plain cuboids relying on friction and `Clip_Tolerance` |
| Slide-in dividers | `joiners.scad`: `dovetail("male"/"female", slide, width, height, slope)` | Backlog item 2 (modular divider slots) |
| Hinged lid | `hinges.scad`: `knuckle_hinge()`, `apply_folding_hinges_and_snaps()` | Backlog item 8 |
| Screw-down lid | `joiners.scad`: `joiner(screwsize=)`, plus `screws.scad` | Backlog item 7 |
| Labels | attachable `text3d` | Backlog item 6 |
| Edge fillets and chamfers | `rounding.scad`, `masks3d.scad` | [E-04 (quick wins)](E-04_quick-wins.md) |

`rabbit_clip()` is the notable one. It is a real cantilever snap with a defined
engagement bump and tunable `snap`, `compression`, and `lock`. The current clips
are rectangular tabs that hold by interference alone.

## The structural argument: attachments

Every feature in the model is positioned by hand-computed `translate()` against
globals. The v1.1.0 side-opening bug was exactly this failure mode: `m_opening`
placed its origin at the shape centre while the call site assumed the bottom
edge, and nothing could catch the mismatch. The result shipped as a model that
silently halved every opening height.

BOSL2's `attach()` / `position()` / `align()` replaces coordinate arithmetic
with named anchors on parent geometry. An opening attaches to "front wall,
bottom edge, inset N" rather than being translated to a computed z. That makes
the entire class of origin-mismatch bug unrepresentable rather than merely
fixed, and it is the main reason to do this work.

## MakerWorld compatibility (researched, and it favours migration)

This was the open question, and the answer inverts the usual trade-off.

MakerWorld's Parametric Model Maker **bundles BOSL2** and you reference it with
`include <BOSL2/std.scad>`. It **does not allow uploading custom local
libraries** alongside your project files. MakerWorld targets the OpenSCAD 2021
stable release.

So:

| Approach | GitHub | MakerWorld | Web customizer (E-08) |
|---|---|---|---|
| Embedded minified subset (today) | works, unreviewable | works, but ships 214 KB of duplicated library | works |
| Split into local `lib/` files | works | **blocked**, custom includes not permitted | works |
| `include <BOSL2/std.scad>` | works, users install BOSL2 | **works, library is provided** | works, playground bundles BOSL2 |

Real BOSL2 is the only approach that is clean on all three. A local `lib/` split
is the one option that actively breaks MakerWorld, which is worth knowing before
anyone reaches for it as the obvious tidy-up.

## Migration plan

**Phase 1: swap the dependency, change nothing else. DONE in v1.3.0.**

Outcome, better than expected in one way and worse in another.

Better: the API surface turned out to be tiny and entirely stable. `cuboid`,
`cyl`, `up/down/left/right/back`, `TOP/BOTTOM/RIGHT/BACK`, `anchor`, `rounding`,
`except`, `is_int`. The model rendered correctly against BOSL2 2.0.747 on the
first attempt with no signature changes to chase, despite the four-year gap.

Worse: it exposed a latent defect. The lid's lip ring and post collar met the
lid panel on a shared plane with **zero overlap**. Coplanar-face fusion is
kernel-dependent; the 2022 BOSL2 fused them and the current one does not, so the
lid exported as three detached solids. Fixed with a `WELD` allowance, applied to
the Gridfinity solids too. Worth noting this was never a migration regression:
any BOSL2 or CGAL update could have triggered it, and it would have shipped a
lid in three pieces with no error.

Verification used **mesh volume**, not the normalised coordinate hash. The hash
is too strict here because rounding tessellation legitimately changed by a
handful of facets. Volumes matched to four decimal places across every
configuration, which is the property that actually matters.

Numbers: the model went from 271 KB to 72 KB, losing a single 214,500-character
line that was 79 percent of the file.

**Phase 2: replace hand-rolled geometry.**
Swap the clip modules for `rabbit_clip()`. This one deliberately changes
geometry, so it is a separate, individually reviewable step with its own
physical print test.

**Phase 3: adopt attachments.**
Convert `m_box_base()` and `m_lid()` to `attachable()` with named anchors, then
convert openings, stabilizers, and bottom openings to attach rather than
translate. Largest and most valuable phase. Best done alongside
[E-03 (openings array)](E-03_openings-array.md), since both touch the same call
sites.

## Distribution consequence

Local users must install BOSL2. That is standard practice in the OpenSCAD
community and a one-line README instruction, but it does end the
"download one file and open it" story for the repo copy.

Mitigation: a **CI-built bundle as a release asset**, verified in CI to render
with BOSL2 moved out of reach.

One correction to the original plan: the bundle is **two files**, not one. BOSL2
pulls in `builtins.scad` with `use` rather than `include`, because that file
wraps OpenSCAD's builtins:

```scad
module _translate(v) translate(v) children();
```

`use` gives it its own scope so `translate` resolves to the builtin. BOSL2's
`transforms.scad` defines its own `translate` that calls `_translate`. Inline
`builtins.scad` textually and its body resolves to BOSL2's override instead,
producing infinite recursion. The sidecar is 1.3 KB and must sit beside the
bundle. A genuinely single-file bundle is not achievable without patching BOSL2.

## Risks

- **Version drift.** A BOSL2 update could silently change geometry. Pin a
  version in the README and in CI, and rely on the geometry test suite.
- **Silent geometry change during Phase 1.** The whole reason E-09 comes first.
- **2021 versus current OpenSCAD.** MakerWorld targets 2021 stable. Avoid BOSL2
  features that require a newer OpenSCAD than that, or maintain a compatibility
  note.

## Acceptance criteria

- [x] Phase 1 lands geometry-neutral. Mesh volumes match to four decimal places
      across every configuration tested. (The originally-specified normalised
      coordinate hash proved too strict: rounding tessellation legitimately
      changed by a few facets. Volume is the right invariant.)
- [x] Model file is 1,621 readable lines with no line over 200 chars.
- [x] `include <BOSL2/std.scad>` at the top, version pinned in CI via `BOSL2_REF`.
- [x] CI builds the bundle and verifies it renders with BOSL2 moved out of reach.
      (Two files, not one; see the distribution section.)
- [x] `THIRD_PARTY_NOTICES.md` rewritten: BOSL2 is a dependency, with install
      instructions and the bundle's attribution story.
- [ ] A MakerWorld upload renders correctly in their customizer. **Untested**,
      needs an actual upload; see [E-11 (distribution)](E-11_distribution.md).
- [ ] Phase 2: `rabbit_clip()` for seam clips.
- [ ] Phase 3: attachments.
