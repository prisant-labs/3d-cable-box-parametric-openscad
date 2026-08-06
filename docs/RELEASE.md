# Release Checklist

A version here promises something specific: the same parameters produce the same
geometry. See [E-10 (versioning)](internal/E-10_versioning.md) for what each
level of bump means. The steps below exist because a version that lies makes a
bug report untraceable.

## Before you start

Set `OPENSCADPATH` if this machine has more than one BOSL2 install, or OpenSCAD
may silently load a stale copy and the renders will not match CI:

```bash
export OPENSCADPATH="$HOME/Documents/OpenSCAD/libraries"
```

Confirm which one is being used before trusting any output.

## 1. Decide the level

- **Patch** - a fix that leaves geometry unchanged for every existing parameter
  set. Metadata, docs, and generated artifacts count here.
- **Minor** - new parameters or features whose defaults leave existing geometry
  untouched.
- **Major** - the same parameter set now renders differently. Changing a default
  is a major bump, even when the new default is better.

## 2. Bump the version

- [ ] `Model_Version` in `cable-box-parametric.scad`.
- [ ] Add the matching `## [x.y.z] - YYYY-MM-DD` section to `CHANGELOG.md`.
      `scripts/check-version.sh` reads the topmost released section, so put the
      new one at the top.

## 3. Regenerate everything that embeds the version

Three artifacts carry `Model_Version` and are generated, so they go stale
silently:

```bash
python scripts/regen_missing_bosl2_fixture.py    # tests/fixtures/missing_bosl2.scad
python scripts/build_bundle.py                   # dist/ standalone bundle + sidecar
python scripts/build_library.py                  # presets, renders, merged JSON
```

`build_library.py` is slow because it re-renders STLs. Use `--no-stl` when only
metadata or renders changed. It reports how many renders it wrote versus left
alone; unchanged renders are deliberately not rewritten, because OpenSCAD's
rasteriser is not byte-deterministic and would otherwise dirty every image.

- [ ] Regenerate whichever apply, and check `git status` matches expectations.
- [ ] If a preset's parameters changed, rebuild without `--no-stl`.

## 4. Verify

```bash
bash scripts/check-version.sh      # scad, changelog and tag must agree
python tests/run_tests.py          # full geometry suite
```

- [ ] Version consistency check passes.
- [ ] Test suite passes.
- [ ] Docs reflect any parameter or behaviour change
      (`PARAMETER_REFERENCE.md`, `FAQ.md`, `README.md`).
- [ ] Licence and third-party notices current (`THIRD_PARTY_NOTICES.md`).
- [ ] For a major or minor bump, validate one physical print for fit and wall
      integrity. Clip geometry in particular cannot be validated by rendering:
      manifoldness and solid counts pass for a joint far too tight to assemble.

## 5. Tag and publish

- [ ] Commit, then annotated tag: `git tag -a vX.Y.Z -m "..."`.
- [ ] Push both: `git push origin main && git push origin vX.Y.Z`.
- [ ] Confirm CI is green, including `docs-pages`.
- [ ] Create the GitHub release with the standard four assets:
      - `cable-box-parametric.scad` (requires BOSL2)
      - `cable-box-standalone-bundle.zip` (bundle plus its `builtins.scad`
        sidecar, which must stay in the same folder)
      - two sample STLs from `library/`

## 6. Snapshot

```bash
bash scripts/backup-release.sh vX.Y.Z
```

- [ ] Writes `_local/backup/vX.Y.Z/` and refreshes the mirror. Local only, never
      committed. Git and the Releases page are the authoritative archive; this
      covers losing access to GitHub itself.
