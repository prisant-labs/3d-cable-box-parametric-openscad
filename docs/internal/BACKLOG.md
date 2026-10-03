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
| 10 | **Calibration coupons** | Tiny test prints for the lid gap and clip fit before a full print. | Done in 2.0.0: [`calibration/`](../../calibration/README.md), eight coupons |
| 11 | **Strain-relief channels** | Curved interior channels that ease cable bend stress near openings. | Open |
| 12 | **Electronics mounting grid** | An internal boss grid for common boards (Raspberry Pi, ESP32, buck converters), with templates. | Open |

## Known problems and open questions

Each of these was found by the 2026-10-02 repository audit and is still open.

| # | Handle | Problem | What decides it |
|---|---|---|---|
| 13 | **Floor clips below the bed** | On a sliced box each male floor clip is 3 mm tall but centred on the 1.85 mm floor (`z_pos = Wall_Thickness / 2` in `m_place_floor_clips`), so 0.575 mm of it hangs below the piece. A slicer that drops the part to the bed leaves the floor 0.575 mm in the air. `snapclip_single_piece_export` and `tabclip_single_piece_export` currently pin that z-min as expected. | A design change to the floor clip, then a print of the clip coupons. Changes sliced geometry, so it needs a versioning call under [E-10 (versioning)](E-10_versioning.md). |
| 14 | **Three-slice snap clips** | A three-slice box with snap clips exports edges shared by four faces at y = ±`Inner_Depth/2`, just above the floor, in the middle slice. The probable cause is the clip spacing from `usable_depth` in `m_place_floor_clips`. | Reproduce, fix, and add a scenario that checks the export mesh, since CGAL's summary passes it. |
| 15 | **Gridfinity base seating** | The base under the box is a square 41.5 mm block per cell, hollowed from below. A standard baseplate pocket tapers, so the base may sit on a baseplate rather than drop into it. Not confirmed either way. | The `gridfinity-base-1x1` coupon against a real baseplate. |
| 16 | **Product name** | The README title, the `.scad` header, and the bundle header still use the 2022 original's name, "Parametric Cable Management Box". The repository and file names already say "cable box parametric". | A naming decision, best taken with the provenance checklist in [E-03 (openings array)](E-03_openings-array.md). |
