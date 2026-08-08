// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// GitHub Pages project site: served under /<repo>/, so `base` is required and
// internal links in the content use relative paths to stay under it.
export default defineConfig({
	site: 'https://prisant-labs.github.io',
	base: '/3d-cable-box-parametric-openscad',
	integrations: [
		starlight({
			title: 'Ultimate Cable Box Parametric OpenSCAD',
			description: 'Detailed technical documentation for cable-box-parametric.scad',
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
			// Mirrors the former mkdocs.yml nav.
			sidebar: [
				{
					label: 'Getting Started',
					items: [
						{ label: 'Docs Index', slug: 'docs-index' },
						{ label: 'Options Guide', slug: 'options-guide' },
						{ label: 'Workflows', slug: 'workflows' },
						{ label: 'Printing', slug: 'printing' },
					],
				},
				{
					label: 'Model Reference',
					items: [
						{ label: 'Parameter Reference', slug: 'parameter-reference' },
						{ label: 'Module Reference', slug: 'module-reference' },
						{ label: 'SCAD Architecture', slug: 'scad-architecture' },
						{ label: 'Validation Rules', slug: 'validation-rules' },
						{ label: 'Parameter Interactions', slug: 'parameter-interactions' },
					],
				},
				// A custom page rather than a content-collection entry, so it is
				// linked by path. Everything under /library/ is generated from
				// library/index.json at build time.
				{ label: 'Preset Library', link: '/library/' },
				{ label: 'FAQ', slug: 'faq' },
				{ label: 'Release', slug: 'release' },
			],
		}),
	],
});
