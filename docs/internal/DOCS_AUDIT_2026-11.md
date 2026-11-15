# Documentation and site audit, November 2026

Audit date: 2026-11-13. Repository state: `main` at `d5e9466`, which merged
[E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md) phase B. Latest tag:
`v2.0.0-rc.6`. Scope: `README.md`, every Markdown file in `docs/` except
`docs/internal/`, and the site published at
<https://projects.prisantlabs.com/3d-cable-box-parametric-openscad/>.

## Verdict

The documentation is accurate and unusually concrete, but it is not yet
engaging, and a newcomer can get stuck before the first print.

- **Accuracy is good.** All 120 documented parameter defaults match the
  `.scad`. No documented parameter is missing from the model, and no model
  parameter is missing from the reference. The live site was built from
  `d5e9466`. Internal links and anchors in the Markdown all resolve.
- **No image shows the retired Gridfinity lid socket.** Every Gridfinity image
  shows the baseplate with pockets facing up. That covers the README, the
  options guide, and the `gridfinity-module` preset images. (High confidence.
  I viewed each one, and the 54 PNGs in `docs/images/options/` are
  byte-identical to the images embedded in `docs/options-guide.html`.)
- **The site is a reference manual with a link list for a front door.** Eleven
  of the thirteen site pages carry no image at all. The options guide carries
  54 images and the preset library carries 9.
- **The newcomer path breaks in three places.** They are F-01 (wrong shortcut
  and no BOSL2 step, now fixed), F-03 (no print guidance after the download)
  and F-05 (a landing page with no way in). The sliced preset adds a fourth
  gap, F-02.

## How to read this document

Each finding has a severity, the exact location, what is wrong, a proposed fix,
and a confidence level. Each finding also says how it was checked.

| Tag | Meaning |
|---|---|
| **Seen** | I looked at the rendered live page or at the image itself. |
| **Crawled** | I fetched the live page and read its DOM, text or HTTP status. |
| **Source** | I inferred it from the repository files only. |
| **External** | I checked it against OpenSCAD's own source code. |

A status line marks each finding: **Fixed** means this pull request changes it.
**Proposed** means the maintainer decides, or the fix needs a regenerated file.

Rendered-site coverage: I saw the landing page in a browser screenshot and read
the DOM of the landing, library and preset pages. The other pages were
crawled for links, images and anchors, and read from source. They were not
viewed as screenshots.

## Decisions for the maintainer

These three decisions matter most. Everything else follows from them. The
maintainer answered all three on 2026-11-14, and the answers are recorded
under each one.

1. **Which release do newcomers get?** The README sends readers to the newest
   pre-release "for the current geometry". That is `v2.0.0-rc.6`. The docs, the
   site and the library all describe `main`, which now holds the unreleased
   Gridfinity lid. See F-04 (the docs describe `main`, the README points at rc.6).

   **Decided: cut `v2.0.0-rc.7` now**, rather than adding a banner and waiting
   for a print test. No banner was added. The README sentence about taking the
   newest pre-release becomes true as soon as the tag exists, and is false
   until then.

2. **What does the landing page promise?** A newcomer wants to get a box. The
   page today lists the parameter reference first. See F-05 (landing page: no hero, no call to action).

   **Decided: get a box first.** `docs/index.md` was rebuilt in the order
   photo, "Get a box", "Change a box", hero render, "Reference", "Scope
   notes". The sidebar in `web/astro.config.mjs` was reordered to match. The
   layout is plain Markdown rather than Starlight's `<CardGrid>`, because
   `docs/` is the source of truth and is read on GitHub as well as on the
   site, and `sync-docs.mjs` emits Markdown rather than MDX.

3. **What counts as print validated?** The landing page says unvalidated
   features are marked where they appear, and they are not. See F-06 (unvalidated features are not marked as promised).

   **Decided: publish a status table, prefilled from the repository.**
   `docs/PRINTING.md` gained a "Print validation status" section.

   This audit's own search for print evidence was too narrow: it covered
   `docs/*.md` and `README.md` and skipped `CHANGELOG.md` and
   `docs/internal/`. Those two hold most of the record. `CHANGELOG.md` dates
   the `Lid_Lip_Gap` fit to the `rc.5` test prints, and
   [`BACKLOG.md`](BACKLOG.md) items 13, 18 and 20 record printed clip
   coupons at `rc.4` and `rc.5`, the sliding seam that led to
   [E-13 (seam joints)](E-13_seam-joints.md), and the two Gridfinity print
   failures that led to [E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md).
   The README photograph adds one more: the box in it has a post and has no
   stabilizer fins.

   So five rows are marked printed, one of them with a known weakness, and
   two Gridfinity rows record that the shape each one replaced was printed
   and failed. A row marked "rendered only" means no record exists here, not
   that a print failed. The maintainer corrects the table from their own
   history.

