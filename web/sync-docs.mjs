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
//   - first prose paragraph after that heading becomes a per-page meta
//     description (see firstProseParagraph/pageDescription below); without
//     this every synced page shared one generic description, the site-wide
//     default from astro.config.mjs
//   - links between docs ("FOO.md" or "FOO.md#anchor") become site routes
//   - links to options-guide.html point at the copy served from public/
// Links are relative because the site lives under a GitHub Pages base path:
// "../slug/" from a subpage, "./slug/" from the root index page.

import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

// A paragraph is a run of non-blank lines. One whose FIRST line looks like a
// heading, list item, blockquote, image, table row, code fence, raw HTML or
// MDX directive is structure, not prose, and the whole paragraph is skipped.
// Checking only the first line -- not every line in the run -- is what keeps
// a wrapped list item's continuation line (indented, no leading marker of its
// own) from being mistaken for the start of a new paragraph.
// A list marker needs a following space, so a paragraph that opens with
// bold text ("**Note.** ...") still counts as prose.
const SKIP_PARAGRAPH_RE = /^(#|>|!|-\s|\*\s|\+\s|\d+\.|\||```|<|:::)/;

/** The first prose paragraph in a docs/*.md body, or null if there is none
 *  (every paragraph is structure, as in a page that is all headings and
 *  lists) -- an OPTIONS_GUIDE.md generated oddly is this script's problem to
 *  accept, not to fix. */
function firstProseParagraph(body) {
	for (const block of body.split(/\r?\n[ \t]*\r?\n/)) {
		const trimmed = block.trim();
		if (!trimmed || SKIP_PARAGRAPH_RE.test(trimmed)) continue;
		return trimmed.replace(/\s+/g, ' ');
	}
	return null;
}

/** Markdown inline syntax reduced to the text a reader would read aloud:
 *  links and images keep their link/alt text, code spans and emphasis keep
 *  their contents, and the markers are dropped. Order matters: images before
 *  links, since an image is `![alt](url)` and the link pattern alone would
 *  otherwise leave a stray "!" in front of the alt text. */
function stripMarkdown(text) {
	return text
		.replace(/!\[([^\]]*)\]\([^)]*\)/g, '$1')
		.replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
		.replace(/`([^`]*)`/g, '$1')
		.replace(/\*\*([^*]*)\*\*/g, '$1')
		.replace(/__([^_]*)__/g, '$1')
		.replace(/\*([^*]*)\*/g, '$1')
		.replace(/_([^_]*)_/g, '$1')
		.replace(/\s+/g, ' ')
		.trim();
}

const DESCRIPTION_MAX = 155;

/** Truncate at a word boundary to about DESCRIPTION_MAX characters, adding
 *  one ellipsis only when truncation actually happened. */
function truncateDescription(text) {
	if (text.length <= DESCRIPTION_MAX) return text;
	const cut = text.slice(0, DESCRIPTION_MAX);
	const lastSpace = cut.lastIndexOf(' ');
	const base = (lastSpace > 0 ? cut.slice(0, lastSpace) : cut).replace(/[.,;:!?-]+$/, '');
	return `${base}…`;
}

/** Frontmatter `description` for one synced page, or null to omit the key
 *  (Starlight then falls back to the site-wide description). */
function pageDescription(body) {
	const para = firstProseParagraph(body);
	if (!para) return null;
	const stripped = stripMarkdown(para);
	return stripped ? truncateDescription(stripped) : null;
}

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
	const description = pageDescription(text);

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
	// JSON.stringify's quoting (escaped backslashes, quotes and control
	// characters inside a double-quoted string) is also valid YAML, and safer
	// than the ad hoc quote-escaping above for text pulled from prose rather
	// than typed as a title.
	const frontmatter = description
		? `title: "${title.replaceAll('"', '\\"')}"\ndescription: ${JSON.stringify(description)}\n`
		: `title: "${title.replaceAll('"', '\\"')}"\n`;
	writeFileSync(
		join(OUT, out),
		`---\n${frontmatter}---\n\n${text.trimStart()}`,
	);
}

// Images referenced relatively from the markdown resolve against the content
// directory, so they live beside the pages and go through Astro's optimizer.
cpSync(join(DOCS, 'images'), join(OUT, 'images'), { recursive: true });

// The self-contained offline guide is served verbatim, not rendered as a page.
cpSync(join(DOCS, 'options-guide.html'), join(WEB, 'public', 'options-guide.html'));

console.log(`sync-docs: ${Object.keys(PAGES).length} pages, images, options-guide.html`);
