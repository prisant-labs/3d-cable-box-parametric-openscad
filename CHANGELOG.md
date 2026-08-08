# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Edge treatment.** `Bottom_Edge_Fillet` rounds the box's outer bottom edge
  and `Top_Edge_Chamfer` chamfers the box's top rim and both exposed lid edges.
  Every horizontal edge was previously a hard 90 degrees, which is the largest
  visible gap between this and a commercial enclosure; the bottom fillet also
  absorbs elephant foot visually. Both default to `0`, and at `0` the code takes
  the same `cuboid()` path it always has, so an untreated model is unchanged by
  construction rather than by comparison. Non-zero, the shell switches to BOSL2
  `offset_sweep()`, which resolves how a horizontal fillet meets the vertical
  corner radius. Suppressed automatically wherever a Gridfinity interface owns
  the face, because those profiles are dimensioned by the standard.
- **Lid removal relief.** `Lid_Relief_Style` takes `Scallop` (a concave groove)
  or `Tab` (a protruding grip), placed by `Lid_Relief_On_Left/Right/Front/Back`
  mirroring the existing `Opening_On_*` block, and sized by `Lid_Relief_Width`
  and `Lid_Relief_Depth`. `Lid_Lip_Gap` defaults to 0.1 mm, which is a
  deliberately tight friction fit with nothing to grip. A side is skipped
  automatically when an opening on that wall reaches the rim, which is the only
  case where the lid feature and the box feature meet. Defaults to `None`.
- **Magnetic lid retention.** `Enable_Lid_Magnets` cuts mating pockets in the
  box and lid, held in bosses at the four inside corners. Corners rather than
  the rim because the rim is only `Wall_Thickness` wide and a 6 mm magnet does
  not fit it, and because corners are free of openings, stabilizers, the post
  and slice seams by construction rather than by avoidance logic. The four
  positions are symmetric in both axes, so they align however the lid is flipped
  onto the box. Bosses run the full box height so they print off the bed instead
  of hanging off the rim. Sizing follows the existing `Gridfinity_Magnet_*`
  convention: `Lid_Magnet_Diameter` 6.2 for a nominal 6 mm magnet. Asserts when
  the boss will not fit the cavity or would touch the post. Defaults to off.

  Magnets must be inserted with opposing poles facing. Symmetric geometry cannot
  enforce that.

All four features default to a state that leaves existing geometry unchanged, so
this is a minor bump under [E-10 (versioning)](docs/internal/E-10_versioning.md)
and does not disturb the 2.0.0 candidate awaiting print validation. Nine
regression scenarios cover them, including that the defaults render identically
and that magnets survive slicing.

## [2.0.0] - 2026-08-07

Major release, because `Enable_Gridfinity_Lid_Top` now renders different
geometry from the same parameter set. Under
[E-10 (versioning)](docs/internal/E-10_versioning.md) that is a major bump even
though the new geometry is the one the parameter always claimed to produce.

**Not yet print-validated.** The Gridfinity socket clearances and the lid clip
placement are arithmetic, not measurements. E-10's flow for this state is a
`v2.0.0-rc.1` prerelease with STLs attached, so the print test has a citable
artifact; the date above belongs to the final release and should be corrected
when it ships.

### Added
- **A preset browser on the docs site**, at `/library/`. A card grid filterable
  by printer bed size and by feature, and a page per preset with an orbitable
  3D view of each part, the parameters that define it, and downloads. Cards use
  the fixed-camera render, so the grid reads as a size comparison rather than
  nine models each zoomed to fill its own frame.
- **`library/index.json`**, the machine-readable twin of `library/README.md`:
  every preset with its overrides, printed envelope, feature flags, and file
  paths, plus the model's full parameter defaults once at the top. It carries a
  schema version, and like the README it always covers every preset even when
  `--only` rebuilt one.
- **A GLB beside every library STL**, converted at build time by
  `scripts/build_library.py`, for 3D preview in a browser. About a tenth the
  size: the 481 KB `gridfinity-module` box-and-lid becomes 51 KB. The mesh is
  canonicalised before export, which is not cosmetic: OpenSCAD emits identical
  geometry in a different facet order every run, so a straight conversion
  produced 27 changed binaries on every rebuild and a canonical one produces
  zero. `trimesh` is an optional dependency; without it the GLBs are skipped
  and the rest of the build is unaffected.

### Changed
- **BREAKING: `Enable_Gridfinity_Lid_Top` now produces sockets, not studs.**
  Under [E-10 (versioning)](docs/internal/E-10_versioning.md) this is a major
  bump, because the same parameter set renders different geometry.

  The lid inverts in use: its lip is the mating face, so the panel's other side
  is the exposed top of a closed box. The previous implementation added a
  two-stage stud to that face, which meant a closed box carried Gridfinity feet
  pointing at the ceiling. Nothing can rest on a foot. The feature's own
  documentation described a baseplate, so the code and the docs had disagreed
  since the feature shipped.

  It is now a 4.75 mm plate spanning the lid, with a mating socket cut into each
  cell, so a Gridfinity bin or another box drops onto the closed lid.

  The socket mouth is sized from the widest part of a foot (`GF_BASE_CELL`,
  41.5 mm) plus clearance, not from `GF_CAVITY_ENTRY_SIZE`. That constant is
  39.4 mm and describes the cavity hollowed *into* the box base, which is the
  inside of the male half; a mouth that size held every part 1.85 mm proud.
  Verified: the model's own base fits with 0.25 mm clearance, and a standard bin
  foot seats on the shoulder at 3.2 mm depth.

  Lid height with the feature on goes from 4.5 mm to 4.75 mm added. Constants
  `GF_LIDTOP_BASE_HEIGHT`, `GF_LIDTOP_TOP_HEIGHT`, `GF_LIDTOP_BASE_SIZE` and
  `GF_LIDTOP_TOP_SIZE` are replaced by `GF_LIDTOP_PLATE_HEIGHT`.

  **Still unvalidated by print.** Nothing here has been fitted to physical
  Gridfinity hardware. The clearance is a number, not a measurement.

