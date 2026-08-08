# Internal Planning Docs

Scoping documents for the work behind each release. They live in the repo
without appearing on the public site: `web/sync-docs.mjs` copies a named list of
pages into the site's content directory, and this directory is not on it, so
nothing here is published unless someone adds it deliberately. (The old
mechanism was `exclude_docs: internal/` in `mkdocs.yml`, which no longer exists.)

Each effort carries an ID and a handle. Always write both on first mention, in
commits, issues, and chat: "E-01 (Gridfinity promotion)", never a bare "E-01".

Status values: **Shipped** in the named release, **Open** for started but
incomplete, **Spec** for written but not begun.

## Efforts

| ID | Handle | Scope | Status | Effort | Depends on |
|---|---|---|---|---|---|
| [E-01](E-01_gridfinity-promotion.md) | **Gridfinity promotion** | Box-underside and lid-topside Gridfinity interfaces | Shipped v1.2.0; lid reworked to a socket in 2.0.0. Unprinted | S | none |
| [E-02](E-02_bosl2-migration.md) | **BOSL2 migration** | Build on BOSL2 rather than hand-rolled primitives | Shipped: phase 1 v1.3.0, phases 2-3 v1.4.0 | L | none |
| [E-03](E-03_openings-array.md) | **Openings array** | Replace 4 fixed per-wall openings with an array-driven spec | Spec | M | E-02 (easier after) |
| [E-04](E-04_quick-wins.md) | **Quick wins** | Edge treatment, lid removal relief, magnet retention | Implemented, unreleased. Opt-in defaults, unprinted | S | none |
| [E-05](E-05_size-by-contents.md) | **Size by contents** | Size the box from what goes in it, not from outer dimensions | Spec | M | none |
| [E-06](E-06_thermal-and-vents.md) | **Thermal and vents** | Ventilation generator plus material guidance for powered contents | Spec | M | E-03 (shares cut logic) |
| [E-07](E-07_preset-library.md) | **Preset library** | A real catalogue of common sizes and configurations | Shipped: catalogue v1.2.0, browser 2.0.0 | M | E-09 (needs artifact automation) |
| [E-08](E-08_web-customizer.md) | **Web customizer** | Browser-based customizer on GitHub Pages | Open. Site shell and preset browser shipped; the WASM playground is not built | M | E-02 (library availability) |
| [E-09](E-09_testing-automation.md) | **Testing automation** | Automated geometry regression testing beyond compile checks | Shipped v1.1.1; 66 scenarios today | M | none |
| [E-10](E-10_versioning.md) | **Versioning** | Version scheme, pre-release flow, traceability from STL to source | Shipped v1.1.1; rc flow used for v1.2.0-rc.1 and v2.0.0-rc.1/rc.2 | S | none |
| [E-11](E-11_distribution.md) | **Distribution** | MakerWorld, Printables, and the licensing question that gates them | Open. Licence settled (MIT); listing drafted, nothing published | S | E-02 (MakerWorld benefits) |

Effort key: S = under a day, M = a few days, L = a week or more.

## What is left

The infrastructure efforts are done: testing (E-09), versioning (E-10), the
BOSL2 migration (E-02), the preset library (E-07), and the Gridfinity interfaces
(E-01) have all shipped. What remains splits three ways.

**Gated on a physical print, not on work.** E-01 (Gridfinity promotion) and the
snap-clip default in [E-02-P2 (snap clips)](E-02-P2_snap-clips.md) are both
built and both waiting on hardware. `v2.0.0-rc.2` exists so that print has a
citable artifact. Nothing else should be sequenced behind them.

**Feature work, in rough order of value per unit of effort.**

1. **E-04 (quick wins)**, independent of everything and the largest visible
   difference for the smallest change.
2. **E-03 (openings array)**, which E-06 then builds on.
3. **E-06 (thermal and vents)**, sharing E-03's cut-placement logic.
4. **E-05 (size by contents)**, now better informed by the nine presets in
   E-07 than it would have been before them.

**Delivery.** E-11 (distribution) is ready whenever the print clears the claims
in the listing copy. E-08 (web customizer) is the largest single remaining
piece and the only unbuilt part of the site; `library/index.json` was shaped
for it, so its "load a preset" path is already fed.

## Cross-cutting decisions still open

- ~~**License.**~~ **Resolved 2026-07-29: MIT.** Reasoning recorded in
  [E-11 (distribution)](E-11_distribution.md). Matches Gridfinity's own licence,
  suits a model that is really source code, and is GPL-compatible for
  [E-08 (web customizer)](E-08_web-customizer.md).
- ~~**Single-file versus library dependency.**~~ **Resolved 2026-07-31:** real
  BOSL2 dependency, with a two-file bundle attached to releases. See
  [E-02 (BOSL2 migration)](E-02_bosl2-migration.md).
- ~~**Whether `Model_Version` lives in the SCAD.**~~ **Resolved:** yes, added in
  v1.1.1 with a CI consistency gate. See [E-10 (versioning)](E-10_versioning.md).
