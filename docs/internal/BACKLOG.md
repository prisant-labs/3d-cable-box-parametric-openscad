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
| 10 | **Calibration coupons** | Tiny test prints for the lid gap and clip fit before a full print. | Done in 2.0.0: [`calibration/`](../../calibration/README.md), ten coupons |
| 11 | **Strain-relief channels** | Curved interior channels that ease cable bend stress near openings. | Open |
| 12 | **Electronics mounting grid** | An internal boss grid for common boards (Raspberry Pi, ESP32, buck converters), with templates. | Open |

## Known problems and open questions

Items 13 to 16 were found by the 2026-10-02 repository audit. Items 17 to 19
were found by printing the 2.0.0-rc.4 calibration coupons on 2026-10-05. Each
item is open unless its last column says otherwise.

| # | Handle | Problem | What decides it |
|---|---|---|---|
| 13 | **Floor clips below the bed** | On a sliced box each male floor clip is 3 mm tall but centred on the 1.85 mm floor (`z_pos = Wall_Thickness / 2` in `m_place_floor_clips`), so 0.575 mm of it hangs below the piece. A slicer that drops the part to the bed leaves the floor 0.575 mm in the air. `snapclip_single_piece_export` and `tabclip_single_piece_export` currently pin that z-min as expected. | **Fixed in 2.0.0-rc.5.** The rc.4 clip coupons confirmed it: the slicer's first layer was the clip footprints alone. The clips now span z 0 to `Clip_Tab_Height`, flush with the floor, and both scenarios pin z-min at 0. Reprint the clip coupons to confirm. |
| 14 | **Three-slice snap clips** | A three-slice box with snap clips exports edges shared by four faces at y = ±`Inner_Depth/2`, just above the floor, in the middle slice. The probable cause is the clip spacing from `usable_depth` in `m_place_floor_clips`. | Reproduce, fix, and add a scenario that checks the export mesh, since CGAL's summary passes it. |
| 15 | **Gridfinity base seating** | The base under the box is a square 41.5 mm block per cell, hollowed from below. A standard baseplate pocket tapers, so the base may sit on a baseplate rather than drop into it. Not confirmed either way. | The `gridfinity-base-1x1` coupon against a real baseplate. The rc.4 coupon seated in the model's own lid socket, which shows that the two halves agree with each other and says nothing about the standard. The next step is a reference baseplate and 1x1 bin printed from an established generator. |
| 16 | **Product name** | The README title, the `.scad` header, and the bundle header still use the 2022 original's name, "Parametric Cable Management Box". The repository and file names already say "cable box parametric". | A naming decision, best taken with the provenance checklist in [E-03 (openings array)](E-03_openings-array.md). |
| 17 | **Lid could not fit** | The lid's lip ring overlapped the outer half of the box wall, so the lid stood on the rim instead of seating. The rc.4 `lid-fit` coupon stacked 19 mm tall instead of 16. The ring formulas were unchanged since 1.0.0. | **Fixed in 2.0.0-rc.5** with `Lid_Style`: a Skirt around the outside (the default) or a Plug inside the wall. The `assembly_*` scenarios place the lid on the box and fail on any overlap. Reprint `lid-fit` and `lid-fit-plug` to tune `Lid_Lip_Gap`. |
| 18 | **Gridfinity printability** | Two print problems, separate from fit. The box body overhangs the 41.5 mm base block by about 4 mm on every side, and that ledge printed as loose loops. The lid socket's floor is a 37.45 mm bridge, which printed strung and sagging, and a sagging floor makes the socket shallower. | A 45 degree transition between base and box, taken together with any base-profile change from item 15. For the socket, a bridge-friendly floor or a documented support setting. |
| 19 | **Lid seam clips below the bed** | On a sliced lid, `m_place_lid_clips` puts each clip's top at `Lid_Height` and its bottom at `Lid_Height - Clip_Tab_Height`. With `Lid_Height` under `Clip_Tab_Height` (3 mm), the clip hangs below the lid, the same failure as item 13. No assert prevents it, and no preset reaches it. Found by reading the code, not by a print. | An assert, or clips clamped to the slab, with a scenario that fails first. |
