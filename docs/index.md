# Ultimate Cable Box Documentation

This site documents the **primary model**: `cable-box-parametric.scad`.

It is intended to be as implementation-close as possible, so parameter behavior matches what the SCAD actually generates.

## Start Here

- [Parameter reference](PARAMETER_REFERENCE.md): every parameter, section by section
- [Options guide](OPTIONS_GUIDE.md): every option rendered, with images
- [Workflows](WORKFLOWS.md): practical setup and tuning
- [Printing](PRINTING.md): print recommendations
- [FAQ](FAQ.md): common issues and fixes

## Deep Technical Docs

- [Module reference](MODULE_REFERENCE.md): geometry and module breakdown
- [SCAD architecture](SCAD_ARCHITECTURE.md): data flow and render architecture
- [Validation rules](VALIDATION_RULES.md): assertion constraints and why they exist
- [Parameter interactions](PARAMETER_INTERACTIONS.md): high-impact parameter interactions

## Scope Notes

- This docs set describes the primary model at the repo root.
- Gridfinity (base and lid interfaces), snap-fit seam clips, and the preset
  library are part of the model and documented here. Features still awaiting
  physical print validation are marked as such where they appear.

## Local Build

The site is built with [Astro Starlight](https://starlight.astro.build/) from `web/`, which syncs its content from this directory at build time:

```bash
cd web
npm ci
npm run dev
```

Then open `http://localhost:4321`.
