// The "rim" anchor must land on top of the wall, so a marker sits above the box.
include <../../cable-box-parametric.scad>

m_box()
    attach("rim")
        cuboid([20, 20, 10]);
