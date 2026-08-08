// Regenerate src/content/docs from ../docs, so the repo's docs/ directory
// stays the single source of truth and the site cannot drift from it.
//
// docs/*.md are GitHub-readable and are linked from the README by their repo
// paths, and scripts/build_options_guide.py generates one of them, so they
// cannot simply move here. Copying them by hand instead would mean two
// maintained copies of every page. This script is the third option: the site's
// content directory is a build artifact, wiped and rebuilt from docs/ by the
// predev/prebuild hooks, and is gitignored for the same reason library STLs
// are generated rather than committed by hand.
//
// Transformations per file:
//   - first "# Title" heading becomes frontmatter (Starlight renders it)
//   - links between docs ("FOO.md" or "FOO.md#anchor") become site routes
//   - links to options-guide.html point at the copy served from public/
// Links are relative because the site lives under a GitHub Pages base path:
// "../slug/" from a subpage, "./slug/" from the root index page.

import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const WEB = dirname(fileURLToPath(import.meta.url));
const DOCS = join(WEB, '..', 'docs');
const OUT = join(WEB, 'src', 'content', 'docs');

// filename in docs/ -> site slug. Internal specs (docs/internal/) are
// deliberately absent: they are repo-only.
const PAGES = {
	'index.md': 'index',
	'DOCS_INDEX.md': 'docs-index',
	'OPTIONS_GUIDE.md': 'options-guide',
	'WORKFLOWS.md': 'workflows',
	'PRINTING.md': 'printing',
	'PARAMETER_REFERENCE.md': 'parameter-reference',
	'MODULE_REFERENCE.md': 'module-reference',
	'SCAD_ARCHITECTURE.md': 'scad-architecture',
	'VALIDATION_RULES.md': 'validation-rules',
	'PARAMETER_INTERACTIONS.md': 'parameter-interactions',
	'FAQ.md': 'faq',
	'RELEASE.md': 'release',
};

rmSync(OUT, { recursive: true, force: true });
mkdirSync(OUT, { recursive: true });

for (const [file, slug] of Object.entries(PAGES)) {
	let text = readFileSync(join(DOCS, file), 'utf8');

	const heading = text.match(/^#\s+(.+?)\s*\r?\n/);
	const title = heading ? heading[1] : slug;
	if (heading) text = text.slice(heading[0].length);

	// The root page sits one path segment higher than every other page.
	const prefix = slug === 'index' ? './' : '../';
	for (const [target, targetSlug] of Object.entries(PAGES)) {
		text = text.replaceAll(`](${target})`, `](${prefix}${targetSlug}/)`);
		text = text.replaceAll(`](${target}#`, `](${prefix}${targetSlug}/#`);
	}
	text = text.replaceAll('](options-guide.html)', `](${prefix}options-guide.html)`);

	// The generated preset library lives at the repo root, so docs/ links to it
	// as "../library/". That is already correct twice over: on GitHub it reaches
	// the generated directory, and from any site subpage it reaches the preset
	// browser. Only the root index page sits a segment higher and needs "./".
	if (slug === 'index') text = text.replaceAll('](../library/', '](./library/');

	const out = slug === 'index' ? 'index.md' : `${slug}.md`;
	writeFileSync(
		join(OUT, out),
		`---\ntitle: "${title.replaceAll('"', '\\"')}"\n---\n\n${text.trimStart()}`,
	);
}

// Images referenced relatively from the markdown resolve against the content
// directory, so they live beside the pages and go through Astro's optimizer.
cpSync(join(DOCS, 'images'), join(OUT, 'images'), { recursive: true });

// The self-contained offline guide is served verbatim, not rendered as a page.
cpSync(join(DOCS, 'options-guide.html'), join(WEB, 'public', 'options-guide.html'));

console.log(`sync-docs: ${Object.keys(PAGES).length} pages, images, options-guide.html`);
