// Assembly test: the box's Gridfinity feet seated in a spec baseplate.
//
// The rc.4 coupon seated in the model's own lid socket, which proved only that
// the model agreed with itself. This plate is built from the Gridfinity spec's
// numbers, typed below and never read from the model, so the feet must fit the
// standard. It is also built a different way from the model's feet, from two
// hulls per pocket, so a mistake in one construction cannot cancel out.
//
// A spec foot is the pocket's profile set in 0.25 mm on every side and dropped
// 0.1 mm, since the foot is 4.75 mm tall and the pocket 4.65 mm. Seated, the
// box's underside rests on the plate's top edges and the feet hang free inside
// the pockets with 0.25 mm all round. The plate is the open-bottom style with
// 0.35 mm below the profile, as kennetek's 5 mm baseplate has, so nothing
// below the profile can stop a foot.
//
// The box is modelled with its underside at z=0 and its feet hanging below.
// The plate's top sits SPACER under that, for the same reason lid_seated.scad
// lifts its lid: CGAL's result for two solids that only touch is unreliable.
//
// Assembly_Check selects what is rendered:
//   "overlap"  the intersection of box and plate. Feet that fit leave it
//              empty, and OpenSCAD exits 1 when asked to export an empty scene.
//   "seated"   the union, so point probes can show the feet filling the
//              pockets, which an empty overlap alone cannot: a box with no
//              feet would overlap nothing either.
include <../../cable-box-parametric.scad>

Assembly_Check = "overlap"; //["overlap", "seated"]
// Typed, not derived, so a model that lays out a different grid collides.
// The default 100 x 75 box rounds up to 3 x 2 cells.
Plate_Cells_X = 3;
Plate_Cells_Y = 2;

// Spec numbers (gridfinity.xyz): 42 mm pitch; pocket top 42 square with a
// 4.0 corner radius; pocket profile from the bottom 0.7 at 45 degrees, 1.8
// vertical, 2.15 at 45 degrees.
SPEC_PITCH = 42;
SPEC_POCKET_TOP_R = 4.0;
SPEC_POCKET_RUNS = [0.7, 1.8, 2.15];
SPEC_PLATE_BELOW_PROFILE = 0.35;

pocket_h = SPEC_POCKET_RUNS[0] + SPEC_POCKET_RUNS[1] + SPEC_POCKET_RUNS[2];
r_mid = SPEC_POCKET_TOP_R - SPEC_POCKET_RUNS[2];
r_bot = r_mid - SPEC_POCKET_RUNS[0];
core = SPEC_PITCH/2 - SPEC_POCKET_TOP_R;
z_waist_lo = SPEC_POCKET_RUNS[0];
z_waist_hi = SPEC_POCKET_RUNS[0] + SPEC_POCKET_RUNS[1];

plate_top = -SPACER;
plate_bottom = plate_top - pocket_h - SPEC_PLATE_BELOW_PROFILE;

// One pocket cutter, its profile bottom at z=0. The vertical waist makes the
// pocket non-convex, so it is the union of two convex halves, each a hull of
// four corner solids of revolution. The lower half reaches past the waist into
// the upper half, where it stays inside it, so the halves never merely touch.
module spec_pocket() {
    lower = [[0, -SPEC_PLATE_BELOW_PROFILE - 1], [r_bot, -SPEC_PLATE_BELOW_PROFILE - 1],
             [r_bot, 0], [r_mid, z_waist_lo], [r_mid, z_waist_hi + 0.1], [0, z_waist_hi + 0.1]];
    upper = [[0, z_waist_hi], [r_mid, z_waist_hi], [SPEC_POCKET_TOP_R, pocket_h],
             [SPEC_POCKET_TOP_R, pocket_h + 1], [0, pocket_h + 1]];
    for (half = [lower, upper])
        hull()
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * core, sy * core, 0])
                    rotate_extrude() polygon(half);
}

module spec_baseplate() {
    difference() {
        translate([-Plate_Cells_X * SPEC_PITCH/2, -Plate_Cells_Y * SPEC_PITCH/2, plate_bottom])
            cube([Plate_Cells_X * SPEC_PITCH, Plate_Cells_Y * SPEC_PITCH, plate_top - plate_bottom]);
        for (ix = [0:Plate_Cells_X-1], iy = [0:Plate_Cells_Y-1])
            translate([(ix - (Plate_Cells_X - 1)/2) * SPEC_PITCH,
                       (iy - (Plate_Cells_Y - 1)/2) * SPEC_PITCH,
                       plate_top - pocket_h])
                spec_pocket();
    }
}

if (Assembly_Check == "overlap")
    intersection() {
        m_box_with_openings();
        spec_baseplate();
    }
else
    union() {
        m_box_with_openings();
        spec_baseplate();
    }
