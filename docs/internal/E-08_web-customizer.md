# E-08: Web customizer

**Handle:** Web customizer. A browser-based parameter customizer served from
GitHub Pages, no backend.

**Effort:** M
**Depends on:** [E-02 (BOSL2 migration)](E-02_bosl2-migration.md) for library
availability. Benefits from [E-07 (preset library)](E-07_preset-library.md).

## Feasibility

Yes, and the tooling is mature. OpenSCAD has an official WebAssembly port, and
several projects wrap it in a browser UI with customizer support. Everything
runs client-side, so a static GitHub Pages deploy is sufficient and there is no
server, no login, and no running cost.

You already have Pages working and deploying from Actions, so the delivery
mechanism is in place.

## Options evaluated

| Option | What it is | Fit |
|---|---|---|
| **[openscad-playground](https://github.com/openscad/openscad-playground)** | Official OpenSCAD org. Headless OpenSCAD WASM plus a PrimeReact UI, Monaco editor, model-viewer. Defaults to the Manifold backend, so it is fast. Ships many standard SCAD libraries including BOSL2. Documents self-hosting: set `homepage` in `package.json`, copy the build to a Pages directory. | **Recommended.** Official, maintained, bundles BOSL2, proven static deploy. |
| [openscad-web](https://github.com/CameronBrooks11/openscad-web) | Browser environment with editor, customizer, viewer. Explicitly documents GitHub Pages self-hosting and publishing an OpenSCAD project into a static tree. | Strong alternative, purpose-built for exactly this. Worth a look before committing. |
| [Web_OpenSCAD_Customizer](https://github.com/vector76/Web_OpenSCAD_Customizer) | Derived from openscad-wasm, hosts a predefined model with parameters exposed rather than a full editor. Closest in spirit to what you want. GPL-2.0. | Author describes it as a proof of concept and their modifications as "surely clumsy". Good reference, risky as a dependency. |
| [openscad-wasm](https://github.com/openscad/openscad-wasm) | The raw WASM port. | Use if you want to build a bespoke UI. Most work, most control. |

**Recommendation:** start from `openscad-playground`, trimmed to hide the code
editor and show only the customizer panel and viewer. Evaluate `openscad-web`
first, since it may already be the trimmed thing you want.

## Why this matters more than it looks

The single hardest part of using a parametric box is knowing what numbers to
type. A web customizer with live preview turns that from a chore into an
exploration, and it removes the "install OpenSCAD first" barrier entirely. It
is the highest-leverage adoption work available, and it composes with
[E-05 (size by contents)](E-05_size-by-contents.md) and
[E-07 (preset library)](E-07_preset-library.md): start from a preset, tweak
live, export STL.

## Design

- Route at `/customizer/` under the existing Pages site so the docs and the tool
  share a domain.
- Preload `cable-box-parametric.scad` from the repo. Pin to a tag rather than
  `main` so the live tool is not tracking unreleased work; see
  [E-10 (versioning)](E-10_versioning.md).
- Serialise parameters into the URL fragment so a configuration is a shareable
  link. This is the feature that makes support tractable: a user reports a
  problem by sending the exact configuration.
- Preset dropdown fed from `library/*/config.json`.
- Export STL client-side.

## Constraints and risks

- **Render time.** The full model with Gridfinity and slicing is not trivial.
  Manifold backend helps a lot. Budget a preview-versus-render distinction and
  test on mobile.
- **Payload size.** OpenSCAD WASM plus bundled libraries is a large download.
  Lazy-load, and do not put it on the docs landing page.
- **Licensing.** OpenSCAD is GPL, so the WASM build and any derived UI carry
  GPL obligations. Your model content is `CC BY-NC-SA 4.0`. Hosting a GPL
  application that loads CC-licensed model files is mere aggregation and is
  fine, but keep the licenses clearly separated in the deploy and do not
  relicense either. Note this interacts with the open license question in
  [E-11 (distribution)](E-11_distribution.md).
- **Version drift.** WASM OpenSCAD may not match the desktop version's output
  exactly. Test the same parameter set both ways before advertising the tool as
  authoritative.
- **Maintenance.** This is a JS build pipeline in an otherwise dependency-free
  repo. Consider a separate repo in the org so the model repo stays clean, and
  publish both to the same Pages domain.

## Acceptance criteria

- [ ] Loads and renders the default model in under about 10 seconds cold.
- [ ] All Customizer parameter groups appear with correct widgets, including
      enum dropdowns.
- [ ] Exported STL is geometrically identical to a desktop OpenSCAD render of
      the same parameters, verified by the normalised comparison from
      [E-09 (testing automation)](E-09_testing-automation.md).
- [ ] Configuration round-trips through a shared URL.
- [ ] Presets load from `library/`.
- [ ] Works on a phone, even if editing is awkward.
- [ ] Licenses for OpenSCAD, BOSL2, and the model are all surfaced in the UI.

## Sources

- [openscad-playground](https://github.com/openscad/openscad-playground)
- [openscad-wasm](https://github.com/openscad/openscad-wasm)
- [openscad-web](https://github.com/CameronBrooks11/openscad-web)
- [Web_OpenSCAD_Customizer](https://github.com/vector76/Web_OpenSCAD_Customizer)
