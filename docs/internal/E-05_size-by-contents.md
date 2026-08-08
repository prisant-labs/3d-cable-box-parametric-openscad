# E-05: Size by contents

**Handle:** Size by contents. Let users size the box from what goes inside it
rather than from outer dimensions.

**Status:** Spec. Not started.

**Effort:** M
**Depends on:** informed by [E-07 (preset library)](E-07_preset-library.md),
which reveals which content classes actually matter.

## The problem

The model asks for `Box_Width`, `Box_Depth`, `Box_Height`. Nobody knows those
numbers. They know they have a 6-outlet surge strip and three wall warts, and
they want a box that holds it.

Getting from one to the other means measuring the contents, adding clearance,
adding `Wall_Thickness * 2`, remembering that stabilizer fins eat
`Stabilizer_Depth` of interior on each wall they are on, and remembering that
the post consumes a `Post_Diameter` circle in the middle. That is a
five-variable mental calculation, and getting it wrong costs a multi-hour print.

This is the single largest usability barrier in the model, larger than any
missing feature.

## Two levels

**Level 1: internal dimension mode.** An input-mode toggle:

```scad
Sizing_Mode = "Outer";  // ["Outer", "Internal"]
Internal_Width = 90;
Internal_Depth = 65;
Internal_Height = 45;
```

In `Internal` mode, outer dimensions are derived, accounting for wall thickness
and, critically, for the usable-interior reductions from stabilizers and the
post. Modest effort, immediately useful, and it makes the model honest about
what "interior" means, which it currently is not.

**Level 2: contents-driven.** Specify what goes in and let the model size
itself:

```scad
Contents = [
    ["brick", 70, 35, 30],
    ["cables", 6],
];
Content_Clearance = 5;
```

Compute a bounding volume with clearance and derive dimensions. More design
work, considerably more delightful, and genuinely differentiating. Almost
nothing in this category does it.

A middle path worth considering: a `Contents_Preset` enum populated from the
[E-07 (preset library)](E-07_preset-library.md) catalogue, so the user picks
"6-outlet surge strip" and gets dimensions, with everything still adjustable
afterward. That reuses catalogue work rather than duplicating it.

## Design notes

- **Report, do not just compute.** Whichever mode is active, `echo` the
  resulting dimensions in both systems: "Internal 90 x 65 x 45, outer
  93.7 x 68.7 x 46.85, usable interior after stabilizers 90 x 35 x 45". The
  usable-interior number is the one people actually need and cannot currently
  get at all.
- **Usable interior is not internal dimensions.** With
  `Stabilizers_Front_Back_Count = 3` and `Stabilizer_Depth = 15`, 30 mm of the
  depth is consumed by fins. The model should say so.
- **Cable volume is a heuristic, not a calculation.** A "6 cables" input should
  map to an empirical allowance, documented and tunable, not presented as
  precise.
- Keep `Outer` the default so existing presets and documentation stay valid.

## Interaction with other efforts

- **[E-08 (web customizer)](E-08_web-customizer.md)** is where this shines: live
  feedback as you type contents, showing the box resize.
- **[E-06 (thermal and vents)](E-06_thermal-and-vents.md)**: if contents are
  declared, the model knows a power brick is inside and can warn when
  ventilation is off.
- **[E-10 (versioning)](E-10_versioning.md)**: adding a mode toggle with an
  `Outer` default is additive, so minor.

## Acceptance criteria

- [ ] `Sizing_Mode` defaults to `Outer` with byte-identical geometry to today.
- [ ] `Internal` mode produces the requested internal dimensions within
      0.01 mm, verified by bounding-box assertion rather than by eye.
- [ ] Both modes echo internal, outer, and usable-interior dimensions.
- [ ] Usable interior correctly accounts for stabilizers and the post.
- [ ] Assertions catch internal dimensions that imply a degenerate outer box.
