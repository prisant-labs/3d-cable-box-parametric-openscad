# E-09: Testing automation

**Handle:** Testing automation. Automated geometry regression testing beyond
compile checks.

**Effort:** M
**Depends on:** nothing. Should land before
[E-02 (BOSL2 migration)](E-02_bosl2-migration.md).

## The premise this doc pushes back on

The working assumption has been that each feature needs human smoke testing.
That is half right. Physical fit, tolerance, and print quality genuinely require
a human and a printer. But **the defects that actually shipped were all
machine-detectable**, and several were caught in this repo by numeric signals
rather than by looking at anything.

Of the five geometry bugs fixed in v1.1.0:

| Defect | Would a machine have caught it? | By what signal |
|---|---|---|
| Openings delivered half their height | yes | bounding-box or point-probe assertion |
| `Bottom_Openings_Count=0` detached the post | **yes** | solid-body count, and a `DEPRECATED` line nothing was reading |
| Corner radius clamp | yes | non-zero exit code across a parameter sweep |
| `Closed_Post` capped the wrong end | yes | point probe at two coordinates |
| Clip floated over the post bore | **yes** | solid-body count |

Every one exits `0` and produces a valid mesh. None would be caught by "does it
compile". Two of them are invisible in a render unless you already suspect them,
because a detached solid looks completely normal on screen. Those two are
arguably *harder* for a human to catch than for a machine.

## Test pyramid

**Tier 0: compiles and asserts.** What you have. Free. Catches nothing subtle.

**Tier 1: solid-body count.** Parse `Volumes: N` from OpenSCAD's CSG summary;
`N - 1` is the number of disconnected solids. Assert the expected count per
scenario. This alone catches the two worst v1.1.0 bugs, because both manifested
purely as an unexpected extra body. Cheapest high-value test available.

**Tier 2: clean-output assertion.** Fail if stdout contains `WARNING` or
`DEPRECATED`. The `Bottom_Openings_Count=0` bug announced itself with a
`DEPRECATED` range line for months and nothing was reading it.

**Tier 3: point probes.** Boolean-intersect the exported STL with a small cube
and assert material present or absent:

```scad
intersection() {
  import("out.stl", convexity=10);
  translate([x, y, z]) cube([dx, dy, dz]);
}
```

An empty top-level object means no material. This is a precise geometric
assertion needing no mesh library, and it is how `Closed_Post` and the opening
extents were pinned down. Two cautions learned the hard way:

- OpenSCAD on Windows is a native binary and cannot resolve MSYS-style `/tmp`
  paths in `import()`. Use native paths or the test silently passes on an
  empty import.
- Size the probe smaller than the feature. A probe wide enough to clip a
  rounded corner reports material and reads as a false negative.

**Tier 4: bounding box and volume.** Parse the STL for min/max per axis, and
compute mesh volume via the signed-tetrahedron sum. Catches whole-model scaling
errors and "the cut removed twice as much as it should" without knowing where
to probe. `numpy-stl` or `trimesh` if you want a dependency; roughly 30 lines of
Python if you do not.

**Tier 5: manifold and watertightness.** `admesh` or `trimesh.is_watertight`.
Catches meshes a slicer will reject.

**Tier 6: normalised golden geometry.** For refactors that must not change
output, compare the **sorted multiset of coordinates**, not a file hash.

> Do not hash STL files. The same input rendered three times produced three
> different SHA-256 hashes at identical byte length, because OpenSCAD's ASCII
> STL facet ordering is not deterministic between runs. Extracting all numeric
> tokens, sorting them, and hashing that is stable and was used to prove the
> v1.1.0 fixes were geometry-neutral at defaults.

**Tier 7: visual regression.** Render to PNG and perceptually diff against
goldens. Catches what nothing else does, but brittle across OpenSCAD versions
and colour schemes. Lowest priority; consider it a reviewer aid rather than a
gate.

## What still needs a human

- Fit and tolerance: lid engagement, clip snap force, magnet seating.
- Printability: overhangs, bridging over openings, warping, elephant foot.
- Aesthetics.
- Real-world function: does the cable bundle actually fit and route.

Everything else should be a gate in CI. The right split is that a human tests
the *physical* claims once per release, and the machine tests the *geometric*
claims on every push.

## Proposed implementation

A `tests/` directory with a scenario matrix as data, not code:

```
tests/
  scenarios.json        # {name, defines[], expect: {rc, solids, bbox, probes[]}}
  run-tests.sh          # renders each scenario, evaluates expectations
  golden/               # normalised geometry fingerprints for refactor guards
```

Run in CI on push and pull request. Keep it data-driven so adding a scenario is
a JSON entry, not a new script.

## Acceptance criteria

- [ ] Every parameter has at least one boundary scenario (0, 1, max, max+1).
- [ ] Every enum value of every enum parameter is rendered at least once.
- [ ] Solid-body count asserted for all scenarios.
- [ ] Build fails on `WARNING` or `DEPRECATED` in OpenSCAD output.
- [ ] The five v1.1.0 defects each have a regression scenario that fails against
      the v1.0.0 model and passes against current.
- [ ] `scad-smoke` runs on `pull_request`, not only `push`.
- [ ] Test runtime stays under about 5 minutes.

## Note on the existing workflow

`scad-smoke.yml` filters on `paths: ["**/*.scad", ...]`, so a change to the test
scripts themselves does not trigger it. Add `tests/**` and `scripts/**`, or drop
the filter.
