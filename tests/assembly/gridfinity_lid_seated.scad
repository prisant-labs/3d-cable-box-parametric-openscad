// Assembly test: a spec-built Gridfinity foot seated in the lid's baseplate.
//
// This is the mirror of tests/assembly/gridfinity_seated.scad, which seats the
// model's feet in a spec-built plate. Here the model is the female half, so the
// reference part is the male one: a foot typed from the Gridfinity spec's
// numbers and never read from the model. Anyone's bin has to drop in, not only
// this model's own box.
//
// The foot is also built a different way from the model's pockets, from two
// convex hulls per corner, so a mistake in one construction cannot cancel out
// the other.
//
// The lid is taken in the frame it exports in, through m_lid_placed(), because
// that is where E-12 phase B's flip lives: the pockets face up and their mouths
// lie on the part's top face at z = Lid_Total_Height. A foot therefore drops in
// from above in its natural orientation, widest end at the top.
//
// The foot is lifted SPACER above full seating rather than set flush, for the
// reason gridfinity_seated.scad drops its plate by the same amount: CGAL's
// result for two solids that only touch is unreliable.
//
// Be clear about which way that errs. A foot narrows downward, so a lifted one
// is NARROWER at every height inside the pocket and its end sits further from
// the floor. The lift is the lenient direction, and it costs this check
// 0.04 mm of strictness. What it cannot hide is a foot that does not reach:
// the seated probes measure the gap under the foot directly.
//
// Assembly_Check selects what is rendered:
//   "overlap"  the intersection of lid and feet. Feet that fit leave it empty,
//              and OpenSCAD exits 1 when asked to export an empty scene.
//   "seated"   the union, so point probes can show each foot reaching the
//              bottom of its pocket, which an empty overlap alone cannot: a
//              lid with no pockets at all would overlap nothing either.
include <../../cable-box-parametric.scad>

Assembly_Check = "overlap"; //["overlap", "seated"]
// Typed, not derived, so a lid that lays out a different grid collides. With
// both Gridfinity toggles on, the default 100 x 75 box rounds up to 3 x 2.
Foot_Cells_X = 3;
Foot_Cells_Y = 2;

// Spec numbers (gridfinity.xyz): 42 mm pitch; foot top 41.5 square with a
// 3.75 corner radius; foot profile from the bottom 0.8 at 45 degrees, 1.8
// vertical, 2.15 at 45 degrees.
SPEC_PITCH = 42;
SPEC_FOOT_TOP = 41.5;
SPEC_FOOT_TOP_R = 3.75;
SPEC_FOOT_RUNS = [0.8, 1.8, 2.15];

foot_h = SPEC_FOOT_RUNS[0] + SPEC_FOOT_RUNS[1] + SPEC_FOOT_RUNS[2];
r_mid = SPEC_FOOT_TOP_R - SPEC_FOOT_RUNS[2];
r_bot = r_mid - SPEC_FOOT_RUNS[0];
core = SPEC_FOOT_TOP/2 - SPEC_FOOT_TOP_R;
z_waist_lo = SPEC_FOOT_RUNS[0];
z_waist_hi = SPEC_FOOT_RUNS[0] + SPEC_FOOT_RUNS[1];

// The mouth of every pocket, and the face the seated foot's top lies on.
mouth_z = Lid_Total_Height;

// One foot, its bottom face at z=0 and its widest ring at z=foot_h. The
// vertical waist makes it non-convex, so it is the union of two convex halves,
// each a hull of four corner solids of revolution. The lower half reaches 0.1
// past the waist into the upper half, where it stays inside it, so the halves
// never merely touch.
module spec_foot() {
    lower = [[0, 0], [r_bot, 0], [r_mid, z_waist_lo],
             [r_mid, z_waist_hi + 0.1], [0, z_waist_hi + 0.1]];
    upper = [[0, z_waist_hi], [r_mid, z_waist_hi],
             [SPEC_FOOT_TOP_R, foot_h], [0, foot_h]];
    for (half = [lower, upper])
        hull()
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * core, sy * core, 0])
                    rotate_extrude() polygon(half);
}

module spec_feet() {
    for (ix = [0:Foot_Cells_X-1], iy = [0:Foot_Cells_Y-1])
        translate([(ix - (Foot_Cells_X - 1)/2) * SPEC_PITCH,
                   (iy - (Foot_Cells_Y - 1)/2) * SPEC_PITCH,
                   mouth_z + SPACER - foot_h])
            spec_foot();
}

module printed_lid() {
    m_lid_placed() m_lid();
}

if (Assembly_Check == "overlap")
    intersection() {
        printed_lid();
        spec_feet();
    }
else
    union() {
        printed_lid();
        spec_feet();
    }
