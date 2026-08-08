# E-10: Versioning

**Handle:** Versioning. Version scheme, pre-release flow during development, and
traceability from an exported STL back to source.

**Status:** Shipped in v1.1.1 (2026-07-29). `Model_Version` is echoed at
render and `scripts/check-version.sh` fails the build when it disagrees with
the changelog or a tag. The pre-release flow described here has been used
twice: `v1.2.0-rc.1`, and `v2.0.0-rc.1`/`rc.2`.

**Effort:** S
**Depends on:** nothing. Pairs with
[E-09 (testing automation)](E-09_testing-automation.md).

## What the version actually promises

For a library you version the API. For a parametric model, **the parameter set
is the API and the output geometry is the return value**. That gives a clean
rule:

| Change | Bump | Reason |
|---|---|---|
| Add a parameter with a default that preserves existing output | minor | purely additive |
| Rename or remove a parameter | **major** | saved presets stop loading |
| Change what an existing parameter *means* | **major** | saved presets load and silently produce different geometry, the worst outcome |
| Fix geometry that was clearly broken, output changes for unchanged inputs | **major** in strict SemVer | see below |
| Fix geometry with no output change for any valid input | patch | |
| Docs, CI, repo structure | patch | |

The third row is the dangerous one, because the failure is silent. A preset that
errors is annoying; a preset that loads and quietly produces a different object
is how someone wastes filament.

## An honest note about v1.1.0

v1.1.0 changed the meaning of `All_Openings_Up` and the per-side
`Move_Opening_*_Up` values from "offset a cut centred on the box floor" to
"height of the opening's bottom edge above the floor". Under the rule above that
is a **major** change and should have been `2.0.0`. It shipped as a minor with
the break called out in the changelog and commit body.

Given the repo had zero external users at the time, the practical harm is nil.
But the precedent is worth naming rather than quietly repeating: decide now
whether this project follows strict SemVer, and if so, the next equivalent
change takes a major bump.

Recommendation: **follow strict SemVer and accept fast major numbers.** For a
model where a wrong version silently produces the wrong physical object, a
scary-looking `4.0.0` is cheaper than a surprise. Major numbers are free.

## Versioning while in development

The problem is wanting testable artifacts without promising stability.

**Recommended flow**

1. Feature work on a branch, no version bump.
2. When it needs a physical print test, tag a **pre-release**:
   `v1.2.0-rc.1`, published as a GitHub prerelease with STL assets attached.
   Prereleases do not show as "Latest" and do not mislead.
3. Iterate `-rc.2`, `-rc.3` as print tests come back.
4. On acceptance, tag `v1.2.0` and publish a normal release.

This matters more than usual here because the feedback loop includes a printer.
An rc tag gives you a stable, downloadable, citable artifact to print, so notes
like "the clip is too tight" attach to something specific rather than to
"whatever was on main that afternoon".

**Do not** use `0.x` at this point. You have a public 1.x with released
artifacts; going backwards would be more confusing than a fast major.

## Traceability from artifact to source

A parametric model is distributed as loose files. An STL someone downloaded
eighteen months ago has nothing in it identifying what produced it, which makes
"my lid does not fit" unanswerable.

**Proposal: a `Model_Version` constant in the SCAD, echoed at render.**

```scad
/* [Hidden] */
Model_Version = "1.1.0";
echo(str("cable-box-parametric ", Model_Version));
```

Benefits:

- The version appears in the OpenSCAD console and therefore in CI logs and in
  any bug report that pastes them.
- CI can assert it matches the git tag on a release build, so the two cannot
  drift.
- It can be written into generated preset `config.json` files, giving library
  artifacts provenance.

Cost: one more thing to bump. Automate it in the release step rather than
relying on memory, and have CI fail the release if `Model_Version`, the tag, and
the top `CHANGELOG.md` section disagree.

Consider also embossing the version on the box underside behind a toggle,
defaulting to off. Cheap once labels exist (backlog item 6), and it makes a
printed object self-identifying.

## Release checklist additions

`docs/RELEASE.md` currently ends at "Tag release" and never mentions publishing
a GitHub Release or cutting the changelog section. Add:

- [ ] `Model_Version`, git tag, and top `CHANGELOG.md` section all agree.
- [ ] Changelog section renamed from `[Unreleased]` to the version with a date.
- [ ] Library preset artifacts regenerated against the released model.
- [ ] GitHub Release published with the `.scad` and STL assets attached.
- [ ] Breaking changes called out in the release notes, not only the changelog.

## Acceptance criteria

- [ ] Versioning rules written into `CONTRIBUTING.md` where contributors see them.
- [ ] `Model_Version` present and echoed.
- [ ] CI asserts version, tag, and changelog agreement on tag builds.
- [ ] `docs/RELEASE.md` updated with the items above.
