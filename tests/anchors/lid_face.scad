// Regression test for the v1.2.0 Gridfinity lid bug, encoded as an anchor test.
//
// The lid prints face-down: its engagement lip points up, into the box, so the
// face that ends up EXPOSED when the box is closed is the model's z=0 face.
// v1.2.0 placed the Gridfinity interface at Lid_Height + Lid_Lip_Gap_Height,
// which is the mating face, and would have buried it inside the closed box.
//
// Attaching a marker to "lid-face" must put it BELOW the lid, never above.
include <../../cable-box-parametric.scad>

Part_To_Render = "Lid Only";

m_lid_part()
    attach("lid-face")
        cuboid([20, 20, 6]);
