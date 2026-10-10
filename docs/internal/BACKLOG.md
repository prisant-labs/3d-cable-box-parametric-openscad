# Backlog

Ideas and known problems that are not yet scoped as an effort. Item numbers are
stable, because effort docs cite them ("backlog item 6 (labels)"); a finished
or moved item keeps its number and says where it went. When an item grows a
spec, it becomes an effort in [the efforts table](README.md#efforts) and this
row points there.

Moved into the repository on 2026-10-02 from a local notes file, so that the
effort docs' references resolve for everyone.

## Features

| # | Handle | Idea | Status |
|---|---|---|---|
| 1 | **Wall cable clips** | Snap-fit clip rails inside the walls, so cables are retained without zip ties. | Open |
| 2 | **Modular divider slots** | Removable divider tracks for separating low-voltage from high-voltage, or signal from power. BOSL2 `dovetail()` fits; see [E-02 (BOSL2 migration)](E-02_bosl2-migration.md). | Open |
| 3 | **Mounting options pack** | Keyhole slots, VHB tape channels, and screw bosses as toggles. | Open |
| 4 | **Vent generator** | Honeycomb or slot ventilation on selected faces, with minimum ligament checks. | Moved to [E-06 (thermal and vents)](E-06_thermal-and-vents.md) |
| 5 | **Grommet seats** | Per-opening grooves for a TPU grommet, for abrasion protection. | Open |
| 6 | **Labels** | Embossed or debossed text on the lid and side walls: name, port, revision. | Open |
| 7 | **Screw-down lid** | Heat-set insert towers or through-hole bosses. Magnets covered the common case; see [E-04 (quick wins)](E-04_quick-wins.md). | Open |
| 8 | **Hinged lid** | Living-hinge or pin-hinge options with a latch toggle. | Open |
| 9 | **Preset library** | Named presets selectable in-file. | Done: [E-07 (preset library)](E-07_preset-library.md), catalogue in v1.2.0 and browser in 2.0.0 |
| 10 | **Calibration coupons** | Tiny test prints for the lid gap and clip fit before a full print. | Done in 2.0.0, then moved out of the repository on 2026-10-06. The coupons are maintainer tooling in `_local/calibration/`, and `PRINTING.md` describes a fit test box instead |
| 11 | **Strain-relief channels** | Curved interior channels that ease cable bend stress near openings. | Open |
| 12 | **Electronics mounting grid** | An internal boss grid for common boards (Raspberry Pi, ESP32, buck converters), with templates. | Open |

## Known problems and open questions

Items 13 to 16 were found by the 2026-10-02 repository audit. Items 17 to 19
were found by printing the 2.0.0-rc.4 calibration coupons on 2026-10-05, and
item 20 by printing the rc.5 coupons on 2026-10-06. Each
item is open unless its last column says otherwise.

| # | Handle | Problem | What decides it |
|---|---|---|---|
| 13 | **Floor clips below the bed** | On a sliced box each male floor clip is 3 mm tall but centred on the 1.85 mm floor (`z_pos = Wall_Thickness / 2` in `m_place_floor_clips`), so 0.575 mm of it hangs below the piece. A slicer that drops the part to the bed leaves the floor 0.575 mm in the air. `snapclip_single_piece_export` and `tabclip_single_piece_export` currently pin that z-min as expected. | **Fixed in 2.0.0-rc.5.** The rc.4 clip coupons confirmed it: the slicer's first layer was the clip footprints alone. The clips now span z 0 to `Clip_Tab_Height`, flush with the floor, and both scenarios pin z-min at 0. The rc.5 reprint confirmed it: every half of both clip pairs printed its whole floor on the bed, without supports. |
| 14 | **Three-slice snap clips** | A three-slice box with snap clips exports edges shared by four faces at y = ±`Inner_Depth/2`, just above the floor, in the middle slice. The probable cause is the clip spacing from `usable_depth` in `m_place_floor_clips`. | Reproduce, fix, and add a scenario that checks the export mesh, since CGAL's summary passes it. |
| 15 | **Gridfinity base seating** | The base under the box is a square 41.5 mm block per cell, hollowed from below. A standard baseplate pocket tapers, so the base may sit on a baseplate rather than drop into it. Not confirmed either way. | The `gridfinity-base-1x1` coupon against a real baseplate. The rc.4 coupon seated in the model's own lid socket, which shows that the two halves agree with each other and says nothing about the standard. The next step is a reference baseplate and 1x1 bin printed from an established generator. **Answered 2026-10-07 by arithmetic: it cannot seat.** The block's square corners reach 29.35 mm from the cell centre, past the pocket's 28.04 mm rounded corner. Moved to [E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md). **Fixed in E-12 phase A (2026-10-08):** solid spec feet, which the suite seats in a spec-built baseplate; a print against a real baseplate is still to come. |
| 16 | **Product name** | The README title, the `.scad` header, and the bundle header still use the 2022 original's name, "Parametric Cable Management Box". The repository and file names already say "cable box parametric". | A naming decision, best taken with the provenance checklist in [E-03 (openings array)](E-03_openings-array.md). |
| 17 | **Lid could not fit** | The lid's lip ring overlapped the outer half of the box wall, so the lid stood on the rim instead of seating. The rc.4 `lid-fit` coupon stacked 19 mm tall instead of 16. The ring formulas were unchanged since 1.0.0. | **Fixed in 2.0.0-rc.5** with `Lid_Style`: a Plug inside the wall (the default, chosen after the rc.5 prints) or a Skirt around the outside. The `assembly_*` scenarios place the lid on the box and fail on any overlap. The rc.5 reprints confirmed it: both styles, with and without magnets, fitted well at the default 0.15 mm gap. |
| 18 | **Gridfinity printability** | Two print problems, separate from fit. The box body overhangs the 41.5 mm base block by about 4 mm on every side, and that ledge printed as loose loops. The lid socket's floor is a 37.45 mm bridge, which printed strung and sagging, and a sagging floor makes the socket shallower. | The rc.5 prints, without supports, showed both again. Standard Gridfinity avoids both: its foot tapers at 45 degrees and is no narrower than the bin above it, and baseplates print with their pockets facing up. Our lid prints face-down so its lip faces up, which puts the socket on the bed, so the lid-top fix is a print-orientation and lip-design question as much as a profile one. Decided by a rebuild to the standard profile, taken together with item 15. **Moved to [E-12 (Gridfinity to spec)](E-12_gridfinity-to-spec.md)** on 2026-10-07: solid spec feet, a footprint rounded up to whole cells, and a pocket-up lid with a solid plug. **The box half is fixed in E-12 phase A (2026-10-08)**; the lid socket waits for phase B. |
| 19 | **Lid seam clips below the bed** | On a sliced lid, `m_place_lid_clips` puts each clip's top at `Lid_Height` and its bottom at `Lid_Height - Clip_Tab_Height`. With `Lid_Height` under `Clip_Tab_Height` (3 mm), the clip hangs below the lid, the same failure as item 13. No assert prevents it, and no preset reaches it. Found by reading the code, not by a print. | An assert, or clips clamped to the slab, with a scenario that fails first. **Moved to [E-13 (seam joints)](E-13_seam-joints.md)** on 2026-10-07. |
| 20 | **Seam alignment** | Both clip styles sit only in the floor and drop in from above, so nothing holds one half level with the other. In the rc.5 prints the halves could slide vertically, and the tab pair's rims did not meet flush. The snap clips work but feel weak. | A joint redesign for boxes larger than the bed, sized for glue as well as a dry fit: dovetail keys in the floor, overlap tabs on the walls, or both. The sliced lid's seam needs the same treatment. **Moved to [E-13 (seam joints)](E-13_seam-joints.md)** on 2026-10-07: a 45 degree sawtooth through the walls, with the floor clips kept. |
| 21 | **Lid edge is round** | `Top_Edge_Chamfer` is documented as chamfering both exposed lid edges, but the lid's slab passes it to `m_edge_treated_shell` as the fillet argument too, so the lid's exposed face gets a round of that radius and only its other face gets a chamfer. The lid prints exposed face down, so that round overhangs the bed the way the box's bottom fillet does. Found by reading the code on 2026-10-09 while building [E-14 (printability options)](E-14_printability-options.md); no print has shown it, and at the default `0` nothing is affected. | A decision on the intended shape. A chamfer matches the docs and prints cleanly. Changing it alters output for lids with `Top_Edge_Chamfer` above 0, so it fits the 2.0.0 series or a later major, and E-12 phase B's lid flip changes which face is on the bed. |
| 22 | **Preview is untested** | Every scenario renders through CGAL, so nothing checks the F5 preview. In E-12 phase A an `intersection()` inside a cutter repeated per hole pushed preview past OpenSCAD's 100,000-element CSG limit, and a box with magnets previewed as an empty scene while every scenario passed. | A smoke step that exports a preview PNG of a feature-heavy configuration and fails on the normalization-abort message. **A manual check is in `docs/RELEASE.md` step 4 since 2026-10-09**; the automated step is still open. |