---

## High severity

### F-01 (newcomer path: wrong shortcut and no BOSL2 step) - Fixed

- **Where:** `README.md` heading "Get a box", paragraph "Want to change
  something?"; `docs/WORKFLOWS.md` heading "1) Quick Start Workflow";
  `docs/FAQ.md` heading "How do I load one of the presets?"; the "Getting
  started" table generated into `docs/options-guide.html`.
- **What is wrong.** Five places told the reader to press `F3` to open the
  Customizer. F3 is not the Customizer. In OpenSCAD 2021.01 and in current
  `master`, the code adds F3 as a second shortcut for **File > Reload** on
  Windows and Linux, and binds nothing to it on macOS. The Customizer is a
  menu item under **Window**, and it has no shortcut in either version's
  `MainWindow.ui`. The 2021.01 file also shows F5 preview, F6 render and F7
  export, so the F6 advice was right. This is the first dead end: the reader
  presses F3 and the file reloads, or nothing happens, and no panel opens.
- **Second break, site only.** The site never says where to get the `.scad`
  or how to install BOSL2. Only the README does, and the README is not a site
  page. `docs/WORKFLOWS.md` step 1 says "Open `cable-box-parametric.scad`"
  with no earlier step. Without BOSL2 the model stops with a message, which is
  correct but is a surprise at step 1.
- **Third break.** `Part_To_Render` defaults to `Box Only`, so a newcomer who
  exports once gets no lid. `docs/WORKFLOWS.md` mentions this only at step 6.
- **Fix made.** F3 is replaced by the **Window** menu in the README, the
  workflow page, the FAQ and `scripts/build_options_guide.py` (then the guide
  was rebuilt with `--no-render`). `docs/WORKFLOWS.md` now opens with a BOSL2
  prerequisite that links to the README install commands.
- **Still proposed.** Add one line to the workflow's step 5: "The default exports
  only the box. Set `Part_To_Render` to `Lid Only` and export again."
- **Same bug, not fixed.** `scripts/build_library.py` line 784 writes
  "the Customizer (F3)" into `library/README.md`. I may not regenerate
  `library/`, so I left the script alone. Change the script and rerun it. The
  fix is the same wording as above.
- **Confidence:** high that F3 is not the Customizer, and high that it means
  File > Reload on Windows and Linux (External: `src/mainwin.cc` at the
  `openscad-2021.01` tag and `src/gui/MainWindow.cc` on `master`, plus both
  `MainWindow.ui` files). I did not press the key in a running application.
  A Nightly build is the only version I did not read line by line.

### F-03 (no print guidance on the path from download to print) - Proposed

- **Where:** the README "Get a box" section, the preset library page, and each
  preset page.
- **What is wrong.** A reader who downloads an STL is never told how to print
  it. The baseline settings (0.4 mm nozzle, 0.20 mm layer, three or more
  walls) and the rule "print each part as exported" live only in
  `docs/PRINTING.md`. The README links that page only for the fit test box.
  Preset pages show a "Rebuild this preset" command, which a printer owner does
  not need, and no print settings, which they do.
- **Proposed fix.** Add one sentence and one link under "Just want to print
  one?": "Print each part as exported, in PLA or PETG, 0.2 mm layers, three
  walls; see the [Printing guide](docs/PRINTING.md)." Add a short fixed
  "Print it" block to `web/src/pages/library/[preset].astro`, above
  "Rebuild this preset", with the same three numbers and a link.
- **Confidence:** high (Crawled and Source).

### F-04 (the docs describe `main`, the README points at rc.6) - Proposed

- **Where:** `README.md` paragraph beginning "Both track `main`";
  `docs/PRINTING.md` heading "Gridfinity"; `docs/FAQ.md` headings about the
  Gridfinity lid.
