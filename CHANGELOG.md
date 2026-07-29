# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
