# E-02 Phase 3: attachables

**Parent:** [E-02 (BOSL2 migration)](E-02_bosl2-migration.md), phase 3
**Handle:** Attachables. Give the box and lid BOSL2 anchors so features are
placed by name rather than by hand-computed coordinates.

**Status:** Shipped in v1.4.0 (2026-08-03). `m_box()` and `m_lid_part()` are
BOSL2 attachables with named anchors: `floor`, `rim`, `wall-front`, `wall-back`,
`wall-left`, `wall-right`, `post-top`, plus `lid-face` and `lip` on the lid.
`Render_On_Include=false` makes the file usable as a library. Three anchor
scenarios cover it in the regression suite.
**Effort:** L
**Depends on:** E-02 phase 1 (landed in v1.3.0)

## Problem

Every feature in this model is positioned by arithmetic against globals:

```scad
back((Box_Depth/2 - Wall_Thickness/2))
right(get_opening_center_offset("Back"))
up(Move_Opening_Back_Up + All_Openings_Up)
m_opening(side="Back", ...);
```

Nothing in that expression states *what* it is positioning against. It happens
to land on the back wall's mid-plane because three separate numbers agree.

This model has already shipped two bugs of exactly that shape:

1. **v1.1.0 opening height.** `m_opening` placed its origin at the shape's
   centre while the call site assumed the bottom edge. Every opening came out at
   half its requested height, silently, for months.
2. **v1.2.0 Gridfinity lid face.** The lid interface was placed at
   `Lid_Height + Lid_Lip_Gap_Height`, which is the mating face, so it would have
   been buried inside the closed box.

Both are origin-mismatch bugs. Neither is detectable by reading the call site,
because the call site contains no statement of intent to check against.

Anchors replace the arithmetic with a name. `attach(BACK)` cannot be off by
`Wall_Thickness/2`, and "the lid's exposed face" is a named thing rather than a
value someone has to derive.

## What BOSL2 provides

```scad
module thing(anchor=CENTER, spin=0, orient=UP) {
    anchors = [ named_anchor("cap", [0, r/sin(45), 0], BACK, 0) ];
    attachable(anchor, spin, orient, size=[w,d,h], anchors=anchors) {
        // the actual geometry, centred
        children();
    }
}
```

`attachable()` handles anchor, spin, and orient, and makes the object usable as
a parent for `attach()` and `position()`. `named_anchor(name, pos, orient, spin)`
adds domain-specific anchors on top of the standard `TOP`/`BOTTOM`/`LEFT`/etc.

## Scope, and what this spec deliberately does not do

The parent doc scoped phase 3 as "convert `m_box_base()` and `m_lid()` to
`attachable()`, then convert openings, stabilizers, and bottom openings to
attach rather than translate."

**This spec does the first half and the openings, and stops there.** The
reasoning matters, so it is recorded rather than left as a silent omission.

**In scope**

- `m_box_with_openings()` and `m_lid()` become attachable, with the standard
  anchors plus named anchors for the things this model actually talks about:
  the four wall inner faces, the floor, the rim, the post top, and the lid's
  exposed face.
- Openings move to anchor-relative placement, because openings are where the
  bug actually happened and where the intent is hardest to read.
- The anchors become the vocabulary [E-03 (openings array)](E-03_openings-array.md)
  will use for its per-opening spec.

**Deliberately out of scope**

- **Stabilizer placement.** Its arithmetic is genuinely complex (alignment
  modes, opening avoidance, fallback to distributed) and it is well covered by
  tests. Converting it is a large diff with real regression risk and a modest
  readability gain, because the hard part is the *distribution logic*, not the
  final translate.
- **Bottom opening placement.** Same reasoning, plus the post-avoidance split
  which is inherently positional arithmetic rather than attachment.
- **Clip placement.** Phase 2 territory.

Converting those is not wrong, but it should be justified by a specific need
rather than done for completeness. Doing it "because phase 3 said so" would be
a large, risky diff whose main output is a different spelling of working code.

## Design

### Anchor set

| Anchor | Where | For |
|---|---|---|
| standard `TOP`/`BOTTOM`/`LEFT`/`RIGHT`/`FRONT`/`BACK` | the box's outer bounding volume | general composition |
| `"floor"` | interior floor centre, pointing `UP` | anything sitting inside |
| `"rim"` | top of the wall, pointing `UP` | lid mating, accessories |
| `"wall-front"`, `"wall-back"`, `"wall-left"`, `"wall-right"` | inner face of each wall, pointing inward, at floor level | openings, fins, anything wall-mounted |
| `"post-top"` | top of the centre post, pointing `UP` | post accessories |
| `"lid-face"` (lid only) | the exposed face of the closed lid, pointing `UP` | Gridfinity, labels, feet |

`"lid-face"` is worth calling out. It is the answer to the question the v1.2.0
Gridfinity bug got wrong. Encoding it once as an anchor means nobody has to
re-derive which side of the lid is up.

### Preserving current placement

The box is currently built sitting on `z=0`, and everything downstream assumes
it. `attachable()` defaults to `anchor=CENTER`, which would move it. So the
modules take `anchor=BOTTOM` as their default, preserving today's behaviour
exactly, while still allowing a caller to re-anchor.

This is the single highest-risk detail in the phase: getting the default anchor
wrong silently relocates the entire model, and every existing test probe is
written in absolute coordinates that would then fail. That is a feature, not a
problem: the probes will catch it.

## Risks

- **Default anchor shifts the model.** Caught by existing probes.
- **`attachable()` needs an accurate `size=`.** With the Gridfinity base
  attached, the box's bounding volume is taller than `Box_Height`. If `size` is
  wrong, anchors land in the wrong place while the geometry still looks fine.
- **Anchor drift versus reality.** A named anchor is a hardcoded position that
  can fall out of sync with the geometry it names, which is the same class of
  problem it is meant to fix. Mitigated by asserting anchor positions in tests,
  not just geometry.
- **`$parent_geom` interactions with `diff()`/`tag()`.** The model uses plain
  `difference()`, which is fine, but mixing attachment idioms with raw
  `difference()` needs care.

## Acceptance criteria

- [ ] Geometry unchanged: mesh volumes match v1.3.0 to four decimal places
      across the full scenario matrix, with default anchors.
- [ ] `m_box_with_openings()` and `m_lid()` accept `anchor`, `spin`, `orient`
      and behave correctly for at least `BOTTOM`, `CENTER`, and `TOP`.
- [ ] Every named anchor above resolves, with a test asserting its position.
- [ ] Openings are placed via anchors, with no remaining
      `Box_Depth/2 - Wall_Thickness/2` style arithmetic at those call sites.
- [ ] A test attaches a marker cube to `"lid-face"` and probes that it lands on
      the exposed side, which is the v1.2.0 bug encoded as a regression test.
- [ ] Module reference and architecture docs document the anchor set.
