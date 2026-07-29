# E-07: Preset library

**Handle:** Preset library. A real catalogue of common sizes and configurations
rather than one default.

**Effort:** M
**Depends on:** [E-09 (testing automation)](E-09_testing-automation.md) for
artifact automation. Pairs with [E-08 (web customizer)](E-08_web-customizer.md).

## Why a catalogue beats a parameter list

The model has 71 parameters. That is its strength and its adoption problem: most
people do not want to design a box, they want *a box that fits the thing they
own*. A catalogue converts a design tool into a product with a
"just print this one" path, while keeping the tool underneath for people who
want it.

Presets are also the honest way to document the model. A preset is an executable
claim that a configuration works, and with automation it is re-verified on every
release rather than rotting.

## The real work is automation, not curation

Today `library/v1-default/` is hand-generated. That worked for one preset. At
fifteen it is unmaintainable, and stale artifacts are worse than none: the v1.0.0
library STLs silently showed openings at half their requested height for months.

**Build the pipeline first, then add presets.** A workflow that, for every
`library/*/config.json`:

1. renders `box-only`, `lid-only`, `box-and-lid` STLs
2. renders matching PNG previews at a consistent camera and colour scheme
3. runs the [E-09](E-09_testing-automation.md) assertions against each
4. writes dimensions, estimated print time, and filament volume into the notes
5. fails the build if any preset no longer renders

Once that exists, adding a preset is a `config.json` plus a description, and
every preset is guaranteed to match the current model.

## Proposed catalogue

Organised by what the user *has*, not by dimensions, because nobody knows they
need 240 x 100 x 65.

**Power and charging**
- Surge protector strip, 6-outlet, standard
- Surge protector strip, 8-outlet, long
- Laptop brick plus 3 cables
- Multi-port USB-C charger plus cables
- Wall-wart cluster, tall clearance

**Desk**
- Compact desk tidy, minimal footprint
- Under-monitor cable pass-through
- Dual-monitor cable junction

**Network and AV**
- Router plus modem, vented, see [E-06 (thermal and vents)](E-06_thermal-and-vents.md)
- Network switch, 5-port and 8-port
- AV rack shelf tidy

**Ecosystem**
- Gridfinity desk module, see [E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md)
- Gridfinity stackable lid variant

**Printer-constrained**
- Bed-limited 180 mm, sliced into 2
- Bed-limited 220 mm, sliced into 2

Each preset needs: the use case in a sentence, what physically fits, outer
dimensions, print time and filament estimate, whether it needs supports, a
photo or render, and any tolerance notes.

## Structure

```
library/
  README.md                    # index table: name, use case, dimensions, sliced?
  <preset-name>/
    config.json                # Customizer parameter set, complete
    notes.md                   # use case, fits, print notes, provenance
    images/*.png               # generated
    stl/*.stl                  # generated
```

Keep `config.json` complete rather than a diff from defaults. It is larger but
it is unambiguous, survives default changes, and doubles as a record of what the
defaults were at that version.

## Interaction with other efforts

- **[E-05 (size by contents)](E-05_size-by-contents.md)** is the generative
  version of this. A catalogue answers "what fits a 6-outlet strip"; size-by-
  contents answers it for anything. Build the catalogue first, because it tells
  you which content classes actually matter.
- **[E-08 (web customizer)](E-08_web-customizer.md)** consumes presets as
  starting points. "Load preset, tweak, export" is the ideal flow.
- **[E-11 (distribution)](E-11_distribution.md)**: each preset is a plausible
  standalone MakerWorld or Printables listing, which multiplies reach far more
  than one listing for a parametric tool.

## Community presets

`community/` already has a documented layout and no contributions. Presets are
the natural contribution type: low effort, high value, easy to validate. Once
the pipeline exists, a contributed preset can be CI-validated automatically,
which makes accepting them cheap. Consider an issue template that collects the
parameter set and a photo.

## Acceptance criteria

- [ ] Artifact pipeline runs in CI and regenerates every preset on tag.
- [ ] Stale-preset detection: build fails if committed artifacts disagree with a
      fresh render.
- [ ] At least 8 presets covering the categories above.
- [ ] `library/README.md` carries a generated index table.
- [ ] Every preset states what physically fits inside it.
- [ ] Print time and filament estimates present, generated not guessed.
- [ ] At least 2 presets validated by an actual print.