- **What is wrong.** The README says take "the newest Pre-release for the
  current geometry". The newest pre-release is `v2.0.0-rc.6`. Only
  `d5e9466` separates `main` from that tag, and that commit is E-12 (Gridfinity to spec) phase B. So
  the lid in rc.6 prints the other way up from what the docs, the library STLs
  and every Gridfinity image show. A reader who downloads the rc.6 `.scad`
  and follows the lid guidance gets a part the docs do not describe.
  `docs/PRINTING.md` does say "Releases through 2.0.0-rc.6 printed the lid the
  other way up", but only inside a bullet list.
- **Proposed fix, either one.** Cut `v2.0.0-rc.7` once the new lid is print
  tested, which also lets the README sentence stay true. Or add a one-line
  banner to the README and the site landing page: "`main` is ahead of the
  latest release. The Gridfinity lid changed after rc.6."
- **Confidence:** high (Source: `git tag --contains` shows rc.6 holds phase A
  and E-14 (printability options) but not phase B; `gh release list` shows rc.6 as the newest tag).

### F-05 (landing page: no hero, no call to action) - Proposed

- **Where:** `docs/index.md`; also the `description` in
  `web/astro.config.mjs`.
- **What is wrong (Seen).** The landing page is a heading, two sentences about
  the SCAD file, and four link lists. It has no image and no statement of what
  the box is. "Start Here" opens with the parameter reference, which is the
  least friendly page. The preset library, the fastest route to a printed box,
  sits in the third section. "Local Build" is Astro instructions for
  contributors. The page title is "Ultimate Cable Box Documentation", the site
  title is "Ultimate Cable Box Parametric OpenSCAD", and the README title is
  "Parametric Cable Management Box". The page's meta description reads "This
  site documents the primary model" and the site-wide one reads "Detailed
  technical documentation".
- **Proposed fix.** Rebuild `docs/index.md` in this order. First, the printed-box
  photo and one sentence on what the box is. Second, three entry cards:
  "Get a box" (preset library), "Change a box" (Workflows, then Options guide),
  and "Print a box" (Printing). Third, the hero render. Fourth, the reference
  links under "Reference". Move "Local Build" to `CONTRIBUTING.md`. Pick one
  product name and use it in the page title, the site title and the README.
  Starlight's `template: splash` and `<CardGrid>` support this layout, but note
  that `sync-docs.mjs` writes plain Markdown, so cards need an `.mdx` page or a
  small change to the script.
- **Confidence:** high (Seen and Crawled).

### F-06 (unvalidated features are not marked as promised) - Proposed

- **Where:** `docs/index.md`, heading "Scope Notes".
- **What is wrong.** The page says "Features still awaiting physical print
  validation are marked as such where they appear." Only two things are marked:
  the `Lid_Lip_Gap` default (confirmed on one printer) and the Snap clip. The
  maintainer has not print tested the Gridfinity lid from E-12 (Gridfinity to spec) phase B, and the
  README, `docs/PRINTING.md` and the FAQ state that it prints with no bridging
  as fact. The same is true of the teardrop and chamfer options from
  [E-14 (printability options)](E-14_printability-options.md), the seam teeth,
  and the Gridfinity feet.
- **Proposed fix.** Add a table, "Print validation status", to
  `docs/PRINTING.md`. Give it three columns: feature, status (printed, rendered
  only), and printer and material. Link it from the landing page. Until the
  maintainer fills it in, change the landing sentence to match what is true.
- **Confidence:** high that the promise is not kept (Source: a search for
  "validation" and "tested" in every doc). I do not know which features have
  been printed. The maintainer does.

---

## Medium severity

### F-02 (sliced preset has no per-piece files or slicer instruction) - Proposed

Severity note: I first rated this high. It is medium, because a slicer that
splits objects into parts can handle the file, and a reader who owns one knows
how. The gap is that nothing tells a newcomer to do that.

- **Where:** `library/surge-strip-6-sliced/`, the preset's page on the site,
  and the README "Get a box" paragraph that says "No software needed beyond
  your slicer".
- **What is wrong.** The preset is advertised as "split for a 180 mm bed". Its
  downloadable STLs are the preview layout with both halves side by side.
  `library/index.json` gives the "Box Only" part as 270.0 x 100.0 x 62.0 mm,
  which is wider than the bed it names. The preset's `notes.md` tells the
  reader to export each half from OpenSCAD, and never mentions that a slicer
  can separate the two solids. So the "slicer only" promise holds only for
  readers who already know that trick.
- **Proposed fix.** In `scripts/build_library.py`, for a sliced preset also
  render one STL per piece with `Slice_Piece_To_Render=1..Slice_Count`. Add them
  as downloads, named `<preset>_box-piece-1.stl`, `-piece-2.stl`, and the same
  for the lid. Until then, change the preset's note to say that no per-piece
  STL exists.