### Fixed
- **Lid magnet pockets were unusable and are now magnet-only.** (Found by
  adversarial review.) The pocket cut still started at the lid-panel interface
  as in the stud era, so it overlapped the socket void and left a 0.45 mm
  pocket: a 2.4 mm magnet glued there stood proud into the socket and held
  every foot off the floor. Pockets now open at each socket floor and reach
  into the lid panel, keeping `GF_MIN_FLOOR` of panel above them. The screw
  hole and counterbore are gone from the lid entirely: a baseplate's screws
  fasten it to a surface, and here that surface is the sealed lid, so a
  through hole would breach the closed box. The bottom base keeps its screw
  holes. Regression probes assert the pocket void and the solid panel above.
- **Slicing a lid shorter than the Gridfinity plate left a full-width layer on
  every piece.** (Found by adversarial review.) The slice cutters were sized
  from `Lid_Height` alone, and the plate hangs `Gridfinity_Lid_Offset` below
  z=0, so at the legal `Lid_Height=4.6` each cutter stopped 0.15 mm short:
  piece 1 measured 103.8 mm wide instead of ~52, defeating the small bed that
  slicing exists for. Both lid and box cutters now span an explicit envelope
  from below the Gridfinity offset to above the lip. Regression asserted by
  bounding box, and the box cutter fix closes the same latent gap for boxes
  shorter than twice the base height.
- **`build_library.py --only` truncated the public preset index.** (Found by
  adversarial review.) The README was rewritten from only the presets in the
  filtered build, so one `--only gridfinity-module` run shipped an index
  listing a single preset while eight valid ones sat beside it on disk. The
  index now always covers every preset, reading dimensions from the on-disk
  STL for presets not rebuilt in that run.
- **Point probes can no longer return a verdict from a broken mesh.** A CGAL
  assertion inside a probe intersection still prints "top level object is
  empty", so a degenerate exported mesh read as a confident "empty" at every
  point. The test harness now raises on CGAL errors instead. The sliced-lid
  export was the mesh that exposed this; that degeneracy is fixed below, and
  the scenario probes it again.
- **Sliced lid pieces exported four zero-area triangles.** The lid's seam clip
  was placed with its top face exactly flush with the top of the lid panel
  (`z_pos = Lid_Height - Clip_Tab_Height/2` on a centred cube puts the top at
  exactly `Lid_Height`). Flush, the clip's top and the panel's top are one
  coplanar face, so on the slice seam the clip's corners became extra collinear
  vertices along an otherwise straight edge, and OpenSCAD's tessellator fanned
  across them into slivers. Measured on every sliced lid configuration: four
  such triangles with Tab clips, eight with Snap, none anywhere else, and none
  on any box piece or unsliced lid. Slicers tolerated them; CGAL did not, so
  every point probe against an exported sliced lid raised instead of answering.
  The clip is now sunk by `SPACER` (0.04 mm, the constant this codebase already
  uses to break tangency). Male and female clips share that offset, so the fit
  is unchanged, the part envelope is unchanged, and 0.04 mm is a fifth of a
  typical layer. Verified: zero degenerate triangles across Tab, Snap, thin
  lids and the Gridfinity plate, and the regression now asserts by probe.
- **Rebuilding the library no longer reports every render as modified.**
  OpenSCAD rasterises through OpenGL, so pixels along polygon edges land
  differently between runs: two renders of an identical model differ by up to
  993 bytes of 2,250,750, invisible to the eye but not byte-equal. Git compares
  bytes, so every rebuild dirtied images that had not changed, and real changes
  were indistinguishable from noise. `scripts/build_library.py` now compares a
  new render against the existing file and keeps the old one when they are the
  same picture. The threshold sits in the gap between measured noise (up to 993
  bytes) and the subtlest real change (a 0.5 mm dimension shift moves 11,508),
  and the measurements are recorded beside it. The build reports how many
  renders it wrote versus left alone.
- `docs/WORKFLOWS.md` told contributors to add presets to `library/` by hand.
  Everything in that directory is generated and hand-added files are overwritten
  on the next build.

### Changed
- **Docs site rebuilt on Astro Starlight, replacing MkDocs.** Same URL, same
  page set, same nav structure. The site lives in `web/` and syncs its content
  from `docs/` at build time (`web/sync-docs.mjs`), so `docs/` remains the
  single source of truth: README links keep working, GitHub browsing keeps
  working, and `build_options_guide.py` keeps generating into the same place.
  Page URLs changed from uppercase (`/PARAMETER_REFERENCE/`) to kebab-case
  (`/parameter-reference/`); old deep links 404. `mkdocs.yml` is gone, its nav
  now lives in `web/astro.config.mjs`, and the Pages workflow builds with Node
  instead of Python. The offline `options-guide.html` is served unchanged. The
  landing page's stale claim that Gridfinity was developed outside this
  repository is corrected.
- `docs/RELEASE.md` rewritten from a seven-line checklist to the actual release
  process: which of the three generated artifacts embed `Model_Version`, the
  version consistency check, the standard release assets, and the snapshot step.
- `docs/FAQ.md` gains preset-loading instructions and the recovery note for the
  1.4.0 `config.json` type error.
- `docs/WORKFLOWS.md` quick start covers starting from a preset.
- `README.md` and `docs/DOCS_INDEX.md` document `cable-box-parametric.json`.

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
