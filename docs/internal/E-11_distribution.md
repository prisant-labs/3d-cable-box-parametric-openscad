# E-11: Distribution

**Handle:** Distribution. Publishing to MakerWorld and Printables.

**Status:** Open. The licence question that gated it is resolved (MIT,
2026-07-29) and the MakerWorld listing is drafted, but nothing is published.
Publishing waits on the print test, because the listing must not claim snap
clips or the Gridfinity lid before either has been printed.

**Effort:** S
**Depends on:** benefits from [E-02 (BOSL2 migration)](E-02_bosl2-migration.md)
and [E-07 (preset library)](E-07_preset-library.md).

## Licence: RESOLVED, MIT (2026-07-29)

**Decision: the project is MIT.** This unblocks everything below. The reasoning
is kept here because it is the kind of decision that gets relitigated.

MIT is the right fit for three reasons:

1. **It is what this ecosystem uses.** Gridfinity itself, which this project
   aims to interoperate with, was released by Zack Freedman under MIT
   specifically as a framework for the community to extend. Matching the
   ecosystem's licence removes friction from exactly the integration
   [E-01 (Gridfinity promotion)](E-01_gridfinity-promotion.md) is building.
2. **The model is code.** A `.scad` file is a program. MIT is the default for
   permissive source, and it is unambiguous about derivative works in a way
   Creative Commons licences are not when applied to software.
3. **It is GPL-compatible**, which matters for
   [E-08 (web customizer)](E-08_web-customizer.md), where OpenSCAD's GPL WASM
   build sits alongside the model.

What this replaced, and why the old licence was a problem:

- `CC BY-NC-SA 4.0` was **NonCommercial**. Anyone printing the box and selling
  it at a market was in breach, print-on-demand services could not offer it, and
  uploading to a platform with a creator rewards programme was at best
  ambiguous.
- Creative Commons themselves recommend against using CC licences for software.
- NC is broadly discouraged for 3D models and suppresses remixing, which is the
  main way a model spreads.

BOSL2 is BSD-2-Clause and imposes nothing either way, so this was purely an
owner's choice.

## MakerWorld

Researched specifics:

- MakerWorld's **Parametric Model Maker** runs your OpenSCAD script server-side
  and renders parameters as a live web customizer with a "Customize" button on
  the listing.
- It **bundles BOSL2**; reference it as `include <BOSL2/std.scad>`.
- It **does not accept custom local library files** alongside your project, so
  either a single self-contained file or BOSL2-only includes will work. A local
  `lib/` split will not.
- Target the **OpenSCAD 2021 stable release** for compatibility.

This is the highest-reach channel available and it needs no model work beyond
what [E-02 (BOSL2 migration)](E-02_bosl2-migration.md) already implies. A
parametric listing there reaches people who will never install OpenSCAD.

## Printables and Thingiverse

- **Printables**: large audience, good for STL collections. Each
  [E-07 (preset library)](E-07_preset-library.md) preset is a plausible listing;
  a "collection" of sizes performs better than one parametric listing.
- **Thingiverse**: its Customizer targets a very old OpenSCAD and will almost
  certainly fail on this model. Publish STLs there if at all, not the source,
  and do not spend effort on Customizer compatibility.

## Assets each listing needs

The repo currently has none of these at publication quality:

- Photographs of the **printed** object. You have two under
  `_local/_NOTES/images/3d-print-photos/` that are gitignored and therefore
  invisible. These are the single most persuasive asset available and they are
  currently hidden.
- A short GIF or clip of the customizer changing a parameter.
- A clear hero render. The current README leads with a Customizer screenshot,
  which shows the tool rather than the product.

## Repo-side work

- Surface the print photos into `docs/images/` and lead the README with one.
- Fill in the GitHub repo social preview image.
- Add a short "Get a printable file without installing anything" section linking
  to Releases, MakerWorld, and eventually
  [E-08 (web customizer)](E-08_web-customizer.md).
- Consider archiving `jprisant/cable-box-parametric-openscad` with a pointer to
  the org repo, so search traffic lands in one place.

## Acceptance criteria

- [x] Licence decision made and recorded (MIT, 2026-07-29).
- [ ] README leads with a photo of a printed box.
- [ ] Repo social preview set.
- [ ] MakerWorld parametric listing live and rendering correctly in their
      customizer.
- [ ] At least 3 presets published to Printables as a collection.
- [ ] Old personal repo archived and pointing at the new one.

## Sources

- [Unofficial MakerWorld PMM OpenSCAD Reference](https://mindflakes.com/posts/2026/05/04/makerworld-pmm-openscad-reference/)
- [MakerWorld Parametric Models with OpenSCAD](https://lizard-spock.co.uk/makerworld-parametric-models-openscad.html)
- [Bambu Lab forum: referencing BOSL in the Maker Lab Customizer](https://forum.bambulab.com/t/makerworld-openscad-wiki/79269)
- [Bambu Lab forum: Parametric Model Maker support for includes](https://forum.bambulab.com/t/parametric-model-maker-support-for-includes/150680)