- **Confidence:** high (Crawled and Source: file list and sizes in the index).

### F-07 (images that do not show what their caption names) - Proposed

All findings here were **Seen** at full size. Each fix is a scene change in
`scripts/build_options_guide.py` (generates `docs/images/options/*.png`,
`docs/OPTIONS_GUIDE.md` and `docs/options-guide.html`) or in
`scripts/build_readme_images.py`. Both take a camera string per scene.

| Image | Problem | Proposed scene change |
|---|---|---|
| `lid-deep-lip` ("Lid_Lip_Gap_Height 8") | Shot from below with `CAM_UNDER`. It shows the flat face and no lip at all. | Use `CAM_ISO` with `Lid_Lip_Gap_Height=8` and `Part_To_Render=Lid Only`, as `lid-default` does, so the lip shows. |
| `wall-thin`, `wall-thick` | Side view at `CAM_LOW`. A 1.2 mm and a 3.0 mm wall look the same at box scale. | Zoom on one corner of the rim, or add a `Wall_Thickness=6` exaggeration labelled as such. A zoomed scene needs a per-scene opt-out, because `render()` always passes `--viewall --autocenter` and appends `,0` to the camera, which override any translation and distance. |
| `edge-fillet`, `edge-bottom-teardrop`, `edge-bottom-chamfer`, `edge-chamfer` | A 1.5 mm or 0.8 mm edge treatment on a 100 mm box is invisible. | Zoom on the bottom edge, or render a small box (`Box_Width=30`, `Box_Depth=30`, `Box_Height=15`) so the profile reads. |
| `gf-both` ("Both, with magnet and screw holes") | The scene renders `Box Only` from below. No lid is visible, so `Enable_Gridfinity_Lid_Top` has no visible effect. The section intro promises a lid shown from above. | Split into `gf-both-box` (underside) and `gf-both-lid` (lid from above), or render `Box and Lid` from a side angle. |
| `lid-default`, `lid-skirt`, `lid-tall` | Three near-identical top views. The Plug versus Skirt difference is a thin ring. | Use a closer `CAM_ISO` on one corner of the lip, so the ring inside a Plug and the wall outside a Skirt are both visible. The lid exports lip up, so do not shoot it from below. |
| `open-default`, `open-up` | Nearly identical at `CAM_ISO`. `open-flush` differs only by a small notch at the floor. | Use `CAM_LOW` and a front-on view, so the gap under the opening shows. |
| `post-closed`, `gf-off` | Underside views where the closed-post floor reads as a small speckle. | Pair each with its default so the difference is visible, or add a cutaway-style zoom. |
| `feature_gridfinity` (README) | The caption names "Gridfinity feet under the box", and the feet are a thin purple rim at this angle. The lid half is correct. | Add a second image from `CAM_UNDER`, or tilt the camera down to 100 degrees. |

Confidence: high. Also note the Tomorrow colour scheme uses orange, blue and
green with no legend. A reader cannot tell that blue and green are fins. Add
one sentence under the options guide intro that names the colours.

### F-08 (photo evidence is thin and one caption does not match) - Proposed

- **Where:** `README.md`, caption under `docs/images/printed-box-black-petg.jpg`.
- **What is wrong.** The caption says the box was printed with
  `All_Openings_Up=0`, so the openings sit flush with the floor. In the photo
  the lower end of the front slot is clearly above the wall's bottom edge, by
  roughly half the slot's width. That fits the default of `5` mm better than
  `0`. Perspective could account for part of the gap.
- **Also.** It is the only photograph in the whole documentation set. There is
  no photo of a lid, a closed box, a sliced pair, a Gridfinity base or a magnet
  pocket. Every other image is an OpenSCAD render.
- **Proposed fix.** The maintainer checks the print's actual setting and
  corrects the caption, or reprints with `0`. Add three photos over time: lid
  seated, a sliced pair joined, and the box in use with cables. Each one earns
  its place more than another render does.
- **Confidence:** medium (Seen; perspective uncertainty).

### F-09 (maintainer material shown to users) - Proposed

