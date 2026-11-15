# FAQ

## Which OpenSCAD version should I use?

Use a current stable OpenSCAD release (2021.01+ recommended).

## I only want numeric entry fields in Customizer. Are sliders required?

No. This project intentionally avoids numeric slider range annotations in the primary parameter block so typed values and step arrows are the main input method.

## Why do my lid and box not fit well?

Tune `Lid_Lip_Gap` in `0.05 mm` increments and print a short calibration pair. Printer, material, and cooling profile all affect final fit.

## What is a good starting value for `Lid_Lip_Gap`?

The default `0.15` is a clearance on each side of the wall the lid fits against. It fitted well with both lid styles on a Bambu Lab P1S printing PLA+. Other printers and materials differ, so print a [fit test box](PRINTING.md#fit-test-box) and adjust in `0.05 mm` steps. PETG and ABS often need slightly larger values.

## Why are my side openings not where I expect?

Global offsets (`All_Openings_Right`, `All_Openings_Up`) combine with each side-local move parameter. Reset one layer of offsets to zero and re-apply intentionally.

Vertically, openings are anchored at their **bottom edge**. The default `All_Openings_Up=5` lifts that edge 5 mm above the box floor. Set `All_Openings_Up=0` to place it flush with the box bottom, so a cable lying on the desk passes straight in without climbing a lip. To centre an opening in the wall instead, set `All_Openings_Up` to `(Box_Height - All_Opening_Height) / 2`.

## How tall is my opening really?

Exactly `All_Opening_Height` (or the per-side override). Earlier builds centred the cut on the box floor, so half of it fell below the model and the visible opening was only half the requested height. That is fixed; if you previously compensated by doubling the height or by setting `All_Openings_Up`, revisit those values.

## Which way is positive for side-local opening move values?

- `Move_Opening_Front_to_Right`: positive moves right (`+X`)
- `Move_Opening_Back_to_Right`: positive moves left (`-X`)
- `Move_Opening_Right_to_Right`: positive moves toward back (`+Y`)
- `Move_Opening_Left_to_Right`: positive moves toward front (`-Y`)

## Why are my side override sizes not applied?

Side override width/height values apply only when greater than `0`. A value of `0` means "use global opening size".

## Why do I get an assertion failure about opening height and width?

`All_Opening_Height` and `All_Opening_Width` must both be greater than `0`.
Either dimension can be larger (vertical, horizontal, or square opening profiles are allowed).

## Why are bottom openings colliding with the center post?

Enable both `Enable_Post=true` and `Bottom_Opening_Avoid_Post=true` so the model splits openings around the center clearance region.

## What do `Bottom_Opening_Axis` and `Bottom_Opening_Orientation` each control?

- `Bottom_Opening_Axis`: where openings are arranged as a sequence.
- `Bottom_Opening_Orientation`: rotation of each individual opening shape.

## What does bottom-opening secondary `Custom` alignment do?

Secondary `Custom` centers the opening line inside the custom margin window on the perpendicular axis (left/right window for `Along Y`, front/back window for `Along X`).

## Why does `Bottom_Opening_Spacing=0` look different from a fixed number?

`0` enables auto spacing derived from alignment mode and available room. Any positive number forces explicit spacing.

## My stabilizers overlap side openings. How do I prevent that?

Use the relevant avoid toggles:

- `Stabilizer_Avoid_Front_Opening`
- `Stabilizer_Avoid_Back_Opening`
- `Stabilizer_Avoid_Left_Opening`
- `Stabilizer_Avoid_Right_Opening`

Then adjust stabilizer counts/margins.

## What does stabilizer `Custom` alignment do?

`Custom` uses the custom margins as bounds and attempts fixed-pitch placement from the start margin. The pitch is `Stabilizer_Width + Stabilizer_FB_Spacing` for front/back walls and `Stabilizer_Width + Stabilizer_LR_Spacing` for left/right walls. If that pattern does not fit inside the margins, it falls back to distributed placement within the same bounds.

## What does `Closed_Post` do?

With `Closed_Post=false` (the default) the post is a tube open at both ends, so cables can be routed down through it and out of the box floor.

With `Closed_Post=true` the bore starts above the floor, leaving a solid base `Wall_Thickness` thick. Use this when you want the post purely as a cable-wrapping core and do not want debris or cable ends dropping through onto the desk.

The post's top is open in both modes.

## When should I use slicing mode?

Use slicing when full-size parts exceed your printer bed limits or when you want smaller printable modules that snap together.

The pieces push together along each seam. Floor clips keep them in line, and a 45 degree sawtooth through the walls keeps them level, so the rims meet flush. `Seam_Tooth_Depth` sets the teeth's depth, and `0` gives a flat seam. For a permanent box, glue the tooth faces.

## How do I export slices correctly?

1. Set `Enable_Slicing=true`.
2. Set `Slice_Count`.
3. Set `Slice_Piece_To_Render` to `1..Slice_Count`.
4. Export each index as an STL.

Use `Slice_Piece_To_Render=0` only for multi-part preview.

## Why did I get an assertion failure for slice/clip parameters?

The model enforces:

- `Slice_Piece_To_Render` is an integer in `0..Slice_Count`
- `Slice_Count >= 2` when slicing is enabled
- `Clips_Per_Edge >= 1` when slicing is enabled
- `Clip_Tolerance >= 0`
- `Seam_Tooth_Depth >= 0`, and less than half a slice width minus `Clip_Tolerance`, when slicing is enabled
- `Lid_Height` at least `Clip_Tab_Height` plus 0.04 mm when slicing is enabled, so the lid's seam clips stay inside the lid
- Clip tab width/depth/height all `> 0`

## How do I run automated OpenSCAD smoke checks?

- GitHub Actions: `.github/workflows/scad-smoke.yml`
- Windows local: `scripts/scad-smoke.ps1`
- Linux/macOS local: `bash scripts/scad-smoke.sh`
- Bash fallback: set `OPENSCAD_BIN` if `openscad` is not on PATH.

The smoke set includes an expected-fail assertion case to guard invalid slicing input.

## Slice clips are too tight. What should I change first?

Increase `Clip_Tolerance` by `0.05` and test one seam before reprinting all pieces.

## Slice clips are too loose. What should I change first?

Decrease `Clip_Tolerance` in small steps and retest. You can also increase `Clip_Tab_Width` or clip count for more retention.

## Can I disable the center post entirely?

Yes. Set `Enable_Post=false`.

## Is there somewhere I can browse the presets before downloading?

Yes. The [preset library](../library/) on the docs site shows all nine with a 3D
view of each part you can orbit, the parameters that define it, and downloads
for STL, GLB and `config.json`. It filters by printer bed size and by feature,
so you can narrow to what actually fits your machine.

The same catalogue is available as data at `library/index.json` if you want to
script against it. Everything there is generated from the model by
`scripts/build_library.py`, so a preset cannot drift from the geometry.

## What is the GLB file next to each STL?

The 3D preview format the docs site uses. `<model-viewer>` reads glTF and not
STL, and a GLB is roughly a tenth the size of the same mesh as ASCII STL. Print
the STL; the GLB is for looking at.

## The lid is very hard to get off. What can I do?

Three options, cheapest first.

1. Increase `Lid_Lip_Gap` in `0.05 mm` steps. It is a friction fit, and
   the default `0.15` has been confirmed on one printer so far.
2. Set `Lid_Relief_Style` to `Scallop` or `Tab`. That adds finger purchase to
   the lid edge: a scallop is a concave groove and does not change the outer
   size, a tab is a protruding grip and is more effective. Choose walls with
   `Lid_Relief_On_Left` and friends.
3. If the problem is that the lid falls off rather than sticks, that is the
   opposite fix: see `Enable_Lid_Magnets` below.

## How do the lid magnets work?

`Enable_Lid_Magnets` cuts a pocket in the box and a matching pocket in the lid
at each of the four inside corners, so a magnet in each holds the lid shut.
Corners rather than the rim, because the rim is only `Wall_Thickness` wide
(1.85 mm by default) and a 6 mm magnet does not fit in it.

`Lid_Magnet_Diameter` defaults to `6.2` for a nominal 6 mm magnet.
`Lid_Magnet_Depth` is the depth in *each* half, and each pocket takes its own
magnet: at the default `2.4`, one magnet per pocket, up to 2.4 mm thick.

**Insert the magnets with opposing poles facing.** The pockets are symmetric so
they align however the lid goes on, which also means the model cannot enforce
polarity for you. Glue one pair at a time and check attraction before the
adhesive sets.

## My box edges are sharp. Can they be rounded?

`Bottom_Edge_Fillet` rounds the outer bottom edge and `Top_Edge_Chamfer`
chamfers the top rim and the lid edges. Both are `0` by default, so nothing
changes until you ask.

Keep the bottom fillet modest. It is the first thing printed, and a large one
becomes an overhang on the opening layers; around `1.0` is a good starting
point. If those layers curl, set `Bottom_Edge_Style` to `Teardrop`, which keeps
the rounded look but meets the bed at 45 degrees, or to `Chamfer`, a plain 45
degree bevel. `Bottom_Edge_Fillet` sets the size for all three styles. Both
treatments are ignored where a Gridfinity interface owns the face, because
those profiles have to match the standard.

## Can I print the box without supports?

Yes. At the defaults no part needs support material, because every face
either stands on the bed or rises at 45 degrees or steeper. What remains is a
handful of short arcs and bridges, which print unsupported but can sag. Two
settings replace those arcs with 45 degree flanks, and a third makes the
magnet bridging land on your real layers:

- `All_Opening_Top_Style=Teardrop` replaces the flat top of each rounded side
  opening with 45 degree flanks and a short flat cap. The opening keeps its
  typed width and height.
- `Bottom_Edge_Style=Teardrop` or `Chamfer` makes a bottom edge treatment meet
  the bed at 45 degrees instead of curling under.
- `Print_Layer_Height` should match the layer height you slice at when the
  Gridfinity base has magnets, so the two bridging steps above each pocket
  print as separate layers.

All three keep today's shapes by default, so a saved preset renders exactly as
before. The [Printing guide](PRINTING.md) has the details.

## How do I load one of the presets?

Open `cable-box-parametric.scad`, then open the Customizer from the `Window`
menu. All nine presets appear in the Customizer's preset dropdown, because `cable-box-parametric.json` sits next to
the model and OpenSCAD reads parameter sets from it.

From the command line:

```bash
openscad -o out.stl cable-box-parametric.scad \
  -p cable-box-parametric.json -P desk-compact
```

Each preset also keeps its own copy at `library/<preset>/config.json`, which
takes the same `-p` and `-P` arguments.

## A preset config.json will not load and OpenSCAD reports a type error

If you see:

```
ERROR: Cannot apply Parameter Set 'conversion of data to type "b" failed'
```

you have a `config.json` from release 1.4.0 or earlier. Boolean values were
written capitalised (`"True"`) where the format requires `"true"`, and OpenSCAD
rejects the whole parameter set rather than skipping the bad value. It affected
`gridfinity-module`, `surge-strip-6-sliced` and `under-desk-passthrough`. Fixed
in 1.4.1: take the current files, or lowercase the booleans by hand.

## Where should reusable preset builds and assets go?

`library/` holds the curated presets, but everything in it is generated. Add an
entry to `PRESETS` in `scripts/build_library.py` and rerun it rather than adding
files by hand.

## Where should community-created variants go?

Use `community/` for user-contributed builds, remixes, and showcase assets.

## What license applies to this repository?

`MIT` for project content, with third-party portions retaining their original licenses (see `THIRD_PARTY_NOTICES.md`).

## Can this box work with Gridfinity?

Yes, in two independent ways, and they are opposite halves of the same joint.

`Enable_Gridfinity_Bottom` puts solid Gridfinity feet under the box, built to
the spec's profile, so it drops into a 42 mm baseplate. The footprint rounds up
to whole cells, so the default `100 x 75` box becomes `125.5 x 83.5`.

`Enable_Gridfinity_Lid_Top` puts a Gridfinity **baseplate** on the lid's exposed
face: a plate with pockets cut into it to the spec's own profile, so bins or
another box sit on the closed box. Pockets rather than studs, because the lid
inverts in use and studs would end up pointing at the ceiling with nothing able
to rest on them. It adds 5.0 mm to the closed height, and the lid is exported
turned over so those pockets print facing up.

Turn on either, both, or neither. Both together gives a box that sits in a
baseplate and is itself a baseplate, and the lid then carries exactly the cells
the base does, so one box stacks squarely on another.

Both halves follow the spec's profile, and the test suite checks each against
the other half built from the spec's own numbers: the model's feet in a
spec baseplate, and a spec foot in the model's lid. It also stacks one whole
box on another. Test a one-cell
[fit test box](PRINTING.md#fit-test-box) against real Gridfinity parts before
you print a full box.

## Why does Gridfinity require `Closed_Post`?

An open post bores through the box floor. A Gridfinity base sits directly under
that floor and would block the bore, so the model asserts rather than producing
a passage that goes nowhere. Set `Closed_Post=true`, or turn the post off.

## Why did my box get bigger when I turned on the Gridfinity base?

The base rounds the footprint up to whole cells: each side becomes the smallest
`(N - 1) * 42 + 41.5` mm that holds what you typed. A box wider than its feet
would overhang them, and on a baseplate that overhang blocks the neighbouring
cells anyway, so rounding up costs no desk space. The model echoes the size it
built in the OpenSCAD console. To keep the box close to a size you have in
mind, type the nearest whole-cell size: `41.5`, `83.5`, `125.5`, `167.5`, and
so on.

## I enabled the Gridfinity lid top but nothing appeared

The lid is probably too small for a single 42 mm cell once
`Gridfinity_Edge_Keepout` is taken off each side. The model says so via `echo`
in the OpenSCAD console. At the default `4 mm` keepout the lid needs roughly
`50 mm` in both directions for one cell.

The keepout only decides this when the base is off. With
`Enable_Gridfinity_Bottom` on, the lid takes the base's cell count instead, and
the base always makes at least one cell.

## Why is my Gridfinity lid upside down compared with the box?

It is not upside down; it is the right way up for printing. A lid with
`Enable_Gridfinity_Lid_Top` exports turned over, so its pockets face up and
print with nothing bridging across them. The face resting on the bed is the one
that ends up inside the closed box. Print it as exported, then turn it over to
put it on the box.

The flip is also why that lid's plug is solid rather than a ring: the plug's
face is on the bed, and a hollow ring there would leave the panel above it
bridging the whole box opening. A solid plug prints as infill, so it costs
little filament.

## My lid's corner cells open through the side of the lid

Your `Box_Corner_Radius` is rounder than the corner cells leave room for. With
the base on, only about `1.75 mm` of plate sits beside the outermost pockets,
and past roughly `10 mm` the lid's corner arc turns in further than the
pocket's does.

The model reports this and carries on, because the lid is still one solid and
every cell still takes a bin. It is not fixed by trimming the pocket: a pocket
is the female half, and one cut back to the lid's outline would stop accepting
a standard foot in that cell. Reduce `Box_Corner_Radius` to the figure the
message gives if you want the corners closed.

## Does enabling Gridfinity shrink the inside of my box?

No. The base is added below the box rather than carved out of the floor, so
`Box_Height` still describes the box body and interior volume is unchanged.
Total printed height grows by `4.75 mm` for the base, and the lid grows by
`5.0 mm` for the lid-top baseplate.

The lid top does take a little of the box's interior, though not its volume:
with `Enable_Gridfinity_Lid_Top` on, the plug is filled solid, so the top
`Lid_Lip_Gap_Height` of the box is occupied by lid rather than by a ring around
its edge. Stabilizer fins must stop below that band, which the model checks.
