# E-02: BOSL2 migration

**Handle:** BOSL2 migration. Replace the embedded February 2022 subset with a
real BOSL2 dependency and adopt its attachment system.

**Effort:** L
**Depends on:** nothing, but [E-09 (testing automation)](E-09_testing-automation.md)
should land first so the migration can be proven geometry-neutral.

## Current state

`cable-box-parametric.scad` embeds a BOSL2 subset copied 27 February 2022,
minified onto **one line of 214,500 characters**. That single line is 79 percent
of the file by bytes. Consequences:

- The file cannot be reviewed, diffed, or searched normally, and cannot be read
  whole inside a model context window.
- You are frozen on a 2022 snapshot. Current BOSL2 is v2.0.733.
- Bug fixes and new modules upstream are unavailable.

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

**Phase 1: swap the dependency, change nothing else.**
Delete the embedded block, add `include <BOSL2/std.scad>`. Prove geometry is
unchanged using normalised STL comparison across the full parameter matrix
(see [E-09 (testing automation)](E-09_testing-automation.md)). Expect some
breakage: 2022 to v2.0.733 is a long gap and some signatures moved.

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

Mitigation: keep a **CI-generated single-file bundle as a release asset**. The
repo stays reviewable, and the Release still offers a self-contained `.scad`
for people who want one. That bundle is also what you would upload to any
platform lacking BOSL2.

## Risks

- **Version drift.** A BOSL2 update could silently change geometry. Pin a
  version in the README and in CI, and rely on the geometry test suite.
- **Silent geometry change during Phase 1.** The whole reason E-09 comes first.
- **2021 versus current OpenSCAD.** MakerWorld targets 2021 stable. Avoid BOSL2
  features that require a newer OpenSCAD than that, or maintain a compatibility
  note.

## Acceptance criteria

- [ ] Phase 1 lands with a normalised-geometry diff of zero across the full
      parameter matrix.
- [ ] Model file drops below 1,500 readable lines with no line over 200 chars.
- [ ] `include <BOSL2/std.scad>` at the top, BOSL2 version pinned and documented.
- [ ] CI emits a single-file bundle as a release asset.
- [ ] A MakerWorld upload of the model renders correctly in their customizer.
- [ ] `THIRD_PARTY_NOTICES.md` updated: BOSL2 becomes a dependency rather than
      embedded code, which changes the attribution wording.