- **Where, on the site:**
  - `docs/WORKFLOWS.md` sections 9 ("CI Smoke Workflow") and 11
    ("Documentation and Contribution Workflow", including four paragraphs on GLB
    conversion).
  - `docs/PARAMETER_REFERENCE.md` heading "Documentation Maintenance Rules".
  - `docs/VALIDATION_RULES.md` heading "Authoring Guidance for New Assertions".
  - `docs/index.md` heading "Local Build".
  - `docs/DOCS_INDEX.md`, which lists `astro.config.mjs` and workflow files, and
    is the first item under "Getting Started" in the sidebar.
  - `docs/RELEASE.md`, a whole page in the sidebar.
- **Why it matters.** A newcomer opens "Workflows" expecting a how-to and meets
  GLB canonicalisation. Contributor text dilutes the guidance a user came for.
- **Proposed fix.** Move all of it to `CONTRIBUTING.md` or `docs/internal/`.
  Drop `RELEASE` and `DOCS_INDEX` from the sidebar, but keep the pages reachable
  from the footer. Keep `WORKFLOWS.md` to the user workflows, sections 1 to 8.
- **Confidence:** high (Crawled and Source).

### F-10 (images missing where prose carries the load) - Proposed

- **Where:** `docs/PRINTING.md` (no images), `docs/FAQ.md` (none),
  `docs/WORKFLOWS.md` (none).
- **What is wrong.** `docs/PRINTING.md` has a ten-bullet Gridfinity section whose
  main point is "which face is on the bed". The FAQ explains the same flip in
  prose twice. Orientation is the one thing a diagram does far better than text.
- **Proposed images**, all producible by `scripts/build_readme_images.py`
  scenes, with `CAM_ISO` unless noted:
  1. `print-orientation-lid`: the lid as exported, plain and with
     `Enable_Gridfinity_Lid_Top=true`, side by side, pockets visible.
     Place it under "Orientation" in `docs/PRINTING.md`.
  2. `fit-test-box`: the 50 x 50 x 12 fit test box with its lid, using the
     exact parameters listed in `docs/PRINTING.md`. This turns a bullet list
     into a picture of the thing to print.
  3. `side-opening-anchor`: `All_Openings_Up=0` next to `5`, `CAM_LOW`, front on.
     Place it in the FAQ answer "Why are my side openings not where I expect?".
  4. `seam-assembled`: a two-piece slice from `Slice_Piece_To_Render=1` and `2`,
     to show the join, for the "Slicing Mode Print Procedure" section.
- **Image decoration check.** I found no purely decorative image. The weakest
  value images are the near-duplicates in F-07.
- **Confidence:** medium. This is judgement, not a defect.

### F-11 (version history inside guidance) - Proposed

- **Where:** `docs/PRINTING.md` lines near "Slicing Mode Print Procedure" and
  all of "Gridfinity"; `docs/MODULE_REFERENCE.md` (`m_lid_body()` and
  `m_floor_clip_male()`); `docs/VALIDATION_RULES.md` ("Seam tooth depth" and
  "A sliced lid must be thick enough"); `docs/PARAMETER_REFERENCE.md`
  (`Gridfinity_Edge_Keepout`); `docs/FAQ.md` heading "A preset config.json will
  not load and OpenSCAD reports a type error" (a release 1.4.0 problem).
- **What is wrong.** Statements such as "Releases through 2.0.0-rc.5 hollowed
  the base" help a reader who printed an old release and bury the advice for
  everyone else. They also go stale at every release.
- **Proposed fix.** Move them to `CHANGELOG.md`. Keep one boxed note per page,
  titled "If you printed an older release", that links to the changelog.
- **Confidence:** high that they are there, medium that moving them is right.
  It is a taste call.

### F-12 (site structure) - Proposed

- **Where:** `web/astro.config.mjs`; each page's description.
- **What is wrong (Seen and Crawled).**
  - The sidebar order is "Docs Index", "Options Guide", "Workflows", "Printing".
    A newcomer's order is Preset Library, Printing, Workflows, Options Guide,
    FAQ.
  - The preset library, the main attraction, is a bare link below the reference
    group.
  - "Release" is a maintainer checklist.
  - Every synced page's "Edit page" link points at
    `.../edit/main/web/src/content/docs/<page>.md`. That path is gitignored, so
    it does not exist on `main`. I confirmed with the GitHub contents API that
    `web/src/content/docs/index.md` returns 404.
  - Page descriptions come from the first paragraph. For the landing page that
    is "This site documents the primary model", which is a poor search snippet.
  - The preset page tells the reader to "Load it in the Customizer with -p and
    -P". Those are command-line flags. **Fixed** in
    `web/src/pages/library/[preset].astro`.
