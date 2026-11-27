# Documentation audit, second pass: legibility and visuals, 27 November 2026

A second pass over the documentation and the site, for human readers and for
coding agents, weighted towards how the material reads and what it shows.

This does not repeat
[the first pass](DOCS_AUDIT_2026-11.md). That audit checked accuracy, links,
anchors and the newcomer path, and its findings F-01 to F-23 stand as written.
It listed what it could not cover: pages other than the landing page as
screenshots, mobile layout, dark mode, the behaviour of the preset library, and
anything under `docs/internal/`. Those gaps are this pass's remit, and they are
where every finding below comes from.

Findings continue the first pass's numbering, from F-24.

## Verdict

The writing is in good order and the preset library is genuinely good. The
weakness is that almost every image is working against the reader rather than
for them.

- **The landing page paints empty.** The hero photograph is lazy-loaded, so the
  first screen a visitor sees is a heading, one sentence and whitespace. The
  page is well built underneath that.
- **The galleries do not survive a phone.** The nine-preset gallery is one
  composite image with its captions baked in. At 375 px each cell is about
  80 px wide and its caption cannot be read. An agent reading the page gets one
  alt attribute for nine presets.
- **Every render is a white slab on the dark theme.** The options guide shows
  54 of them.
- **The options guide shows one image per screen where the point is
  comparison.** Several of the first pass's F-07 complaints are layout problems
  rather than camera problems. A 1.5 mm fillet is invisible alone and plain
  beside the unfilleted default.
- **The agent entry point omits the three documents that explain the model's
  shape.** `AGENTS.md` names none of `SCAD_ARCHITECTURE.md`,
  `MODULE_REFERENCE.md` or `PARAMETER_INTERACTIONS.md`.
- **The heaviest reference pages carry no image at all.** Eight of the thirteen
  documentation pages have none, and they are the text-heavy ones.

## How this was checked

| Tag | Meaning |
|---|---|
| **Seen** | I viewed the rendered page or the image myself. |
| **Measured** | I counted it from the files. |
| **Source** | I read it in the repository only. |

Coverage: the live site at `84f2690`, viewed as screenshots on the landing
page, the options guide, the parameter reference, the parameter interactions
page, the preset library and the `gridfinity-module` preset page. The landing
page was viewed in both colour schemes and at 375 px. Image attributes were
read from the live DOM.

## High severity

### F-24 (the landing page paints an empty first screen)

- **Where:** the hero photograph in `docs/index.md`, as served.
- **What is wrong.** The image carries `loading="lazy"`, because Starlight
  lazy-loads every Markdown image. On a fresh load the first screen is the
  title, one sentence and nothing else. I hit this myself and first recorded it
  as a missing hero, which was wrong: the photograph is there, and it is the
  right photograph. It simply arrives late.
- **It is not layout shift.** The element carries `width="1600"` and
  `height="1077"`, so the space is reserved. The cost is the first impression,
  not a jump.
- **Fix.** Mark the first image of the landing page `loading="eager"` with
  `fetchpriority="high"`. In Starlight that means either an image component in
  the template or a small rehype step in `web/sync-docs.mjs` that rewrites the
  first `<img>` of `index.md`.
- **Confidence: high.** Seen twice, in dark and light schemes, and the
  attribute was read from the DOM.

### F-25 (the composite galleries fail on a phone and tell an agent nothing)

- **Where:** `showcase_presets.png` and `showcase_variations.png` in
  `docs/index.md`.
- **What is wrong.** Each gallery is a single image with its captions drawn
  into the pixels. Three consequences follow. At 375 px the nine-preset
  composite renders about 240 px wide, so each cell is roughly 80 px and the
  preset names below them are an unreadable smear. The cells are not links, so
  a reader who sees "Six-outlet surge protector" cannot click it. One alt
  attribute, "The nine presets, each a box beside its lid, drawn at one scale",
  is all that an agent or a screen reader receives for nine products.
- **Fix.** Keep the composite and add a Markdown list of the nine presets under
  it, each name linking to its library page. That costs nine lines, works on
  GitHub and on the site, and gives the phone reader and the agent the names.
  It respects decision 2 of the first pass, which chose plain Markdown over
  Starlight's `<CardGrid>` because `docs/` is the source of truth.
- **Confidence: high.** Seen at 375 px; attributes read from the DOM.

### F-26 (every render is a white slab on the dark theme)

