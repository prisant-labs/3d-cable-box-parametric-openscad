# E-03: Openings array

**Handle:** Openings array. Replace the four fixed per-wall openings with an
array-driven specification.

**Status:** Spec. Not started.

**Effort:** M
**Depends on:** much easier after
[E-02 (BOSL2 migration)](E-02_bosl2-migration.md). Best done together.

## The limitation

The model supports **exactly one opening per wall, four maximum**. Real cable
routing frequently wants two or three on the back wall: one for the power feed,
one for a monitor bundle, one for ethernet. Today that is impossible at any
parameter setting.

The cost is also visible in the source. Four near-identical Customizer sections
(`Left`, `Right`, `Back`, `Front` overrides) times five parameters each is 20
parameters expressing one idea, plus `get_effective_opening_width()`,
`get_effective_opening_corner_radius()`, and `get_opening_center_offset()`, each
a four-branch conditional keyed on a side string. Adding a per-side property
today means touching four parameters, three functions, and four call sites.

## Proposed model

A list of opening specs, each naming its wall:

```scad
// [wall, offset_along_wall, up, width, height, corner_radius]
Openings = [
    ["Back",  -30, 0, 20, 25, -1],
    ["Back",   30, 0, 12, 40, -1],
    ["Front",   0, 0, 10, 30, -1],
];
```

Retain the current global defaults so simple use stays simple, and let `undef`
in a slot mean "use the global".

## The Customizer problem, and why it is the crux

OpenSCAD's Customizer does not edit lists of tuples usefully. It handles
numbers, booleans, strings, and enums. A raw vector-of-vectors parameter shows
up as a text field, which is a bad experience and a regression for anyone using
the GUI, which is most people.

Options:

1. **Hybrid.** Keep the existing four simple per-wall openings as the Customizer
   path, and add an `Extra_Openings` list for power users editing the file.
   Lowest risk, keeps the GUI intact, but retains the existing duplication.
2. **Fixed slot count.** Expose N slots (say 8) as flat parameters
   (`Opening_1_Wall`, `Opening_1_Up`, ...) with a count parameter. Customizer
   handles it, and unused slots are skipped. Verbose in the panel but honest,
   and it is what most parametric models with repeated features do.
3. **Full array, GUI via [E-08 (web customizer)](E-08_web-customizer.md).**
   Cleanest model, defers the GUI problem to a custom interface that can render
   a proper repeater widget.

**Recommendation:** option 1 now, option 3 later. Option 2 trades one kind of
duplication for another and inflates the parameter panel, which is already at 71.

This decision should be made deliberately rather than discovered halfway
through, because it determines whether this is a refactor or a rewrite.

## Related cleanup

- Consolidate the three side-keyed lookup functions into one that returns a
  resolved spec struct per opening.
- Directional conventions are currently wall-relative and inconsistent by
  design: `Move_Opening_Back_to_Right` is positive toward `-X` while
  `Move_Opening_Front_to_Right` is positive toward `+X`. Documented, but a
  frequent confusion. An array spec is the opportunity to switch to a single
  unambiguous convention, at the cost of a breaking change; see
  [E-10 (versioning)](E-10_versioning.md).
- Stabilizer opening-avoidance currently queries one opening per wall. It will
  need to consider all openings on a wall.

## Acceptance criteria

- [ ] Two or more openings on a single wall render correctly.
- [ ] Existing per-wall parameters continue to work unchanged, or the break is
      versioned as major and documented.
- [ ] Stabilizer avoidance accounts for every opening on a wall.
- [ ] Openings that overlap each other merge cleanly rather than producing
      artifacts.
- [ ] An opening whose bounds fall outside its wall produces a warning.
- [ ] Slicing mode handles openings that straddle a seam.