- **Proposed fix.**
  1. Reorder the sidebar: "Start" (Preset Library, Printing, Workflows), "Learn"
     (Options Guide, FAQ), "Reference" (the five reference pages).
  2. Add `editUrl` to each page's frontmatter in `web/sync-docs.mjs`, pointing at
     `docs/<FILE>.md`. Verify with a clean `npm ci && npm run build`.
  3. Write a hand-made `description` for the landing page.
- **Confidence:** high for the edit link and the order (Crawled). Medium that
  the new order is better.

### F-13 (options guide gaps) - Proposed

- **Where:** `scripts/build_options_guide.py`, the `SECTIONS` list.
- **What is wrong.** The README headlines the Snap clip, and the options guide
  has no Snap image. It has no `Lid_Lip_Gap` image and no `Print_Layer_Height`
  note. The guide has no short "how to read this page" paragraph: what the
  caption lines mean, that unlisted parameters are at their default, and what
  the colours mean.
- **Proposed fix.** Add scenes `slice-snap` (`Clip_Style=Snap`, `Slice_Count=2`,
  zoomed on one seam) and `slice-tab` (the default, for comparison). Add a
  two-sentence intro to the guide.
- **Confidence:** high (Source).

### F-14 (FAQ shape and one contradictory answer) - Proposed

- **Where:** `docs/FAQ.md`, heading "Can I print the box without supports?"
- **What is wrong.** The answer begins "Yes, at the defaults". It then lists
  three options that change the defaults. A reader cannot tell whether to do
  anything. The FAQ has 41 questions in one flat list, with no grouping.
- **Proposed fix.** Rewrite the answer: "Mostly, at the defaults. Two features
  need a setting: rounded opening tops and a bottom fillet. Set
  `All_Opening_Top_Style=Teardrop` and `Bottom_Edge_Style=Teardrop`." Group the
  questions under five headings: Setup, Fit, Openings and posts, Slicing,
  Gridfinity.
- **Confidence:** high for the contradiction (Source). Medium for the grouping.

### F-15 (duplicated and drifting explanations) - Proposed

- **Where:**
  - The Gridfinity lid explanation appears in `README.md`,
    `docs/PARAMETER_REFERENCE.md`, `docs/PRINTING.md`, `docs/FAQ.md` (four
    questions) and `docs/VALIDATION_RULES.md`.
  - The document list appears in `README.md`, `docs/index.md` and
    `docs/DOCS_INDEX.md`.
  - The baseline printing profile appears in `docs/PRINTING.md` and
    `docs/WORKFLOWS.md`. This pair had **already contradicted itself** on lid
    orientation. **Fixed**: `docs/WORKFLOWS.md` now defers to
    `docs/PRINTING.md`.
  - The list under "Current assertions enforce" in `docs/SCAD_ARCHITECTURE.md`
    omits the lid, edge, relief, magnet and Gridfinity rules that
    `docs/VALIDATION_RULES.md` lists.
- **Proposed fix.** Keep one home per fact. Link from the others. Delete the
  assertion list from `docs/SCAD_ARCHITECTURE.md` and link to the validation
  page.
- **Confidence:** high (Source).

---

## Low severity

- **F-16 (writing-rule breaks, examples only).** Many sentences exceed 25
  words, and many use several modifiers before a noun. I did not rewrite
  them in bulk. Examples to fix first: `docs/PRINTING.md`, "Gridfinity", the
  bullet starting "Two short ceilings remain" (about 70 words);
  `docs/PARAMETER_REFERENCE.md`, the `Gridfinity_Magnet_Depth` row;
  `docs/FAQ.md`, "Why is my Gridfinity lid upside down compared with the box?".
  Confidence: high. This is a style pass for the maintainer to schedule.
- **F-17 (naming).** "Ultimate Cable Box", "Parametric Cable Management Box"
  and "cable box" are three names for one product. See F-05 (landing page: no hero, no call to action).
- **F-18 (README length and order).** The README is 224 lines. Its
  "Validation" section serves contributors and sits before the licence. The
  hero render appears after the install steps, far from the top. Move the
  contributor sections to the end, or to `CONTRIBUTING.md`.
- **F-19 (library render framing).** I measured all nine `box-and-lid` images. The
  part fills between 38 and 78 percent of the frame width, so the same card
  shows `usb-charger` (38), `gridfinity-module` (40) and `desk-compact` (44)
  small beside `surge-strip-6` (78). Frame each preset to a similar fill in
  `scripts/build_library.py`. Confidence: high (Seen and measured).
