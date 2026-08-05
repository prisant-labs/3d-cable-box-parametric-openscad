# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.1] - 2026-08-04

Bugfix release. The model itself is untouched, so geometry is unchanged and the
STLs in `library/` are byte-identical to 1.4.0. What changed is the preset
metadata and the preview renders around it.

### Fixed
- **Preset `config.json` files were rejected by OpenSCAD outright.** Booleans
  were written capitalised (`"True"`), where the Customizer parameter-set format
  requires `"true"`. Loading such a set fails with
  `Cannot apply Parameter Set 'conversion of data to type "b" failed'`, and
  OpenSCAD then discards the *entire* set rather than skipping the offending
  key. That made `gridfinity-module`, `surge-strip-6-sliced` and
  `under-desk-passthrough` unusable through the `-p` / `-P` invocation that
  `library/README.md` documents. The STLs were never affected, because the
  render path lowercased booleans correctly; only the JSON path was wrong, and
  nothing exercised it.
- **Preview renders hid the difference between presets.** Images were rendered
  with `--viewall`, which zooms each model to fill the frame and therefore
  discards scale. Five of the nine presets differ only in dimensions, so a
  265 mm surge strip and a 120 mm charger were drawn the same size. The
  `box-and-lid` view now renders every preset at one fixed camera distance, so
  the library reads as a size comparison. Detail views keep fit-to-frame, where
  only shape matters.
- **Release snapshots recorded the wrong commit.** `scripts/backup-release.sh`
  used `git rev-parse <tag>`, which returns the annotated tag object rather than
  the commit it wraps, so every `MANIFEST.txt` stored a tag SHA in a field
  labelled `commit:`. Snapshot contents and checksums were correct throughout.

### Added
- **`cable-box-parametric.json`**, one parameter-set file beside the model
  carrying all nine presets. OpenSCAD's Customizer offers the full list when the
  model is opened, and `-p cable-box-parametric.json -P <preset>` selects one
  from the command line. It is generated from the same table as the per-preset
  files, so the two cannot disagree.

## [1.4.0] - 2026-08-03

Completes E-02 (BOSL2 migration) phases 2 and 3. Geometry is unchanged at
default settings: mesh volumes match 1.3.0 exactly across box, lid, both,
Gridfinity bottom, Gridfinity lid, and slicing.

### Added
- **Snap-fit seam clips.** `Clip_Style` adds `"Snap"`, a BOSL2 `rabbit_clip`
  cantilever joint, alongside the original `"Tab"`. The tab is a rectangle in a
  slightly larger hole held by friction; the snap has an engagement bump and an
  arm that flexes, so it absorbs print inaccuracy instead of jamming.
  Tuning parameters: `Clip_Snap_Length`, `Clip_Snap`, `Clip_Arm_Thickness`,
  `Clip_Compression`, `Clip_Lock`.
  **The default remains `"Tab"`** until a print validates the snap geometry.
  Clip correctness cannot be established by rendering: manifoldness, solid
  counts, and probes all pass for a joint far too tight to assemble or too loose
  to hold.
- **Attachment interface.** `m_box()` and `m_lid_part()` expose the box and lid
  as BOSL2 attachables with named anchors: `floor`, `rim`, `wall-front`,
  `wall-back`, `wall-left`, `wall-right`, `post-top`, `lid-face`, `lip`.
  `lid-face` names the face that ends up exposed when the box is closed, which
  is the thing v1.2.0's Gridfinity lid interface got wrong.
- **Library mode.** `Render_On_Include=false` suppresses the auto-render so the
  file can be included and composed against.
- **A missing-dependency guard.** Without BOSL2 the model previously produced
  "Can't open include file", a wall of unknown-module warnings, no geometry, and
  **exit code 0**, which looks like success. It now fails with one message
  naming what to install and pointing at the standalone bundle.
- `scripts/bump-bosl2.sh` makes moving the pinned BOSL2 version a verified act:
  renders nine scenarios against old and new refs, compares mesh volumes, runs
  the suite, and refuses to apply on any change.

