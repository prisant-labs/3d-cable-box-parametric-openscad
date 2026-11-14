// Assembly test: one box stacked on another box's lid.
//
// This is the whole point of having both Gridfinity interfaces on one model:
// a closed box becomes a surface another box sits on. The two halves are built
// by different code and sized from different rules, so only putting them
// together shows whether they meet. tests/assembly/gridfinity_lid_seated.scad
// proves the lid takes a spec foot; this proves it takes THIS model's foot, at
// this model's cell count, which is the pairing a user actually gets.
//
// Both parts are taken in the frame they export in, so the flip E-12 phase B
// adds to the lid is part of what is tested. The lid's pocket mouths lie on
// its top face at z = Lid_Total_Height, and the box sits SPACER above that,
// because CGAL's result for two solids that only touch is unreliable.
//
// A foot narrows downward, so lifting the box makes its feet narrower at every
// height inside the pockets and holds their ends further from the floors. The
// lift is the lenient direction, and it costs this check 0.04 mm of
// strictness; the seated probes below are what show the feet reaching.
//
// Assembly_Check selects what is rendered:
//   "overlap"  the intersection of lid and box. Feet that fit leave it empty,
//              and OpenSCAD exits 1 when asked to export an empty scene.
//   "seated"   the union, so point probes can show the feet reaching the
//              bottom of their pockets, which an empty overlap alone cannot.
include <../../cable-box-parametric.scad>

Assembly_Check = "overlap"; //["overlap", "seated"]

module printed_lid() {
    m_lid_placed() m_lid();
}

// The box is taken in its modelled frame, where its underside is z=0 and its
// feet hang below. Lifting by the lid's full height therefore rests the
// underside on the lid's top face and drops the feet into the pockets, which
// is what stacking means. Going through m_box_placed() instead would stand the
// box on its feet first and leave it sitting on the lid rather than in it.
module stacked_box() {
    translate([0, 0, Lid_Total_Height + SPACER])
        m_box_with_openings();
}

if (Assembly_Check == "overlap")
    intersection() {
        printed_lid();
        stacked_box();
    }
else
    union() {
        printed_lid();
        stacked_box();
    }