- **F-20 (`docs/FAQ.md` bare-path mentions).** Several answers named files
  without linking them. **Fixed** for the three I found: `docs/FAQ.md`,
  `docs/PARAMETER_REFERENCE.md` (two) and `docs/SCAD_ARCHITECTURE.md`.
- **F-21 (broken link on the site).** `docs/RELEASE.md` linked
  `internal/E-10_versioning.md`, which returns 404 on the site because
  `docs/internal/` is not published. **Fixed** with an absolute GitHub URL.
  Confidence: high (Crawled: HTTP 404).
- **F-22 (capitalised booleans in the options guide).**
  `docs/OPTIONS_GUIDE.md` showed `Enable_Post=False` and `Closed_Post=True`. OpenSCAD
  spells these `false` and `true`, and the FAQ itself records that
  capitalised booleans broke parameter sets in release 1.4.0. **Fixed** in
  `scripts/build_options_guide.py`, then regenerated with `--no-render`. The
  diff touches only the caption lines and one table row, and no image changed.
- **F-23 (stale wording, fixed).** `docs/WORKFLOWS.md` said the model asserts
  "`height > width` globally". The model asserts only that height and width are
  above zero and that height is at most `Box_Height`. `docs/PRINTING.md` said
  "Until 2.0.0-rc.6" about the old lid orientation, which reads as if rc.6 had
  the new lid. It did not. It now reads "Releases through 2.0.0-rc.6".
  `docs/PRINTING.md` also ran two paragraphs together.

## What is good, and worth protecting

- The FAQ answers carry numbers and parameter names. The "Why did my box get
  bigger" answer is a model of the form.
- `docs/PRINTING.md` gives measured limits (a 15.3 mm disc, a 4 mm ledge), which
  makes it actionable. The fit test box recipe is the best single piece of
  guidance in the set.
- The options guide is the project's strongest asset. Every image has alt text,
  every caption names its parameter, and a standalone HTML copy exists.
- Honesty about Snap clips and about one-printer evidence builds trust.

## Images I recommend adding or replacing

All of these use scripts that exist today. None was generated by hand here.

| Image | Shows | Produced by |
|---|---|---|
| `lid-deep-lip` (replace) | Lid, `CAM_ISO`, lip visible | `scripts/build_options_guide.py`, scene `lid-deep-lip` |
| `wall-thin`, `wall-thick` (replace) | Rim corner, zoomed | same, scenes `wall-*` |
| `edge-*` (replace, four) | Bottom edge on a small box | same, scenes `edge-*` |
| `gf-both-box`, `gf-both-lid` (replace `gf-both`) | Underside, then lid from above | same, scene `gf-both` |
| `slice-snap`, `slice-tab` (new) | One seam in each clip style | same |
| `print-orientation-lid` (new) | Plain lid next to Gridfinity lid, as exported | `scripts/build_readme_images.py` |
| `fit-test-box` (new) | The 50 x 50 x 12 test box and lid | same |
| `side-opening-anchor` (new) | `All_Openings_Up` 0 beside 5 | same |
| `seam-assembled` (new) | Pieces 1 and 2 of a sliced box | same |
| `feature_gridfinity` (replace) | Add an underside view so the feet show | same |

After any render change, run the scripts with `--only <slug>` so the other
images do not churn, because renders are not byte-stable.

## What I did not check, and why

- **Pages other than the landing page as screenshots.** I read their DOM and
  source and crawled their links, but did not view them. Layout problems on
  the long reference pages would not show up in my checks.
- **Mobile layout and dark mode.** Not tested.
- **Library images other than `box-and-lid`.** I viewed the `gridfinity-module`
  set in full and measured the framing of the rest. I did not view every
  `box-only` and `lid-only` image.
- **Interactive parts of the preset library**: the 3D viewer, the bed-size
  filter and the downloads. I confirmed the pages and downloads load (HTTP 200),
  not that they behave.
- **Whether the STL downloads match the model today.** I checked sizes in
  `library/index.json`, not mesh contents. The project's own scripts
  (`scripts/compare_meshes.py`) cover that.
- **Every number in `docs/PRINTING.md` and the FAQ.** I verified the Gridfinity
  constants (4.75 mm base, 5.0 mm lid plate, 42 mm pitch, 15.3 mm socket disc,
  4 mm rim overhang, 1.75 mm plate margin) by arithmetic against the `.scad`.
  I did not verify the 8.9 mm magnet-boss ring or the 0.41 bridge ratio.