### Fixed
- Snap clips did not overlap their slice. The existing offsets assume a centred
  cube; a `rabbit_clip` is base-anchored and grows away from the slice, so the
  pin was left floating with nothing to bond to.
- Preview layout now accounts for clip protrusion. An 8 mm snap pin crossed the
  default 5 mm preview spacing and fused the all-slices preview into one body.
  `"Tab"` previews are unchanged.

### Testing
- 65 scenarios, up from 48. Adds bounding-box assertions, `output_contains`, and
  per-scenario source files for anchor and fixture tests.
- The harness now reports which BOSL2 version OpenSCAD actually loads, before
  any scenario runs. This exists because a full green local run turned out to be
  testing a different library than CI: on Windows, `~/Documents` is redirected to
  OneDrive, so a clone into that literal path went somewhere OpenSCAD never looks
  while a stale copy kept being loaded. That masked the clip-overlap bug above.

## [1.3.0] - 2026-07-31

Replaces the embedded BOSL2 copy with a real dependency. Dimensionally identical:
mesh volumes match the previous release to four decimal places across every
configuration tested, with only corner-rounding tessellation differing.

### Changed
- **BOSL2 is now a dependency, not embedded.** The model declares
  `include <BOSL2/std.scad>`. This removes a single 214,500-character line that
  was 79 percent of the file and froze the project on a February 2022 snapshot;
  CI pins BOSL2 2.0.747. The model file drops from 271 KB to 72 KB and is
  reviewable, diffable, and searchable for the first time.
  - MakerWorld's parametric customizer bundles BOSL2, so this also makes the
    model publishable there. A local `lib/` split would not have been, since
    MakerWorld forbids custom library uploads.
  - Local users install BOSL2 once; see the README. Releases attach a standalone
    bundle for anyone who would rather not.

### Fixed
- **The lid was relying on coplanar-face fusion.** Its lip ring and post collar
  both met the lid panel on a shared plane with zero overlap. Whether such a
  pair fuses into one body is kernel-dependent: the 2022 BOSL2 fused them, the
  current one does not, so the lid exported as three detached solids. Both now
  overlap into the panel by a `WELD` allowance. The same applied to the
  Gridfinity base and lid profile.

  This was a latent defect, not a migration regression. Any BOSL2 or CGAL change
  could have triggered it, and it would have shipped a lid in three pieces
  without a single error message. Caught by the geometry suite's
  disconnected-solid assertion.

### Added
- `scripts/build_bundle.py` produces a standalone model with BOSL2 inlined,
  verified in CI to render with no library installed.
  - The bundle is two files: the model plus `builtins.scad`. That file cannot be
    inlined. BOSL2 pulls it in with `use` rather than `include` because it wraps
    OpenSCAD's builtins (`module _translate(v) translate(v) children();`).
    `use` scopes it so `translate` resolves to the builtin; inlining it makes
    the body resolve to BOSL2's own `translate`, and the two recurse forever.
- CI installs a pinned BOSL2, builds the bundle, and verifies the bundle renders
  with BOSL2 moved out of reach.

## [1.2.0] - 2026-07-30

Adds optional Gridfinity interfaces. Geometry with both toggles off is
byte-identical to 1.1.1, verified by normalised STL comparison across all three
`Part_To_Render` modes.

### Added
- **Gridfinity base under the box** (`Enable_Gridfinity_Bottom`). Adds a 42 mm
  grid of base cells with the two-stage mating cavity so the box drops into a
  standard Gridfinity baseplate.
- **Gridfinity profile on the lid** (`Enable_Gridfinity_Lid_Top`). Puts the
  interface on the lid's exposed face so the closed box participates in a
  Gridfinity stack.
- Optional magnet pockets and screw holes on both interfaces
  (`Enable_Gridfinity_Magnet_Screw`), keeping `GF_MIN_FLOOR` of material between
  a pocket and the box floor.
- `Gridfinity_Profile_Clearance` and `Gridfinity_Edge_Keepout` for fit tuning.
- Assertions: Gridfinity bottom conflicts with bottom openings, and requires
  `Closed_Post` because the base would otherwise block an open post bore.
- Nine Gridfinity test scenarios, including probes that confirm the mating
  cavity is actually cut and that a box too small for one cell does not float.

