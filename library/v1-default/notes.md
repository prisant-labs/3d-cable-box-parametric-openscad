# v1 Default Preset

Baseline release artifacts generated from the model defaults.

- Source: `cable-box-parametric.scad`
- Generated: `2026-07-28`
- Model version: `1.1.0`
- Tool: OpenSCAD 2021.01 CLI

## Included artifacts

- `stl/cable-box-v1_box-only.stl`
- `stl/cable-box-v1_lid-only.stl`
- `stl/cable-box-v1_box-and-lid.stl`
- `images/cable-box-v1_box-only.png`
- `images/cable-box-v1_lid-only.png`
- `images/cable-box-v1_box-and-lid.png`
- `config.json`

## Reproducing these files

```bash
openscad -o stl/cable-box-v1_box-only.stl ../../cable-box-parametric.scad \
  -D 'Part_To_Render="Box Only"'
```

Or load `config.json` as a Customizer parameter set:

```bash
openscad -o out.stl ../../cable-box-parametric.scad -p config.json -P v1-default
```

## Notes

- Generated with model defaults except for `Part_To_Render` per artifact.
- `config.json` carries every Customizer parameter at its shipped default, so it
  doubles as a reference for what the defaults actually are.
- Regenerated for `1.1.0`. The `1.0.0` artifacts predated the side-opening height
  fix and showed openings at half their requested height.
