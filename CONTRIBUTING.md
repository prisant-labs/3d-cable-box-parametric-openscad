# Contributing

Thanks for contributing.

## Scope

This project contains OpenSCAD source and supporting docs for a parametric cable-management box.

## What you need installed

Editing the model needs only OpenSCAD (2021.01 or newer) and
[BOSL2](https://github.com/BelfrySCAD/BOSL2). `README.md` has the install line
for each platform. Everything below is optional and only matters if you touch
the thing it builds.

| Tool | Needed for | Without it |
|---|---|---|
| Python 3 | `tests/run_tests.py`, and every script in `scripts/` | You cannot run the regression suite locally, but CI will |
| `trimesh` (`pip install trimesh`) | GLB previews in `scripts/build_library.py` | The GLBs are skipped with a note; STLs, renders and indexes still build. `--no-glb` skips it explicitly |
| Node 22 | the docs site in `web/` | The published site still builds in CI; you just cannot preview locally |

There is no lockfile for the Python side on purpose: the scripts use the
standard library plus `trimesh` and nothing else.

## Workflow

1. Open an issue for significant changes.
2. Create a branch from `main`.
3. Keep PRs focused and include testing/print validation notes.
4. Update `README.md`, `docs/`, and `CHANGELOG.md` when behavior changes.

## Pull Request Checklist

- [ ] Geometry compiles in OpenSCAD.
- [ ] `python tests/run_tests.py` passes.
- [ ] New or changed parameters are documented in `docs/PARAMETER_REFERENCE.md`,
      and any new assertion in `docs/VALIDATION_RULES.md`.
- [ ] Any fit/tolerance changes are called out.
- [ ] Generated files under `library/` and `dist/` are regenerated rather than
      hand-edited. See `docs/WORKFLOWS.md`.
- [ ] Changelog updated.

A note on what the tests can and cannot tell you: the suite asserts exit codes,
solid counts, manifoldness, warning cleanliness and point probes, which catches
the class of defect where OpenSCAD returns 0 and produces geometry that cannot
be printed. It cannot tell you whether a clip is too tight to assemble or a
magnet holds. Those need a print, and PRs that change fit should say whether one
happened.

## Licensing of Contributions

By submitting a contribution, you agree your contribution is licensed under:

- `MIT` for this repository.

If you include third-party code/assets, include proper attribution and license notices in `THIRD_PARTY_NOTICES.md`.
