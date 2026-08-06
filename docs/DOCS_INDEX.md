# Documentation Index

- `index.md`: Site landing page for local MkDocs/GitHub Pages builds.
- `OPTIONS_GUIDE.md`: Every parameter rendered from the model, with images.
- `options-guide.html`: The same guide as one self-contained file that works offline.
- `PARAMETER_REFERENCE.md`: Complete section-by-section and variable-by-variable parameter reference.
- `MODULE_REFERENCE.md`: Module-by-module geometry reference and render flow.
- `SCAD_ARCHITECTURE.md`: Core architecture, data flow, and coordinate-system details.
- `VALIDATION_RULES.md`: Assertion constraints, triggers, and resolution guidance.
- `PARAMETER_INTERACTIONS.md`: Cross-parameter behavior and tuning order.
- `WORKFLOWS.md`: Practical setup, calibration, slicing, and troubleshooting workflows.
- `PRINTING.md`: Printing-specific baseline settings and process guidance.
- `FAQ.md`: Common questions and issue resolution.
- `RELEASE.md`: Release checklist, from version bump through snapshot.
- `../library/README.md`: The nine presets, what each fits, and their sizes.
- `../cable-box-parametric.json`: All nine presets as one OpenSCAD parameter-set
  file, so the Customizer lists them when the model is opened. Generated.
- `../mkdocs.yml`: Docs site navigation/config.
- `.github/workflows/docs-pages.yml`: GitHub Pages publish workflow.
- `.github/workflows/scad-smoke.yml`: GitHub Actions OpenSCAD smoke workflow.
- `scripts/scad-smoke.ps1` / `scripts/scad-smoke.sh`: Local smoke render scripts.

## Local Docs Preview

```bash
pip install mkdocs mkdocs-material
mkdocs serve
```

Open `http://127.0.0.1:8000`.
