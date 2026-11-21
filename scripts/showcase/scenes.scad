// Showcase scenes for the docs: the parts together, which the model itself
// never draws. full_render() lays the box and lid side by side, the way they
// print. These scenes show them the way they are used: closed, cut open, and
// pulled apart.
//
// scripts/build_readme_images.py renders this file with
// -D Render_On_Include=false, so the include defines the modules and draws
// nothing. It then picks a scene with -D Scene="...". Any model parameter can
// be set with -D alongside it, exactly as for the model.
//
// Nothing here is printed or tested. It is a camera rig, so it reuses the
// model's own modules and placement rather than restating any geometry.
include <../../cable-box-parametric.scad>

Scene = "closed"; // ["closed", "section", "section-magnets", "exploded", "exploded-sliced"]

// How far the exploded views pull the parts apart.
Explode_Gap = 30;

// The lid is modelled as it prints, lip up. Turned over and lowered by this
// much, its slab face sits SPACER above the rim and its lip reaches into the
// box, which is the placement tests/assembly/lid_seated.scad checks. A
// Gridfinity lid is modelled the same way, with its plate below z = 0, so the
// same transform seats it with the plate on top.
module lid_in_use(lift = 0) {
    up(Gridfinity_Base_Offset + Box_Height + Lid_Height + SPACER + lift)
        mirror([0, 0, 1])
            m_lid();
}

module box_in_use() {
    m_box_placed() m_box_with_openings();
}

module closed() {
    box_in_use();
    lid_in_use();
}

// Removes everything in front of the plane y = at, so the camera looks at the
// cut face. The cutter is sized to the parts plus a margin, not made huge: a
// 2000 mm cutter stopped the preview drawing the difference at all.
//
// The cutter is coloured, because the preview paints the cut faces from it.
// Left uncoloured, they come out the same orange as the post. Separate
// cutters for the box and the lid do not give them separate colours in
// OpenSCAD 2021.01, so the 0.15 mm gap between lip and wall does not show at
// any useful zoom; these views show how the parts meet, not the clearance.
COLOR_CUT = "#F4D35E";

module cut_front(at = 0) {
    w = Lid_Outer_Width + 20;
    h = Box_Total_Height + Lid_Total_Height + 20;
    difference() {
        children();
        color(COLOR_CUT)
            translate([-w / 2, at - Lid_Outer_Depth, -10]) cube([w, Lid_Outer_Depth, h]);
    }
}

module closed_cut(at = 0) {
    cut_front(at) closed();
}

// The y of the two back magnet bosses, as m_magnet_corner_positions() places
// them.
function magnet_row_y() =
    Box_Depth_Effective / 2 - Wall_Thickness - Magnet_Boss_Diameter / 2 + WELD;

// The same x layout as full_render()'s sliced preview, spread wider so each
// seam shows.
function spread_x(i, w) =
    (i - 1) * (w + Explode_Gap) - (Slice_Count - 1) * (w + Explode_Gap) / 2;

if (Scene == "closed") {
    closed();
} else if (Scene == "section") {
    closed_cut(0);
} else if (Scene == "section-magnets") {
    closed_cut(magnet_row_y());
} else if (Scene == "exploded") {
    box_in_use();
    lid_in_use(Explode_Gap);
} else if (Scene == "exploded-sliced") {
    assert(Enable_Slicing, "exploded-sliced needs Enable_Slicing=true");
    for (i = [1:Slice_Count]) {
        translate([spread_x(i, Slice_Width), 0, 0])
            m_box_placed() m_box_slice(i);
        translate([spread_x(i, Lid_Outer_Width / Slice_Count), 0,
                   Gridfinity_Base_Offset + Box_Height + Lid_Height + SPACER + Explode_Gap])
            mirror([0, 0, 1]) m_lid_slice(i);
    }
}
