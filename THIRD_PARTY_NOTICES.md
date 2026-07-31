# Third-Party Notices

## BOSL2 (Dependency)

The model depends on BOSL2 rather than embedding it. `cable-box-parametric.scad`
declares `include <BOSL2/std.scad>` and no BOSL2 source is committed here.

- Upstream: https://github.com/BelfrySCAD/BOSL2
- License: BSD 2-Clause
- Copyright: (c) 2017-2019 Revar Desmera and the BOSL2 contributors
- Version pinned in CI: see `BOSL2_REF` in `.github/workflows/scad-smoke.yml`

Install it into your OpenSCAD library folder:

```bash
# Windows and macOS
git clone https://github.com/BelfrySCAD/BOSL2.git ~/Documents/OpenSCAD/libraries/BOSL2

# Linux
git clone https://github.com/BelfrySCAD/BOSL2.git ~/.local/share/OpenSCAD/libraries/BOSL2
```

MakerWorld's parametric customizer bundles BOSL2, so no action is needed there.

### Standalone bundle

Each release attaches a bundle with BOSL2 inlined, for anyone who would rather
not install a library. It is two files, `cable-box-parametric-bundled.scad` plus
`builtins.scad`, which must sit in the same folder.

The sidecar is not an oversight. BOSL2 pulls in `builtins.scad` with `use`
rather than `include` because it wraps OpenSCAD's builtins:

```scad
module _translate(v) translate(v) children();
```

`use` gives that file its own scope, so `translate` resolves to the builtin.
BOSL2's `transforms.scad` defines its own `translate` that calls `_translate`.
Inlining `builtins.scad` textually makes its body resolve to BOSL2's override
instead, and the two recurse into each other. Keeping it a separate `use` file
is what preserves the correct resolution.

The bundled model carries the BSD-2-Clause text for BOSL2 in its own header and
footer, satisfying the attribution requirement for redistribution.

## Gridfinity (Interoperability)

The optional Gridfinity interfaces implement the Gridfinity storage
specification so parts made with this model mate with the wider ecosystem.

- Origin: Gridfinity by Zack Freedman
- License: MIT
- Specification reference: https://gridfinity.xyz/specification/

No Gridfinity code is copied into this repository. The mating geometry is
implemented independently from the published dimensions, deliberately, because
MakerWorld's parametric customizer permits only its own bundled libraries and a
vendored Gridfinity dependency would block publishing there.

## Licensing Interaction Note

Repository-level licensing is `MIT`. Included third-party code remains under its own original license terms, which MIT does not override.
