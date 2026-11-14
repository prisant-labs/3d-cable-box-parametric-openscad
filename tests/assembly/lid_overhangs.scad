// Assembly test: the lid carries no wide flat overhang or bridge in the
// orientation it prints in.
//
// E-12 (Gridfinity to spec) asks that neither part have a flat overhang or
// bridge wider than about 15 mm. Point probes cannot show that. A probe proves
// only the one spot it names, and a ceiling moves whenever a parameter moves,
// so a probe-based version of this check would pass a lid whose ceiling had
// merely shifted.
//
// This measures every height at once. Material at a height has something under
// it exactly when the part RAISED by Probe_Drop covers it, so the unsupported
// material is the part less that raised copy. The slab of air up to the bed is
// added to the raised copy, so the part's own footprint on the bed does not
// read as unsupported.
//
// Flattening that material to a 2D footprint and shrinking it by half the
// allowed span leaves a region only where some unsupported face is wider than
// the span. An empty region exports as nothing, and OpenSCAD exits 1 when
// asked to export an empty scene, which is what the scenario expects.
//
// Shrinking merges nothing: offset() with a negative delta only removes. The
// flattening does merge footprints from different heights, so a region that
// survives is a reason to look rather than a proof on its own. Every region
// that has survived so far has been one ceiling.
//
// Max_Bridge_Width is 16 rather than 15 because the post socket's ceiling is
// Post_Diameter + 2 * Lid_Lip_Gap across, 15.3 mm at the defaults, and
// E-12 accepts it by name.
include <../../cable-box-parametric.scad>

// The widest unsupported span the criterion allows, in millimetres.
Max_Bridge_Width = 16;
// How far down a face must find material to count as supported. Smaller than
// one layer, so a 45 degree face reads as supported and a horizontal one
// does not.
Probe_Drop = 0.1;
// Build plate, large enough to pass under any preset.
Plate_Span = 400;
Plate_Height = 5;

// The lid as it is exported: m_lid_placed() carries the Gridfinity flip and
// the lift that puts the part's lowest point on z = 0.
module printed_lid() {
    m_lid_placed() m_lid();
}

// Everything a face can rest on: the part and the build plate, both raised by
// Probe_Drop. The plate overlaps the part's underside by SPACER rather than
// meeting it, because two subtracted solids that meet on a shared plane leave
// a sliver: the first version of this file met at z = Probe_Drop exactly and
// reported the whole lid as one 6e-7 mm thick unsupported sheet.
module lid_support() {
    translate([0, 0, Probe_Drop])
        union() {
            printed_lid();
            translate([-Plate_Span/2, -Plate_Span/2, -Plate_Height])
                cube([Plate_Span, Plate_Span, Plate_Height + SPACER]);
        }
}

linear_extrude(1)
    offset(delta = -Max_Bridge_Width / 2)
        projection()
            difference() {
                printed_lid();
                lid_support();
            }