- **OpenSCAD on a real machine.** I did not open the application. The F3
  finding rests on OpenSCAD's source, not on a keypress. Please press F3 once in
  2021.01 and tell me if it does something useful.
- **Print outcomes.** I cannot judge whether any guidance produces a good part.
- **`docs/internal/`, `tests/`, `library/` contents, and the `.scad`.** Out of
  scope, and I changed none of them.
- **Bulk sentence-length compliance.** Sampled only (F-16).
- **`npm run build`.** I did not run a site build. My site edit is one
  sentence in an Astro template, and the Markdown edits use link forms
  `sync-docs.mjs` already rewrites. A build in CI will confirm.

## Change log of this pull request

### First pass, before the decisions

Changed directly: F-01 (F3 wording and BOSL2 prerequisite), F-12 (one preset
page sentence), F-15 (workflow orientation), F-20, F-21, F-22, F-23. All edits
are to prose, one Astro template sentence, and one generator script.

### Second pass, after the decisions of 2026-11-14

- **F-05**, landing page rebuilt in "get a box first" order, with the printed
  photo at the top and the hero render between the two task sections. "Local
  Build" moved to `CONTRIBUTING.md`, which gained the `npm ci` warning about
  Astro's Node floor.
- **F-06**, "Print validation status" table added to `docs/PRINTING.md` and
  linked from the landing page's scope notes. Built from `CHANGELOG.md`,
  `docs/internal/BACKLOG.md` and the README photograph, not from the
  user-facing docs alone.
- **F-08**, the caption only. The README said the photographed box was
  printed with `All_Openings_Up=0`, which sits the openings flush with the
  floor. In the photograph the front slot's lower end is well above the floor,
  so the caption now gives `All_Openings_Up=0` as advice rather than as a
  claim about that print. Only the maintainer knows the real setting. The
  wider half of F-08, that one photograph is the whole photographic record,
  still stands.
- **F-17**, not fixed, and the audit was wrong to treat it as a free choice.
  Standardising on the README's "Parametric Cable Management Box" was tried
  and reverted: [`BACKLOG.md`](BACKLOG.md) item 16 records that this is the
  2022 original design's name, and that renaming belongs with the provenance
  checklist in [E-03 (openings array)](E-03_openings-array.md). Picking it
  would have spread an inherited name onto the site header. The landing
  heading is now "Ultimate Cable Box", the short form of the site title, so
  the page no longer calls itself "Documentation" and no new name is
  introduced. The site-wide `description` was rewritten from "Detailed
  technical documentation" to a sentence about the product, which is
  independent of the naming decision.
- **F-12**, the two remaining items. Every synced page now carries an explicit
  `editUrl` pointing at its real source under `docs/`, so "Edit page" no
  longer returns 404; the generated options guide opts out with
  `editUrl: false`. The sidebar is reordered into Start, Change a box, Model
  Reference and Project.
- **F-03**, print guidance added to the README's "Get a box" paragraph and as
  a "Print it" section on every preset page, both linking the printing guide.
- **F-01**, the two leftovers. `docs/WORKFLOWS.md` step 5 now says the default
  export is the box alone, and step 6 says to export the lid.
  `scripts/build_library.py` no longer writes "the Customizer (F3)";
  `library/README.md` was regenerated with `--no-stl --no-png --no-glb`, and
  `library/index.json` and `cable-box-parametric.json` are byte-identical.
- **F-14**, the contradiction only. The FAQ answer about printing without
  supports now says that no part needs support material at the defaults, and
  that the three settings improve short arcs and bridges rather than making
  the model printable. The FAQ is still one flat list of 41 questions.

A side effect of the title change: Starlight builds every `<title>` as
"page | site", so the landing page read "Parametric Cable Management Box |
Parametric Cable Management Box". `sync-docs.mjs` now emits an explicit title
tag for that one page.

### Still proposed, in rough order of value

F-07 and F-10 (the image work, which is the largest remaining item), F-02
(per-piece STLs for the sliced preset), F-09 (move maintainer material out of
the user pages), F-11 (version history out of guidance), F-13 (options guide
gaps), F-14's grouping, F-15's duplication, F-16, F-18, F-19. F-08 needs the
maintainer: only they know what `All_Openings_Up` was set to for the
photographed print.
