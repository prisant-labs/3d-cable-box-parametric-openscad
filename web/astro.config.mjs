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
			// One product name across the README, this site and the landing
			// page. The site previously said "Ultimate Cable Box Parametric
			// OpenSCAD" while the README said "Parametric Cable Management Box"
			// and the landing page said "Ultimate Cable Box Documentation".
			title: 'Parametric Cable Management Box',
			description:
				'A cable box you size to your own gear: an OpenSCAD model with nine ready-to-print presets, configurable openings, and Gridfinity interfaces.',
			social: [
				{
					icon: 'github',
					label: 'GitHub',
					href: 'https://github.com/prisant-labs/3d-cable-box-parametric-openscad',
				},
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
