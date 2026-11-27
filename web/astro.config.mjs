// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// GitHub Pages project site: served under /<repo>/, so `base` is required and
// internal links in the content use relative paths to stay under it.
//
// `site` is the custom domain, not the github.io host the repo is actually
// hosted from: the org's Pages site answers to projects.prisantlabs.com, and
// prisant-labs.github.io/3d-cable-box-parametric-openscad/ 301-redirects
// there. Astro bakes `site` into the canonical link, og:url and the sitemap,
// so pointing it at the github.io host would make every one of those lie
// about where the page actually lives.
export default defineConfig({
	site: 'https://projects.prisantlabs.com',
	base: '/3d-cable-box-parametric-openscad',
	integrations: [
		starlight({
			// The project still answers to two names, which the docs audit
			// raised as F-17. Resolving it is backlog item 16: the README's
			// "Parametric Cable Management Box" is the 2022 original design's
			// name, so picking it would spread an inherited name rather than
			// settle anything. The decision belongs with the provenance
			// checklist in E-03 (openings array). Until then this title stands
			// and the landing page uses its shorter form.
			title: 'Ultimate Cable Box Parametric OpenSCAD',
			// Every image in docs/ is a render on an off-white background, so
			// on the dark theme a bare one is a white slab. This gives each a
			// panel, matching what docs/options-guide.html already does. See
			// F-26 in docs/internal/DOCS_AUDIT_2026-11_visuals.md.
			customCss: ['./src/styles/docs.css'],
			description:
				'A cable box you size to your own gear: an OpenSCAD model with nine ready-to-print presets, configurable openings, and Gridfinity interfaces.',
			social: [
				{
					icon: 'github',
					label: 'GitHub',
					href: 'https://github.com/prisant-labs/3d-cable-box-parametric-openscad',
				},
			],
			// The image chat apps and social sites show when someone shares a
			// link to the site. Starlight sets the title and description itself
			// but no image, so shared links showed a bare text card. The file is
			// rendered by scripts/build_readme_images.py and copied to public/ by
			// sync-docs.mjs. Crawlers need an absolute URL.
			head: [
				{
					tag: 'meta',
					attrs: {
						property: 'og:image',
						content:
							'https://projects.prisantlabs.com/3d-cable-box-parametric-openscad/social-card.png',
					},
				},
				{ tag: 'meta', attrs: { property: 'og:image:width', content: '1200' } },
				{ tag: 'meta', attrs: { property: 'og:image:height', content: '630' } },
				{
					tag: 'meta',
					attrs: {
						property: 'og:image:alt',
						content: 'A rendered cable box and its lid, side by side',
					},
				},
				{ tag: 'meta', attrs: { name: 'twitter:card', content: 'summary_large_image' } },
			],
			editLink: {
				baseUrl:
					'https://github.com/prisant-labs/3d-cable-box-parametric-openscad/edit/main/web/',
			},
			// Ordered the way a newcomer arrives: get a part, print it, then
			// change it. The reference pages answer questions that come later,
			// so they sit last. This mirrors the order of docs/index.md, and
			// replaces the former mkdocs.yml nav, which opened with the docs
			// index and the parameter reference.
			sidebar: [
				{
					label: 'Start',
					items: [
						// A custom page rather than a content-collection entry, so it
						// is linked by path. Everything under /library/ is generated
						// from library/index.json at build time.
						{ label: 'Preset Library', link: '/library/' },
						{ label: 'Printing', slug: 'printing' },
					],
				},
				{
					label: 'Change a box',
					items: [
						{ label: 'Workflows', slug: 'workflows' },
						{ label: 'Options Guide', slug: 'options-guide' },
						{ label: 'FAQ', slug: 'faq' },
					],
				},
				{
					label: 'Model Reference',
					items: [
						{ label: 'Parameter Reference', slug: 'parameter-reference' },
						{ label: 'Parameter Interactions', slug: 'parameter-interactions' },
						{ label: 'Validation Rules', slug: 'validation-rules' },
						{ label: 'Module Reference', slug: 'module-reference' },
						{ label: 'SCAD Architecture', slug: 'scad-architecture' },
					],
				},
				{
					label: 'Project',
					items: [
						{ label: 'Docs Index', slug: 'docs-index' },
						{ label: 'Release', slug: 'release' },
					],
				},
			],
		}),
	],
});
