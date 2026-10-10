# E-03: Openings array

**Handle:** Openings array. Replace the four fixed per-wall openings with an
array-driven specification.

**Status:** Spec. Not started.

**Effort:** M
**Depends on:** much easier after
[E-02 (BOSL2 migration)](E-02_bosl2-migration.md). Best done together.

**Also carries a provenance decision (2026-10-02).** The model began as a
derivative of a 2022 Creative Commons Attribution design by Nick Talavera; see
the "Earlier Versions" note in `THIRD_PARTY_NOTICES.md`. The decision is to
make the model independent of it rather than to keep crediting it. The code
was rewritten for 2.0.0 with no geometry change, and the inherited preview
palette was replaced. What remains is the Customizer interface: 27 parameter lines (name and
default) and 9 section headers inherited from the original. 24 of the
original's 36 parameters are the per-wall opening block that this effort
replaces, so E-03 is where that break happens, as a major version. When it
lands:

- replace the remaining inherited names, defaults, and section headers too:
  `Box_*`, `Post_*`, `Lid_*`, `Part_To_Render` and its option strings;
- decide the product name: the README title, the `.scad` header, and the
  bundle header still say "Parametric Cable Management Box", which is the
  original's title ([backlog item 16 (product name)](BACKLOG.md));
- re-run the overlap check, whose acceptance bar is no shared parameter lines
  or section headers. It lives at `_local/audit/2026-10-02_scripts/overlap.py`
  on the maintainer's machine only, because it compares against the original
  file, which is deliberately not in the repository;
- update the "Earlier Versions" note so it no longer says the names and
  defaults follow the original;
- ship a migration table and a converter for saved `config.json` parameter
  sets, because every user's saved set breaks.

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

**Top style.** [E-14 (printability options)](E-14_printability-options.md)
added a global `All_Opening_Top_Style` in `v2.0.0-rc.6`, with `"Round"`
and `"Teardrop"`. The row needs a top-style slot that falls back to that global.
Because E-03 is a major release anyway, it is also where the default should
change to `"Teardrop"`.

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
