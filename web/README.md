# Docs site

[Astro Starlight](https://starlight.astro.build/) site publishing the
repository's documentation to GitHub Pages at
<https://prisant-labs.github.io/3d-cable-box-parametric-openscad/>.

The content is not authored here. `sync-docs.mjs` regenerates
`src/content/docs/` from the repo's `docs/` directory before every dev run and
build (via the `predev`/`prebuild` hooks), so `docs/` remains the single source
of truth and the two cannot drift. Edit pages in `docs/`, not here.

```bash
npm ci
npm run dev      # syncs, then serves at http://localhost:4321
npm run build    # syncs, then builds to dist/
```

Deployed by `.github/workflows/docs-pages.yml` on every push to `main`.

- `astro.config.mjs` holds the site title, base path, and sidebar (the former
  `mkdocs.yml` nav).
- `public/options-guide.html` is copied in by the sync and served verbatim as
  the offline single-file guide.
- Internal specs (`docs/internal/`) are deliberately not synced.
