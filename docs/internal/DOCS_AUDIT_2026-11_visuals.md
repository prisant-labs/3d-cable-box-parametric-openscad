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

Findings continue the first pass's numbering, from F-24. Where a finding here
touches one of its findings, it says so rather than renumbering.

## Verdict

The writing is in good order, the preset library is genuinely good, and the
offline options guide is better built than the site that replaced it. The
weakness is the site's presentation of images.

- **The landing page shows a blank gap where the hero should be.** Fourteen
  seconds of viewing, across four loads, never caught the photograph painting
  on arrival. The space is reserved, so nothing jumps; it simply stays empty.
- **The site does not give an image the treatment the offline guide already
  gives it.** `docs/options-guide.html` puts every render in a bordered figure
  with a light backing and arranges them in a responsive grid, in both colour
  schemes. The Starlight site does neither, so the same images are bare white
  slabs stacked one per screen.
- **The gallery cells are not links,** and nine presets share one alt
  attribute, so neither a phone reader nor an agent can act on them.
- **The agent entry point omitted the three documents that explain the model's
  shape.** `AGENTS.md` named none of `SCAD_ARCHITECTURE.md`,
  `MODULE_REFERENCE.md` or `PARAMETER_INTERACTIONS.md`.
- **The reference pages carry no visuals at all,** including the two whose
  subject is a relationship rather than a value.

## How this was checked

| Tag | Meaning |
|---|---|
| **Seen** | I viewed the rendered page or the image myself, at full scale. |
| **Measured** | I read it from the live DOM, or counted it from the files. |
| **Source** | I read it in the repository only. |

Coverage: the live site, viewed as screenshots on the landing page, the options
guide, the parameter reference, the parameter interactions page, the preset
library and the `gridfinity-module` preset page. The landing page was viewed in
both colour schemes and at 375 px. Element sizes came from
`getBoundingClientRect()` rather than from a screenshot, after a first pass
misread a scaled screenshot. The site has deployed from `84f2690`; nothing in
that commit changes a site page, so these pages are as they were at `b88ec42`.

## High severity

### F-24 (the landing page shows a blank gap where the hero should be)

- **Where:** the hero photograph in `docs/index.md`, as served.
- **What is wrong.** On a fresh load the first screen is the title, one
  sentence, and a reserved but empty rectangle. I caught this four times: twice
  on a desktop viewport in each colour scheme, and once at 375 px after a
  four-second wait, where `naturalWidth` was still `0` for every image on the
  page.
- **It is not layout shift.** The element carries `width="1600"` and
  `height="1077"`, so the space is held. The cost is the first impression.
- **Likely cause, inferred.** Every image on the page carries
  `loading="lazy"`, which is Starlight's default for a Markdown image. That is
  right for the two galleries and wrong for the first image on the page.
- **Fix.** Mark the landing page's first image `loading="eager"` with
  `fetchpriority="high"`. In Starlight that means an image component in the
  template, or a small rehype step in `web/sync-docs.mjs` that rewrites the
  first `<img>` of `index.md` only.
- **Confidence: high** that the gap appears, which I saw four times.
  **Medium** on the cause: I read the attribute but did not measure the
  request with resource timing, so I cannot prove the attribute is what delays
  it.

### F-25 (the gallery cells are not links, and nine presets share one alt text)

- **Where:** `showcase_presets.png` and `showcase_variations.png` in
  `docs/index.md`.
- **What is wrong.** Each gallery is one image with its captions drawn into
  the pixels. Two consequences are permanent. The cells are not links, so a
  reader who sees "Six-outlet surge protector" cannot click through to it. One
  alt attribute, "The nine presets, each a box beside its lid, drawn at one
  scale", is everything an agent or a screen reader receives about nine
  products.
- **A correction to my own first reading.** I first wrote that the captions
  were unreadable on a phone. They are not. Measured, the image is 343 px wide
  in a 375 px viewport, so each of the nine cells is about 114 px and its
  caption is small but legible. My "unreadable" came from reading a scaled
  screenshot rather than the pixels. The type is at the edge of comfort, not
  past it.
- **Fix.** Keep the composite and list the nine presets under it, each name
  linking to its library page. That works on GitHub and on the site, and gives
  the agent and the screen reader the names. It respects decision 2 of the
  first pass, which chose plain Markdown over Starlight's `<CardGrid>` because
  `docs/` is the source of truth. **Done in this change.**
- **Confidence: high.** Measured from the DOM.

### F-26 (the site does not give an image the treatment its own offline guide does)

- **Where:** every rendered image on the Starlight site, against
  `docs/options-guide.html`.
- **What is wrong.** The renders have an off-white background. On the site's
  near-black dark theme each one is a bare bright rectangle with hard edges,
  and the options guide stacks 54 of them. In the light scheme they look
  correct, so this is about presentation, not about the renders.
- **The repository already contains the fix.** The offline guide styles every
  image as a figure with a surface background and a one-pixel border, and sets
  the image's own backing per scheme:

  ```css
  figure img { background: #f7f7f7 }
  @media (prefers-color-scheme: dark) { figure img { background: #eee } }
  ```

  A bordered card reads as a deliberate panel. A bare image on a black page
  reads as a hole.
