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
python scripts/build_library.py                  # presets, renders, GLBs, indexes
```

`build_library.py` is slow because it re-renders STLs. Use `--no-stl` when only
metadata or renders changed. It reports how many renders it wrote versus left
alone; unchanged renders are deliberately not rewritten, because OpenSCAD's
rasteriser is not byte-deterministic and would otherwise dirty every image.

Two more generators do not embed the version, but they go stale the same way.
Rerun them when default geometry or the preview palette changes:

```bash
python scripts/build_options_guide.py            # docs/images/options/ + options-guide.html
python scripts/build_readme_images.py            # README hero and feature images
```

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

A workflow does this now, not a person with a zip tool. Human judgement stays
in two places: deciding the tag, and reading the drafted notes before anyone
else can.

- [ ] Merge the release pull request, so `main` carries everything being
      released and has passed CI.
- [ ] Tag `main` with an annotated tag: `git tag -a vX.Y.Z -m "..."` (or
      `vX.Y.Z-rc.N` for a release candidate).
- [ ] Push the tag: `git push origin vX.Y.Z`.
- [ ] Watch the `release` workflow run. It repeats the version check, the
      geometry suite, and the standalone-bundle render, then packages the
      assets below and opens a **draft** release with generated notes
      attached. Nothing is public at this point.
- [ ] Open the draft and read the notes. `scripts/release_notes.py` writes
      them from `CHANGELOG.md`; see "Promoting a release candidate to final"
      below for what it does differently on a candidate versus a final tag.
      Edit the notes if a reader who was not in the room needs more context
      than the changelog prose gives.
- [ ] Confirm the attached assets match the list below, then publish.

You can dry-run the workflow without tagging anything, from the Actions tab:
`workflow_dispatch` takes a `tag` input and runs every step except creating
the release itself.

### Release assets

`scripts/package_release.py` builds these and the workflow attaches them to
the draft:

- `cable-box-parametric.scad` - requires BOSL2.
- `cable-box-parametric.json` - all nine presets' parameter sets, for the
  Customizer.
- `cable-box-standalone-bundle.zip` - the bundle plus its `builtins.scad`
  sidecar, which must stay in the same folder, plus a short `README.txt`
  saying so.
- `cable-box-presets.zip` - every preset's `config.json`, `notes.md`, and its
  three STLs (box, lid, box-and-lid). Earlier releases attached two sample
  STLs by hand and the other seven presets had none; this replaces that with
  all nine, every time.

### Promoting a release candidate to final

A candidate tag (`vX.Y.Z-rc.N`) and the final tag (`vX.Y.Z`) read
`CHANGELOG.md` differently, because a candidate ships before anyone has
folded its changes into a dated section.

- **Candidate notes** are stitched together: a header naming it a release
  candidate for `X.Y.Z` and saying further print validation would be helpful
  before the final release; then
  whatever is still in `[Unreleased]`, under "New in this candidate"; then
  the `[X.Y.Z]` section if one exists, both under one heading, "Full X.Y.Z
  changelog so far". `[Unreleased]` can span several candidates, so the
  script cannot know what is new since the previous one.
- **Before publishing a candidate**, add a short "What's new since rc.N"
  summary at the top of the draft, by hand. Readers of a candidate mostly
  want that, and only a person can judge it.
- **Final notes** are just the `[X.Y.Z]` section, verbatim.
  `scripts/release_notes.py` refuses to write them while `[Unreleased]` still
  has entries, because a final release that leaves work behind in
  `[Unreleased]` is a release whose own notes lost part of it.

Before tagging a final release:

- [ ] Move every entry out of `[Unreleased]` and into the `[X.Y.Z]` section,
      merging with whatever earlier candidates already put there.
- [ ] Set that section's date to the real release date, replacing the
      placeholder.
- [ ] Confirm `Model_Version` in `cable-box-parametric.scad` still reads
      `X.Y.Z`. Promotion changes the changelog, not the version.
- [ ] Tag `vX.Y.Z`. Both `scripts/check-version.sh` and
      `scripts/release_notes.py` now read a changelog with nothing left in
      `[Unreleased]`.

## 6. Snapshot

```bash
bash scripts/backup-release.sh vX.Y.Z
```

- [ ] Writes `_local/backup/vX.Y.Z/` and refreshes the mirror. Local only, never
      committed. Git and the Releases page are the authoritative archive; this
      covers losing access to GitHub itself.
