# Ultimate Cable Box Documentation

This site documents the **primary model**: `cable-box-parametric.scad`.

It is intended to be as implementation-close as possible, so parameter behavior matches what the SCAD actually generates.

## Start Here

- Parameter reference: `PARAMETER_REFERENCE.md`
- Practical setup and tuning: `WORKFLOWS.md`
- Print recommendations: `PRINTING.md`
- Common issues and fixes: `FAQ.md`

## Deep Technical Docs

- Geometry/module breakdown: `MODULE_REFERENCE.md`
- Data-flow and render architecture: `SCAD_ARCHITECTURE.md`
- Assertion constraints and why they exist: `VALIDATION_RULES.md`
- High-impact parameter interactions: `PARAMETER_INTERACTIONS.md`

## Scope Notes

- This docs set describes the primary model at repo root.
- Experimental variants (Gridfinity integration, a simplified companion model) are developed outside this repository and are intentionally not release-baseline behavior.

## Local Build

```bash
pip install mkdocs mkdocs-material
mkdocs serve
```

Then open `http://127.0.0.1:8000`.