- **Fix.** Give synced images the same figure treatment on the site, in CSS.
  Nothing needs re-rendering. **Done in this change**, as
  `web/src/styles/docs.css`, registered through Starlight's `customCss`. The
  mount carries the theme and the render does not, because the renders are
  opaque and only the padding ring shows the background. A first attempt set
  that ring to the render's own off-white, which drew no frame and changed
  nothing on screen; the second sets it to a Starlight surface token, so a
  white render reads as a framed plate rather than a hole. Verified on a local
  build in both colour schemes.
- **What it does not do.** The page is still mostly white rectangles. A frame
  improves how they sit on the page; it does not change the renders. That is
  the first pass's F-07.
- **Do not reach for a transparent background.** The model renders dark slate,
  so a transparent image on the dark theme would be dark on dark, which is
  worse than the slab. I also did not confirm that OpenSCAD 2021.01 can export
  an alpha channel at all.
- **Confidence: high** on the problem and on the offline guide's treatment,
  both read directly. **Medium** on the CSS fix, which I did not build.

### F-27 (the site stacks the options guide one image per screen; the offline guide does not)

- **Where:** `docs/OPTIONS_GUIDE.md` as served by the site.
- **What is wrong.** Each render is full content width and roughly 450 px
  tall, one per section, so 54 of them make a very long scroll. Many sections
  exist to compare values: wall thickness has two, corner radius three, the
  bottom edge treatments four. The reader cannot see two at once, and the
  difference between them is often a fraction of a millimetre.
- **The offline guide already solves this**, with a responsive grid:

  ```css
  .grid { display: grid; gap: 20px;
          grid-template-columns: repeat(auto-fill, minmax(min(100%, 320px), 1fr)) }
  ```

  So this finding is about the Markdown page and the site only. A first draft
  of this audit said it applied to the offline guide as well, on the grounds
  that the images are byte-identical. Identical images say nothing about
  layout, and that was wrong.
- **Why this matters beyond layout.** Part of the first pass's F-07 (images
  that do not show what their caption names) is this problem wearing a
  different hat. `wall-thin` and `wall-thick` look identical because a 1.2 mm
  and a 3.0 mm wall are identical at box scale. Side by side at the same
  camera, the difference reads without any new camera work.
- **Fix.** Group a parameter's variants into one row on the site, as the
  offline guide does. **Not done, and not doable in CSS alone.** Each variant
  is a flat run of siblings, an `h3`, a paragraph holding a code span and a
  paragraph holding the image, with nothing wrapping the three. A grid needs a
  wrapper per variant. There is also no per-page hook to scope the rule to
  this page: Astro hashes the asset filenames, so the `images/options/` path a
  selector would key on is gone from the built markup. The route is a rehype
  step in `web/sync-docs.mjs` that wraps each variant for this page only.
- **Confidence: high** on both layouts, read from the generator and seen on
  the site. **Medium** on how many F-07 entries it closes, since I re-rendered
  nothing.

## Medium severity

### F-28 (the 3D preview renders almost shadeless)

- **Where:** the `<model-viewer>` preview on each preset page.
- **What is wrong.** The viewer works. It loads the GLB, reports the printed
  envelope, offers a part switcher and accepts orbit and zoom. The model
  renders with very little shading. On `gridfinity-module`, viewed at full
  scale after fourteen seconds, the lid's three-by-two cells are faintly
  visible as outlines and the box reads as a featureless white wedge: no
  openings, no feet. The OpenSCAD thumbnail on the library card shows all of
  them. The two parts also occupy about a third of the frame's height.
- **This is not the withdrawn F-19.** That finding was about the library's
  still renders, whose fixed camera distance is deliberate so the grid reads as
  a size comparison. This is the interactive viewer's own lighting and frame.
- **Fix.** Give `<model-viewer>` an environment image and a shadow, and tighten
  the frame. The page already knows the envelope, so the frame can follow it.
- **Confidence: high** that it reads as a blob, seen at full scale. **Low** on
  the cause: I did not read the component's attributes.
- This closes one item the first pass could not check. The filters, which
  report "9 of 9", the part switcher, the viewer and the downloads all behave.

### F-29 (the agent entry point omitted the architecture documents)

- **Where:** `AGENTS.md`, which `CLAUDE.md` imports.
- **What is wrong.** The file is otherwise a good briefing: a command table,
  the model rules, the versioning rules and the planning-document convention.
  It named `docs/VALIDATION_RULES.md`, `docs/PARAMETER_REFERENCE.md` and
  `docs/RELEASE.md`, and none of `docs/SCAD_ARCHITECTURE.md`,
  `docs/MODULE_REFERENCE.md` or `docs/PARAMETER_INTERACTIONS.md`. An agent
  asked to change geometry therefore had no pointer to the render flow, the
  module list or the cross-parameter rules, and the obvious alternative is to
  read a 141 KB `.scad` from the top.
- **Fix.** A "Where things are" table in `AGENTS.md`, one row per question.
  **Done in this change**, and each row was checked against its document.
