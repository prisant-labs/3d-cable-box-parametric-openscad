// The "floor" anchor must land on the interior floor surface, pointing up, so a
// marker attached to it sits inside the box rather than under it or on the rim.
include <../../cable-box-parametric.scad>

m_box()
    attach("floor")
        cuboid([20, 20, 10]);
