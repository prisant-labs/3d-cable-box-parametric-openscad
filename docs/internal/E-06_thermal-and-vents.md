# E-06: Thermal and vents

**Handle:** Thermal and vents. A ventilation pattern generator, plus material
guidance for boxes holding powered equipment.

**Status:** Spec. Not started.

**Effort:** M
**Depends on:** shares cut-placement logic with
[E-03 (openings array)](E-03_openings-array.md); do that first if both are
planned.

## Why this ranks higher than "nice pattern generator"

This product category holds power bricks, surge protectors, routers, and
switches. Those dissipate heat continuously in an enclosed plastic box.

PLA's glass transition begins around 55 to 60 degrees C. A sealed box around a
laptop charger under sustained load is a plausible route to a softened,
deformed enclosure. That makes ventilation closer to a safety feature than a
cosmetic one, and it makes the current `PRINTING.md` guidance incomplete:

> Material: PLA or PETG recommended for first-fit calibration

That is fine for fit calibration and inadequate as material guidance for a box
containing a power supply. Backlog item 4 has ventilation listed as a normal
feature; this doc argues for promoting it and pairing it with documentation.

The documentation half costs almost nothing and should not wait for the
geometry half.

## Scope

**Ventilation generator**

- Per-face toggles: front, back, left, right, lid, floor.
- Patterns: `Honeycomb`, `Slots`, `Grid`, `Circles`. Honeycomb is the usual
  choice because it maximises open area per unit of lost strength and prints
  well without support.
- Controls: cell size, ligament width (the material between cells), margin from
  edges, and open-area target.
- **Minimum ligament check.** Assert that the ligament is at least roughly two
  extrusion widths, otherwise the slicer produces disconnected thin walls that
  print as stringy garbage. This is the assertion that makes the feature usable
  by people who do not already know this.
- Must respect existing openings, stabilizer footprints, and the post.

**Documentation**

- A thermal section in `PRINTING.md`: material selection by contents, why PLA is
  a poor choice around sustained heat, PETG and ABS or ASA as alternatives, and
  a plain recommendation to ventilate when enclosing anything powered.
- An FAQ entry: "Can I put a power brick or surge protector in this?"

**Out of scope**

- Active cooling, fan mounts. Different feature, different audience.
- Thermal simulation. Not credible to attempt and not needed to give sound
  advice.

## Design notes

- **Vent cuts are the same operation as openings**: a 2D pattern extruded
  through a wall. Whatever spec format [E-03](E-03_openings-array.md) settles on
  should generalise to cover vents, otherwise there will be two placement
  systems doing one job.
- **Floor vents interact** with bottom openings and with the
  [E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md) base. Likely
  mutually exclusive with the Gridfinity underside; assert rather than allow a
  nonsense combination.
- **Convection wants both low and high vents.** Vents only in the lid do much
  less than a low intake plus a high exhaust. Worth encoding as a preset or at
  least stating in the docs.
- **Strength.** Large open area on a wall carrying stabilizer fins undermines
  their purpose. Consider warning when vents and fins overlap heavily.
- **Print time.** Honeycomb across several faces adds a lot of perimeter and
  therefore time. Mention it.

## Interaction

- **[E-05 (size by contents)](E-05_size-by-contents.md)**: if contents declare a
  power supply, warn when ventilation is disabled. That is the payoff of having
  contents as structured data.
- **[E-07 (preset library)](E-07_preset-library.md)**: the router and switch
  presets should ship vented by default.

## Acceptance criteria

- [ ] Per-face vent toggles, defaulting to off, geometry unchanged when off.
- [ ] At least `Honeycomb` and `Slots` implemented.
- [ ] Ligament width assertion with an actionable message.
- [ ] Vents never intersect side openings, the post, or stabilizer roots.
- [ ] Vented faces still render a single solid body, verified per
      [E-09 (testing automation)](E-09_testing-automation.md).
- [ ] `PRINTING.md` thermal section and FAQ entry landed, independently of the
      geometry work.
- [ ] Slicing mode handles a vent pattern crossing a seam.

## Human smoke test

- [ ] Print a vented panel and confirm the ligaments are solid, not stringy.
- [ ] Confirm honeycomb prints without support in the intended orientation.