- **Where:** `docs/images/`, `docs/images/options/`, and the preset card
  thumbnails.
- **What is wrong.** The renders carry an off-white background. The site's dark
  theme is near-black, so each image is a bright rectangle with hard edges. The
  options guide stacks 54 of them. In the light scheme the same images look
  correct, so this is a dark-theme defect rather than a bad render.
- **Fix.** Render with a transparent background and let the page show through,
  which OpenSCAD supports through the colour scheme, or post-process the PNGs
  to transparency in `scripts/build_options_guide.py` and
  `scripts/build_library.py`. A transparent render also removes the need to
  pick a background that suits both themes.
- **Confidence: high.** Seen in both schemes on three different pages.

### F-27 (the options guide cannot show a comparison)

- **Where:** `docs/OPTIONS_GUIDE.md` and `docs/options-guide.html`.
- **What is wrong.** Every render is full content width and roughly 450 px
  tall, one per section, so the page is a very long single-file scroll. Many
  sections exist to compare values: wall thickness has two, corner radius has
  three, the bottom edge treatments have four. The reader cannot see two of
  them at once, and the difference between them is often a fraction of a
  millimetre.
- **Why this matters beyond layout.** Several entries in the first pass's F-07
  (images that do not show what their caption names) are this problem wearing a
  different hat. `wall-thin` and `wall-thick` look identical because a 1.2 mm
  and a 3.0 mm wall look identical at box scale, and `edge-fillet` shows no
  fillet because 1.5 mm on a 100 mm box is nothing. Side by side, with the same
  camera, both differences read without any new camera work.
- **Fix.** Group a parameter's variants into one row at half or third width.
  This shortens the page, makes the comparison possible, and is cheaper than
  the per-scene zoom that F-07 proposes, which needs an opt-out from the
  `--viewall --autocenter` that `render()` always passes.
- **Confidence: high** on the layout, **medium** on how many F-07 entries it
  closes. I did not re-render anything to prove it.

## Medium severity

### F-28 (the 3D preview renders as a white blob)

- **Where:** the `<model-viewer>` preview on each preset page.
- **What is wrong.** The viewer works. It loads the GLB, reports the printed
  envelope and accepts orbit and zoom. The model itself renders nearly
  shadeless, so on `gridfinity-module` the box and lid read as two white
  shapes. The feet, the openings and the lid pockets are not visible. The
  card thumbnail on the library page, made by OpenSCAD, shows all of them.
  The parts also sit small inside a tall frame.
- **Fix.** Give `<model-viewer>` an environment image and a shadow, and tighten
  the frame to the model's aspect. The page already knows the envelope, so the
  frame can follow it.
- **Confidence: high** that it reads as a blob, which I saw. **Low** on the
  cause: I did not read the component's attributes.
- This closes one item the first pass could not check, which was whether the
  library's interactive parts behave. The filters, the part switcher, the
  viewer and the downloads all work.

### F-29 (the agent entry point omits the architecture documents)

- **Where:** `AGENTS.md`, which `CLAUDE.md` imports.
- **What is wrong.** The file is otherwise a good briefing: a command table,
  the model rules, the versioning rules and the planning-document convention.
  It names `docs/VALIDATION_RULES.md`, `docs/PARAMETER_REFERENCE.md` and
  `docs/RELEASE.md`. It names none of `docs/SCAD_ARCHITECTURE.md`,
  `docs/MODULE_REFERENCE.md` or `docs/PARAMETER_INTERACTIONS.md`. An agent
  asked to change geometry therefore has no pointer to the render flow, the
  module list or the cross-parameter rules, and the obvious alternative is to
  read a 141 KB `.scad` from the top.
- **Fix.** One short "Where things are" block in `AGENTS.md`, naming those
  three with a clause each.
- **Confidence: high.** `grep -c` over `AGENTS.md` returns zero for all three.

### F-30 (the pages carrying the most text carry no visuals)

- **Measured**, counting images, words and table rows per page:

| Page | Words | Table rows | Images |
|---|---|---|---|
| `PARAMETER_REFERENCE.md` | 6,306 | 207 | 0 |
| `VALIDATION_RULES.md` | 3,563 | 0 | 0 |
| `FAQ.md` | 2,718 | 0 | 1 |
| `MODULE_REFERENCE.md` | 2,298 | 11 | 0 |
| `PARAMETER_INTERACTIONS.md` | 1,024 | 0 | 0 |
| `SCAD_ARCHITECTURE.md` | 698 | 0 | 0 |