### Added (tooling and content)
- **Preset library**: nine generated presets in `library/`, covering a compact
  desk tidy through a six-outlet surge strip split for a 180 mm bed. Each ships
  a complete `config.json`, STLs, renders, and notes.
- `scripts/build_library.py` generates all of it from a data table, so presets
  cannot drift from the model the way the hand-made v1 artifacts did.
- **Visual options guide**: `docs/options-guide.html`, a self-contained page with
  43 renders embedded as data URIs that works offline, plus a Markdown companion
  at `docs/OPTIONS_GUIDE.md`. Generated by `scripts/build_options_guide.py`.
- `scripts/backup-release.sh` snapshots a release (mirror clone, model file,
  changelog, and a manifest with the commit and model hash) into gitignored
  `_local/backup/`.
- README rewritten around a photograph of a printed box, feature renders, and
  the preset table.

### Changed (CI)
- All GitHub Actions bumped past the Node 20 deprecation: `checkout` v4 to v7,
  `setup-python` v5 to v7, `configure-pages` v5 to v6, `upload-pages-artifact`
  v3 to v5, `deploy-pages` v4 to v5.

### Notes on the height convention
The base is **added below** the box rather than carved out of the floor, so
`Box_Height` keeps meaning "the box body" and enabling Gridfinity never silently
steals interior height. Carving instead would have required a separate
`Floor_Thickness` threaded through stabilizer, bottom-opening, clip, and post
placement, all of which currently treat `Wall_Thickness` as the floor. The whole
box is lifted by the base height at render time so the exported object still
sits on z=0.

The same reasoning applies to the lid. Its lip is the mating face, so z=0 is the
exposed top, and the profile grows downward from there with the lid lifted to
match. The original prototype placed it on the lip side, which would have buried
it inside the closed box.

### Provisional: the lid Gridfinity profile
The lid interface is currently a **positive stud**, so the closed box behaves
like a bin that sits in a baseplate. If the intent is instead for Gridfinity
bins to sit on top of the closed lid, it needs to be a socket. This is unresolved
pending a physical print, and may change. The box underside interface is not
affected. Both are off by default.

Gridfinity is by Zack Freedman and is MIT licensed. See `THIRD_PARTY_NOTICES.md`.

## [1.1.1] - 2026-07-29

### Fixed
- Side openings anchored flush with the box floor produced a non-manifold solid.
  The cut stopped exactly on the box bottom plane, leaving a zero-thickness
  tangency that CGAL reports as `Simple: no` and a slicer may reject. The cut is
  now sunk `SPACER` below its own bottom edge so it crosses that plane with real
  cross-section. Caught by the new geometry test harness on its first run.

### Changed
- **Licence changed from `CC BY-NC-SA 4.0` to `MIT`.** The NonCommercial clause
  blocked selling printed copies, blocked print-on-demand, and was at best
  ambiguous on platforms with creator rewards. MIT matches Gridfinity's own
  licence, suits a model that is really source code, and is GPL-compatible for
  a future browser customizer.

### Added
- `Model_Version` constant, echoed at render, so an exported STL can be traced
  back to the source that produced it.
- `scripts/check-version.sh`: fails the build when `Model_Version`, the top
  `CHANGELOG.md` section, and the git tag disagree. Handles `-rc` suffixes.
- `tests/`: a data-driven geometry regression harness. 39 scenarios asserting
  exit code, assertion text, manifoldness, disconnected-solid count, absence of
  warnings, and point probes against the exported mesh. Every defect fixed in
  1.1.0 has a regression scenario.

## [1.1.0] - 2026-07-28

First release published under `prisant-labs`. Fixes four geometry defects that
could produce unprintable output without any error, and adds validation so
out-of-range parameters fail with an actionable message instead of silently
generating broken solids.

### Fixed
- Side openings now deliver their full requested height. The cut was centered on
  the box floor, so half of it fell below the model and `All_Opening_Height = 30`
  produced a 15 mm opening. Openings are now anchored at their bottom edge.
