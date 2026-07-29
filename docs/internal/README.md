# Internal Planning Docs

Scoping documents for work not yet committed to a release. These are excluded
from the published docs site via `exclude_docs: internal/` in `mkdocs.yml`, so
they live in the repo without appearing on the public site.

Each effort carries an ID and a handle. Always write both on first mention, in
commits, issues, and chat: "E-01 (Gridfinity promotion)", never a bare "E-01".

## Efforts

| ID | Handle | Scope | Effort | Depends on |
|---|---|---|---|---|
| [E-01](E-01_gridfinity-promotion.md) | **Gridfinity promotion** | Ship the prototyped box-underside and lid-topside Gridfinity interfaces | S | none |
| [E-02](E-02_bosl2-migration.md) | **BOSL2 migration** | Replace the embedded 2022 subset with a real BOSL2 dependency, adopt attachments | L | none |
| [E-03](E-03_openings-array.md) | **Openings array** | Replace 4 fixed per-wall openings with an array-driven spec | M | E-02 (easier after) |
| [E-04](E-04_quick-wins.md) | **Quick wins** | Edge treatment, lid removal relief, magnet retention | S | none |
| [E-05](E-05_size-by-contents.md) | **Size by contents** | Size the box from what goes in it, not from outer dimensions | M | none |
| [E-06](E-06_thermal-and-vents.md) | **Thermal and vents** | Ventilation generator plus material guidance for powered contents | M | E-03 (shares cut logic) |
| [E-07](E-07_preset-library.md) | **Preset library** | A real catalogue of common sizes and configurations | M | E-09 (needs artifact automation) |
| [E-08](E-08_web-customizer.md) | **Web customizer** | Browser-based customizer on GitHub Pages | M | E-02 (library availability) |
| [E-09](E-09_testing-automation.md) | **Testing automation** | Automated geometry regression testing beyond compile checks | M | none |
| [E-10](E-10_versioning.md) | **Versioning** | Version scheme, pre-release flow, traceability from STL to source | S | none |
| [E-11](E-11_distribution.md) | **Distribution** | MakerWorld, Printables, and the licensing question that gates them | S | E-02 (MakerWorld benefits) |

Effort key: S = under a day, M = a few days, L = a week or more.

## Suggested order

1. **E-09 (testing automation)** and **E-10 (versioning)** first. They are cheap,
   and every effort below is safer to land once geometry regressions are caught
   automatically and releases are traceable.
2. **E-01 (Gridfinity promotion)**. The work is largely done; this is promotion
   and documentation, not construction.
3. **E-02 (BOSL2 migration)**. Do it before the feature work, because E-03, E-04,
   and E-06 all get materially cheaper on the far side of it.
4. **E-04 (quick wins)** whenever. Independent of everything.
5. **E-03 (openings array)**, then **E-06 (thermal and vents)**, then
   **E-05 (size by contents)**.
6. **E-07 (preset library)** and **E-08 (web customizer)** last. Both are
   multipliers on a feature set, so they are worth more once the features exist.
7. **E-11 (distribution)** has one blocking decision (the NonCommercial license)
   that is worth resolving early even if publishing happens late.

## Cross-cutting decisions still open

- **License.** `CC BY-NC-SA 4.0` is NonCommercial. See
  [E-11 (distribution)](E-11_distribution.md) for how that interacts with
  MakerWorld's rewards programme and with people selling prints. This decision
  gates distribution and is hard to reverse once contributors have signed on to
  the current terms.
- **Single-file versus library dependency.** See
  [E-02 (BOSL2 migration)](E-02_bosl2-migration.md). Affects E-08 and E-11.
- **Whether `Model_Version` lives in the SCAD.** See
  [E-10 (versioning)](E-10_versioning.md).
