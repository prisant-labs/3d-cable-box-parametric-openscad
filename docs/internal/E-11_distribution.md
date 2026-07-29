# E-11: Distribution

**Handle:** Distribution. Publishing to MakerWorld and Printables, and the
licensing decision that gates it.

**Effort:** S once the license question is settled
**Depends on:** benefits from [E-02 (BOSL2 migration)](E-02_bosl2-migration.md)
and [E-07 (preset library)](E-07_preset-library.md).

## The blocking question: NonCommercial

The repo is `CC BY-NC-SA 4.0`. The **NC** clause is worth a deliberate decision
before publishing anywhere, because it is effectively irreversible once
contributors have submitted work under it.

What NC does in practice for a 3D model:

- A person who prints your box and sells it at a market is in breach.
- A print-on-demand service cannot offer it.
- **MakerWorld runs a rewards and points programme.** Uploading NC-licensed work
  to a platform that pays creators is at minimum ambiguous and worth checking
  against their current terms before relying on it.
- NC is generally discouraged in the 3D printing community and reduces remixing,
  which is the main way a model spreads.

What NC does not do: it does not prevent anyone from using the model, modifying
it, or printing it for themselves. The ShareAlike clause already forces
derivatives to stay open.

**Options**

| License | Effect |
|---|---|
| Keep `CC BY-NC-SA 4.0` | Maximum control, minimum reach. Blocks commercial printing and complicates reward platforms. |
| `CC BY-SA 4.0` | Drops NC. Derivatives stay open, commercial use allowed. The usual choice for models intended to spread. |
| `GPL-3.0` | Common for OpenSCAD source specifically, since the model is code. Strong copyleft on derivatives. |
| Dual: code GPL, artifacts CC BY-SA | Precise but more explanation than most people will read. |

**Recommendation:** decide explicitly, and if reach matters at all, drop the NC.
Note that BOSL2 is BSD-2-Clause and imposes nothing either way, so this is
purely your call. Also note that
[E-08 (web customizer)](E-08_web-customizer.md) introduces GPL components,
making a coherent license story more valuable.

Whatever you choose, record the reasoning in an ADR so it does not get quietly
relitigated.

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

- [ ] License decision made and recorded as an ADR.
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