- `Bottom_Openings_Count = 0` no longer cuts two unintended floor openings.
  The count reached `for (i = [0:count-1])` as `[0:-1]`, which OpenSCAD's
  deprecated reverse-range behavior iterates as `-1` then `0`. With the center
  post enabled the two cutouts undercut the post footprint and detached it from
  the floor, producing two disconnected solids at exit code 0.
- `Box_Corner_Radius` is now clamped against the inner cavity rather than the
  outer shell. The previous clamp used `min(R, Box_Width/2, Box_Depth/2)` but the
  same value was reused for the inner cuboid, which is `Wall_Thickness*2` smaller,
  so any radius above `(min(Box_Width, Box_Depth) - Wall_Thickness*2)/2` aborted
  inside BOSL2. A radius that has to be reduced is now reported via `echo`.
- `Closed_Post = true` now closes the post bottom as documented. It previously
  shortened the bore from the top, which left a cap at the post's upper end and
  the floor still open.
- Seam clips are no longer placed over the post opening. With `Clips_Per_Edge = 1`
  the single clip landed at the box center, directly above the open post bore,
  where it had no material to bond to and exported as a loose solid. Box and lid
  clip positions are now pushed clear of the post opening.

### Added
- Validation for degenerate inputs that previously rendered successfully and
  produced unusable geometry: box and wall dimensions, post diameter versus the
  interior, stabilizer height and depth versus the box, negative stabilizer
  counts, side-opening height versus box height, and bottom opening count and size.
- `Max_Corner_Radius`, `Corner_Radius`, `Floor_Clip_Clearance`, and
  `Lid_Clip_Clearance` derived values, so the constraints above are computed once
  and reused rather than restated at each call site.

### Changed
- **Breaking:** `All_Openings_Up` and the per-side `Move_Opening_*_Up` values now
  measure the opening's bottom edge above the box floor, rather than offsetting a
  cut centered on the floor. `0` sits an opening flush with the box bottom so a
  cable on the desk passes straight in. To centre an opening in the wall, use
  `(Box_Height - All_Opening_Height) / 2`. Saved presets that compensated for the
  old behavior need their vertical offsets revisited.
- Primary model renamed to `cable-box-parametric.scad`.
- Repository moved to `prisant-labs/3d-cable-box-parametric-openscad`; all
  references, the docs site config, and the SCAD header updated to match.
- Agent working notes and private scratch directories are no longer tracked.
- `Closed_Post` Customizer help corrected to describe the actual behavior.

## [1.0.0] - 2026-02-16

### Added
- Initial project scaffold with GitHub best-practice baseline files.
- CC BY-NC-SA 4.0 licensing documents and contribution terms.
- Full parameter documentation in `docs/PARAMETER_REFERENCE.md`.
- Workflow guide in `docs/WORKFLOWS.md`.
- Docs set covering FAQ, printing, release, architecture, modules, and validation.
- Folder scaffolding and contribution guides for `library/` and `community/`.
- OpenSCAD smoke automation:
  - `.github/workflows/scad-smoke.yml`
  - `scripts/scad-smoke.ps1`
  - `scripts/scad-smoke.sh`
- Initial release artifact preset under `library/v1-default/`:
  - `stl/` baseline outputs
  - `images/` baseline previews
  - `config.json` and `notes.md`
- Per-side opening corner radius overrides and a global default.
- Stabilizer spacing controls for front/back and left/right walls.
- `Bottom_Opening_Post_Margin` for clearance around the center post.

### Changed
- Rewrote SCAD Customizer inline help for concise, parameter-level guidance.
- Removed numeric slider range annotations from user-facing Customizer parameters.
- Implemented true `Custom` placement behavior for front/back and left/right
  stabilizer alignment modes.
- Implemented true `Custom` behavior for bottom opening secondary alignment
  (centers within the custom margin window).
- Tightened slicing validation (`Slice_Piece_To_Render` integer and range checks,
  plus clip parameter guards).
- Clarified opening offset directionality in SCAD inline help and docs.
- Hardened local smoke scripts for real-world execution:
  - PowerShell runner uses deterministic process checks and parameter-set
    handling for `Part_To_Render`.
  - Bash runner supports `OPENSCAD_BIN` override and Windows Bash fallback paths.