- **Confidence: high.** `grep -c` over `AGENTS.md` returned zero for all three.

### F-30 (the reference pages carry no visuals)

- **Measured** with a pattern that catches every Markdown image, after a
  narrower one undercounted:

| Page | Words | Images | Table rows | Code fences |
|---|---|---|---|---|
| `PARAMETER_REFERENCE.md` | 6,306 | 0 | 207 | 2 |
| `VALIDATION_RULES.md` | 3,563 | 0 | 0 | 76 |
| `MODULE_REFERENCE.md` | 2,298 | 0 | 11 | 2 |
| `PARAMETER_INTERACTIONS.md` | 1,024 | 0 | 0 | 0 |
| `SCAD_ARCHITECTURE.md` | 698 | 0 | 0 | 0 |

  No page in `docs/` contains an `<img>` tag or a Mermaid block, so these
  counts are the whole picture. The README is not in this finding; the first
  pass's F-18 covers its length and order.

- **The two worth fixing describe a relationship, not a value.**
  `SCAD_ARCHITECTURE.md` lists the file's seven-part order and then states the
  axis conventions in prose, including that the front opening's offset runs
  toward `+X` while the back opening's runs toward `-X`. A reader will misread
  that sentence and would not misread a labelled sketch.
  `PARAMETER_INTERACTIONS.md` is 1,024 words describing which parameters
  constrain which, which is a graph.
- **`VALIDATION_RULES.md` is better than its shape suggests.** Each rule is a
  heading, the assertion in a `scad` block, then "Why:" and "Fix:", grouped by
  subsystem. The gap is not structure but lookup: a reader who hits an
  assertion message has 601 lines to scan. A table at the top mapping message
  to section would close that without touching the prose.
- **Fix, in order of value.** A flow and axes diagram in
  `SCAD_ARCHITECTURE.md`. A constraint diagram in
  `PARAMETER_INTERACTIONS.md`. A lookup table at the top of
  `VALIDATION_RULES.md`.
- **Confidence: high** on the counts, **medium** on the priority, which is a
  judgement about who reads these pages.

### F-31 (the FAQ is forty-one flat questions)

- **Measured:** 41 level-two headings over 2,718 words, with no grouping.
- **What is wrong.** A reader scanning for their problem meets 41
  equal-weight headings and no way to narrow by topic. The first pass's F-14
  (FAQ shape and one contradictory answer) proposed grouping and is still
  open. This pass adds only the number.
- **Fix.** Group under four or five level-two headings, demote the questions
  to level three, keep the wording.

## Low severity

### F-32 (the release checklist assumes OpenSCAD is on PATH)

- **Where:** `docs/RELEASE.md`, step 4, the preview render command.
- **What is wrong.** The command begins with a bare `openscad` and fails with
  `openscad: command not found` where OpenSCAD is installed but not on PATH. I
  hit this running the step verbatim during the 2.0.0 release. The escape
  hatch exists and is documented, as the `OPENSCAD_BIN` variable, in
  `docs/FAQ.md` and `docs/WORKFLOWS.md`.
- **Fix.** One sentence under the command. **Done in this change.**

## What is good, and worth protecting

- **Alt text is complete.** Every image in `docs/index.md`, `README.md`,
  `docs/PRINTING.md` and `docs/OPTIONS_GUIDE.md` carries it: 3, 9, 4 and 54
  images. That is what makes these pages usable to an agent at all.
- **The offline options guide is the best-built artefact in the set.** It has
  a responsive grid, a figure treatment that survives both colour schemes, its
  own theme toggle, and print rules that stop a figure breaking across pages.
  Two of this audit's findings are really a request to bring the site up to it.
- **The preset library is the best part of the site.** A real card grid,
  filters that work and report their count, feature chips, a part switcher,
  and a 3D viewer with per-part downloads and sizes.
- **`DOCS_INDEX.md` is accurate.** It names 21 paths and every one resolves.
- **The landing page order works.** Photograph, "Get a box", "Change a box",
  then reference. Decision 2 of the first pass was right.

## What I did not check, and why

- **Print outcomes.** No document here can be judged by rendering.
- **Eight of the nine preset pages.** I viewed `gridfinity-module` only.
- **Tablet width.** I checked 375 px and the desktop pane, not the middle.
- **The offline guide rendered.** I read its CSS and markup, and did not open
  the file in a browser.
- **Screen readers and keyboard navigation.** Alt text is present; focus order
  and landmarks are untested.
- **Loading time as numbers.** F-24 reports what paints, not a measurement.
- **The WASM playground** of
  [E-08 (web customizer)](E-08_web-customizer.md), which is not built.

## Suggested order of work

1. F-24, the eager hero. One attribute, and it changes the first impression.
2. ~~F-26, the figure treatment.~~ Done in this change.
3. F-27, the grid for the options guide, which needs a wrapper per variant in
   `sync-docs.mjs` before any CSS can place them.
4. The first pass's F-07, the remaining image work, and the only part that
   re-renders anything.
5. F-28, the viewer's lighting and frame.
6. F-30 and F-31, the diagrams, the lookup table and the FAQ grouping.
