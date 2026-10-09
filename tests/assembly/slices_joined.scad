// Assembly test: two slices of a sliced box, or of a sliced lid, joined.
//
// Single-piece scenarios cannot show whether a seam holds the halves level. In
// the rc.5 prints both clip styles let the halves slide vertically, because the
// floor clip's socket runs straight through the floor and nothing else on the
// seam resists vertical movement. Every piece rendered cleanly and passed.
//
// Slice 1 and slice 2 are put back where they came from, then parted by SPACER
// along X. The flat floor faces would otherwise touch, and CGAL's result for
// two solids that only touch is unreliable.
//
// Assembly_Check selects what is rendered, always the intersection of the two:
//   "overlap"  at the joined position. A seam that fits leaves it empty, and
//              OpenSCAD exits 1 when asked to export an empty scene.
//   "lifted"   slice 2 raised by Seam_Test_Offset. A seam that locks vertical
//              movement makes the two collide, so the export is not empty.
//   "dropped"  slice 2 lowered by Seam_Test_Offset, the same proof downward.
// Assembly_Part picks the box or the lid.
//
// "lifted" and "dropped" look only outside the band the seam clips occupy:
// above the floor clips on the box, below the lid clips on the lid. The clips
// are not what these checks prove. They also give wrong answers there. A lid
// socket is closed below by the slab, so lifting collides even with a flat
// seam. A floor clip sits flush against the wall's inner face, so a dropped
// slice only touches it, which CGAL reports unreliably.
include <../../cable-box-parametric.scad>

Assembly_Check = "overlap"; //["overlap", "lifted", "dropped"]
Assembly_Part = "Box"; //["Box", "Lid"]
// More than Clip_Tolerance, which is the vertical play a seam is allowed.
Seam_Test_Offset = 0.5;

function joined_slice_centre(i, span) = -span/2 + (i - 0.5) * span / Slice_Count;

module joined_slice(i) {
    span = Assembly_Part == "Lid" ? Lid_Outer_Width : Box_Width_Effective;
    translate([joined_slice_centre(i, span), 0, 0])
        if (Assembly_Part == "Lid") m_lid_slice(i);
        else m_box_slice(i);
}

dz = Assembly_Check == "lifted"  ?  Seam_Test_Offset :
     Assembly_Check == "dropped" ? -Seam_Test_Offset : 0;

// Outside the clip band, with the offset added so the moved slice's clips
// stay outside it too.
clip_clear = Clip_Tab_Height + Clip_Tolerance + Seam_Test_Offset;
band = Assembly_Part == "Lid"
    ? [-Gridfinity_Lid_Offset - 1, Lid_Height - clip_clear]
    : [Wall_Thickness + clip_clear, Box_Height + 1];

intersection() {
    translate([-SPACER/2, 0, 0]) joined_slice(1);
    translate([ SPACER/2, 0, dz]) joined_slice(2);
    if (dz != 0)
        translate([-Box_Width_Effective * 1.5, -Box_Depth_Effective * 1.5, band[0]])
            cube([Box_Width_Effective * 3, Box_Depth_Effective * 3, band[1] - band[0]]);
}