- **What is wrong.** Eight of the thirteen pages carry no image. The two worst
  cases are the ones whose subject is a relationship rather than a value.
  `SCAD_ARCHITECTURE.md` describes the render flow in 698 words of prose, and a
  flow is the thing a diagram carries best. `PARAMETER_INTERACTIONS.md` lists
  which parameters constrain which, which is a graph. `VALIDATION_RULES.md`
  spends 3,563 words on assertions without a single table, although each
  assertion has the same three parts: what trips it, which parameter caused it,
  and how to resolve it.
- **Fix, in order of value.** One flow diagram in `SCAD_ARCHITECTURE.md`. One
  constraint diagram in `PARAMETER_INTERACTIONS.md`. A table at the top of
  `VALIDATION_RULES.md` with one row per assertion, keeping the prose beneath
  it. The first pass's F-10 (images missing where prose carries the load) asks
  for images on the user-facing pages; this is the same request pointed at the
  reference set.
- **Confidence: high** on the counts. **Medium** on the priority order, which
  is a judgement about who reads these pages.

### F-31 (the FAQ is forty-one flat questions)

- **Measured:** 41 level-two headings over 2,718 words, with no grouping.
- **What is wrong.** A reader scanning for their problem has 41 equal-weight
  headings and no way to narrow by topic. The first pass's F-14 (FAQ shape and
  one contradictory answer) proposed grouping and is still open. This pass adds
  only the number.
- **Fix.** Group under four or five level-two headings, demote the questions to
  level three, and keep the wording.

## Low severity

### F-32 (the release checklist assumes OpenSCAD is on PATH)

- **Where:** `docs/RELEASE.md`, step 4, the preview render command.
- **What is wrong.** The command begins with a bare `openscad`. On a machine
  where OpenSCAD is installed but not on PATH, it fails with
  `openscad: command not found`. I hit this running the step verbatim during
  the 2.0.0 release. The escape hatch exists and is documented, in
  `docs/FAQ.md` and `docs/WORKFLOWS.md`, as the `OPENSCAD_BIN` variable that
  `tests/run_tests.py` honours.
- **Fix.** One sentence under the command pointing at `OPENSCAD_BIN`.
- **Confidence: high.** I hit it and then found the variable by grep.

## What is good, and worth protecting

- **Alt text is complete.** Every image in `docs/index.md`, `README.md`,
  `docs/PRINTING.md` and `docs/OPTIONS_GUIDE.md` carries alt text: 3, 9, 4 and
  54 images, all covered. That is rare and it is what makes the pages usable to
  an agent at all.
- **The preset library is the best thing on the site.** It has a real card
  grid, filters that work and report "9 of 9", feature chips, a part switcher
  and a working 3D viewer with per-part downloads and sizes.
- **`DOCS_INDEX.md` is accurate.** It names 21 paths and every one resolves.
  Nothing in `docs/` is missing from it.
- **The landing page order works.** Photograph, "Get a box", "Change a box",
  then reference. Decision 2 of the first pass was right.
- **`AGENTS.md` is a good briefing in every respect except F-29.** The command
  table in particular saves an agent from guessing.

## What I did not check, and why

- **Print outcomes.** No document here can be judged by rendering.
- **Eight of the nine preset pages.** I viewed `gridfinity-module` only.
- **Tablet width.** I checked 375 px and the desktop pane, not the middle.
- **`docs/options-guide.html`,** the offline single-file build. The first pass
  found its images byte-identical to `docs/images/options/`, so F-26 and F-27
  apply to it, but I did not open it.
- **Screen readers and keyboard navigation.** Alt text is present; I did not
  test focus order or landmarks.
- **Page weight and loading time as numbers.** F-24 is an observation about
  what paints first, not a measurement.
- **The WASM playground** of
  [E-08 (web customizer)](E-08_web-customizer.md), which is not built.

## Suggested order of work

1. F-24, the eager hero. One attribute, and it changes the first impression.
2. F-29, the three links in `AGENTS.md`. Five minutes.
3. F-25, the preset list under the gallery. Nine lines.
4. F-26, transparent renders. One change in two generators, then a rebuild.
5. F-27 together with the first pass's F-07, which is the real image work.
6. F-30 and F-31, the diagrams and the FAQ grouping.
