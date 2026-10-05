// Assembly test: the lid seated on the box.
//
// Every other scenario checks one part on its own, which is how a lid that
// could not fit its box shipped from v1.0.0 to v2.0.0-rc.4: its lip ring was
// sized to land on top of the box wall, so the lid stood on the rim. Each part
// rendered cleanly and passed. Only the two parts together show the problem.
//
// The lid is modelled as it prints, lip up. Here it is flipped and lowered onto
// the box, with its slab face SPACER above the rim. That small lift keeps the
// slab off the rim plane, because CGAL's result for two solids that only touch
// is unreliable. A lip that engages still reaches 2.96 mm past the rim.
//
// Assembly_Check selects what is rendered:
//   "overlap"  the intersection of box and lid. A lid that fits leaves it empty,
//              and OpenSCAD exits 1 when asked to export an empty scene.
//   "seated"   the union, so point probes can show the lip hanging past the rim,
//              which an empty overlap alone cannot (a lid hovering above the
//              box would also overlap nothing).
include <../../cable-box-parametric.scad>

Assembly_Check = "overlap"; //["overlap", "seated"]

module seated_lid() {
    up(Box_Height + Lid_Height + SPACER)
        mirror([0, 0, 1])
            m_lid();
}

if (Assembly_Check == "overlap")
    intersection() {
        m_box_with_openings();
        seated_lid();
    }
else
    union() {
        m_box_with_openings();
        seated_lid();
    }
