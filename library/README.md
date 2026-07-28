# Library

Curated preset builds live here.

## Goal

Provide ready-to-print, reusable presets with matching visual references.

## Recommended structure

- `library/<preset-name>/config.json` or `config.md`
- `library/<preset-name>/images/<preview>.png`
- `library/<preset-name>/stl/<part>.stl`
- `library/<preset-name>/notes.md`

## Preset metadata checklist

- Intended use case (desk, AV rack, router shelf, etc.)
- Core dimensions (`Box_Width`, `Box_Depth`, `Box_Height`)
- Fit settings (`Lid_Lip_Gap`, printer/material context)
- Opening strategy (global + overrides)
- Slicing settings (if used)

## Contribution expectations

- Include at least one image and one printable STL.
- Include parameter values used to generate the STL.
- Keep file and folder names ASCII and descriptive.

## Current presets

- `library/v1-default/`
  - Baseline v1 artifact set generated from the core SCAD defaults.
  - Includes `stl/`, `images/`, `config.json`, and `notes.md`.
