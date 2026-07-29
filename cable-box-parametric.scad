/*
Parametric Cable Management Box (OpenSCAD)
Repository: https://github.com/prisant-labs/3d-cable-box-parametric-openscad
License: MIT
SPDX-License-Identifier: MIT

See README.md for usage, docs/PARAMETER_REFERENCE.md for full parameter docs,
and THIRD_PARTY_NOTICES.md for third-party attributions.
*/

// Embedded BOSL2 portions:
// Upstream: https://github.com/revarbat/BOSL2
// License: BSD-2-Clause (see THIRD_PARTY_NOTICES.md)

/*[Overall]*/
// Which model output to render.
Part_To_Render = "Box Only"; //["Box Only", "Lid Only", "Box and Lid"]

/*[Box]*/
// Outer width of the box body (mm).
Box_Width = 100;
// Outer depth of the box body (mm).
Box_Depth = 75;
// Outer height of the box body (mm).
Box_Height = 50;
// Corner radius for outer box edges (mm). Clamped to what the inner cavity allows.
Box_Corner_Radius = 8.1;
// Wall thickness for box and post shell (mm).
Wall_Thickness = 1.85;

/*[Post]*/
// Add a center post for cable wrapping.
Enable_Post = true;
// If true, the post floor is solid instead of open through the box bottom.
Closed_Post = false;
// Outer diameter of the center post (mm).
Post_Diameter = 15;

/*[Lid]*/
// Lid wall height above the box top plane (mm).
Lid_Height = 8.1;
// Fit clearance between lid and box (mm). Increase if fit is tight.
Lid_Lip_Gap = 0.1;
// Height of the inner lip that engages the box (mm).
Lid_Lip_Gap_Height = 3;

/*[Openings]*/
// Default opening width for all enabled side openings (mm).
All_Opening_Width=10;
// Default opening height for all enabled side openings (mm).
All_Opening_Height=30;
// Default corner radius for all side openings (mm). Use -1 for fully rounded ends.
All_Opening_Corner_Radius=-1;
// Global side-opening offset along each wall's local left/right direction (mm).
All_Openings_Right=0;
// Height of each side opening's bottom edge above the box floor (mm). 0 sits it flush with the box bottom.
All_Openings_Up=0;
Opening_On_Right=true;
Opening_On_Left=true;
Opening_On_Front=true;
Opening_On_Back=true;

/*[Left Openings Overrides]*/
// Left opening width override (mm). Use 0 to keep default width.
Override_Opening_Width_Left=0;
// Left opening height override (mm). Use 0 to keep default height.
Override_Opening_Height_Left=0;
// Left opening corner radius override (mm). Use -1 to keep default corner radius.
Override_Opening_Corner_Radius_Left=-1;
// Left wall opening depth shift (mm). Positive moves toward front (-Y).
Move_Opening_Left_to_Right=0;
// Left opening vertical offset (mm).
Move_Opening_Left_Up=0;

/*[Right Openings Overrides]*/
// Right opening width override (mm). Use 0 to keep default width.
Override_Opening_Width_Right=0;
// Right opening height override (mm). Use 0 to keep default height.
Override_Opening_Height_Right=0;
// Right opening corner radius override (mm). Use -1 to keep default corner radius.
Override_Opening_Corner_Radius_Right=-1;
// Right wall opening depth shift (mm). Positive moves toward back (+Y).
Move_Opening_Right_to_Right=0;
// Right opening vertical offset (mm).
Move_Opening_Right_Up=0;

/*[Back Openings Overrides]*/
// Back opening width override (mm). Use 0 to keep default width.
Override_Opening_Width_Back=0;
// Back opening height override (mm). Use 0 to keep default height.
Override_Opening_Height_Back=0;
// Back opening corner radius override (mm). Use -1 to keep default corner radius.
Override_Opening_Corner_Radius_Back=-1;
// Back wall opening lateral shift (mm). Positive moves toward left (-X).
Move_Opening_Back_to_Right=0;
// Back opening vertical offset (mm).
Move_Opening_Back_Up=0;

/*[Front Openings Overrides]*/
// Front opening width override (mm). Use 0 to keep default width.
Override_Opening_Width_Front=0;
// Front opening height override (mm). Use 0 to keep default height.
Override_Opening_Height_Front=0;
// Front opening corner radius override (mm). Use -1 to keep default corner radius.
Override_Opening_Corner_Radius_Front=-1;
// Front wall opening lateral shift (mm). Positive moves toward right (+X).
Move_Opening_Front_to_Right=0;
// Front opening vertical offset (mm).
Move_Opening_Front_Up=0;

/*[Stabilizers - Main Settings]*/
// Add wall fins for extra rigidity.
Enable_Stabilizers = true;
// Fin thickness along the wall (mm).
Stabilizer_Width = 1.5;
// Fin depth from wall into the box interior (mm).
Stabilizer_Depth = 15;
// Fin height from box floor upward (mm).
Stabilizer_Height = 35;

/*[Stabilizers - Front/Back Walls]*/
// Number of fins per wall on front and back.
Stabilizers_Front_Back_Count = 3;
// Placement mode for front/back fins.
Stabilizers_Front_Back_Alignment = "Centered"; //["Centered", "Distributed", "Custom"]
// Gap between adjacent front/back fins in Centered/Custom modes (mm).
Stabilizer_FB_Spacing = 3;
// Left margin used by Distributed/Custom (mm).
Stabilizer_FB_Margin_Left = 15;
// Right margin used by Distributed/Custom (mm).
Stabilizer_FB_Margin_Right = 15;
// Skip fin positions that overlap the front opening.
Stabilizer_Avoid_Front_Opening = true;
// Skip fin positions that overlap the back opening.
Stabilizer_Avoid_Back_Opening = true;

/*[Stabilizers - Left/Right Walls]*/
// Number of fins per wall on left and right.
Stabilizers_Left_Right_Count = 0;
// Placement mode for left/right fins.
Stabilizers_Left_Right_Alignment = "Centered"; //["Centered", "Distributed", "Custom"]
// Gap between adjacent left/right fins in Centered/Custom modes (mm).
Stabilizer_LR_Spacing = 3;
// Front margin used by Distributed/Custom (mm).
Stabilizer_LR_Margin_Front = 15;
// Back margin used by Distributed/Custom (mm).
Stabilizer_LR_Margin_Back = 15;
// Skip fin positions that overlap the left opening.
Stabilizer_Avoid_Left_Opening = true;
// Skip fin positions that overlap the right opening.
Stabilizer_Avoid_Right_Opening = true;

/*[Bottom Openings - Main]*/
// Add cable openings to the box floor.
Enable_Bottom_Openings = false;
// Number of floor openings.
Bottom_Openings_Count = 3;
// Axis used to arrange multiple floor openings.
Bottom_Opening_Axis = "Along X"; //["Along X", "Along Y"]
// Opening width (short axis) in mm.
Bottom_Opening_Width = 15;
// Opening length (long axis) in mm.
Bottom_Opening_Depth = 30;
// Orientation of each opening cutout.
Bottom_Opening_Orientation = "Along Y"; //["Along X", "Along Y"]
// Corner radius for floor openings (0 keeps square corners).
Bottom_Opening_Corner_Radius = 5;
// Gap between floor openings (mm). Use 0 for auto spacing.
Bottom_Opening_Spacing = 0;

/*[Bottom Openings - Alignment]*/
// Primary alignment along the arrangement axis.
Bottom_Opening_Alignment_Primary = "Centered"; //["Centered", "Distributed", "Start", "End", "Custom"]
// Secondary alignment on the perpendicular axis. Custom centers within custom margins.
Bottom_Opening_Alignment_Secondary = "Centered"; //["Centered", "Start", "End", "Custom"]
// Split openings around the center post when post is enabled.
Bottom_Opening_Avoid_Post = true;
// Minimum gap from post outer wall to nearest bottom opening edge (mm) when post avoid is enabled.
Bottom_Opening_Post_Margin = 2;

/*[Bottom Openings - Custom Margins]*/
// Left margin for Start/End/Custom placement modes (mm).
Bottom_Opening_Margin_Left = 10;
// Right margin for Start/End/Custom placement modes (mm).
Bottom_Opening_Margin_Right = 10;
// Front margin for Start/End/Custom placement modes (mm).
Bottom_Opening_Margin_Front = 10;
// Back margin for Start/End/Custom placement modes (mm).
Bottom_Opening_Margin_Back = 10;

/*[Slicing - For Smaller Print Beds]*/
// Enable split mode with clip connectors.
Enable_Slicing = false;
// Number of slices across width.
Slice_Count = 2;
// 0 renders all slices for preview; 1..Slice_Count renders one slice.
Slice_Piece_To_Render = 0;
// Added clearance between male/female clip geometry (mm).
Clip_Tolerance = 0.2;
// Number of clips on each split edge.
Clips_Per_Edge = 2;
// Clip length along the split seam (mm).
Clip_Tab_Width = 10;
// Clip insertion depth (mm).
Clip_Tab_Depth = 4;
// Clip height (mm).
Clip_Tab_Height = 3;
// Spacing between slices when previewing all parts (mm).
Slice_Preview_Spacing = 5;

/* [Hidden] */
// Model version. Must match the git tag and the top CHANGELOG.md section on a
// release build; CI enforces that. Echoed at render so an exported STL can be
// traced back to the source that produced it, which matters for a model
// distributed as loose files.
Model_Version = "1.1.1";
echo(str("cable-box-parametric ", Model_Version));

$fn = 40;
SPACER=0.04;

// Calculate inner dimensions (accounting for walls)
Inner_Width = Box_Width - Wall_Thickness * 2;
Inner_Depth = Box_Depth - Wall_Thickness * 2;

// Calculate slice width
Slice_Width = Box_Width / max(Slice_Count, 1);

// Largest corner radius the geometry can actually build.
// This must be derived from the INNER cavity, not the outer shell. The same
// rounding value is reused for the inner cuboid, which is Wall_Thickness*2
// smaller on each axis, so clamping to the outer half-extent lets values
// through that BOSL2 then rejects.
Max_Corner_Radius = max(0, (min(Box_Width, Box_Depth) - Wall_Thickness * 2) / 2 - 1e-6);
Corner_Radius = min(Box_Corner_Radius, Max_Corner_Radius);

// Smallest |y| at which a seam clip sits on real material. A clip centred
// inside the post opening has nothing to bond to and exports as a loose solid.
// The box floor is bored to (Post_Diameter/2 - Wall_Thickness) only while the
// post is open at the bottom; the lid is always pierced at Post_Diameter/2.
Floor_Clip_Clearance = (Enable_Post && !Closed_Post)
    ? Post_Diameter/2 - Wall_Thickness + Clip_Tab_Width/2
    : 0;
Lid_Clip_Clearance = Enable_Post
    ? Post_Diameter/2 + Clip_Tab_Width/2
    : 0;

// Push a clip position clear of the post opening, but never outside the wall
// it has to bond to. If it cannot clear, the position is left alone so the
// degenerate case stays visible rather than silently relocating.
function clear_post_opening(y, clearance, limit) =
    (clearance <= 0 || abs(y) >= clearance) ? y :
    (clearance <= limit) ? (y < 0 ? -clearance : clearance) :
    y;

// Validation
assert(Box_Width > 0 && Box_Depth > 0 && Box_Height > 0, "Box_Width, Box_Depth, and Box_Height must be > 0");
assert(Wall_Thickness > 0, "Wall_Thickness must be > 0");
assert(Wall_Thickness * 2 < min(Box_Width, Box_Depth), "Wall_Thickness is too large for the box footprint; Inner_Width and Inner_Depth would be <= 0");
assert(Box_Corner_Radius >= 0, "Box_Corner_Radius must be >= 0");
assert(!Enable_Post || Post_Diameter > Wall_Thickness * 2, "Post_Diameter must exceed Wall_Thickness*2 so the post has a wall");
assert(!Enable_Post || Post_Diameter < min(Inner_Width, Inner_Depth), "Post_Diameter must fit inside the box interior");
assert(!Enable_Stabilizers || Stabilizer_Height + Wall_Thickness <= Box_Height, "Stabilizer_Height plus the floor exceeds Box_Height");
assert(!Enable_Stabilizers || Stabilizer_Depth * 2 < min(Inner_Width, Inner_Depth), "Stabilizer_Depth is too large for the box interior");
assert(!Enable_Stabilizers || Stabilizer_Width > 0, "Stabilizer_Width must be > 0");
assert(Stabilizers_Front_Back_Count >= 0 && Stabilizers_Left_Right_Count >= 0, "Stabilizer counts must be >= 0");
assert(All_Opening_Height <= Box_Height, "All_Opening_Height must not exceed Box_Height");
assert(!Enable_Bottom_Openings || Bottom_Openings_Count >= 1, "Bottom_Openings_Count must be >= 1 when bottom openings are enabled");
assert(!Enable_Bottom_Openings || (Bottom_Opening_Width > 0 && Bottom_Opening_Depth > 0), "Bottom opening width and depth must be > 0");
assert(Override_Opening_Height_Front >= 0 && Override_Opening_Width_Front >= 0 && Override_Opening_Height_Back >= 0 && Override_Opening_Width_Back >= 0 && Override_Opening_Height_Left >= 0 && Override_Opening_Width_Left >= 0 && Override_Opening_Height_Right >= 0 && Override_Opening_Width_Right >= 0,"Height and width overrides must be positive or zero");
assert(All_Opening_Corner_Radius >= -1 && Override_Opening_Corner_Radius_Front >= -1 && Override_Opening_Corner_Radius_Back >= -1 && Override_Opening_Corner_Radius_Left >= -1 && Override_Opening_Corner_Radius_Right >= -1, "Corner radius values must be >= -1");
assert(All_Opening_Height > 0 && All_Opening_Width > 0, "All_Opening_Height and All_Opening_Width must be > 0");
assert(Stabilizer_FB_Spacing >= 0 && Stabilizer_LR_Spacing >= 0, "Stabilizer spacing must be >= 0");
assert(Bottom_Opening_Post_Margin >= 0, "Bottom opening post margin must be >= 0");
assert(is_int(Slice_Piece_To_Render) && Slice_Piece_To_Render >= 0 && Slice_Piece_To_Render <= Slice_Count, "Slice piece to render must be an integer in range 0..slice count");
assert(!Enable_Slicing || Slice_Count >= 2, "Slice count must be >= 2 when slicing is enabled");
assert(!Enable_Slicing || Clips_Per_Edge >= 1, "Clips per edge must be >= 1");
assert(Clip_Tolerance >= 0, "Clip tolerance must be >= 0");
assert(Clip_Tab_Width > 0 && Clip_Tab_Depth > 0 && Clip_Tab_Height > 0, "Clip tab dimensions must be > 0");

// Report a corner radius the geometry had to reduce, so the difference between
// the requested and the built shape is visible rather than silent.
if (Box_Corner_Radius > Max_Corner_Radius)
    echo(str("Box_Corner_Radius reduced from ", Box_Corner_Radius,
             " to ", Max_Corner_Radius,
             " (limited by the inner cavity at Wall_Thickness=", Wall_Thickness, ")"));

// ============================================
// STABILIZERS MODULE (v5)
// ============================================

// Calculate the effective opening width for a given wall
function get_effective_opening_width(side) =
    (side == "Front") ?
        (Override_Opening_Width_Front > 0 ? Override_Opening_Width_Front : All_Opening_Width) :
    (side == "Back") ?
        (Override_Opening_Width_Back > 0 ? Override_Opening_Width_Back : All_Opening_Width) :
    (side == "Left") ?
        (Override_Opening_Width_Left > 0 ? Override_Opening_Width_Left : All_Opening_Width) :
    (side == "Right") ?
        (Override_Opening_Width_Right > 0 ? Override_Opening_Width_Right : All_Opening_Width) :
    All_Opening_Width;

// Calculate the effective opening corner radius for a given wall
function get_effective_opening_corner_radius(side) =
    (side == "Front") ?
        (Override_Opening_Corner_Radius_Front >= 0 ? Override_Opening_Corner_Radius_Front : All_Opening_Corner_Radius) :
    (side == "Back") ?
        (Override_Opening_Corner_Radius_Back >= 0 ? Override_Opening_Corner_Radius_Back : All_Opening_Corner_Radius) :
    (side == "Left") ?
        (Override_Opening_Corner_Radius_Left >= 0 ? Override_Opening_Corner_Radius_Left : All_Opening_Corner_Radius) :
    (side == "Right") ?
        (Override_Opening_Corner_Radius_Right >= 0 ? Override_Opening_Corner_Radius_Right : All_Opening_Corner_Radius) :
    All_Opening_Corner_Radius;

// Calculate opening center position offset for a given wall (for horizontal movement)
function get_opening_center_offset(side) =
    (side == "Front") ?
        Move_Opening_Front_to_Right + All_Openings_Right :
    (side == "Back") ?
        -(Move_Opening_Back_to_Right + All_Openings_Right) :
    (side == "Left") ?
        -(Move_Opening_Left_to_Right + All_Openings_Right) :
    (side == "Right") ?
        Move_Opening_Right_to_Right + All_Openings_Right :
    0;

// Single stabilizer fin shape - triangular wedge
// Full depth at bottom, tapering to wall at top
module m_stabilizer_fin(width, depth, height) {
    // Wedge shape using polyhedron - triangular cross-section
    // The fin has full depth at the floor and tapers to the wall at the top
    polyhedron(
        points = [
            // Bottom face (at floor) - full depth rectangle
            [0, 0, 0],           // 0: bottom-front-left (at wall)
            [width, 0, 0],       // 1: bottom-front-right (at wall)
            [width, depth, 0],   // 2: bottom-back-right (extends into box)
            [0, depth, 0],       // 3: bottom-back-left (extends into box)
            // Top edge (at height) - line along wall
            [0, 0, height],      // 4: top-front-left (at wall)
            [width, 0, height]   // 5: top-front-right (at wall)
        ],
        faces = [
            [0, 1, 2, 3],    // bottom face (rectangle)
            [4, 5, 1, 0],    // front face (at wall - rectangle)
            [5, 2, 1],       // right side (triangle)
            [0, 3, 4],       // left side (triangle)
            [3, 2, 5, 4]     // back/angled face (the slope)
        ]
    );
}

// Place stabilizers along front/back walls (running in Y direction, placed along X)
module m_stabilizers_front_back() {
    if (Stabilizers_Front_Back_Count > 0) {
        // Calculate margins
        fb_spacing = max(0, Stabilizer_FB_Spacing);
        fb_pitch = Stabilizer_Width + fb_spacing;

        margin_left = (Stabilizers_Front_Back_Alignment == "Custom" ||
                       Stabilizers_Front_Back_Alignment == "Distributed") ?
                      Stabilizer_FB_Margin_Left : Corner_Radius;
        margin_right = (Stabilizers_Front_Back_Alignment == "Custom" ||
                        Stabilizers_Front_Back_Alignment == "Distributed") ?
                       Stabilizer_FB_Margin_Right : Corner_Radius;

        usable_start = -Inner_Width/2 + margin_left;
        usable_end = Inner_Width/2 - margin_right;
        usable_range = usable_end - usable_start;

        // Calculate positions
        distributed_positions =
            (Stabilizers_Front_Back_Count == 1) ? [0] :
            [for (i = [0:Stabilizers_Front_Back_Count-1])
                usable_start + Stabilizer_Width/2 + i * (usable_range - Stabilizer_Width) / (Stabilizers_Front_Back_Count - 1)];

        centered_positions =
            let(
                total_width = Stabilizer_Width * Stabilizers_Front_Back_Count +
                             (Stabilizers_Front_Back_Count - 1) * fb_spacing,
                start_x = -total_width/2 + Stabilizer_Width/2
            )
            [for (i = [0:Stabilizers_Front_Back_Count-1])
                start_x + i * fb_pitch];

        positions =
            (Stabilizers_Front_Back_Count == 1) ? [0] :
            (Stabilizers_Front_Back_Alignment == "Distributed") ?
                distributed_positions :
            (Stabilizers_Front_Back_Alignment == "Custom") ?
                let(
                    custom_pitch = fb_pitch,
                    custom_required = Stabilizer_Width + (Stabilizers_Front_Back_Count - 1) * custom_pitch,
                    use_fixed = usable_range >= custom_required
                )
                use_fixed ?
                    [for (i = [0:Stabilizers_Front_Back_Count-1])
                        usable_start + Stabilizer_Width/2 + i * custom_pitch] :
                    distributed_positions :
            // Centered (default)
            centered_positions;

        // Opening avoidance zones
        front_opening_center = get_opening_center_offset("Front");
        front_opening_width = get_effective_opening_width("Front");
        front_avoid_min = front_opening_center - front_opening_width/2 - Stabilizer_Width;
        front_avoid_max = front_opening_center + front_opening_width/2 + Stabilizer_Width;

        back_opening_center = get_opening_center_offset("Back");
        back_opening_width = get_effective_opening_width("Back");
        back_avoid_min = back_opening_center - back_opening_width/2 - Stabilizer_Width;
        back_avoid_max = back_opening_center + back_opening_width/2 + Stabilizer_Width;

        // If avoid mode would suppress all fins, fall back to distributed spacing.
        // This keeps wall stabilizers usable without disabling opening avoidance.
        back_fallback_needed =
            Stabilizer_Avoid_Back_Opening && Opening_On_Back &&
            len([for (p = positions)
                if (!(p > back_avoid_min && p < back_avoid_max)) p]) == 0 &&
            len([for (p = distributed_positions)
                if (!(p > back_avoid_min && p < back_avoid_max)) p]) > 0;

        front_fallback_needed =
            Stabilizer_Avoid_Front_Opening && Opening_On_Front &&
            len([for (p = positions)
                if (!(p > front_avoid_min && p < front_avoid_max)) p]) == 0 &&
            len([for (p = distributed_positions)
                if (!(p > front_avoid_min && p < front_avoid_max)) p]) > 0;

        back_positions = back_fallback_needed ? distributed_positions : positions;
        front_positions = front_fallback_needed ? distributed_positions : positions;

        // Place stabilizers on back wall (extending toward front, -Y direction)
        for (i = [0:Stabilizers_Front_Back_Count-1]) {
            x_pos_back = back_positions[i];

            // Check if we should avoid this position for back wall
            skip_back = Stabilizer_Avoid_Back_Opening && Opening_On_Back &&
                        (x_pos_back > back_avoid_min && x_pos_back < back_avoid_max);

            if (!skip_back) {
                // Back wall stabilizer - extends from back wall toward front (-Y)
                translate([x_pos_back + Stabilizer_Width/2,
                           Inner_Depth/2,
                           Wall_Thickness])
                    rotate([0, 0, 180])
                    color("#5588FF")
                    m_stabilizer_fin(Stabilizer_Width, Stabilizer_Depth, Stabilizer_Height);
            }

            // Check if we should avoid this position for front wall
            x_pos_front = front_positions[i];
            skip_front = Stabilizer_Avoid_Front_Opening && Opening_On_Front &&
                         (x_pos_front > front_avoid_min && x_pos_front < front_avoid_max);

            if (!skip_front) {
                // Front wall stabilizer - extends from front wall toward back (+Y)
                translate([x_pos_front - Stabilizer_Width/2,
                           -Inner_Depth/2,
                           Wall_Thickness])
                    color("#5588FF")
                    m_stabilizer_fin(Stabilizer_Width, Stabilizer_Depth, Stabilizer_Height);
            }
        }
    }
}

// Place stabilizers along left/right walls (running in X direction, placed along Y)
module m_stabilizers_left_right() {
    if (Stabilizers_Left_Right_Count > 0) {
        // Calculate margins
        lr_spacing = max(0, Stabilizer_LR_Spacing);
        lr_pitch = Stabilizer_Width + lr_spacing;

        margin_front = (Stabilizers_Left_Right_Alignment == "Custom" ||
                        Stabilizers_Left_Right_Alignment == "Distributed") ?
                       Stabilizer_LR_Margin_Front : Corner_Radius;
        margin_back = (Stabilizers_Left_Right_Alignment == "Custom" ||
                       Stabilizers_Left_Right_Alignment == "Distributed") ?
                      Stabilizer_LR_Margin_Back : Corner_Radius;

        usable_start = -Inner_Depth/2 + margin_front;
        usable_end = Inner_Depth/2 - margin_back;
        usable_range = usable_end - usable_start;

        // Calculate positions
        distributed_positions =
            (Stabilizers_Left_Right_Count == 1) ? [0] :
            [for (i = [0:Stabilizers_Left_Right_Count-1])
                usable_start + Stabilizer_Width/2 + i * (usable_range - Stabilizer_Width) / (Stabilizers_Left_Right_Count - 1)];

        centered_positions =
            let(
                total_depth = Stabilizer_Width * Stabilizers_Left_Right_Count +
                             (Stabilizers_Left_Right_Count - 1) * lr_spacing,
                start_y = -total_depth/2 + Stabilizer_Width/2
            )
            [for (i = [0:Stabilizers_Left_Right_Count-1])
                start_y + i * lr_pitch];

        positions =
            (Stabilizers_Left_Right_Count == 1) ? [0] :
            (Stabilizers_Left_Right_Alignment == "Distributed") ?
                distributed_positions :
            (Stabilizers_Left_Right_Alignment == "Custom") ?
                let(
                    custom_pitch = lr_pitch,
                    custom_required = Stabilizer_Width + (Stabilizers_Left_Right_Count - 1) * custom_pitch,
                    use_fixed = usable_range >= custom_required
                )
                use_fixed ?
                    [for (i = [0:Stabilizers_Left_Right_Count-1])
                        usable_start + Stabilizer_Width/2 + i * custom_pitch] :
                    distributed_positions :
            // Centered (default)
            centered_positions;

        // Opening avoidance zones - for left/right walls, openings move along Y (back_to_right param)
        left_opening_center = get_opening_center_offset("Left");
        left_opening_width = get_effective_opening_width("Left");
        left_avoid_min = left_opening_center - left_opening_width/2 - Stabilizer_Width;
        left_avoid_max = left_opening_center + left_opening_width/2 + Stabilizer_Width;

        right_opening_center = get_opening_center_offset("Right");
        right_opening_width = get_effective_opening_width("Right");
        right_avoid_min = right_opening_center - right_opening_width/2 - Stabilizer_Width;
        right_avoid_max = right_opening_center + right_opening_width/2 + Stabilizer_Width;

        // If avoid mode would suppress all fins, fall back to distributed spacing.
        // This keeps side stabilizers usable without disabling opening avoidance.
        left_fallback_needed =
            Stabilizer_Avoid_Left_Opening && Opening_On_Left &&
            len([for (p = positions)
                if (!(p > left_avoid_min && p < left_avoid_max)) p]) == 0 &&
            len([for (p = distributed_positions)
                if (!(p > left_avoid_min && p < left_avoid_max)) p]) > 0;

        right_fallback_needed =
            Stabilizer_Avoid_Right_Opening && Opening_On_Right &&
            len([for (p = positions)
                if (!(p > right_avoid_min && p < right_avoid_max)) p]) == 0 &&
            len([for (p = distributed_positions)
                if (!(p > right_avoid_min && p < right_avoid_max)) p]) > 0;

        left_positions = left_fallback_needed ? distributed_positions : positions;
        right_positions = right_fallback_needed ? distributed_positions : positions;

        // Place stabilizers on left and right walls
        for (i = [0:Stabilizers_Left_Right_Count-1]) {
            y_pos_left = left_positions[i];

            // Check if we should avoid this position for left wall
            skip_left = Stabilizer_Avoid_Left_Opening && Opening_On_Left &&
                        (y_pos_left > left_avoid_min && y_pos_left < left_avoid_max);

            if (!skip_left) {
                // Left wall stabilizer - extends from left wall toward right (+X direction)
                translate([-Inner_Width/2,
                           y_pos_left + Stabilizer_Width/2,
                           Wall_Thickness])
                    rotate([0, 0, -90])
                    color("#55FF88")
                    m_stabilizer_fin(Stabilizer_Width, Stabilizer_Depth, Stabilizer_Height);
            }

            // Check if we should avoid this position for right wall
            y_pos_right = right_positions[i];
            skip_right = Stabilizer_Avoid_Right_Opening && Opening_On_Right &&
                         (y_pos_right > right_avoid_min && y_pos_right < right_avoid_max);

            if (!skip_right) {
                // Right wall stabilizer - extends from right wall toward left (-X direction)
                translate([Inner_Width/2,
                           y_pos_right - Stabilizer_Width/2,
                           Wall_Thickness])
                    rotate([0, 0, 90])
                    color("#55FF88")
                    m_stabilizer_fin(Stabilizer_Width, Stabilizer_Depth, Stabilizer_Height);
            }
        }
    }
}

// Main stabilizers module - places all stabilizers
module m_stabilizers() {
    if (Enable_Stabilizers) {
        m_stabilizers_front_back();
        m_stabilizers_left_right();
    }
}

// ============================================
// BOTTOM OPENINGS MODULE
// ============================================

// Single bottom opening shape
module m_bottom_opening_shape(width, length, corner_radius) {
    effective_radius = min(corner_radius, width/2, length/2);

    actual_w = (Bottom_Opening_Orientation == "Along X") ? length : width;
    actual_l = (Bottom_Opening_Orientation == "Along X") ? width : length;
    eff_r = min(effective_radius, actual_w/2, actual_l/2);

    if (eff_r <= 0) {
        cube([actual_w, actual_l, Wall_Thickness + SPACER*2], center=true);
    } else {
        hull() {
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (actual_w/2 - eff_r),
                               y * (actual_l/2 - eff_r),
                               0])
                        cylinder(r=eff_r,
                                 h=Wall_Thickness + SPACER*2,
                                 center=true);
                }
            }
        }
    }
}

// Calculate the size of one opening along the arrangement axis
function get_opening_size_along_axis() =
    (Bottom_Opening_Axis == "Along X") ?
        ((Bottom_Opening_Orientation == "Along X") ? Bottom_Opening_Depth : Bottom_Opening_Width) :
        ((Bottom_Opening_Orientation == "Along Y") ? Bottom_Opening_Depth : Bottom_Opening_Width);

// Calculate the size of one opening perpendicular to the arrangement axis
function get_opening_size_perp_axis() =
    (Bottom_Opening_Axis == "Along X") ?
        ((Bottom_Opening_Orientation == "Along Y") ? Bottom_Opening_Depth : Bottom_Opening_Width) :
        ((Bottom_Opening_Orientation == "Along X") ? Bottom_Opening_Depth : Bottom_Opening_Width);

// Place all bottom openings based on alignment settings
module m_bottom_openings() {
    opening_size = get_opening_size_along_axis();
    opening_size_perp = get_opening_size_perp_axis();

    // Determine available space based on axis
    if (Bottom_Opening_Axis == "Along X") {
        // Openings arranged along X axis
        available_x = Inner_Width;
        available_y = Inner_Depth;

        // Calculate secondary axis position (Y)
        custom_secondary_range_y = max(0, Inner_Depth - Bottom_Opening_Margin_Front - Bottom_Opening_Margin_Back);
        y_pos = (Bottom_Opening_Alignment_Secondary == "Centered") ? 0 :
                (Bottom_Opening_Alignment_Secondary == "Start") ?
                    -Inner_Depth/2 + Bottom_Opening_Margin_Front + opening_size_perp/2 :
                (Bottom_Opening_Alignment_Secondary == "End") ?
                    Inner_Depth/2 - Bottom_Opening_Margin_Back - opening_size_perp/2 :
                // Custom - center inside front/back custom margins
                    -Inner_Depth/2 + Bottom_Opening_Margin_Front + custom_secondary_range_y/2;

        // Handle post avoidance
        if (Enable_Post && Bottom_Opening_Avoid_Post && Bottom_Openings_Count > 0) {
            m_place_openings_avoid_post_x(opening_size, y_pos);
        } else {
            m_place_openings_along_x(opening_size, y_pos, available_x);
        }
    } else {
        // Openings arranged along Y axis
        available_x = Inner_Width;
        available_y = Inner_Depth;

        // Calculate secondary axis position (X)
        custom_secondary_range_x = max(0, Inner_Width - Bottom_Opening_Margin_Left - Bottom_Opening_Margin_Right);
        x_pos = (Bottom_Opening_Alignment_Secondary == "Centered") ? 0 :
                (Bottom_Opening_Alignment_Secondary == "Start") ?
                    -Inner_Width/2 + Bottom_Opening_Margin_Left + opening_size_perp/2 :
                (Bottom_Opening_Alignment_Secondary == "End") ?
                    Inner_Width/2 - Bottom_Opening_Margin_Right - opening_size_perp/2 :
                // Custom - center inside left/right custom margins
                    -Inner_Width/2 + Bottom_Opening_Margin_Left + custom_secondary_range_x/2;

        // Handle post avoidance
        if (Enable_Post && Bottom_Opening_Avoid_Post && Bottom_Openings_Count > 0) {
            m_place_openings_avoid_post_y(opening_size, x_pos);
        } else {
            m_place_openings_along_y(opening_size, x_pos, available_y);
        }
    }
}

// Place openings along X axis with alignment
module m_place_openings_along_x(opening_size, y_pos, available_x) {
    // Calculate usable width based on alignment
    usable_start = (Bottom_Opening_Alignment_Primary == "Custom" ||
                    Bottom_Opening_Alignment_Primary == "Start") ?
                   -Inner_Width/2 + Bottom_Opening_Margin_Left :
                   -Inner_Width/2;

    usable_end = (Bottom_Opening_Alignment_Primary == "Custom" ||
                  Bottom_Opening_Alignment_Primary == "End") ?
                 Inner_Width/2 - Bottom_Opening_Margin_Right :
                 Inner_Width/2;

    usable_width = usable_end - usable_start;

    // Calculate total width of all openings with spacing
    spacing = (Bottom_Opening_Spacing > 0) ? Bottom_Opening_Spacing :
              (Bottom_Openings_Count > 1 && Bottom_Opening_Alignment_Primary == "Distributed") ?
              (usable_width - Bottom_Openings_Count * opening_size) / (Bottom_Openings_Count - 1) :
              (Bottom_Openings_Count > 1) ? opening_size * 0.5 : 0;

    total_width = opening_size * Bottom_Openings_Count + spacing * (Bottom_Openings_Count - 1);

    // Calculate starting position based on alignment
    start_x =
        (Bottom_Opening_Alignment_Primary == "Centered") ?
            -total_width/2 + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "Distributed") ?
            usable_start + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "Start") ?
            usable_start + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "End") ?
            usable_end - total_width + opening_size/2 :
        // Custom
            usable_start + opening_size/2;

    // Recalculate spacing for distributed mode
    actual_spacing = (Bottom_Opening_Alignment_Primary == "Distributed" && Bottom_Openings_Count > 1) ?
                     (usable_width - opening_size) / (Bottom_Openings_Count - 1) :
                     opening_size + spacing;

    // Guard the count. At 0 this range becomes [0:-1], which OpenSCAD's
    // deprecated reverse-range behaviour iterates as -1 then 0, cutting two
    // unintended openings that can sever the centre post from the floor.
    if (Bottom_Openings_Count > 0)
    for (i = [0:Bottom_Openings_Count-1]) {
        x_pos = (Bottom_Opening_Alignment_Primary == "Distributed") ?
                usable_start + opening_size/2 + i * actual_spacing :
                start_x + i * (opening_size + spacing);

        translate([x_pos, y_pos, Wall_Thickness/2])
            m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
    }
}

// Place openings along Y axis with alignment
module m_place_openings_along_y(opening_size, x_pos, available_y) {
    usable_start = (Bottom_Opening_Alignment_Primary == "Custom" ||
                    Bottom_Opening_Alignment_Primary == "Start") ?
                   -Inner_Depth/2 + Bottom_Opening_Margin_Front :
                   -Inner_Depth/2;

    usable_end = (Bottom_Opening_Alignment_Primary == "Custom" ||
                  Bottom_Opening_Alignment_Primary == "End") ?
                 Inner_Depth/2 - Bottom_Opening_Margin_Back :
                 Inner_Depth/2;

    usable_depth = usable_end - usable_start;

    spacing = (Bottom_Opening_Spacing > 0) ? Bottom_Opening_Spacing :
              (Bottom_Openings_Count > 1 && Bottom_Opening_Alignment_Primary == "Distributed") ?
              (usable_depth - Bottom_Openings_Count * opening_size) / (Bottom_Openings_Count - 1) :
              (Bottom_Openings_Count > 1) ? opening_size * 0.5 : 0;

    total_length = opening_size * Bottom_Openings_Count + spacing * (Bottom_Openings_Count - 1);

    start_y =
        (Bottom_Opening_Alignment_Primary == "Centered") ?
            -total_length/2 + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "Distributed") ?
            usable_start + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "Start") ?
            usable_start + opening_size/2 :
        (Bottom_Opening_Alignment_Primary == "End") ?
            usable_end - total_length + opening_size/2 :
            usable_start + opening_size/2;

    actual_spacing = (Bottom_Opening_Alignment_Primary == "Distributed" && Bottom_Openings_Count > 1) ?
                     (usable_depth - opening_size) / (Bottom_Openings_Count - 1) :
                     opening_size + spacing;

    // See m_place_openings_along_x for why the count is guarded here.
    if (Bottom_Openings_Count > 0)
    for (i = [0:Bottom_Openings_Count-1]) {
        y_pos = (Bottom_Opening_Alignment_Primary == "Distributed") ?
                usable_start + opening_size/2 + i * actual_spacing :
                start_y + i * (opening_size + spacing);

        translate([x_pos, y_pos, Wall_Thickness/2])
            m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
    }
}

// Place openings avoiding post (along X)
module m_place_openings_avoid_post_x(opening_size, y_pos) {
    alignment = Bottom_Opening_Alignment_Primary;
    post_clearance = Post_Diameter/2 + Bottom_Opening_Post_Margin;

    usable_start = (alignment == "Custom" || alignment == "Start") ?
                   -Inner_Width/2 + Bottom_Opening_Margin_Left :
                   -Inner_Width/2;
    usable_end = (alignment == "Custom" || alignment == "End") ?
                 Inner_Width/2 - Bottom_Opening_Margin_Right :
                 Inner_Width/2;

    left_seg_start = usable_start;
    left_seg_end = min(-post_clearance, usable_end);
    right_seg_start = max(post_clearance, usable_start);
    right_seg_end = usable_end;

    left_len = max(0, left_seg_end - left_seg_start);
    right_len = max(0, right_seg_end - right_seg_start);
    total_len = left_len + right_len;

    desired_left =
        (Bottom_Openings_Count <= 0) ? 0 :
        (alignment == "Start" || alignment == "Custom") ? Bottom_Openings_Count :
        (alignment == "End") ? 0 :
        (alignment == "Distributed" && total_len > 0) ?
            round(Bottom_Openings_Count * left_len / total_len) :
            floor(Bottom_Openings_Count / 2);
    desired_right = Bottom_Openings_Count - desired_left;

    left_cap = floor((left_len + 0.0001) / max(opening_size, 0.0001));
    right_cap = floor((right_len + 0.0001) / max(opening_size, 0.0001));

    left_count0 = min(desired_left, left_cap);
    right_count0 = min(desired_right, right_cap);
    remaining0 = Bottom_Openings_Count - left_count0 - right_count0;

    left_pref_extra = (alignment == "End") ? 0 :
                      min(max(0, left_cap - left_count0), remaining0);
    left_count1 = left_count0 + left_pref_extra;
    remaining1 = remaining0 - left_pref_extra;

    right_extra = min(max(0, right_cap - right_count0), remaining1);
    right_count1 = right_count0 + right_extra;
    remaining2 = remaining1 - right_extra;

    left_extra = min(max(0, left_cap - left_count1), remaining2);
    left_count = left_count1 + left_extra;
    right_count = right_count1;
    remaining = remaining2 - left_extra;

    if (remaining > 0)
        echo(str("Bottom openings omitted by post clearance: ", remaining));

    base_gap = (Bottom_Opening_Spacing > 0) ? Bottom_Opening_Spacing : opening_size * 0.5;

    // Left segment
    if (left_count > 0) {
        left_total = opening_size * left_count + base_gap * (left_count - 1);
        left_use_distributed = (alignment == "Distributed" || left_total > left_len) && left_count > 1;
        left_gap = left_use_distributed ?
                   max(0, (left_len - left_count * opening_size) / (left_count - 1)) :
                   base_gap;
        left_step = opening_size + left_gap;
        left_total_actual = opening_size * left_count + left_gap * (left_count - 1);
        left_start =
            left_use_distributed ?
                left_seg_start + opening_size/2 :
            (alignment == "End") ?
                left_seg_end - left_total_actual + opening_size/2 :
            (alignment == "Centered") ?
                left_seg_start + (left_len - left_total_actual)/2 + opening_size/2 :
                left_seg_start + opening_size/2;

        for (i = [0:left_count-1]) {
            x_pos = left_start + i * left_step;
            translate([x_pos, y_pos, Wall_Thickness/2])
                m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
        }
    }

    // Right segment
    if (right_count > 0) {
        right_total = opening_size * right_count + base_gap * (right_count - 1);
        right_use_distributed = (alignment == "Distributed" || right_total > right_len) && right_count > 1;
        right_gap = right_use_distributed ?
                    max(0, (right_len - right_count * opening_size) / (right_count - 1)) :
                    base_gap;
        right_step = opening_size + right_gap;
        right_total_actual = opening_size * right_count + right_gap * (right_count - 1);
        right_start =
            right_use_distributed ?
                right_seg_start + opening_size/2 :
            (alignment == "Start" || alignment == "Custom") ?
                right_seg_start + opening_size/2 :
            (alignment == "Centered") ?
                right_seg_start + (right_len - right_total_actual)/2 + opening_size/2 :
                right_seg_end - right_total_actual + opening_size/2;

        for (i = [0:right_count-1]) {
            x_pos = right_start + i * right_step;
            translate([x_pos, y_pos, Wall_Thickness/2])
                m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
        }
    }
}

// Place openings avoiding post (along Y)
module m_place_openings_avoid_post_y(opening_size, x_pos) {
    alignment = Bottom_Opening_Alignment_Primary;
    post_clearance = Post_Diameter/2 + Bottom_Opening_Post_Margin;

    usable_start = (alignment == "Custom" || alignment == "Start") ?
                   -Inner_Depth/2 + Bottom_Opening_Margin_Front :
                   -Inner_Depth/2;
    usable_end = (alignment == "Custom" || alignment == "End") ?
                 Inner_Depth/2 - Bottom_Opening_Margin_Back :
                 Inner_Depth/2;

    front_seg_start = usable_start;
    front_seg_end = min(-post_clearance, usable_end);
    back_seg_start = max(post_clearance, usable_start);
    back_seg_end = usable_end;

    front_len = max(0, front_seg_end - front_seg_start);
    back_len = max(0, back_seg_end - back_seg_start);
    total_len = front_len + back_len;

    desired_front =
        (Bottom_Openings_Count <= 0) ? 0 :
        (alignment == "Start" || alignment == "Custom") ? Bottom_Openings_Count :
        (alignment == "End") ? 0 :
        (alignment == "Distributed" && total_len > 0) ?
            round(Bottom_Openings_Count * front_len / total_len) :
            floor(Bottom_Openings_Count / 2);
    desired_back = Bottom_Openings_Count - desired_front;

    front_cap = floor((front_len + 0.0001) / max(opening_size, 0.0001));
    back_cap = floor((back_len + 0.0001) / max(opening_size, 0.0001));

    front_count0 = min(desired_front, front_cap);
    back_count0 = min(desired_back, back_cap);
    remaining0 = Bottom_Openings_Count - front_count0 - back_count0;

    front_pref_extra = (alignment == "End") ? 0 :
                       min(max(0, front_cap - front_count0), remaining0);
    front_count1 = front_count0 + front_pref_extra;
    remaining1 = remaining0 - front_pref_extra;

    back_extra = min(max(0, back_cap - back_count0), remaining1);
    back_count1 = back_count0 + back_extra;
    remaining2 = remaining1 - back_extra;

    front_extra = min(max(0, front_cap - front_count1), remaining2);
    front_count = front_count1 + front_extra;
    back_count = back_count1;
    remaining = remaining2 - front_extra;

    if (remaining > 0)
        echo(str("Bottom openings omitted by post clearance: ", remaining));

    base_gap = (Bottom_Opening_Spacing > 0) ? Bottom_Opening_Spacing : opening_size * 0.5;

    // Front segment
    if (front_count > 0) {
        front_total = opening_size * front_count + base_gap * (front_count - 1);
        front_use_distributed = (alignment == "Distributed" || front_total > front_len) && front_count > 1;
        front_gap = front_use_distributed ?
                    max(0, (front_len - front_count * opening_size) / (front_count - 1)) :
                    base_gap;
        front_step = opening_size + front_gap;
        front_total_actual = opening_size * front_count + front_gap * (front_count - 1);
        front_start =
            front_use_distributed ?
                front_seg_start + opening_size/2 :
            (alignment == "End") ?
                front_seg_end - front_total_actual + opening_size/2 :
            (alignment == "Centered") ?
                front_seg_start + (front_len - front_total_actual)/2 + opening_size/2 :
                front_seg_start + opening_size/2;

        for (i = [0:front_count-1]) {
            y_pos_front = front_start + i * front_step;
            translate([x_pos, y_pos_front, Wall_Thickness/2])
                m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
        }
    }

    // Back segment
    if (back_count > 0) {
        back_total = opening_size * back_count + base_gap * (back_count - 1);
        back_use_distributed = (alignment == "Distributed" || back_total > back_len) && back_count > 1;
        back_gap = back_use_distributed ?
                   max(0, (back_len - back_count * opening_size) / (back_count - 1)) :
                   base_gap;
        back_step = opening_size + back_gap;
        back_total_actual = opening_size * back_count + back_gap * (back_count - 1);
        back_start =
            back_use_distributed ?
                back_seg_start + opening_size/2 :
            (alignment == "Start" || alignment == "Custom") ?
                back_seg_start + opening_size/2 :
            (alignment == "Centered") ?
                back_seg_start + (back_len - back_total_actual)/2 + opening_size/2 :
                back_seg_end - back_total_actual + opening_size/2;

        for (i = [0:back_count-1]) {
            y_pos_back = back_start + i * back_step;
            translate([x_pos, y_pos_back, Wall_Thickness/2])
                m_bottom_opening_shape(Bottom_Opening_Width, Bottom_Opening_Depth, Bottom_Opening_Corner_Radius);
        }
    }
}

// ============================================
// SIMPLE FLOOR/CEILING CLIP MODULES
// ============================================

module m_floor_clip_male() {
    cube([Clip_Tab_Depth, Clip_Tab_Width, Clip_Tab_Height], center=true);
}

module m_floor_clip_female() {
    cube([Clip_Tab_Depth + Clip_Tolerance*2 + SPACER,
          Clip_Tab_Width + Clip_Tolerance*2,
          Clip_Tab_Height + Clip_Tolerance*2 + SPACER], center=true);
}

module m_place_floor_clips(x_pos, is_male) {
    z_pos = Wall_Thickness / 2;
    usable_depth = Box_Depth - Wall_Thickness*2 - Clip_Tab_Width;
    female_depth = Clip_Tab_Depth + Clip_Tolerance*2 + SPACER;
    // Offsets intentionally overlap seam slightly to avoid tangent-only booleans.
    male_x_offset = Clip_Tab_Depth/2 - SPACER;
    female_x_offset = female_depth/2 - SPACER;
    x_offset = is_male ? male_x_offset : female_x_offset;

    y_limit = Inner_Depth/2 - Clip_Tab_Width/2;

    if (Clips_Per_Edge == 1) {
        translate([x_pos + x_offset, clear_post_opening(0, Floor_Clip_Clearance, y_limit), z_pos])
            if (is_male) m_floor_clip_male();
            else m_floor_clip_female();
    } else {
        y_spacing = usable_depth / (Clips_Per_Edge - 1);
        y_start = -usable_depth/2;

        for (i = [0:Clips_Per_Edge-1]) {
            translate([x_pos + x_offset,
                       clear_post_opening(y_start + y_spacing * i, Floor_Clip_Clearance, y_limit),
                       z_pos])
                if (is_male) m_floor_clip_male();
                else m_floor_clip_female();
        }
    }
}

module m_place_lid_clips(x_pos, is_male) {
    z_pos = Lid_Height - Clip_Tab_Height/2;
    lid_depth = Box_Depth + Wall_Thickness*2 + Lid_Lip_Gap;
    usable_depth = lid_depth - Clip_Tab_Width*2;
    female_depth = Clip_Tab_Depth + Clip_Tolerance*2 + SPACER;
    // Offsets intentionally overlap seam slightly to avoid tangent-only booleans.
    male_x_offset = Clip_Tab_Depth/2 - SPACER;
    female_x_offset = female_depth/2 - SPACER;
    x_offset = is_male ? male_x_offset : female_x_offset;

    y_limit = usable_depth/2;

    if (Clips_Per_Edge == 1) {
        translate([x_pos + x_offset, clear_post_opening(0, Lid_Clip_Clearance, y_limit), z_pos])
            if (is_male) m_floor_clip_male();
            else m_floor_clip_female();
    } else {
        y_spacing = usable_depth / (Clips_Per_Edge - 1);
        y_start = -usable_depth/2;

        for (i = [0:Clips_Per_Edge-1]) {
            translate([x_pos + x_offset,
                       clear_post_opening(y_start + y_spacing * i, Lid_Clip_Clearance, y_limit),
                       z_pos])
                if (is_male) m_floor_clip_male();
                else m_floor_clip_female();
        }
    }
}

// ============================================
// ORIGINAL BOX MODULES
// ============================================

module m_box_base() {
    difference() {
        {
            union() {
                difference() {
                    color("#009292")
                    cuboid([Box_Width, Box_Depth, Box_Height],
                        rounding = Corner_Radius,
                        except = [TOP, BOTTOM],
                        anchor = [0, 0, -1]);

                    color("#88070B")
                    up(Wall_Thickness)
                    cuboid([Box_Width-Wall_Thickness*2, Box_Depth-Wall_Thickness*2, Box_Height+SPACER],
                        rounding = Corner_Radius,
                        except = [TOP, BOTTOM],
                        anchor = [0, 0, -1]);
                }

                if (Enable_Post)
                    color("#F65156")
                    cyl(d = Post_Diameter, h = Box_Height, anchor = [0, 0, -1]);

                // Add stabilizers (v5)
                m_stabilizers();
            }
        }

        // Post bore. Closed_Post closes the BOTTOM, so the cut has to start
        // above the floor. Shortening the cut from the top instead would leave
        // a cap at the post's upper end and the floor still open.
        if (Enable_Post)
            color("#F65156")
            up(Closed_Post ? Wall_Thickness : -SPACER)
            cyl(d = Post_Diameter-Wall_Thickness*2,
                h = Box_Height + SPACER*2,
                anchor = [0, 0, -1]);

        if (Enable_Bottom_Openings)
            m_bottom_openings();
    }
}

module m_box_with_openings() {
    difference() {
        m_box_base();

        union() {
            if (Opening_On_Back)
                back((Box_Depth/2-Wall_Thickness/2))
                right(get_opening_center_offset("Back"))
                up(Move_Opening_Back_Up + All_Openings_Up)
                m_opening(side="Back",
                    width = Override_Opening_Width_Back > 0 ? Override_Opening_Width_Back: All_Opening_Width,
                    height = Override_Opening_Height_Back > 0 ? Override_Opening_Height_Back: All_Opening_Height,
                    corner_radius = get_effective_opening_corner_radius("Back"));

            if (Opening_On_Front)
                back(-(Box_Depth/2-Wall_Thickness/2))
                right(get_opening_center_offset("Front"))
                up(Move_Opening_Front_Up + All_Openings_Up)
                m_opening(side="Front",
                    width = Override_Opening_Width_Front > 0 ? Override_Opening_Width_Front: All_Opening_Width,
                    height = Override_Opening_Height_Front > 0 ? Override_Opening_Height_Front: All_Opening_Height,
                    corner_radius = get_effective_opening_corner_radius("Front"));

            if (Opening_On_Right)
                right(Box_Width/2-Wall_Thickness/2)
                up(Move_Opening_Right_Up + All_Openings_Up)
                back(get_opening_center_offset("Right"))
                m_opening(side="Right",
                    width = Override_Opening_Width_Right > 0 ? Override_Opening_Width_Right: All_Opening_Width,
                    height = Override_Opening_Height_Right > 0 ? Override_Opening_Height_Right: All_Opening_Height,
                    corner_radius = get_effective_opening_corner_radius("Right"));

            if (Opening_On_Left)
                left(Box_Width/2-Wall_Thickness/2)
                up(Move_Opening_Left_Up + All_Openings_Up)
                back(get_opening_center_offset("Left"))
                m_opening(side="Left",
                    width = Override_Opening_Width_Left > 0 ? Override_Opening_Width_Left: All_Opening_Width,
                    height = Override_Opening_Height_Left > 0 ? Override_Opening_Height_Left: All_Opening_Height,
                    corner_radius = get_effective_opening_corner_radius("Left"));
        }
    }
}

module m_box_slice(slice_num) {
    slice_width = Box_Width / Slice_Count;
    slice_start_x = -Box_Width/2 + (slice_num - 1) * slice_width;
    slice_end_x = slice_start_x + slice_width;
    slice_center_x = (slice_start_x + slice_end_x) / 2;

    is_first_slice = (slice_num == 1);
    is_last_slice = (slice_num == Slice_Count);

    translate([-slice_center_x, 0, 0])
    union() {
        difference() {
            m_box_with_openings();

            if (!is_first_slice) {
                translate([slice_start_x - Box_Width, 0, Box_Height/2])
                    cube([Box_Width*2, Box_Depth*2, Box_Height*2], center=true);
            }

            if (!is_last_slice) {
                translate([slice_end_x + Box_Width, 0, Box_Height/2])
                    cube([Box_Width*2, Box_Depth*2, Box_Height*2], center=true);
            }

            if (!is_first_slice) {
                m_place_floor_clips(slice_start_x, false);
            }
        }

        if (!is_last_slice) {
            color("#00FF00")
            m_place_floor_clips(slice_end_x, true);
        }
    }
}

module m_lid () {
    difference() {
        union() {
            if (Enable_Post) {
                color("#F65156")
                up(Lid_Height)
                cyl(d = Post_Diameter + Wall_Thickness, h = Lid_Lip_Gap_Height, anchor = [0, 0, -1]);
            }

            color("#FFCE13")
            cuboid([Box_Width + Wall_Thickness*2 + Lid_Lip_Gap,
                    Box_Depth + Wall_Thickness*2 + Lid_Lip_Gap,
                    Lid_Height],
                rounding = Corner_Radius,
                except = [TOP, BOTTOM],
                anchor = [0, 0, -1]);

            difference() {
                color("#FFCE13")
                translate([0, 0, Lid_Height])
                cuboid([Box_Width + Lid_Lip_Gap,
                        Box_Depth + Lid_Lip_Gap,
                        Lid_Lip_Gap_Height],
                    rounding = Corner_Radius,
                    except = [TOP, BOTTOM],
                    anchor = [0, 0, -1]);

                color("#FFCE13")
                translate([0, 0, Lid_Height])
                cuboid([Box_Width - Wall_Thickness + Lid_Lip_Gap,
                        Box_Depth - Wall_Thickness + Lid_Lip_Gap,
                        Lid_Lip_Gap_Height+SPACER],
                    rounding = Corner_Radius,
                    except = [TOP, BOTTOM],
                    anchor = [0, 0, -1]);
            }

        }

        if (Enable_Post) {
            color("#F65156")
            up(Lid_Height)
            down(Wall_Thickness+Lid_Lip_Gap + min(0.2, Lid_Height))
            cyl(d = Post_Diameter,
                h = Lid_Lip_Gap_Height+Wall_Thickness+Lid_Lip_Gap+ min(0.2, Lid_Height) + SPACER,
                anchor = [0, 0, -1]);
        }

    }
}

module m_lid_slice(slice_num) {
    lid_width = Box_Width + Wall_Thickness*2 + Lid_Lip_Gap;
    slice_width = lid_width / Slice_Count;
    slice_start_x = -lid_width/2 + (slice_num - 1) * slice_width;
    slice_end_x = slice_start_x + slice_width;
    slice_center_x = (slice_start_x + slice_end_x) / 2;

    is_first_slice = (slice_num == 1);
    is_last_slice = (slice_num == Slice_Count);

    translate([-slice_center_x, 0, 0])
    union() {
        difference() {
            m_lid();

            if (!is_first_slice) {
                translate([slice_start_x - lid_width, 0, Lid_Height])
                    cube([lid_width*2, Box_Depth*2, Lid_Height*4], center=true);
            }

            if (!is_last_slice) {
                translate([slice_end_x + lid_width, 0, Lid_Height])
                    cube([lid_width*2, Box_Depth*2, Lid_Height*4], center=true);
            }

            if (!is_first_slice) {
                m_place_lid_clips(slice_start_x, false);
            }
        }

        if (!is_last_slice) {
            color("#00FF00")
            m_place_lid_clips(slice_end_x, true);
        }
    }
}

// Cuts one side opening. The module's local origin is the opening's BOTTOM
// edge, not its centre, so a caller placing it at z=0 gets the full requested
// height sitting flush with the box floor. Centring the cut on the origin
// instead would drop half of it below the box, silently halving the opening.
module m_opening (side, width, height, corner_radius) {
    new_thickness = Wall_Thickness + SPACER * 2;
    max_corner_radius = min(width, height) / 2;
    effective_corner_radius =
        (corner_radius < 0) ? max_corner_radius :
        min(max(corner_radius, 0), max_corner_radius);
    side_wall = (side == "Right" || side == "Left");

    // Sink the cut SPACER below its own bottom edge. With the opening anchored
    // flush to the box floor, a cut that stops exactly on z=0 is tangent to the
    // box bottom plane, which leaves a zero-thickness knife edge and makes the
    // whole solid non-manifold ("Simple: no"). Sinking it means the cut crosses
    // that plane with real cross-section instead of touching it.
    up(height / 2 - SPACER)
    if (effective_corner_radius <= 0) {
        // Square opening
        if (side_wall)
            cube([new_thickness, width, height + SPACER * 2], center = true);
        else
            cube([width, new_thickness, height + SPACER * 2], center = true);
    } else {
        // Rounded-rectangle opening
        x_offset = width/2 - effective_corner_radius;
        z_offset = height/2 - effective_corner_radius;

        hull() {
            for (x_sign = [-1, 1], z_sign = [-1, 1]) {
                if (side_wall)
                    translate([0, x_sign * x_offset, z_sign * z_offset])
                        cyl(d = effective_corner_radius * 2, h = new_thickness, anchor = [0, 0, 0], orient = RIGHT);
                else
                    translate([x_sign * x_offset, 0, z_sign * z_offset])
                        cyl(d = effective_corner_radius * 2, h = new_thickness, anchor = [0, 0, 0], orient = BACK);
            }
        }
    }
}

// ============================================
// MAIN RENDER MODULE
// ============================================

module full_render() {
    if (Enable_Slicing) {
        if (Slice_Piece_To_Render == 0) {
            for (i = [1:Slice_Count]) {
                x_offset = (i - 1) * (Slice_Width + Slice_Preview_Spacing) - (Slice_Count - 1) * (Slice_Width + Slice_Preview_Spacing) / 2;

                translate([x_offset, 0, 0]) {
                    if (Part_To_Render != "Lid Only") {
                        m_box_slice(i);
                    }
                    if (Part_To_Render != "Box Only") {
                        lid_slice_width = (Box_Width + Wall_Thickness*2 + Lid_Lip_Gap) / Slice_Count;
                        lid_x_offset = (i - 1) * (lid_slice_width + Slice_Preview_Spacing) - (Slice_Count - 1) * (lid_slice_width + Slice_Preview_Spacing) / 2;
                        translate([lid_x_offset - x_offset, Box_Depth + 20, 0])
                            m_lid_slice(i);
                    }
                }
            }
        } else {
            if (Part_To_Render != "Lid Only") {
                m_box_slice(Slice_Piece_To_Render);
            }
            if (Part_To_Render != "Box Only") {
                translate([0, Box_Depth + 20, 0])
                    m_lid_slice(Slice_Piece_To_Render);
            }
        }
    } else {
        if (Part_To_Render != "Box Only") {
            right((Part_To_Render != "Lid Only") ? Box_Width + 20 : 0)
                m_lid();
        }
        if (Part_To_Render != "Lid Only") {
            m_box_with_openings();
        }
    }
}

full_render();


/*
--------- BEGIN BOSL2 ----------
  Copied from BOSL2 Library (27 February 2022) (https://codeandmake.com/)
  https://github.com/revarbat/BOSL2
  BSD 2-Clause License
  Copyright (c) 2017-2019, Revar Desmera
  All rights reserved.

*/
_UNDEF="LRG+HX7dy89RyHvDlAKvb9Y04OTuaikpx205CTh8BSI"; $slop = 0.0; INCH = 25.4; LEFT  = [-1,  0,  0]; RIGHT = [ 1,  0,  0]; FRONT = [ 0, -1,  0]; FWD = FRONT; FORWARD = FRONT; BACK  = [ 0,  1,  0]; BOTTOM  = [ 0,  0, -1]; BOT = BOTTOM; DOWN = BOTTOM; TOP = [ 0,  0,  1]; UP = TOP; CENTER = [ 0,  0,  0]; CTR = CENTER; CENTRE = CENTER; SEGMENT = [true,true]; RAY = [true, false]; LINE = [false, false];PHI = (1+sqrt(5))/2; EPSILON = 1e-9; INF = 1/0; NAN = acos(2); function sqr(x) = assert(is_finite(x) || is_vector(x) || is_matrix(x), "Input is not a number nor a list of numbers.") x*x; function log2(x) = assert( is_finite(x), "Input is not a number.") ln(x)/ln(2); function hypot(x,y,z=0) = assert( is_vector([x,y,z]), "Improper number(s).") norm([x,y,z]); function factorial(n,d=0) = assert(is_int(n) && is_int(d) && n>=0 && d>=0, "Factorial is defined only for non negative integers") assert(d<=n, "d cannot be larger than n") product([1,for (i=[n:-1:d+1]) i]); function binomial(n) = assert( is_int(n) && n>0, "Input is not an integer greater than 0.") [for( c = 1, i = 0; i<=n; c = c*(n-i)/(i+1), i = i+1 ) c ] ; function binomial_coefficient(n,k) = assert( is_int(n) && is_int(k), "Some input is not a number.") k < 0 || k > n ? 0 : k ==0 || k ==n ? 1 : let( k = min(k, n-k), b = [for( c = 1, i = 0; i<=k; c = c*(n-i)/(i+1), i = i+1 ) c] ) b[len(b)-1]; function lerp(a,b,u) = assert(same_shape(a,b), "Bad or inconsistent inputs to lerp") is_finite(u)? (1-u)*a + u*b : assert(is_finite(u) || is_vector(u) || valid_range(u), "Input u to lerp must be a number, vector, or valid range.") [for (v = u) (1-v)*a + v*b ]; function lerpn(a,b,n,endpoint=true) = assert(same_shape(a,b), "Bad or inconsistent inputs to lerpn") assert(is_int(n)) assert(is_bool(endpoint)) let( d = n - (endpoint? 1 : 0) ) [for (i=[0:1:n-1]) let(u=i/d) (1-u)*a + u*b]; function u_add(a,b) = is_undef(a) || is_undef(b)? undef : a + b; function u_sub(a,b) = is_undef(a) || is_undef(b)? undef : a - b; function u_mul(a,b) = is_undef(a) || is_undef(b)? undef : is_vector(a) && is_vector(b)? v_mul(a,b) : a * b; function u_div(a,b) = is_undef(a) || is_undef(b)? undef : is_vector(a) && is_vector(b)? v_div(a,b) : a / b; function sinh(x) = assert(is_finite(x), "The input must be a finite number.") (exp(x)-exp(-x))/2; function cosh(x) = assert(is_finite(x), "The input must be a finite number.") (exp(x)+exp(-x))/2; function tanh(x) = assert(is_finite(x), "The input must be a finite number.") sinh(x)/cosh(x); function asinh(x) = assert(is_finite(x), "The input must be a finite number.") ln(x+sqrt(x*x+1)); function acosh(x) = assert(is_finite(x), "The input must be a finite number.") ln(x+sqrt(x*x-1)); function atanh(x) = assert(is_finite(x), "The input must be a finite number.") ln((1+x)/(1-x))/2; function quant(x,y) = assert( is_finite(y) && y>0, "The quantum `y` must be a non zero integer.") is_list(x) ?   [for (v=x) quant(v,y)] :   assert( is_finite(x), "The input to quantize is not a number nor a list of numbers.") floor(x/y+0.5)*y; function quantdn(x,y) = assert( is_finite(y) && y>0, "The quantum `y` must be a non zero integer.") is_list(x) ?   [for (v=x) quantdn(v,y)] :   assert( is_finite(x), "The input to quantize must be a number or a list of numbers.") floor(x/y)*y; function quantup(x,y) = assert( is_finite(y) && y>0, "The quantum `y` must be a non zero integer.") is_list(x) ?   [for (v=x) quantup(v,y)] :   assert( is_finite(x), "The input to quantize must be a number or a list of numbers.") ceil(x/y)*y; function constrain(v, minval, maxval) = assert( is_finite(v+minval+maxval), "Input must be finite number(s).") min(maxval, max(minval, v)); function posmod(x,m) = assert( is_finite(x) && is_finite(m) && !approx(m,0) , "Input must be finite numbers. The divisor cannot be zero.") (x%m+m)%m; function modang(x) = assert( is_finite(x), "Input must be a finite number.") let(xx = posmod(x,360)) xx<180? xx : xx-360; function rand_int(minval, maxval, N, seed=undef) = assert( is_finite(minval+maxval+N) && (is_undef(seed) || is_finite(seed) ), "Input must be finite numbers.") assert(maxval >= minval, "Max value cannot be smaller than minval") let (rvect = is_def(seed) ? rands(minval,maxval+1,N,seed) : rands(minval,maxval+1,N)) [for(entry = rvect) floor(entry)]; function random_points(N, dim=2, scale=1, seed) = assert( is_int(N) && N>=0, "The number of points should be a non-negative integer.") assert( is_int(dim) && dim>=1, "The point dimensions should be an integer greater than 1.") assert( is_finite(scale) || is_vector(scale,dim), "The scale should be a number or a vector with length equal to d.") let( rnds =   is_undef(seed) ? rands(-1,1,N*dim) : rands(-1,1,N*dim, seed) ) is_num(scale) ? scale*[for(i=[0:1:N-1]) [for(j=[0:dim-1]) rnds[i*dim+j] ] ] : [for(i=[0:1:N-1]) [for(j=[0:dim-1]) scale[j]*rnds[i*dim+j] ] ]; function gaussian_rands(N=1, mean=0, cov=1, seed=undef) = assert(is_num(mean) || is_vector(mean)) let( dim = is_num(mean) ? 1 : len(mean) ) assert((dim==1 && is_num(cov)) || is_matrix(cov,dim,dim),"mean and covariance matrix not compatible") assert(is_undef(seed) || is_finite(seed)) let( nums = is_undef(seed)? rands(0,1,dim*N*2) : rands(0,1,dim*N*2,seed), rdata = [for (i = count(dim*N,0,2)) sqrt(-2*ln(nums[i]))*cos(360*nums[i+1])] ) dim==1 ? add_scalar(sqrt(cov)*rdata,mean) : assert(is_matrix_symmetric(cov),"Supplied covariance matrix is not symmetric") let( L = cholesky(cov) ) assert(is_def(L), "Supplied covariance matrix is not positive definite") move(mean,list_to_matrix(rdata,dim)*transpose(L)); function spherical_random_points(N=1, radius=1, seed) = assert( is_int(n) && n>=1, "The number of points should be an integer greater than zero.") assert( is_num(radius) && radius>0, "The radius should be a non-negative number.") let( theta = is_undef(seed) ? rands(0,360,n) : rands(0,360,n, seed), cosphi = rands(-1,1,n)) [for(i=[0:1:n-1]) let( sin_phi=sqrt(1-cosphi[i]*cosphi[i]) ) radius*[sin_phi*cos(theta[i]),sin_phi*sin(theta[i]), cosphi[i]]]; function random_polygon(n=3,size=1, seed) = assert( is_int(n) && n>2, "Improper number of polygon vertices.") assert( is_num(size) && size>0, "Improper size.") let( seed = is_undef(seed) ? rands(0,1,1)[0] : seed, cumm = cumsum(rands(0.1,10,n+1,seed)), angs = 360*cumm/cumm[n-1], rads = rands(.01,size,n,seed+cumm[0]) ) [for(i=count(n)) rads[i]*[cos(angs[i]), sin(angs[i])] ]; function gcd(a,b) = assert(is_int(a) && is_int(b),"Arguments to gcd must be integers") b==0 ? abs(a) : gcd(b,a % b); function _lcm(a,b) = assert(is_int(a) && is_int(b), "Invalid non-integer parameters to lcm") assert(a!=0 && b!=0, "Arguments to lcm should not be zero") abs(a*b) / gcd(a,b); function _lcmlist(a) = len(a)==1 ? a[0] : _lcmlist(concat(lcm(a[0],a[1]),list_tail(a,2))); function lcm(a,b=[]) = !is_list(a) && !is_list(b) ?   _lcm(a,b) :   let( arglist = concat(force_list(a),force_list(b)) ) assert(len(arglist)>0, "Invalid call to lcm with empty list(s)") _lcmlist(arglist); function sum(v, dflt=0) = v==[]? dflt : assert(is_consistent(v), "Input to sum is non-numeric or inconsistent") is_finite(v[0]) || is_vector(v[0]) ? [for(i=v) 1]*v : _sum(v,v[0]*0); function _sum(v,_total,_i=0) = _i>=len(v) ? _total : _sum(v,_total+v[_i], _i+1); function cumsum(v) = assert(is_consistent(v), "The input is not consistent." ) len(v)<=1 ? v : _cumsum(v,_i=1,_acc=[v[0]]); function _cumsum(v,_i=0,_acc=[]) = _i>=len(v) ? _acc : _cumsum( v, _i+1, [ each _acc, _acc[len(_acc)-1] + v[_i] ] ); function sum_of_sines(a, sines) = assert( is_finite(a) && is_matrix(sines,undef,3), "Invalid input.") sum([ for (s = sines) let( ss=point3d(s), v=ss[0]*sin(a*ss[1]+ss[2]) ) v ]); function deltas(v, wrap=false) = assert( is_consistent(v) && len(v)>1 , "Inconsistent list or with length<=1.") [for (p=pair(v,wrap)) p[1]-p[0]] ; function product(v) = assert( is_vector(v) || is_matrix(v) || ( is_matrix(v[0],square=true) && is_consistent(v)), "Invalid input.") _product(v, 1, v[0]); function _product(v, i=0, _tot) = i>=len(v) ? _tot : _product( v, i+1, ( is_vector(v[i])? v_mul(_tot,v[i]) : _tot*v[i] ) ); function cumprod(list) = is_vector(list) ? _cumprod(list) : assert(is_consistent(list), "Input must be a consistent list of scalars, vectors or square matrices") is_matrix(list[0]) ? assert(len(list[0])==len(list[0][0]), "Matrices must be square") _cumprod(list) : _cumprod_vec(list); function _cumprod(v,_i=0,_acc=[]) = _i==len(v) ? _acc : _cumprod( v, _i+1, concat( _acc, [_i==0 ? v[_i] : v[_i]*_acc[len(_acc)-1]] ) ); function _cumprod_vec(v,_i=0,_acc=[]) = _i==len(v) ? _acc : _cumprod_vec( v, _i+1, concat( _acc, [_i==0 ? v[_i] : v_mul(_acc[len(_acc)-1],v[_i])] ) ); function mean(v) = assert(is_list(v) && len(v)>0, "Invalid list.") sum(v)/len(v); function median(v) = assert(is_vector(v), "Input to median must be a vector") len(v)%2 ? max( list_smallest(v, ceil(len(v)/2)) ) : let( lowest = list_smallest(v, len(v)/2 + 1), max  = max(lowest), imax = search(max,lowest,1), max2 = max([for(i=idx(lowest)) if(i!=imax[0]) lowest[i] ]) ) (max+max2)/2; function convolve(p,q) = p==[] || q==[] ? [] : assert( (is_vector(p) || is_matrix(p)) && ( is_vector(q) || (is_matrix(q) && ( !is_vector(p[0]) || (len(p[0])==len(q[0])) ) ) ) , "The inputs should be vectors or paths all of the same dimension.") let( n = len(p), m = len(q)) [for(i=[0:n+m-2], k1 = max(0,i-n+1), k2 = min(i,m-1) ) sum([for(j=[k1:k2]) p[i-j]*q[j] ]) ]; function all_integer(x) = is_num(x)? is_int(x) : is_list(x)? (x != [] && [for (xx=x) if(!is_int(xx)) 1] == []) : false; function any(l, func) = assert(is_list(l), "The input is not a list." ) assert(func==undef || is_func(func)) is_func(func) ? _any_func(l, func) : _any_bool(l); function _any_func(l, func, i=0, out=false) = i >= len(l) || out? out : _any_func(l, func, i=i+1, out=out || func(l[i])); function _any_bool(l, i=0, out=false) = i >= len(l) || out? out : _any_bool(l, i=i+1, out=out || l[i]); function all(l, func) = assert(is_list(l), "The input is not a list.") assert(func==undef || is_func(func)) is_func(func) ? _all_func(l, func) : _all_bool(l); function _all_func(l, func, i=0, out=true) = i >= len(l) || !out? out : _all_func(l, func, i=i+1, out=out && func(l[i])); function _all_bool(l, i=0, out=true) = i >= len(l) || !out? out : _all_bool(l, i=i+1, out=out && l[i]); function count_true(l, func, nmax) = assert(is_list(l)) assert(func==undef || is_func(func)) is_func(func) ? _count_true_func(l, func, nmax) : _count_true_bool(l, nmax); function _count_true_func(l, func, nmax, i=0, out=0) = i >= len(l) || (nmax!=undef && out>=nmax) ? out : _count_true_func( l, func, nmax, i = i + 1, out = out + (func(l[i])? 1:0) ); function _count_true_bool(l, nmax, i=0, out=0) = i >= len(l) || (nmax!=undef && out>=nmax) ? out : _count_true_bool( l, nmax, i = i + 1, out = out + (l[i]? 1:0) ); function deriv(data, h=1, closed=false) = assert( is_consistent(data) , "Input list is not consistent or not numerical.") assert( len(data)>=2, "Input `data` should have at least 2 elements.") assert( is_finite(h) || is_vector(h), "The sampling `h` must be a number or a list of numbers." ) assert( is_num(h) || len(h) == len(data)-(closed?0:1), str("Vector valued `h` must have length ",len(data)-(closed?0:1))) is_vector(h) ? _deriv_nonuniform(data, h, closed=closed) : let( L = len(data) ) closed ? [ for(i=[0:1:L-1]) (data[(i+1)%L]-data[(L+i-1)%L])/2/h ] : let( first = L<3 ? data[1]-data[0] : 3*(data[1]-data[0]) - (data[2]-data[1]), last = L<3 ? data[L-1]-data[L-2]: (data[L-3]-data[L-2])-3*(data[L-2]-data[L-1]) ) [ first/2/h, for(i=[1:1:L-2]) (data[i+1]-data[i-1])/2/h, last/2/h ]; function _dnu_calc(f1,fc,f2,h1,h2) = let( f1 = h2<h1 ? lerp(fc,f1,h2/h1) : f1 , f2 = h1<h2 ? lerp(fc,f2,h1/h2) : f2 ) (f2-f1) / 2 / min(h1,h2); function _deriv_nonuniform(data, h, closed) = let( L = len(data) ) closed ? [for(i=[0:1:L-1]) _dnu_calc(data[(L+i-1)%L], data[i], data[(i+1)%L], select(h,i-1), h[i]) ] : [ (data[1]-data[0])/h[0], for(i=[1:1:L-2]) _dnu_calc(data[i-1],data[i],data[i+1], h[i-1],h[i]), (data[L-1]-data[L-2])/h[L-2] ]; function deriv2(data, h=1, closed=false) = assert( is_consistent(data) , "Input list is not consistent or not numerical.") assert( is_finite(h), "The sampling `h` must be a number." ) let( L = len(data) ) assert( L>=3, "Input list has less than 3 elements.") closed ? [ for(i=[0:1:L-1]) (data[(i+1)%L]-2*data[i]+data[(L+i-1)%L])/h/h ] : let( first = L==3? data[0] - 2*data[1] + data[2] : L==4? 2*data[0] - 5*data[1] + 4*data[2] - data[3] : (35*data[0] - 104*data[1] + 114*data[2] - 56*data[3] + 11*data[4])/12, last = L==3? data[L-1] - 2*data[L-2] + data[L-3] : L==4? -2*data[L-1] + 5*data[L-2] - 4*data[L-3] + data[L-4] : (35*data[L-1] - 104*data[L-2] + 114*data[L-3] - 56*data[L-4] + 11*data[L-5])/12 ) [ first/h/h, for(i=[1:1:L-2]) (data[i+1]-2*data[i]+data[i-1])/h/h, last/h/h ]; function deriv3(data, h=1, closed=false) = assert( is_consistent(data) , "Input list is not consistent or not numerical.") assert( len(data)>=5, "Input list has less than 5 elements.") assert( is_finite(h), "The sampling `h` must be a number." ) let( L = len(data), h3 = h*h*h ) closed? [ for(i=[0:1:L-1]) (-data[(L+i-2)%L]+2*data[(L+i-1)%L]-2*data[(i+1)%L]+data[(i+2)%L])/2/h3 ] : let( first=(-5*data[0]+18*data[1]-24*data[2]+14*data[3]-3*data[4])/2, second=(-3*data[0]+10*data[1]-12*data[2]+6*data[3]-data[4])/2, last=(5*data[L-1]-18*data[L-2]+24*data[L-3]-14*data[L-4]+3*data[L-5])/2, prelast=(3*data[L-1]-10*data[L-2]+12*data[L-3]-6*data[L-4]+data[L-5])/2 ) [ first/h3, second/h3, for(i=[2:1:L-3]) (-data[i-2]+2*data[i-1]-2*data[i+1]+data[i+2])/2/h3, prelast/h3, last/h3 ]; function complex(list) = is_num(list) ? [list,0] : [for(entry=list) is_num(entry) ? [entry,0] : complex(entry)]; function c_mul(z1,z2) = is_matrix([z1,z2],2,2) ? _c_mul(z1,z2) : _combine_complex(_c_mul(_split_complex(z1), _split_complex(z2))); function _split_complex(data) = is_vector(data,2) ? data : is_num(data[0][0]) ? [data*[1,0], data*[0,1]] : [ [for(vec=data) vec * [1,0]], [for(vec=data) vec * [0,1]] ]; function _combine_complex(data) = is_vector(data,2) ? data : is_num(data[0][0]) ? [for(i=[0:len(data[0])-1]) [data[0][i],data[1][i]]] : [for(i=[0:1:len(data[0])-1]) [for(j=[0:1:len(data[0][0])-1]) [data[0][i][j], data[1][i][j]]]]; function _c_mul(z1,z2) = [ z1.x*z2.x - z1.y*z2.y, z1.x*z2.y + z1.y*z2.x ]; function c_div(z1,z2) = assert( is_vector(z1,2) && is_vector(z2), "Complex numbers should be represented by 2D vectors." ) assert( !approx(z2,0), "The divisor `z2` cannot be zero." ) let(den = z2.x*z2.x + z2.y*z2.y) [(z1.x*z2.x + z1.y*z2.y)/den, (z1.y*z2.x - z1.x*z2.y)/den]; function c_conj(z) = is_vector(z,2) ? [z.x,-z.y] : [for(entry=z) c_conj(entry)]; function c_real(z) = is_vector(z,2) ? z.x : is_num(z[0][0]) ? z*[1,0] : [for(vec=z) vec * [1,0]]; function c_imag(z) = is_vector(z,2) ? z.y : is_num(z[0][0]) ? z*[0,1] : [for(vec=z) vec * [0,1]]; function c_ident(n) = [for (i = [0:1:n-1]) [for (j = [0:1:n-1]) (i==j)?[1,0]:[0,0]]]; function c_norm(z) = norm_fro(z); function quadratic_roots(a,b,c,real=false) = real ? [for(root = quadratic_roots(a,b,c,real=false)) if (root.y==0) root.x] : is_undef(b) && is_undef(c) && is_vector(a,3) ? quadratic_roots(a[0],a[1],a[2]) : assert(is_num(a) && is_num(b) && is_num(c)) assert(a!=0 || b!=0 || c!=0, "Quadratic must have a nonzero coefficient") a==0 && b==0 ? [] : a==0 ? [[-c/b,0]] : let( descrim = b*b-4*a*c, sqrt_des = sqrt(abs(descrim)) ) descrim < 0 ? [[-b, sqrt_des], [-b, -sqrt_des]]/2/a : b<0 ? [[2*c/(-b+sqrt_des),0], [(-b+sqrt_des)/a/2,0]] : [[(-b-sqrt_des)/2/a, 0], [2*c/(-b-sqrt_des),0]]; function polynomial(p,z,k,total) = is_undef(k) ? assert( is_vector(p) , "Input polynomial coefficients must be a vector." ) assert( is_finite(z) || is_vector(z,2), "The value of `z` must be a real or a complex number." ) polynomial( _poly_trim(p), z, 0, is_num(z) ? 0 : [0,0]) : k==len(p) ? total : polynomial(p,z,k+1, is_num(z) ? total*z+p[k] : c_mul(total,z)+[p[k],0]); function poly_mult(p,q) = is_undef(q) ? len(p)==2 ? poly_mult(p[0],p[1]) : poly_mult(p[0], poly_mult(list_tail(p))) : assert( is_vector(p) && is_vector(q),"Invalid arguments to poly_mult") p*p==0 || q*q==0 ? [0] : _poly_trim(convolve(p,q)); function poly_div(n,d) = assert( is_vector(n) && is_vector(d) , "Invalid polynomials." ) let( d = _poly_trim(d), n = _poly_trim(n) ) assert( d!=[0] , "Denominator cannot be a zero polynomial." ) n==[0] ? [[0],[0]] : _poly_div(n,d,q=[]); function _poly_div(n,d,q) = len(n)<len(d) ? [q,_poly_trim(n)] : let( t = n[0] / d[0], newq = concat(q,[t]), newn = [for(i=[1:1:len(n)-1]) i<len(d) ? n[i] - t*d[i] : n[i]] ) _poly_div(newn,d,newq); function _poly_trim(p,eps=0) = let( nz = [for(i=[0:1:len(p)-1]) if ( !approx(p[i],0,eps)) i]) len(nz)==0 ? [0] : list_tail(p,nz[0]); function poly_add(p,q) = assert( is_vector(p) && is_vector(q), "Invalid input polynomial(s)." ) let(  plen = len(p), qlen = len(q), long = plen>qlen ? p : q, short = plen>qlen ? q : p ) _poly_trim(long + concat(repeat(0,len(long)-len(short)),short)); function poly_roots(p,tol=1e-14,error_bound=false) = assert( is_vector(p), "Invalid polynomial." ) let( p = _poly_trim(p,eps=0) ) assert( p!=[0], "Input polynomial cannot be zero." ) p[len(p)-1] == 0 ? let( solutions = poly_roots(list_head(p),tol=tol, error_bound=error_bound)) (error_bound ? [ [[0,0], each solutions[0]], [0, each solutions[1]]] : [[0,0], each solutions]) : len(p)==1 ? (error_bound ? [[],[]] : []) : len(p)==2 ? let( solution = [[-p[1]/p[0],0]]) (error_bound ? [solution,[0]] : solution) : let( n = len(p)-1, pderiv = [for(i=[0:n-1]) p[i]*(n-i)], s = [for(i=[0:1:n]) abs(p[i])*(4*(n-i)+1)], beta = -p[1]/p[0]/n, r = 1+pow(abs(polynomial(p,beta)/p[0]),1/n), init = [for(i=[0:1:n-1]) let(angle = 360*i/n+270/n/PI) [beta,0]+r*[cos(angle),sin(angle)] ], roots = _poly_roots(p,pderiv,s,init,tol=tol), error = error_bound ? [for(xi=roots) n * (norm(polynomial(p,xi))+tol*polynomial(s,norm(xi))) / abs(norm(polynomial(pderiv,xi))-tol*polynomial(s,norm(xi)))] : 0 ) error_bound ? [roots, error] : roots; function _poly_roots(p, pderiv, s, z, tol, i=0) = assert(i<45, str("Polyroot exceeded iteration limit.  Current solution:", z)) let( n = len(z), svals = [for(zk=z) tol*polynomial(s,norm(zk))], p_of_z = [for(zk=z) polynomial(p,zk)], done = [for(k=[0:n-1]) norm(p_of_z[k])<=svals[k]], newton = [for(k=[0:n-1]) c_div(p_of_z[k], polynomial(pderiv,z[k]))], zdiff = [for(k=[0:n-1]) sum([for(j=[0:n-1]) if (j!=k) c_div([1,0], z[k]-z[j])])], w = [for(k=[0:n-1]) done[k] ? [0,0] : c_div( newton[k], [1,0] - c_mul(newton[k], zdiff[k]))] ) all(done) ? z : _poly_roots(p,pderiv,s,z-w,tol,i+1); function real_roots(p,eps=undef,tol=1e-14) = assert( is_vector(p), "Invalid polynomial." ) let( p = _poly_trim(p,eps=0) ) assert( p!=[0], "Input polynomial cannot be zero." ) let( roots_err = poly_roots(p,error_bound=true), roots = roots_err[0], err = roots_err[1] ) is_def(eps) ? [for(z=roots) if (abs(z.y)/(1+norm(z))<eps) z.x] : [for(i=idx(roots)) if (abs(roots[i].y)<=err[i]) roots[i].x]; function root_find(f,x0,x1,tol=1e-15) = let( y0 = f(x0), y1 = f(x1), yrange = y0<y1 ? [y0,y1] : [y1,y0] ) y0==0 || _rfcheck(x0, y0,yrange,tol) ? x0 : y1==0 || _rfcheck(x1, y1,yrange,tol) ? x1 : assert(y0*y1<0, "Sign of function must be different at the interval endpoints") _rootfind(f,[x0,x1],[y0,y1],yrange,tol); function _rfcheck(x,y,range,tol) = assert(is_finite(y), str("Function not finite at ",x)) abs(y) < tol*(range[1]-range[0]); function _rootfind(f, xpts, ypts, yrange, tol, i=0) = assert(i<100, "root_find did not converge to a solution") let( xmid = (xpts[0]+xpts[1])/2, ymid = f(xmid), yrange = [min(ymid, yrange[0]), max(ymid, yrange[1])] ) _rfcheck(xmid, ymid, yrange, tol) ? xmid : let( y = ymid * ypts[0] < 0 ? [ypts[0], ymid, ypts[1]] : [ypts[1], ymid, ypts[0]], x = ymid * ypts[0] < 0 ? [xpts[0], xmid, xpts[1]] : [xpts[1], xmid, xpts[0]], v = y[2]*(y[2]-y[0]) - 2*y[1]*(y[1]-y[0]) ) v <= 0 ? _rootfind(f,x,y,yrange,tol,i+1) : let( B = (x[1]-x[0]) / (y[1]-y[0]), C = y*[-1,2,-1] / (y[2]-y[1]) / (y[2]-y[0]), newx = x[0] - B * y[0] *(1-C*y[1]), newy = f(newx), new_yrange = [min(yrange[0],newy), max(yrange[1], newy)], yinterval = newy*y[0] < 0 ? [y[0],newy] : [newy,y[1]], xinterval = newy*y[0] < 0 ? [x[0],newx] : [newx,x[1]] ) _rfcheck(newx, newy, new_yrange, tol) ? newx : _rootfind(f, xinterval, yinterval, new_yrange, tol, i+1);_NO_ARG = [true,[123232345],false]; module move(v=[0,0,0], p, x=0, y=0, z=0) { assert(!is_string(v),"Module form of `move()` does not accept string `v` arguments"); assert(is_undef(p), "Module form `move()` does not accept p= argument."); assert(is_vector(v) && (len(v)==3 || len(v)==2), "Invalid value for `v`") translate(point3d(v)+[x,y,z]) children(); } function move(v=[0,0,0], p=_NO_ARG, x=0, y=0, z=0) = is_string(v) ? ( assert(is_vnf(p) || is_path(p),"String movements only work with point lists and VNFs") let( center = v=="centroid" ? centroid(p) : v=="mean" ? mean(p) : v=="box" ? mean(pointlist_bounds(p)) : assert(false,str("Unknown string movement ",v)) ) move(-center,p=p, x=x,y=y,z=z) ) : assert(is_vector(v) && (len(v)==3 || len(v)==2), "Invalid value for `v`") let( m = affine3d_translate(point3d(v)+[x,y,z]) ) p==_NO_ARG ? m : apply(m, p); function translate(v=[0,0,0], p=_NO_ARG) = move(v=v, p=p); module left(x=0, p) { assert(is_undef(p), "Module form `left()` does not accept p= argument."); assert(is_finite(x), "Invalid number") translate([-x,0,0]) children(); } function left(x=0, p=_NO_ARG) = assert(is_finite(x), "Invalid number") move([-x,0,0],p=p); module right(x=0, p) { assert(is_undef(p), "Module form `right()` does not accept p= argument."); assert(is_finite(x), "Invalid number") translate([x,0,0]) children(); } function right(x=0, p=_NO_ARG) = assert(is_finite(x), "Invalid number") move([x,0,0],p=p); module xmove(x=0, p) { assert(is_undef(p), "Module form `xmove()` does not accept p= argument."); assert(is_finite(x), "Invalid number") translate([x,0,0]) children(); } function xmove(x=0, p=_NO_ARG) = assert(is_finite(x), "Invalid number") move([x,0,0],p=p); module fwd(y=0, p) { assert(is_undef(p), "Module form `fwd()` does not accept p= argument."); assert(is_finite(y), "Invalid number") translate([0,-y,0]) children(); } function fwd(y=0, p=_NO_ARG) = assert(is_finite(y), "Invalid number") move([0,-y,0],p=p); module back(y=0, p) { assert(is_undef(p), "Module form `back()` does not accept p= argument."); assert(is_finite(y), "Invalid number") translate([0,y,0]) children(); } function back(y=0,p=_NO_ARG) = assert(is_finite(y), "Invalid number") move([0,y,0],p=p); module ymove(y=0, p) { assert(is_undef(p), "Module form `ymove()` does not accept p= argument."); assert(is_finite(y), "Invalid number") translate([0,y,0]) children(); } function ymove(y=0,p=_NO_ARG) = assert(is_finite(y), "Invalid number") move([0,y,0],p=p); module down(z=0, p) { assert(is_undef(p), "Module form `down()` does not accept p= argument."); translate([0,0,-z]) children(); } function down(z=0, p=_NO_ARG) = assert(is_finite(z), "Invalid number") move([0,0,-z],p=p); module up(z=0, p) { assert(is_undef(p), "Module form `up()` does not accept p= argument."); assert(is_finite(z), "Invalid number"); translate([0,0,z]) children(); } function up(z=0, p=_NO_ARG) = assert(is_finite(z), "Invalid number") move([0,0,z],p=p); module zmove(z=0, p) { assert(is_undef(p), "Module form `zmove()` does not accept p= argument."); assert(is_finite(z), "Invalid number"); translate([0,0,z]) children(); } function zmove(z=0, p=_NO_ARG) = assert(is_finite(z), "Invalid number") move([0,0,z],p=p); module rot(a=0, v, cp, from, to, reverse=false) { m = rot(a=a, v=v, cp=cp, from=from, to=to, reverse=reverse); multmatrix(m) children(); } function rot(a=0, v, cp, from, to, reverse=false, p=_NO_ARG, _m) = assert(is_undef(from)==is_undef(to), "from and to must be specified together.") assert(is_undef(from) || is_vector(from, zero=false), "'from' must be a non-zero vector.") assert(is_undef(to) || is_vector(to, zero=false), "'to' must be a non-zero vector.") assert(is_undef(v) || is_vector(v, zero=false), "'v' must be a non-zero vector.") assert(is_undef(cp) || is_vector(cp), "'cp' must be a vector.") assert(is_finite(a) || is_vector(a), "'a' must be a finite scalar or a vector.") assert(is_bool(reverse)) let( m = let( from = is_undef(from)? undef : point3d(from), to = is_undef(to)? undef : point3d(to), cp = is_undef(cp)? undef : point3d(cp), m1 = !is_undef(from) ? assert(is_num(a)) affine3d_rot_from_to(from,to) * affine3d_rot_by_axis(from,a) : !is_undef(v)? assert(is_num(a)) affine3d_rot_by_axis(v,a) : is_num(a) ? affine3d_zrot(a) : affine3d_zrot(a.z) * affine3d_yrot(a.y) * affine3d_xrot(a.x), m2 = is_undef(cp)? m1 : (move(cp) * m1 * move(-cp)), m3 = reverse? rot_inverse(m2) : m2 ) m3 ) p==_NO_ARG ? m : apply(m, p); module xrot(a=0, p, cp) { assert(is_undef(p), "Module form `xrot()` does not accept p= argument."); if (a==0) { children(); } else if (!is_undef(cp)) { translate(cp) rotate([a, 0, 0]) translate(-cp) children(); } else { rotate([a, 0, 0]) children(); } } function xrot(a=0, p=_NO_ARG, cp) = rot([a,0,0], cp=cp, p=p); module yrot(a=0, p, cp) { assert(is_undef(p), "Module form `yrot()` does not accept p= argument."); if (a==0) { children(); } else if (!is_undef(cp)) { translate(cp) rotate([0, a, 0]) translate(-cp) children(); } else { rotate([0, a, 0]) children(); } } function yrot(a=0, p=_NO_ARG, cp) = rot([0,a,0], cp=cp, p=p); module zrot(a=0, p, cp) { assert(is_undef(p), "Module form `zrot()` does not accept p= argument."); if (a==0) { children(); } else if (!is_undef(cp)) { translate(cp) rotate(a) translate(-cp) children(); } else { rotate(a) children(); } } function zrot(a=0, p=_NO_ARG, cp) = rot(a, cp=cp, p=p); function scale(v=1, p=_NO_ARG, cp=[0,0,0]) = assert(is_num(v) || is_vector(v),"Invalid scale") assert(p==_NO_ARG || is_list(p),"Invalid point list") assert(is_vector(cp)) let( v = is_num(v)? [v,v,v] : v, m = cp==[0,0,0] ? affine3d_scale(v) : affine3d_translate(point3d(cp)) * affine3d_scale(v) * affine3d_translate(point3d(-cp)) ) p==_NO_ARG? m : apply(m, p) ; module xscale(x=1, p, cp=0) { assert(is_undef(p), "Module form `xscale()` does not accept p= argument."); cp = is_num(cp)? [cp,0,0] : cp; if (cp == [0,0,0]) { scale([x,1,1]) children(); } else { translate(cp) scale([x,1,1]) translate(-cp) children(); } } function xscale(x=1, p=_NO_ARG, cp=0) = assert(is_finite(x)) assert(p==_NO_ARG || is_list(p)) assert(is_finite(cp) || is_vector(cp)) let( cp = is_num(cp)? [cp,0,0] : cp ) scale([x,1,1], cp=cp, p=p); module yscale(y=1, p, cp=0) { assert(is_undef(p), "Module form `yscale()` does not accept p= argument."); cp = is_num(cp)? [0,cp,0] : cp; if (cp == [0,0,0]) { scale([1,y,1]) children(); } else { translate(cp) scale([1,y,1]) translate(-cp) children(); } } function yscale(y=1, p=_NO_ARG, cp=0) = assert(is_finite(y)) assert(p==_NO_ARG || is_list(p)) assert(is_finite(cp) || is_vector(cp)) let( cp = is_num(cp)? [0,cp,0] : cp ) scale([1,y,1], cp=cp, p=p); module zscale(z=1, p, cp=0) { assert(is_undef(p), "Module form `zscale()` does not accept p= argument."); cp = is_num(cp)? [0,0,cp] : cp; if (cp == [0,0,0]) { scale([1,1,z]) children(); } else { translate(cp) scale([1,1,z]) translate(-cp) children(); } } function zscale(z=1, p=_NO_ARG, cp=0) = assert(is_finite(z)) assert(is_undef(p) || is_list(p)) assert(is_finite(cp) || is_vector(cp)) let( cp = is_num(cp)? [0,0,cp] : cp ) scale([1,1,z], cp=cp, p=p); function mirror(v, p=_NO_ARG) = assert(is_vector(v)) assert(p==_NO_ARG || is_list(p),"Invalid pointlist") let(m = len(v)==2? affine2d_mirror(v) : affine3d_mirror(v)) p==_NO_ARG? m : apply(m,p); module xflip(p, x=0) { assert(is_undef(p), "Module form `zflip()` does not accept p= argument."); translate([x,0,0]) mirror([1,0,0]) translate([-x,0,0]) children(); } function xflip(p=_NO_ARG, x=0) = assert(is_finite(x)) assert(p==_NO_ARG || is_list(p),"Invalid point list") let( v = RIGHT ) x == 0 ? mirror(v,p=p) : let( cp = x * v, m = move(cp) * mirror(v) * move(-cp) ) p==_NO_ARG? m : apply(m, p); module yflip(p, y=0) { assert(is_undef(p), "Module form `yflip()` does not accept p= argument."); translate([0,y,0]) mirror([0,1,0]) translate([0,-y,0]) children(); } function yflip(p=_NO_ARG, y=0) = assert(is_finite(y)) assert(p==_NO_ARG || is_list(p),"Invalid point list") let( v = BACK ) y == 0 ? mirror(v,p=p) : let( cp = y * v, m = move(cp) * mirror(v) * move(-cp) ) p==_NO_ARG? m : apply(m, p); module zflip(p, z=0) { assert(is_undef(p), "Module form `zflip()` does not accept p= argument."); translate([0,0,z]) mirror([0,0,1]) translate([0,0,-z]) children(); } function zflip(p=_NO_ARG, z=0) = assert(is_finite(z)) assert(p==_NO_ARG || is_list(p),"Invalid point list") z==0? mirror([0,0,1],p=p) : let(m = up(z) * mirror(UP) * down(z)) p==_NO_ARG? m : apply(m, p); function frame_map(x,y,z, p=_NO_ARG, reverse=false) = p != _NO_ARG ? apply(frame_map(x,y,z,reverse=reverse), p) : assert(num_defined([x,y,z])>=2, "Must define at least two inputs") let( xvalid = is_undef(x) || (is_vector(x) && len(x)==3), yvalid = is_undef(y) || (is_vector(y) && len(y)==3), zvalid = is_undef(z) || (is_vector(z) && len(z)==3) ) assert(xvalid,"Input x must be a length 3 vector") assert(yvalid,"Input y must be a length 3 vector") assert(zvalid,"Input z must be a length 3 vector") let( x = is_undef(x)? undef : unit(x,RIGHT), y = is_undef(y)? undef : unit(y,BACK), z = is_undef(z)? undef : unit(z,UP), map = is_undef(x)? [cross(y,z), y, z] : is_undef(y)? [x, cross(z,x), z] : is_undef(z)? [x, y, cross(x,y)] : [x, y, z] ) reverse? ( let( ocheck = ( approx(map[0]*map[1],0) && approx(map[0]*map[2],0) && approx(map[1]*map[2],0) ) ) assert(ocheck, "Inputs must be orthogonal when reverse==true") [for (r=map) [for (c=r) c, 0], [0,0,0,1]] ) : [for (r=transpose(map)) [for (c=r) c, 0], [0,0,0,1]]; module frame_map(x,y,z,p,reverse=false) { assert(is_undef(p), "Module form `frame_map()` does not accept p= argument."); multmatrix(frame_map(x,y,z,reverse=reverse)) children(); } module skew(p, sxy=0, sxz=0, syx=0, syz=0, szx=0, szy=0) { assert(is_undef(p), "Module form `skew()` does not accept p= argument.") multmatrix( affine3d_skew(sxy=sxy, sxz=sxz, syx=syx, syz=syz, szx=szx, szy=szy) ) children(); } function skew(p=_NO_ARG, sxy=0, sxz=0, syx=0, syz=0, szx=0, szy=0) = assert(is_finite(sxy)) assert(is_finite(sxz)) assert(is_finite(syx)) assert(is_finite(syz)) assert(is_finite(szx)) assert(is_finite(szy)) let( m = affine3d_skew(sxy=sxy, sxz=sxz, syx=syx, syz=syz, szx=szx, szy=szy) ) p==_NO_ARG? m : apply(m, p); function is_2d_transform(t) = t[2][0]==0 && t[2][1]==0 && t[2][3]==0 && t[0][2] == 0 && t[1][2]==0 && (t[2][2]==1 || !(t[0][0]==1 && t[0][1]==0 && t[1][0]==0 && t[1][1]==1)); function apply(transform,points) = points==[] ? [] : is_vector(points) ? _apply(transform, [points])[0] : is_vnf(points) ? let( newvnf = [_apply(transform, points[0]), points[1]], reverse = (len(transform)==len(transform[0])) && determinant(transform)<0 ) reverse ? vnf_reverse_faces(newvnf) : newvnf : is_list(points) && is_list(points[0]) && is_vector(points[0][0]) ? [for (x=points) _apply(transform,x)] : _apply(transform,points); function _apply(transform,points) = assert(is_matrix(transform),"Invalid transformation matrix") assert(is_matrix(points),"Invalid points list") let( tdim = len(transform[0])-1, datadim = len(points[0]) ) assert(len(transform)==tdim || len(transform)-1==tdim, "transform matrix height not compatible with width") assert(datadim==2 || datadim==3,"Data must be 2D or 3D") let( scale = len(transform)==tdim ? 1 : transform[tdim][tdim], matrix = [for(i=[0:1:tdim]) [for(j=[0:1:datadim-1]) transform[j][i]]] / scale ) tdim==datadim ? [for(p=points) concat(p,1)] * matrix : tdim == 3 && datadim == 2 ? assert(is_2d_transform(transform), str("Transforms is 3D and acts on Z, but points are 2D")) [for(p=points) concat(p,[0,1])]*matrix : assert(false, str("Unsupported combination: ",len(transform),"x",len(transform[0])," transform (dimension ",tdim, "), data of dimension ",datadim));$tags = ""; $overlap = 0; $color = undef; $attach_to = undef; $attach_anchor = [CENTER, CENTER, UP, 0]; $attach_norot = false; $parent_anchor = BOTTOM; $parent_spin = 0; $parent_orient = UP; $parent_size = undef; $parent_geom = undef; $tags_shown = []; $tags_hidden = []; _ANCHOR_TYPES = ["intersect","hull"]; module position(from) { assert($parent_geom != undef, "No object to attach to!"); anchors = (is_vector(from)||is_string(from))? [from] : from; for (anchr = anchors) { anch = _find_anchor(anchr, $parent_geom); $attach_to = undef; $attach_anchor = anch; $attach_norot = true; translate(anch[1]) children(); } } module orient(dir, anchor, spin) { if (!is_undef(dir)) { assert(anchor==undef, "Only one of dir= or anchor= may be given to orient()"); assert(is_vector(dir)); spin = default(spin, 0); assert(is_finite(spin)); two_d = _attach_geom_2d($parent_geom); fromvec = two_d? BACK : UP; rot(spin, from=fromvec, to=dir) children(); } else { assert(dir==undef, "Only one of dir= or anchor= may be given to orient()"); assert($parent_geom != undef, "No parent to orient from!"); assert(is_string(anchor) || is_vector(anchor)); anch = _find_anchor(anchor, $parent_geom); two_d = _attach_geom_2d($parent_geom); fromvec = two_d? BACK : UP; $attach_to = undef; $attach_anchor = anch; $attach_norot = true; spin = default(spin, anch[3]); assert(is_finite(spin)); rot(spin, from=fromvec, to=anch[2]) children(); } } module attach(from, to, overlap, norot=false) { assert($parent_geom != undef, "No object to attach to!"); overlap = (overlap!=undef)? overlap : $overlap; anchors = (is_vector(from)||is_string(from))? [from] : from; for (anchr = anchors) { anch = _find_anchor(anchr, $parent_geom); two_d = _attach_geom_2d($parent_geom); $attach_to = to; $attach_anchor = anch; $attach_norot = norot; olap = two_d? [0,-overlap,0] : [0,0,-overlap]; if (norot || (norm(anch[2]-UP)<1e-9 && anch[3]==0)) { translate(anch[1]) translate(olap) children(); } else { fromvec = two_d? BACK : UP; translate(anch[1]) rot(anch[3],from=fromvec,to=anch[2]) translate(olap) children(); } } } module tags(tags) { $tags = tags; if(_attachment_is_shown(tags)) { children(); } } module diff(neg, pos, keep) { if (_attachment_is_shown($tags)) { difference() { if (pos != undef) { show(pos) children(); } else { if (keep == undef) { hide(neg) children(); } else { hide(str(neg," ",keep)) children(); } } show(neg) children(); } } if (keep!=undef) { show(keep) children(); } else if (pos!=undef) { hide(str(pos," ",neg)) children(); } } module intersect(a, b=undef, keep=undef) { if (_attachment_is_shown($tags)) { intersection() { if (b != undef) { show(b) children(); } else { if (keep == undef) { hide(a) children(); } else { hide(str(a," ",keep)) children(); } } show(a) children(); } } if (keep!=undef) { show(keep) children(); } else if (b!=undef) { hide(str(a," ",b)) children(); } } module hulling(a) { if (is_undef(a)) { hull() children(); } else { hull() show(a) children(); children(); } } module recolor(c) { $color = c; children(); } module hide(tags="") { $tags_hidden = tags==""? [] : str_split(tags, " "); $tags_shown = []; children(); } module show(tags="") { $tags_shown = tags==""? [] : str_split(tags, " "); $tags_hidden = []; children(); } module edge_mask(edges=EDGES_ALL, except=[]) { assert($parent_geom != undef, "No object to attach to!"); edges = _edges(edges, except=except); vecs = [ for (i = [0:3], axis=[0:2]) if (edges[axis][i]>0) EDGE_OFFSETS[axis][i] ]; for (vec = vecs) { vcount = (vec.x?1:0) + (vec.y?1:0) + (vec.z?1:0); assert(vcount == 2, "Not an edge vector!"); anch = _find_anchor(vec, $parent_geom); $attach_to = undef; $attach_anchor = anch; $attach_norot = true; $tags = "mask"; rotang = vec.z<0? [90,0,180+v_theta(vec)] : vec.z==0 && sign(vec.x)==sign(vec.y)? 135+v_theta(vec) : vec.z==0 && sign(vec.x)!=sign(vec.y)? [0,180,45+v_theta(vec)] : [-90,0,180+v_theta(vec)]; translate(anch[1]) rot(rotang) children(); } } module corner_mask(corners=CORNERS_ALL, except=[]) { assert($parent_geom != undef, "No object to attach to!"); corners = _corners(corners, except=except); vecs = [for (i = [0:7]) if (corners[i]>0) CORNER_OFFSETS[i]]; for (vec = vecs) { vcount = (vec.x?1:0) + (vec.y?1:0) + (vec.z?1:0); assert(vcount == 3, "Not an edge vector!"); anch = _find_anchor(vec, $parent_geom); $attach_to = undef; $attach_anchor = anch; $attach_norot = true; $tags = "mask"; rotang = vec.z<0? [  0,0,180+v_theta(vec)-45] : [180,0,-90+v_theta(vec)-45]; translate(anch[1]) rot(rotang) children(); } } module face_profile(faces=[], r, d, convexity=10) { faces = is_vector(faces)? [faces] : faces; assert(all([for (face=faces) is_vector(face) && sum([for (x=face) x!=0? 1 : 0])==1]), "Vector in faces doesn't point at a face."); r = get_radius(r=r, d=d, dflt=undef); assert(is_num(r) && r>0); edge_profile(faces) children(); corner_profile(faces, convexity=convexity, r=r) children(); } module edge_profile(edges=EDGES_ALL, except=[], convexity=10) { assert($parent_geom != undef, "No object to attach to!"); edges = _edges(edges, except=except); vecs = [ for (i = [0:3], axis=[0:2]) if (edges[axis][i]>0) EDGE_OFFSETS[axis][i] ]; for (vec = vecs) { vcount = (vec.x?1:0) + (vec.y?1:0) + (vec.z?1:0); assert(vcount == 2, "Not an edge vector!"); anch = _find_anchor(vec, $parent_geom); $attach_to = undef; $attach_anchor = anch; $attach_norot = true; $tags = "mask"; psize = point3d($parent_size); length = [for (i=[0:2]) if(!vec[i]) psize[i]][0]+0.1; rotang = vec.z<0? [90,0,180+v_theta(vec)] : vec.z==0 && sign(vec.x)==sign(vec.y)? 135+v_theta(vec) : vec.z==0 && sign(vec.x)!=sign(vec.y)? [0,180,45+v_theta(vec)] : [-90,0,180+v_theta(vec)]; translate(anch[1]) { rot(rotang) { linear_extrude(height=length, center=true, convexity=convexity) { children(); } } } } } module corner_profile(corners=CORNERS_ALL, except=[], r, d, convexity=10) { assert($parent_geom != undef, "No object to attach to!"); r = get_radius(r=r, d=d, dflt=undef); assert(is_num(r)); corners = _corners(corners, except=except); vecs = [for (i = [0:7]) if (corners[i]>0) CORNER_OFFSETS[i]]; for (vec = vecs) { vcount = (vec.x?1:0) + (vec.y?1:0) + (vec.z?1:0); assert(vcount == 3, "Not an edge vector!"); anch = _find_anchor(vec, $parent_geom); $attach_to = undef; $attach_anchor = anch; $attach_norot = true; $tags = "mask"; rotang = vec.z<0? [  0,0,180+v_theta(vec)-45] : [180,0,-90+v_theta(vec)-45]; translate(anch[1]) { rot(rotang) { render(convexity=convexity) difference() { translate(-0.1*[1,1,1]) cube_BOSL2(r+0.1, center=false); right(r) back(r) zrot(180) { rotate_extrude(angle=90, convexity=convexity) { xflip() left(r) { difference() { square_BOSL2(r,center=false); children(); } } } } } } } } } module attachable( anchor, spin, orient, size, size2, shift, r,r1,r2, d,d1,d2, l,h, vnf, path, region, extent=true, cp=[0,0,0], offset=[0,0,0], anchors=[], two_d=false, axis=UP ) { dummy1 = assert($children==2, "attachable() expects exactly two children; the shape to manage, and the union of all attachment candidates.") assert(is_undef(anchor) || is_vector(anchor) || is_string(anchor), str("Got: ",anchor)) assert(is_undef(spin)   || is_vector(spin,3) || is_num(spin), str("Got: ",spin)) assert(is_undef(orient) || is_vector(orient,3), str("Got: ",orient)); anchor = default(anchor, CENTER); spin =   default(spin,   0); orient = default(orient, UP); region = !is_undef(region)? region : !is_undef(path)? [path] : undef; geom = _attach_geom( size=size, size2=size2, shift=shift, r=r, r1=r1, r2=r2, h=h, d=d, d1=d1, d2=d2, l=l, vnf=vnf, region=region, extent=extent, cp=cp, offset=offset, anchors=anchors, two_d=two_d, axis=axis ); m = _attach_transform(anchor,spin,orient,geom); multmatrix(m) { $parent_anchor = anchor; $parent_spin   = spin; $parent_orient = orient; $parent_geom   = geom; $parent_size   = _attach_geom_size(geom); $attach_to   = undef; do_show = _attachment_is_shown($tags); if (do_show) { if (is_undef($color)) { children(0); } else color($color) { $color = undef; children(0); } } children(1); } } function reorient( anchor, spin, orient, size, size2, shift, r,r1,r2, d,d1,d2, l,h, vnf, path, region, extent=true, offset=[0,0,0], cp=[0,0,0], anchors=[], two_d=false, axis=UP, p=undef ) = assert(is_undef(anchor) || is_vector(anchor) || is_string(anchor), str("Got: ",anchor)) assert(is_undef(spin)   || is_vector(spin,3) || is_num(spin), str("Got: ",spin)) assert(is_undef(orient) || is_vector(orient,3), str("Got: ",orient)) let( anchor = default(anchor, CENTER), spin =   default(spin,   0), orient = default(orient, UP), region = !is_undef(region)? region : !is_undef(path)? [path] : undef ) (anchor==CENTER && spin==0 && orient==UP && p!=undef)? p : let( geom = _attach_geom( size=size, size2=size2, shift=shift, r=r, r1=r1, r2=r2, h=h, d=d, d1=d1, d2=d2, l=l, vnf=vnf, region=region, extent=extent, cp=cp, offset=offset, anchors=anchors, two_d=two_d, axis=axis ), $attach_to = undef ) _attach_transform(anchor,spin,orient,geom,p); function named_anchor(name, pos=[0,0,0], orient=UP, spin=0) = [name, pos, orient, spin]; function _attach_geom( size, size2, shift, r,r1,r2, d,d1,d2, l,h, vnf, region, extent=true, cp=[0,0,0], offset=[0,0,0], anchors=[], two_d=false, axis=UP ) = assert(is_bool(extent)) assert(is_vector(cp) || is_string(cp)) assert(is_vector(offset)) assert(is_list(anchors)) assert(is_bool(two_d)) assert(is_vector(axis)) !is_undef(size)? ( two_d? ( let( size2 = default(size2, size.x), shift = default(shift, 0) ) assert(is_vector(size,2)) assert(is_num(size2)) assert(is_num(shift)) ["rect", point2d(size), size2, shift, cp, offset, anchors] ) : ( let( size2 = default(size2, point2d(size)), shift = default(shift, [0,0]) ) assert(is_vector(size,3)) assert(is_vector(size2,2)) assert(is_vector(shift,2)) ["cuboid", size, size2, shift, axis, cp, offset, anchors] ) ) : !is_undef(vnf)? ( assert(is_vnf(vnf)) assert(two_d == false) extent? ["vnf_extent", vnf, cp, offset, anchors] : ["vnf_isect", vnf, cp, offset, anchors] ) : !is_undef(region)? ( assert(is_region(region),2) let( l = default(l, h) ) two_d==true ? assert(is_undef(l)) extent==true ? ["rgn_extent", region, cp, offset, anchors] : ["rgn_isect",  region, cp, offset, anchors] : assert(is_finite(l)) extent==true ? ["xrgn_extent", region, l, cp, offset, anchors] : ["xrgn_isect",  region, l, cp, offset, anchors] ) : let( r1 = get_radius(r1=r1,d1=d1,r=r,d=d,dflt=undef) ) !is_undef(r1)? ( let( l = default(l, h) ) !is_undef(l)? ( let( shift = default(shift, [0,0]), r2 = get_radius(r1=r2,d1=d2,r=r,d=d,dflt=undef) ) assert(is_num(r1) || is_vector(r1,2)) assert(is_num(r2) || is_vector(r2,2)) assert(is_num(l)) assert(is_vector(shift,2)) ["cyl", r1, r2, l, shift, axis, cp, offset, anchors] ) : ( two_d? ( assert(is_num(r1) || is_vector(r1,2)) ["circle", r1, cp, offset, anchors] ) : ( assert(is_num(r1) || is_vector(r1,3)) ["spheroid", r1, cp, offset, anchors] ) ) ) : assert(false, "Unrecognizable geometry description."); function _attach_geom_2d(geom) = let( type = geom[0] ) type == "rect" || type == "circle" || type == "rgn_isect" || type == "rgn_extent"; function _attach_geom_size(geom) = let( type = geom[0] ) type == "cuboid"? ( let( size=geom[1], size2=geom[2], shift=point2d(geom[3]), maxx = max(size.x,size2.x), maxy = max(size.y,size2.y), z = size.z ) [maxx, maxy, z] ) : type == "cyl"? ( let( r1=geom[1], r2=geom[2], l=geom[3], shift=point2d(geom[4]), axis=point3d(geom[5]), rx1 = default(r1[0],r1), ry1 = default(r1[1],r1), rx2 = default(r2[0],r2), ry2 = default(r2[1],r2), maxxr = max(rx1,rx2), maxyr = max(ry1,ry2) ) approx(axis,UP)? [2*maxxr,2*maxyr,l] : approx(axis,RIGHT)? [l,2*maxyr,2*maxxr] : approx(axis,BACK)? [2*maxxr,l,2*maxyr] : [2*maxxr, 2*maxyr, l] ) : type == "spheroid"? ( let( r=geom[1] ) is_num(r)? [2,2,2]*r : v_mul([2,2,2],point3d(r)) ) : type == "vnf_extent" || type=="vnf_isect"? ( let( vnf = geom[1] ) vnf==EMPTY_VNF? [0,0,0] : let( mm = pointlist_bounds(geom[1][0]), delt = mm[1]-mm[0] ) delt ) : type == "xrgn_isect" || type == "xrgn_extent"? ( let( mm = pointlist_bounds(flatten(geom[1])), delt = mm[1]-mm[0] ) [delt.x, delt.y, geom[2]] ) : type == "rect"? ( let( size=geom[1], size2=geom[2], shift=geom[3], maxx = max(size.x,size2+abs(shift)) ) [maxx, size.y] ) : type == "circle"? ( let( r=geom[1] ) is_num(r)? [2,2]*r : v_mul([2,2],point2d(r)) ) : type == "rgn_isect" || type == "rgn_extent"? ( let( mm = pointlist_bounds(flatten(geom[1])), delt = mm[1]-mm[0] ) [delt.x, delt.y] ) : assert(false, "Unknown attachment geometry type."); function _attach_transform(anchor, spin, orient, geom, p) = assert(is_undef(anchor) || is_vector(anchor) || is_string(anchor), str("Got: ",anchor)) assert(is_undef(spin)   || is_vector(spin,3) || is_num(spin), str("Got: ",spin)) assert(is_undef(orient) || is_vector(orient,3), str("Got: ",orient)) let( anchor = default(anchor, CENTER), spin   = default(spin,   0), orient = default(orient, UP), two_d = _attach_geom_2d(geom), m = ($attach_to != undef)? ( let( anch = _find_anchor($attach_to, geom), pos = anch[1] ) two_d? ( assert(two_d && is_num(spin)) affine3d_zrot(spin) * rot(to=FWD, from=point3d(anch[2])) * affine3d_translate(point3d(-pos)) ) : ( assert(is_num(spin) || is_vector(spin,3)) let( ang = vector_angle(anch[2], DOWN), axis = vector_axis(anch[2], DOWN), ang2 = (anch[2]==UP || anch[2]==DOWN)? 0 : 180-anch[3], axis2 = rot(p=axis,[0,0,ang2]) ) affine3d_rot_by_axis(axis2,ang) * ( is_num(spin)? affine3d_zrot(ang2+spin) : ( affine3d_zrot(spin.z) * affine3d_yrot(spin.y) * affine3d_xrot(spin.x) * affine3d_zrot(ang2) ) ) * affine3d_translate(point3d(-pos)) ) ) : ( let( pos = _find_anchor(anchor, geom)[1] ) two_d? ( assert(two_d && is_num(spin)) affine3d_zrot(spin) * affine3d_translate(point3d(-pos)) ) : ( assert(is_num(spin) || is_vector(spin,3)) let( axis = vector_axis(UP,orient), ang = vector_angle(UP,orient) ) affine3d_rot_by_axis(axis,ang) * ( is_num(spin)? affine3d_zrot(spin) : ( affine3d_zrot(spin.z) * affine3d_yrot(spin.y) * affine3d_xrot(spin.x) ) ) * affine3d_translate(point3d(-pos)) ) ) ) is_undef(p)? m : is_vnf(p)? [(p==EMPTY_VNF? p : apply(m, p[0])), p[1]] : apply(m, p); function _get_cp(geom) = let(cp=select(geom,-3)) is_vector(cp) ? cp : let( type = in_list(geom[0],["vnf_extent","vnf_isect"]) ? "vnf" : in_list(geom[0],["rgn_extent","rgn_isect"]) ? "path" : in_list(geom[0],["xrgn_extent","xrgn_isect"]) ? "xpath" : "other" ) assert(type!="other", "Invalid cp value") cp=="centroid" ? ( type=="vnf" && (len(geom[1][0])==0 || len(geom[1][1])==0) ? [0,0,0] : [each centroid(geom[1]), if (type=="xpath") geom[2]/2] ) : let(points = type=="vnf"?geom[1][0]:flatten(force_region(geom[1]))) cp=="mean" ? [each mean(points), if (type=="xpath") geom[2]/2] : cp=="box" ?[each  mean(pointlist_bounds(points)), if (type=="xpath") geom[2]/2] : assert(false,"Invalid cp specification"); function _force_anchor_2d(anchor) = assert(anchor.y==0 || anchor.z==0, "Anchor for a 2D shape cannot be fully 3D.  It must have either Y or Z component equal to zero.") anchor.y==0 ? [anchor.x,anchor.z] : point2d(anchor); function _find_anchor(anchor, geom) = is_string(anchor)? ( anchor=="origin"? [anchor, CENTER, UP, 0] : let( anchors = last(geom), found = search([anchor], anchors, num_returns_per_match=1)[0] ) assert(found!=[], str("Unknown anchor: ",anchor)) anchors[found] ) : let( cp = _get_cp(geom), offset_raw = select(geom,-2), offset = [for (i=[0:2]) anchor[i]==0? 0 : offset_raw[i]], type = geom[0] ) assert(is_vector(anchor),str("Invalid anchor: anchor=",anchor)) let(anchor = point3d(anchor)) anchor==CENTER? [anchor, cp, UP, 0] : let( oang = ( approx(point2d(anchor), [0,0])? 0 : atan2(anchor.y, anchor.x)+90 ) ) type == "cuboid"? ( let(all_comps_good = [for (c=anchor) if (c!=sign(c)) 1]==[]) assert(all_comps_good, "All components of an anchor for a cuboid/prismoid must be -1, 0, or 1") let( size=geom[1], size2=geom[2], shift=point2d(geom[3]), axis=point3d(geom[4]), anch = rot(from=axis, to=UP, p=anchor), h = size.z, u = (anch.z+1)/2, axy = point2d(anch), bot = point3d(v_mul(point2d(size)/2,axy),-h/2), top = point3d(v_mul(point2d(size2)/2,axy)+shift,h/2), pos = point3d(cp) + lerp(bot,top,u) + offset, vecs = [ if (anchor.x!=0) unit(rot(from=UP, to=unit([(top-bot).x,0,h]), p=[axy.x,0,0]), UP), if (anchor.y!=0) unit(rot(from=UP, to=unit([0,(top-bot).y,h]), p=[0,axy.y,0]), UP), if (anchor.z!=0) anch==CENTER? UP : unit([0,0,anch.z],UP) ], vec = unit(sum(vecs) / len(vecs)), pos2 = rot(from=UP, to=axis, p=pos), vec2 = rot(from=UP, to=axis, p=vec) ) [anchor, pos2, vec2, oang] ) : type == "cyl"? ( assert(anchor.z == sign(anchor.z), "The Z component of an anchor for a cylinder/cone must be -1, 0, or 1") let( rr1=geom[1], rr2=geom[2], l=geom[3], shift=point2d(geom[4]), axis=point3d(geom[5]), r1 = is_num(rr1)? [rr1,rr1] : point2d(rr1), r2 = is_num(rr2)? [rr2,rr2] : point2d(rr2), anch = rot(from=axis, to=UP, p=anchor), u = (anch.z+1)/2, axy = unit(point2d(anch),[0,0]), bot = point3d(v_mul(r1,axy), -l/2), top = point3d(v_mul(r2,axy)+shift, l/2), pos = point3d(cp) + lerp(bot,top,u) + offset, sidevec = rot(from=UP, to=top-bot, p=point3d(axy)), vvec = anch==CENTER? UP : unit([0,0,anch.z],UP), vec = anch==CENTER? UP : approx(axy,[0,0])? unit(anch,UP) : approx(anch.z,0)? sidevec : unit((sidevec+vvec)/2,UP), pos2 = rot(from=UP, to=axis, p=pos), vec2 = rot(from=UP, to=axis, p=vec) ) [anchor, pos2, vec2, oang] ) : type == "spheroid"? ( let( rr = geom[1], r = is_num(rr)? [rr,rr,rr] : point3d(rr), anchor = unit(point3d(anchor),CENTER), pos = point3d(cp) + v_mul(r,anchor) + point3d(offset), vec = unit(v_mul(r,anchor),UP) ) [anchor, pos, vec, oang] ) : type == "vnf_isect"? ( let( vnf=geom[1] ) vnf==EMPTY_VNF? [anchor, [0,0,0], unit(anchor), 0] : let( eps = 1/2048, points = vnf[0], faces = vnf[1], rpts = apply(rot(from=anchor, to=RIGHT) * move(-cp), points), hits = [ for (face = faces) let( verts = select(rpts, face), ys = column(verts,1), zs = column(verts,2) ) if (max(ys) >= -eps && max(zs) >= -eps && min(ys) <=  eps &&  min(zs) <=  eps) let( poly = select(points, face), isect = polygon_line_intersection(poly, [cp,cp+anchor], eps=eps), ptlist = is_undef(isect) ? [] : is_vector(isect) ? [isect] : flatten(isect), n = len(ptlist)>0 ? polygon_normal(poly) : undef ) for(pt=ptlist) [anchor * (pt-cp), n, pt] ] ) assert(len(hits)>0, "Anchor vector does not intersect with the shape.  Attachment failed.") let( furthest = max_index(column(hits,0)), dist = hits[furthest][0], pos = hits[furthest][2], hitnorms = [for (hit = hits) if (approx(hit[0],dist,eps=eps)) hit[1]], unorms = [ for (i = idx(hitnorms)) let( thisnorm = hitnorms[i], isdup = [ for (j = [i+1:1:len(hitnorms)-1]) if (approx(thisnorm, hitnorms[j])) 1 ] != [] ) if (!isdup) thisnorm ], n = unit(sum(unorms)), oang = approx(point2d(n), [0,0])? 0 : atan2(n.y, n.x) + 90 ) [anchor, pos, n, oang] ) : type == "vnf_extent"? ( let( vnf=geom[1] ) vnf==EMPTY_VNF? [anchor, [0,0,0], unit(anchor), 0] : let( rpts = apply(rot(from=anchor, to=RIGHT) * move(point3d(-cp)), vnf[0]), maxx = max(column(rpts,0)), idxs = [for (i = idx(rpts)) if (approx(rpts[i].x, maxx)) i], avep = sum(select(rpts,idxs))/len(idxs), mpt = approx(point2d(anchor),[0,0])? [maxx,0,0] : avep, pos = point3d(cp) + rot(from=RIGHT, to=anchor, p=mpt) ) [anchor, pos, anchor, oang] ) : type == "rect"? ( let(all_comps_good = [for (c=anchor) if (c!=sign(c)) 1]==[]) assert(all_comps_good, "All components of an anchor for a rectangle/trapezoid must be -1, 0, or 1") let( anchor=_force_anchor_2d(anchor), size=geom[1], size2=geom[2], shift=geom[3], u = (anchor.y+1)/2, frpt = [size.x/2*anchor.x, -size.y/2], bkpt = [size2/2*anchor.x+shift,  size.y/2], pos = point2d(cp) + lerp(frpt, bkpt, u) + point2d(offset), svec = point3d(line_normal(bkpt,frpt)*anchor.x), vec = anchor.y < 0? ( anchor.x == 0? FWD : size.x == 0? unit(-[shift,size.y], FWD) : unit((point3d(svec) + FWD) / 2, FWD) ) : anchor.y == 0? ( anchor.x == 0? BACK : svec ) : ( anchor.x == 0? BACK : size2 == 0? unit([shift,size.y], BACK) : unit((point3d(svec) + BACK) / 2, BACK) ) ) [anchor, pos, vec, 0] ) : type == "circle"? ( let( anchor = unit(_force_anchor_2d(anchor),[0,0]), r = force_list(geom[1],2), pos = approx(anchor.x,0) ? [0,sign(anchor.y)*r.y] : let( m = anchor.y/anchor.x, px = sign(anchor.x) * sqrt(1/(1/sqr(r.x) + m*m/sqr(r.y))) ) [px,m*px], vec = unit([r.y/r.x*pos.x, r.x/r.y*pos.y]) ) [anchor, point2d(cp+offset)+pos, vec, 0] ) : type == "rgn_isect"? ( let( anchor = _force_anchor_2d(anchor), rgn = force_region(move(-point2d(cp), p=geom[1])), isects = [ for (path=rgn, t=triplet(path,true)) let( seg1 = [t[0],t[1]], seg2 = [t[1],t[2]], isect = line_intersection([[0,0],anchor], seg1,RAY,SEGMENT), n = is_undef(isect)? [0,1] : !approx(isect, t[1])? line_normal(seg1) : unit((line_normal(seg1)+line_normal(seg2))/2,[0,1]), n2 = vector_angle(anchor,n)>90? -n : n ) if(!is_undef(isect) && !approx(isect,t[0])) [norm(isect), isect, n2] ] ) assert(len(isects)>0, "Anchor vector does not intersect with the shape.  Attachment failed.") let( maxidx = max_index(column(isects,0)), isect = isects[maxidx], pos = point2d(cp) + isect[1], vec = unit(isect[2],[0,1]) ) [anchor, pos, vec, 0] ) : type == "rgn_extent"? ( let( anchor = _force_anchor_2d(anchor), rgn = force_region(geom[1]), rpts = rot(from=anchor, to=RIGHT, p=flatten(rgn)), maxx = max(column(rpts,0)), ys = [for (pt=rpts) if (approx(pt.x, maxx)) pt.y], midy = (min(ys)+max(ys))/2, pos = rot(from=RIGHT, to=anchor, p=[maxx,midy]) ) [anchor, pos, unit(anchor), 0] ) : type=="xrgn_extent" || type=="xrgn_isect" ? ( assert(in_list(anchor.z,[-1,0,1]), "The Z component of an anchor for an extruded 2D shape must be -1, 0, or 1.") let( anchor_xy = point2d(anchor), L = geom[2] ) approx(anchor_xy,[0,0]) ? [anchor, up(anchor.z*L/2,cp), anchor, oang] : let( newgeom = list_set(geom, [0,len(geom)-3], [substr(geom[0],1), point2d(cp)]), result2d = _find_anchor(anchor_xy, newgeom), pos = point3d(result2d[1], cp.z+anchor.z*L/2), vec = unit(point3d(result2d[2], anchor.z),UP), oang = atan2(vec.y,vec.x) + 90 ) [anchor, pos, vec, oang] ) : assert(false, "Unknown attachment geometry type."); function _attachment_is_shown(tags) = assert(!is_undef($tags_shown)) assert(!is_undef($tags_hidden)) let( tags = str_split(tags, " "), shown  = !$tags_shown || any([for (tag=tags) in_list(tag, $tags_shown)]), hidden = any([for (tag=tags) in_list(tag, $tags_hidden)]) ) shown && !hidden; function _standard_anchors(two_d=false) = [ for ( zv = [ if (!two_d) TOP, CENTER, if (!two_d) BOTTOM ], yv = [FRONT, CENTER, BACK], xv = [LEFT, CENTER, RIGHT] ) xv+yv+zv ]; module show_anchors(s=10, std=true, custom=true) { check = assert($parent_geom != undef) 1; two_d = _attach_geom_2d($parent_geom); if (std) { for (anchor=_standard_anchors(two_d=two_d)) { if(two_d) { attach(anchor) anchor_arrow2d(s); } else { attach(anchor) anchor_arrow(s); } } } if (custom) { for (anchor=last($parent_geom)) { attach(anchor[0]) { if(two_d) { anchor_arrow2d(s, color="cyan"); } else { anchor_arrow(s, color="cyan"); } color("black") tags("anchor-arrow") { xrot(two_d? 0 : 90) { back(s/3) { yrot_copies(n=2) up(two_d? 0.51 : s/30) { linear_extrude(height=0.01, convexity=12, center=true) { text(text=anchor[0], size=s/4, halign="center", valign="center", font="Helvetica", $fn=36); } } } } } color([1, 1, 1, 1]) tags("anchor-arrow") { xrot(two_d? 0 : 90) { back(s/3) { cube_BOSL2([s/4.5*len(anchor[0]), s/3, 0.01], center=true); } } } } } } children(); } module anchor_arrow(s=10, color=[0.333,0.333,1], flag=true, $tags="anchor-arrow") { $fn=12; recolor("gray") spheroid(d=s/6) { attach(CENTER,BOT) recolor(color) cyl(h=s*2/3, d=s/15) { attach(TOP,BOT) cyl(h=s/3, d1=s/5, d2=0) { if(flag) { position(BOT) recolor([1,0.5,0.5]) cuboid([s/100, s/6, s/4], anchor=FRONT+BOT); } children(); } } } } module anchor_arrow2d(s=15, color=[0.333,0.333,1], $tags="anchor-arrow") { color(color) stroke([[0,0],[0,s]], width=s/10, endcap1="butt", endcap2="arrow2"); } module expose_anchors(opacity=0.2) { show("anchor-arrow") children(); hide("anchor-arrow") color(is_undef($color)? [0,0,0] : is_string($color)? $color : point3d($color), opacity) children(); } module frame_ref(s=15, opacity=1) { cube_BOSL2(0.01, center=true) { attach([1,0,0]) anchor_arrow(s=s, flag=false, color=[1.0, 0.3, 0.3, opacity]); attach([0,1,0]) anchor_arrow(s=s, flag=false, color=[0.3, 1.0, 0.3, opacity]); attach([0,0,1]) anchor_arrow(s=s, flag=false, color=[0.3, 0.3, 1.0, opacity]); children(); } } module _edges_text3d(txt,size=3) { if (is_list(txt)) { for (i=idx(txt)) { down((i-len(txt)/2+0.5)*size*1.5) { _edges_text3d(txt[i], size=size); } } } else { xrot(90) color("#000") linear_extrude(height=0.1) { text(text=txt, size=size, halign="center", valign="center"); } } } function _edges_vec_txt(x) = is_string(x)? str("\"", x, "\"") : assert(is_string(x) || is_vector(x,3), str(x)) let( lst = concat( x.z>0? ["TOP"]   : x.z<0? ["BOT"]  : [], x.y>0? ["BACK"]  : x.y<0? ["FWD"]  : [], x.x>0? ["RIGHT"] : x.x<0? ["LEFT"] : [] ), out = [ for (i = idx(lst)) i>0? str("+",lst[i]) : lst[i] ] ) out; function _edges_text(edges) = is_string(edges) ? [str("\"",edges,"\"")] : edges==EDGES_NONE ? ["EDGES_NONE"] : edges==EDGES_ALL ? ["EDGES_ALL"] : _is_edge_array(edges) ? [""] : is_vector(edges,3) ? _edges_vec_txt(edges) : is_list(edges) ? let( lst = [for (x=edges) each _edges_text(x)], out = [ for (i=idx(lst)) str( (i==0? "[" : ""), lst[i], (i<len(lst)-1? "," : ""), (i==len(lst)-1? "]" : "") ) ] ) out : [""]; EDGES_NONE = [[0,0,0,0], [0,0,0,0], [0,0,0,0]]; EDGES_ALL = [[1,1,1,1], [1,1,1,1], [1,1,1,1]]; EDGE_OFFSETS = [ [ [ 0,-1,-1], [ 0, 1,-1], [ 0,-1, 1], [ 0, 1, 1] ], [ [-1, 0,-1], [ 1, 0,-1], [-1, 0, 1], [ 1, 0, 1] ], [ [-1,-1, 0], [ 1,-1, 0], [-1, 1, 0], [ 1, 1, 0] ] ]; function _is_edge_array(x) = is_list(x) && is_vector(x[0]) && len(x)==3 && len(x[0])==4; function _edge_set(v) = _is_edge_array(v)? v : [ for (ax=[0:2]) [ for (b=[-1,1], a=[-1,1]) let( v2=[[0,a,b],[a,0,b],[a,b,0]][ax] ) ( is_string(v)? ( v=="X"? (ax==0) : v=="Y"? (ax==1) : v=="Z"? (ax==2) : v=="ALL"? true : v=="NONE"? false : let(valid_values = ["X", "Y", "Z", "ALL", "NONE"]) assert( in_list(v, valid_values), str(v, " must be a vector, edge array, or one of ", valid_values) ) v ) : let(nonz = sum(v_abs(v))) nonz==2? (v==v2) : let( matches = count_true([ for (i=[0:2]) v[i] && (v[i]==v2[i]) ]) ) nonz==1? (matches==1) : (matches==2) )? 1 : 0 ] ]; function _normalize_edges(v) = [for (ax=v) [for (edge=ax) edge>0? 1 : 0]]; function _edges(v, except=[]) = v==[] ? EDGES_NONE : (is_string(v) || is_vector(v) || _is_edge_array(v))? _edges([v], except=except) : (is_string(except) || is_vector(except) || _is_edge_array(except))? _edges(v, except=[except]) : except==[]? _normalize_edges(sum([for (x=v) _edge_set(x)])) : _normalize_edges( _normalize_edges(sum([for (x=v) _edge_set(x)])) - sum([for (x=except) _edge_set(x)]) ); module _show_edges(edges="ALL", size=20, text, txtsize=3,toplabel) { edge_set = _edges(edges); text = !is_undef(text) ? text : _edges_text(edges); color("red") { for (axis=[0:2], i=[0:3]) { if (edge_set[axis][i] > 0) { translate(EDGE_OFFSETS[axis][i]*size/2) { if (axis==0) xcyl(h=size, d=2); if (axis==1) ycyl(h=size, d=2); if (axis==2) zcyl(h=size, d=2); } } } } fwd(size/2) _edges_text3d(text, size=txtsize); color("yellow",0.7) cuboid(size=size); vpr = [55,0,25]; color("black") if (is_def(toplabel)) for(h=idx(toplabel)) up(21+6*h)rot(vpr) text3d(select(toplabel,-h-1),size=3.3,h=0.1,orient=UP,anchor=FRONT); } CORNERS_NONE = [0,0,0,0,0,0,0,0]; CORNERS_ALL = [1,1,1,1,1,1,1,1]; CORNER_OFFSETS = [ [-1,-1,-1], [ 1,-1,-1], [-1, 1,-1], [ 1, 1,-1], [-1,-1, 1], [ 1,-1, 1], [-1, 1, 1], [ 1, 1, 1] ]; function _is_corner_array(x) = is_vector(x) && len(x)==8 && all([for (xx=x) xx==1||xx==0]); function _normalize_corners(v) = [for (x=v) x>0? 1 : 0]; function _corner_set(v) = _is_corner_array(v)? v : [ for (i=[0:7]) let( v2 = CORNER_OFFSETS[i] ) ( is_string(v)? ( v=="ALL"? true : v=="NONE"? false : let(valid_values = ["ALL", "NONE"]) assert( in_list(v, valid_values), str(v, " must be a vector, corner array, or one of ", valid_values) ) v ) : all([for (i=[0:2]) !v[i] || (v[i]==v2[i])]) )? 1 : 0 ]; function _corners(v, except=[]) = v==[] ? CORNERS_NONE : (is_string(v) || is_vector(v) || _is_corner_array(v))? _corners([v], except=except) : (is_string(except) || is_vector(except) || _is_corner_array(except))? _corners(v, except=[except]) : except==[]? _normalize_corners(sum([for (x=v) _corner_set(x)])) : let( a = _normalize_corners(sum([for (x=v) _corner_set(x)])), b = _normalize_corners(sum([for (x=except) _corner_set(x)])) ) _normalize_corners(a - b); function _corner_edges(edges, v) = let(u = (v+[1,1,1])/2) [edges[0][u.y+u.z*2], edges[1][u.x+u.z*2], edges[2][u.x+u.y*2]]; function _corner_edge_count(edges, v) = let(u = (v+[1,1,1])/2) edges[0][u.y+u.z*2] + edges[1][u.x+u.z*2] + edges[2][u.x+u.y*2]; function _corners_text(corners) = is_string(corners) ? [str("\"",corners,"\"")] : corners==CORNERS_NONE ? ["CORNERS_NONE"] : corners==CORNERS_ALL ? ["CORNERS_ALL"] : _is_corner_array(corners) ? [""] : is_vector(corners,3) ? _edges_vec_txt(corners) : is_list(corners) ? let( lst = [for (x=corners) each _corners_text(x)], out = [ for (i=idx(lst)) str( (i==0? "[" : ""), lst[i], (i<len(lst)-1? "," : ""), (i==len(lst)-1? "]" : "") ) ] ) out : [""]; module _show_corners(corners="ALL", size=20, text, txtsize=3,toplabel) { corner_set = _corners(corners); text = !is_undef(text) ? text : _corners_text(corners); for (i=[0:7]) if (corner_set[i]>0) translate(CORNER_OFFSETS[i]*size/2) color("red") sphere_BOSL2(d=2, $fn=16); fwd(size/2) _edges_text3d(text, size=txtsize); color("yellow",0.7) cuboid(size=size); vpr = [55,0,25]; color("black") if (is_def(toplabel)) for(h=idx(toplabel)) up(21+6*h)rot(vpr) text3d(select(toplabel,-h-1),size=3.3,h=.1,orient=UP,anchor=FRONT); } module _show_cube_faces(faces, size=20, toplabel,botlabel) { color("red") for(f=faces){ move(f*size/2) rot(from=UP,to=f) cuboid([size,size,.1]); } vpr = [55,0,25]; color("black"){ if (is_def(toplabel)) for(h=idx(toplabel)) up(21+6*h)rot(vpr) text3d(select(toplabel,-h-1),size=3.3,h=.1,orient=UP,anchor=FRONT); if (is_def(botlabel)) for(h=idx(botlabel)) down(26+6*h)rot(vpr) text3d(botlabel[h],size=3.3,h=.1,orient=UP,anchor=FRONT); } color("yellow",0.7) cuboid(size=size); }module cube_BOSL2(size=1, center, anchor, spin=0, orient=UP) { anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]); size = scalar_vec3(size); attachable(anchor,spin,orient, size=size) { _cube(size, center=true); children(); } } function cube_BOSL2(size=1, center, anchor, spin=0, orient=UP) = let( siz = scalar_vec3(size), anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]), unscaled = [ [-1,-1,-1],[1,-1,-1],[1,1,-1],[-1,1,-1], [-1,-1, 1],[1,-1, 1],[1,1, 1],[-1,1, 1], ]/2, verts = is_num(size)? unscaled * size : is_vector(size,3)? [for (p=unscaled) v_mul(p,size)] : assert(is_num(size) || is_vector(size,3)), faces = [ [0,1,2], [0,2,3], [0,4,5], [0,5,1], [1,5,6], [1,6,2], [2,6,7], [2,7,3], [3,7,4], [3,4,0], [6,4,7], [6,5,4] ] ) [reorient(anchor,spin,orient, size=siz, p=verts), faces]; module cuboid( size=[1,1,1], p1, p2, chamfer, rounding, edges=EDGES_ALL, except=[], except_edges, trimcorners=true, teardrop=false, anchor=CENTER, spin=0, orient=UP ) { module xtcyl(l,r) { if (teardrop) { teardrop(r=r, l=l, cap_h=r, ang=teardrop, spin=90, orient=DOWN); } else { yrot(90) cyl(l=l, r=r); } } module ytcyl(l,r) { if (teardrop) { teardrop(r=r, l=l, cap_h=r, ang=teardrop, spin=0, orient=DOWN); } else { zrot(90) yrot(90) cyl(l=l, r=r); } } module tsphere_BOSL2(r) { if (teardrop) { onion(r=r, cap_h=r, ang=teardrop, orient=DOWN); } else { spheroid(r=r, style="octa", orient=DOWN); } } module corner_shape(corner) { e = _corner_edges(edges, corner); cnt = sum(e); r = first_defined([chamfer, rounding]); dummy=assert(is_finite(r) && !approx(r,0)); c = [min(r,size.x/2), min(r,size.y/2), min(r,size.z/2)]; c2 = v_mul(corner,c/2); $fn = is_finite(chamfer)? 4 : quantup(segs(r),4); translate(v_mul(corner, size/2-c)) { if (cnt == 0 || approx(r,0)) { translate(c2) cube_BOSL2(c, center=true); } else if (cnt == 1) { if (e.x) right(c2.x) xtcyl(l=c.x, r=r); if (e.y) back (c2.y) ytcyl(l=c.y, r=r); if (e.z) up   (c2.z) zcyl(l=c.z, r=r); } else if (cnt == 2) { if (!e.x) { intersection() { ytcyl(l=c.y*2, r=r); zcyl(l=c.z*2, r=r); } } else if (!e.y) { intersection() { xtcyl(l=c.x*2, r=r); zcyl(l=c.z*2, r=r); } } else { intersection() { xtcyl(l=c.x*2, r=r); ytcyl(l=c.y*2, r=r); } } } else { if (trimcorners) { tsphere_BOSL2(r=r); } else { intersection() { xtcyl(l=c.x*2, r=r); ytcyl(l=c.y*2, r=r); zcyl(l=c.z*2, r=r); } } } } } size = scalar_vec3(size); edges = _edges(edges, except=first_defined([except_edges,except])); teardrop = is_bool(teardrop)&&teardrop? 45 : teardrop; chamfer = approx(chamfer,0) ? undef : chamfer; rounding = approx(rounding,0) ? undef : rounding; assert(is_vector(size,3)); assert(all_positive(size)); assert(is_undef(chamfer) || is_finite(chamfer),"chamfer must be a finite value"); assert(is_undef(rounding) || is_finite(rounding),"rounding must be a finite value"); assert(is_undef(rounding) || is_undef(chamfer), "Cannot specify nonzero value for both chamfer and rounding"); assert(teardrop==false || (is_finite(teardrop) && teardrop>0 && teardrop<90), "teardrop must be either false or an angle number between 0 and 90") assert(is_undef(p1) || is_vector(p1)); assert(is_undef(p2) || is_vector(p2)); assert(is_bool(trimcorners)); if (!is_undef(p1)) { if (!is_undef(p2)) { translate(pointlist_bounds([p1,p2])[0]) { cuboid(size=v_abs(p2-p1), chamfer=chamfer, rounding=rounding, edges=edges, trimcorners=trimcorners, anchor=-[1,1,1]) children(); } } else { translate(p1) { cuboid(size=size, chamfer=chamfer, rounding=rounding, edges=edges, trimcorners=trimcorners, anchor=-[1,1,1]) children(); } } } else { if (is_finite(chamfer)) { if (any(edges[0])) assert(chamfer <= size.y/2 && chamfer <=size.z/2, "chamfer must be smaller than half the cube length or height."); if (any(edges[1])) assert(chamfer <= size.x/2 && chamfer <=size.z/2, "chamfer must be smaller than half the cube width or height."); if (any(edges[2])) assert(chamfer <= size.x/2 && chamfer <=size.y/2, "chamfer must be smaller than half the cube width or length."); } if (is_finite(rounding)) { if (any(edges[0])) assert(rounding <= size.y/2 && rounding<=size.z/2, "rounding radius must be smaller than half the cube length or height."); if (any(edges[1])) assert(rounding <= size.x/2 && rounding<=size.z/2, "rounding radius must be smaller than half the cube width or height."); if (any(edges[2])) assert(rounding <= size.x/2 && rounding<=size.y/2, "rounding radius must be smaller than half the cube width or length."); } majrots = [[0,90,0], [90,0,0], [0,0,0]]; attachable(anchor,spin,orient, size=size) { if (is_finite(chamfer) && !approx(chamfer,0)) { if (edges == EDGES_ALL && trimcorners) { if (chamfer<0) { cube_BOSL2(size, center=true) { attach(TOP,overlap=0) prismoid([size.x,size.y], [size.x-2*chamfer,size.y-2*chamfer], h=-chamfer, anchor=TOP); attach(BOT,overlap=0) prismoid([size.x,size.y], [size.x-2*chamfer,size.y-2*chamfer], h=-chamfer, anchor=TOP); } } else { isize = [for (v = size) max(0.001, v-2*chamfer)]; hull() { cube_BOSL2([ size.x, isize.y, isize.z], center=true); cube_BOSL2([isize.x,  size.y, isize.z], center=true); cube_BOSL2([isize.x, isize.y,  size.z], center=true); } } } else if (chamfer<0) { assert(edges == EDGES_ALL || edges[2] == [0,0,0,0], "Cannot use negative chamfer with Z aligned edges."); ach = abs(chamfer); cube_BOSL2(size, center=true); difference() { union() { for (i = [0:3], axis=[0:1]) { if (edges[axis][i]>0) { vec = EDGE_OFFSETS[axis][i]; translate(v_mul(vec/2, size+[ach,ach,-ach])) { rotate(majrots[axis]) { cube_BOSL2([ach, ach, size[axis]], center=true); } } } } if (trimcorners) { for (za=[-1,1], ya=[-1,1], xa=[-1,1]) { ce = _corner_edges(edges, [xa,ya,za]); if (ce.x + ce.y > 1) { translate(v_mul([xa,ya,za]/2, size+[ach-0.01,ach-0.01,-ach])) { cube_BOSL2([ach+0.01,ach+0.01,ach], center=true); } } } } } for (i = [0:3], axis=[0:1]) { if (edges[axis][i]>0) { vec = EDGE_OFFSETS[axis][i]; translate(v_mul(vec/2, size+[2*ach,2*ach,-2*ach])) { rotate(majrots[axis]) { zrot(45) cube_BOSL2([ach*sqrt(2), ach*sqrt(2), size[axis]+2.1*ach], center=true); } } } } } } else { hull() { corner_shape([-1,-1,-1]); corner_shape([ 1,-1,-1]); corner_shape([-1, 1,-1]); corner_shape([ 1, 1,-1]); corner_shape([-1,-1, 1]); corner_shape([ 1,-1, 1]); corner_shape([-1, 1, 1]); corner_shape([ 1, 1, 1]); } } } else if (is_finite(rounding) && !approx(rounding,0)) { sides = quantup(segs(rounding),4); if (edges == EDGES_ALL) { if(rounding<0) { cube_BOSL2(size, center=true); zflip_copy() { up(size.z/2) { difference() { down(-rounding/2) cube_BOSL2([size.x-2*rounding, size.y-2*rounding, -rounding], center=true); down(-rounding) { ycopies(size.y-2*rounding) xcyl(l=size.x-3*rounding, r=-rounding); xcopies(size.x-2*rounding) ycyl(l=size.y-3*rounding, r=-rounding); } } } } } else { isize = [for (v = size) max(0.001, v-2*rounding)]; minkowski() { cube_BOSL2(isize, center=true); if (trimcorners) { tsphere_BOSL2(r=rounding, $fn=sides); } else { intersection() { xtcyl(r=rounding, l=rounding*2, $fn=sides); ytcyl(r=rounding, l=rounding*2, $fn=sides); cyl(r=rounding, h=rounding*2, $fn=sides); } } } } } else if (rounding<0) { assert(edges == EDGES_ALL || edges[2] == [0,0,0,0], "Cannot use negative rounding with Z aligned edges."); ard = abs(rounding); cube_BOSL2(size, center=true); difference() { union() { for (i = [0:3], axis=[0:1]) { if (edges[axis][i]>0) { vec = EDGE_OFFSETS[axis][i]; translate(v_mul(vec/2, size+[ard,ard,-ard])) { rotate(majrots[axis]) { cube_BOSL2([ard, ard, size[axis]], center=true); } } } } if (trimcorners) { for (za=[-1,1], ya=[-1,1], xa=[-1,1]) { ce = _corner_edges(edges, [xa,ya,za]); if (ce.x + ce.y > 1) { translate(v_mul([xa,ya,za]/2, size+[ard-0.01,ard-0.01,-ard])) { cube_BOSL2([ard+0.01,ard+0.01,ard], center=true); } } } } } for (i = [0:3], axis=[0:1]) { if (edges[axis][i]>0) { vec = EDGE_OFFSETS[axis][i]; translate(v_mul(vec/2, size+[2*ard,2*ard,-2*ard])) { rotate(majrots[axis]) { cyl(l=size[axis]+2.1*ard, r=ard); } } } } } } else { hull() { corner_shape([-1,-1,-1]); corner_shape([ 1,-1,-1]); corner_shape([-1, 1,-1]); corner_shape([ 1, 1,-1]); corner_shape([-1,-1, 1]); corner_shape([ 1,-1, 1]); corner_shape([-1, 1, 1]); corner_shape([ 1, 1, 1]); } } } else { cube_BOSL2(size=size, center=true); } children(); } } } function cuboid( size=[1,1,1], p1, p2, chamfer, rounding, edges=EDGES_ALL, except_edges=[], trimcorners=true, anchor=CENTER, spin=0, orient=UP ) = no_function("cuboid"); module prismoid( size1, size2, h, shift=[0,0], rounding=0, rounding1, rounding2, chamfer=0, chamfer1, chamfer2, l, center, anchor, spin=0, orient=UP ) { assert(is_num(size1) || is_vector(size1,2)); assert(is_num(size2) || is_vector(size2,2)); assert(is_num(h) || is_num(l)); assert(is_vector(shift,2)); assert(is_num(rounding) || is_vector(rounding,4), "Bad rounding argument."); assert(is_undef(rounding1) || is_num(rounding1) || is_vector(rounding1,4), "Bad rounding1 argument."); assert(is_undef(rounding2) || is_num(rounding2) || is_vector(rounding2,4), "Bad rounding2 argument."); assert(is_num(chamfer) || is_vector(chamfer,4), "Bad chamfer argument."); assert(is_undef(chamfer1) || is_num(chamfer1) || is_vector(chamfer1,4), "Bad chamfer1 argument."); assert(is_undef(chamfer2) || is_num(chamfer2) || is_vector(chamfer2,4), "Bad chamfer2 argument."); eps = pow(2,-14); size1 = is_num(size1)? [size1,size1] : size1; size2 = is_num(size2)? [size2,size2] : size2; assert(all_nonnegative(size1)); assert(all_nonnegative(size2)); assert(size1.x + size2.x > 0); assert(size1.y + size2.y > 0); s1 = [max(size1.x, eps), max(size1.y, eps)]; s2 = [max(size2.x, eps), max(size2.y, eps)]; rounding1 = default(rounding1, rounding); rounding2 = default(rounding2, rounding); chamfer1 = default(chamfer1, chamfer); chamfer2 = default(chamfer2, chamfer); anchor = get_anchor(anchor, center, BOT, BOT); vnf = prismoid( size1=size1, size2=size2, h=h, shift=shift, rounding1=rounding1, rounding2=rounding2, chamfer1=chamfer1, chamfer2=chamfer2, l=l, center=CENTER ); attachable(anchor,spin,orient, size=[s1.x,s1.y,h], size2=s2, shift=shift) { vnf_polyhedron(vnf, convexity=4); children(); } } function prismoid( size1, size2, h, shift=[0,0], rounding=0, rounding1, rounding2, chamfer=0, chamfer1, chamfer2, l, center, anchor=DOWN, spin=0, orient=UP ) = assert(is_vector(size1,2)) assert(is_vector(size2,2)) assert(is_num(h) || is_num(l)) assert(is_vector(shift,2)) assert( (is_num(rounding) && rounding>=0) || (is_vector(rounding,4) && all_nonnegative(rounding)), "Bad rounding argument." ) assert( is_undef(rounding1) || (is_num(rounding1) && rounding1>=0) || (is_vector(rounding1,4) && all_nonnegative(rounding1)), "Bad rounding1 argument." ) assert( is_undef(rounding2) || (is_num(rounding2) && rounding2>=0) || (is_vector(rounding2,4) && all_nonnegative(rounding2)), "Bad rounding2 argument." ) assert( (is_num(chamfer) && chamfer>=0) || (is_vector(chamfer,4) && all_nonnegative(chamfer)), "Bad chamfer argument." ) assert( is_undef(chamfer1) || (is_num(chamfer1) && chamfer1>=0) || (is_vector(chamfer1,4) && all_nonnegative(chamfer1)), "Bad chamfer1 argument." ) assert( is_undef(chamfer2) || (is_num(chamfer2) && chamfer2>=0) || (is_vector(chamfer2,4) && all_nonnegative(chamfer2)), "Bad chamfer2 argument." ) let( eps = pow(2,-14), h = first_defined([h,l,1]), shiftby = point3d(point2d(shift)), s1 = [max(size1.x, eps), max(size1.y, eps)], s2 = [max(size2.x, eps), max(size2.y, eps)], rounding1 = default(rounding1, rounding), rounding2 = default(rounding2, rounding), chamfer1 = default(chamfer1, chamfer), chamfer2 = default(chamfer2, chamfer), anchor = get_anchor(anchor, center, BOT, BOT), vnf = (rounding1==0 && rounding2==0 && chamfer1==0 && chamfer2==0)? ( let( corners = [[1,1],[1,-1],[-1,-1],[-1,1]] * 0.5, points = [ for (p=corners) point3d(v_mul(s2,p), +h/2) + shiftby, for (p=corners) point3d(v_mul(s1,p), -h/2) ], faces=[ [0,1,2], [0,2,3], [0,4,5], [0,5,1], [1,5,6], [1,6,2], [2,6,7], [2,7,3], [3,7,4], [3,4,0], [4,7,6], [4,6,5], ] ) [points, faces] ) : ( let( path1 = rect(size1, rounding=rounding1, chamfer=chamfer1, anchor=CTR), path2 = rect(size2, rounding=rounding2, chamfer=chamfer2, anchor=CTR), points = [ each path3d(path1, -h/2), each path3d(move(shiftby, p=path2), +h/2), ], faces = hull(points) ) [points, faces] ) ) reorient(anchor,spin,orient, size=[s1.x,s1.y,h], size2=s2, shift=shift, p=vnf); module octahedron(size=1, anchor=CENTER, spin=0, orient=UP) { vnf = octahedron(size=size); attachable(anchor,spin,orient, vnf=vnf, extent=true) { vnf_polyhedron(vnf, convexity=2); children(); } } function octahedron(size=1, anchor=CENTER, spin=0, orient=UP) = let( s = size / 2, vnf = [ [ [0,0,s], [s,0,0], [0,s,0], [-s,0,0], [0,-s,0], [0,0,-s] ], [ [0,2,1], [0,3,2], [0,4,3], [0,1,4], [5,1,2], [5,2,3], [5,3,4], [5,4,1] ] ] ) reorient(anchor,spin,orient, vnf=vnf, extent=true, p=vnf); module rect_tube( h, size, isize, center, shift=[0,0], wall, size1, size2, isize1, isize2, rounding=0, rounding1, rounding2, irounding=0, irounding1, irounding2, chamfer=0, chamfer1, chamfer2, ichamfer=0, ichamfer1, ichamfer2, anchor, spin=0, orient=UP, l ) { h = one_defined([h,l],"h,l"); assert(is_num(h), "l or h argument required."); assert(is_vector(shift,2)); s1 = is_num(size1)? [size1, size1] : is_vector(size1,2)? size1 : is_num(size)? [size, size] : is_vector(size,2)? size : undef; s2 = is_num(size2)? [size2, size2] : is_vector(size2,2)? size2 : is_num(size)? [size, size] : is_vector(size,2)? size : undef; is1 = is_num(isize1)? [isize1, isize1] : is_vector(isize1,2)? isize1 : is_num(isize)? [isize, isize] : is_vector(isize,2)? isize : undef; is2 = is_num(isize2)? [isize2, isize2] : is_vector(isize2,2)? isize2 : is_num(isize)? [isize, isize] : is_vector(isize,2)? isize : undef; size1 = is_def(s1)? s1 : (is_def(wall) && is_def(is1))? (is1+2*[wall,wall]) : undef; size2 = is_def(s2)? s2 : (is_def(wall) && is_def(is2))? (is2+2*[wall,wall]) : undef; isize1 = is_def(is1)? is1 : (is_def(wall) && is_def(s1))? (s1-2*[wall,wall]) : undef; isize2 = is_def(is2)? is2 : (is_def(wall) && is_def(s2))? (s2-2*[wall,wall]) : undef; assert(wall==undef || is_num(wall)); assert(size1!=undef, "Bad size/size1 argument."); assert(size2!=undef, "Bad size/size2 argument."); assert(isize1!=undef, "Bad isize/isize1 argument."); assert(isize2!=undef, "Bad isize/isize2 argument."); assert(isize1.x < size1.x, "Inner size is larger than outer size."); assert(isize1.y < size1.y, "Inner size is larger than outer size."); assert(isize2.x < size2.x, "Inner size is larger than outer size."); assert(isize2.y < size2.y, "Inner size is larger than outer size."); anchor = get_anchor(anchor, center, BOT, BOT); attachable(anchor,spin,orient, size=[each size1, h], size2=size2, shift=shift) { diff("_H_o_L_e_") prismoid( size1, size2, h=h, shift=shift, rounding=rounding, rounding1=rounding1, rounding2=rounding2, chamfer=chamfer, chamfer1=chamfer1, chamfer2=chamfer2, anchor=CTR ) { children(); tags("_H_o_L_e_") prismoid( isize1, isize2, h=h+0.05, shift=shift, rounding=irounding, rounding1=irounding1, rounding2=irounding2, chamfer=ichamfer, chamfer1=ichamfer1, chamfer2=ichamfer2, anchor=CTR ); } children(); } } function rect_tube( h, size, isize, center, shift=[0,0], wall, size1, size2, isize1, isize2, rounding=0, rounding1, rounding2, irounding=0, irounding1, irounding2, chamfer=0, chamfer1, chamfer2, ichamfer=0, ichamfer1, ichamfer2, anchor, spin=0, orient=UP, l ) = no_function("rect_tube"); module wedge(size=[1, 1, 1], center, anchor, spin=0, orient=UP) { size = scalar_vec3(size); anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]); vnf = wedge(size, center=true); attachable(anchor,spin,orient, size=size, size2=[size.x,0], shift=[0,-size.y/2]) { if (size.z > 0) { vnf_polyhedron(vnf); } children(); } } function wedge(size=[1,1,1], center, anchor, spin=0, orient=UP) = let( size = scalar_vec3(size), anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]), pts = [ [ 1,1,-1], [ 1,-1,-1], [ 1,-1,1], [-1,1,-1], [-1,-1,-1], [-1,-1,1], ], faces = [ [0,1,2], [3,5,4], [0,3,1], [1,3,4], [1,4,2], [2,4,5], [2,5,3], [0,2,3], ], vnf = [scale(size/2,p=pts), faces] ) reorient(anchor,spin,orient, size=size, size2=[size.x,0], shift=[0,-size.y/2], p=vnf); module cylinder_BOSL2(h, r1, r2, center, l, r, d, d1, d2, anchor, spin=0, orient=UP) { anchor = get_anchor(anchor, center, BOTTOM, BOTTOM); r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1); r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1); l = first_defined([h, l, 1]); attachable(anchor,spin,orient, r1=r1, r2=r2, l=l) { _cylinder(h=l, r1=r1, r2=r2, center=true); children(); } } function cylinder_BOSL2(h, r1, r2, center, l, r, d, d1, d2, anchor, spin=0, orient=UP) = let( anchor = get_anchor(anchor, center, BOTTOM, BOTTOM), r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1), r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1), l = first_defined([h, l, 1]), sides = segs(max(r1,r2)), verts = [ for (i=[0:1:sides-1]) let(a=360*(1-i/sides)) [r1*cos(a),r1*sin(a),-l/2], for (i=[0:1:sides-1]) let(a=360*(1-i/sides)) [r2*cos(a),r2*sin(a), l/2], ], faces = [ [for (i=[0:1:sides-1]) sides-1-i], for (i=[0:1:sides-1]) [i, ((i+1)%sides)+sides, i+sides], for (i=[0:1:sides-1]) [i, (i+1)%sides, ((i+1)%sides)+sides], [for (i=[0:1:sides-1]) sides+i] ] ) [reorient(anchor,spin,orient, l=l, r1=r1, r2=r2, p=verts), faces]; module cyl( h, r, center, l, r1, r2, d, d1, d2, chamfer, chamfer1, chamfer2, chamfang, chamfang1, chamfang2, rounding, rounding1, rounding2, circum=false, realign=false, from_end=false, anchor, spin=0, orient=UP ) { l = first_defined([l, h, 1]); _r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1); _r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1); sides = segs(max(_r1,_r2)); sc = circum? 1/cos(180/sides) : 1; r1=_r1*sc; r2=_r2*sc; phi = atan2(l, r2-r1); anchor = get_anchor(anchor,center,BOT,CENTER); attachable(anchor,spin,orient, r1=r1, r2=r2, l=l) { zrot(realign? 180/sides : 0) { if (!any_defined([chamfer, chamfer1, chamfer2, rounding, rounding1, rounding2])) { cylinder_BOSL2(h=l, r1=r1, r2=r2, center=true, $fn=sides); } else { vang = atan2(l, r1-r2)/2; chang1 = 90-first_defined([chamfang1, chamfang, vang]); chang2 = 90-first_defined([chamfang2, chamfang, 90-vang]); cham1 = u_mul(first_defined([chamfer1, chamfer]) , (from_end? 1 : tan(chang1))); cham2 = u_mul(first_defined([chamfer2, chamfer]) , (from_end? 1 : tan(chang2))); fil1 = first_defined([rounding1, rounding]); fil2 = first_defined([rounding2, rounding]); if (chamfer != undef) { assert(chamfer <= r1,  "chamfer is larger than the r1 radius of the cylinder."); assert(chamfer <= r2,  "chamfer is larger than the r2 radius of the cylinder."); } if (cham1 != undef) { assert(cham1 <= r1,  "chamfer1 is larger than the r1 radius of the cylinder."); } if (cham2 != undef) { assert(cham2 <= r2,  "chamfer2 is larger than the r2 radius of the cylinder."); } if (rounding != undef) { assert(rounding <= r1,  "rounding is larger than the r1 radius of the cylinder."); assert(rounding <= r2,  "rounding is larger than the r2 radius of the cylinder."); } if (fil1 != undef) { assert(fil1 <= r1,  "rounding1 is larger than the r1 radius of the cylinder."); } if (fil2 != undef) { assert(fil2 <= r2,  "rounding2 is larger than the r1 radius of the cylinder."); } dy1 = abs(first_defined([cham1, fil1, 0])); dy2 = abs(first_defined([cham2, fil2, 0])); assert(dy1+dy2 <= l, "Sum of fillets and chamfer sizes must be less than the length of the cylinder."); path = concat( [[0,l/2]], !is_undef(cham2)? ( let( p1 = [r2-cham2/tan(chang2),l/2], p2 = lerp([r2,l/2],[r1,-l/2],abs(cham2)/l) ) [p1,p2] ) : !is_undef(fil2)? ( let( cn = circle_2tangents([r2-fil2,l/2], [r2,l/2], [r1,-l/2], r=abs(fil2)), ang = fil2<0? phi : phi-180, steps = ceil(abs(ang)/360*segs(abs(fil2))), step = ang/steps, pts = [for (i=[0:1:steps]) let(a=90+i*step) cn[0]+abs(fil2)*[cos(a),sin(a)]] ) pts ) : [[r2,l/2]], !is_undef(cham1)? ( let( p1 = lerp([r1,-l/2],[r2,l/2],abs(cham1)/l), p2 = [r1-cham1/tan(chang1),-l/2] ) [p1,p2] ) : !is_undef(fil1)? ( let( cn = circle_2tangents([r1-fil1,-l/2], [r1,-l/2], [r2,l/2], r=abs(fil1)), ang = fil1<0? 180-phi : -phi, steps = ceil(abs(ang)/360*segs(abs(fil1))), step = ang/steps, pts = [for (i=[0:1:steps]) let(a=(fil1<0?180:0)+(phi-90)+i*step) cn[0]+abs(fil1)*[cos(a),sin(a)]] ) pts ) : [[r1,-l/2]], [[0,-l/2]] ); rotate_extrude(convexity=2) { polygon(path); } } } children(); } } module xcyl(h, r, d, r1, r2, d1, d2, l, anchor=CENTER) { r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1); r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1); l = first_defined([l, h, 1]); attachable(anchor,0,UP, r1=r1, r2=r2, l=l, axis=RIGHT) { cyl(l=l, r1=r1, r2=r2, orient=RIGHT, anchor=CENTER); children(); } } module ycyl(h, r, d, r1, r2, d1, d2, l, anchor=CENTER) { r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=1); r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=1); l = first_defined([l, h, 1]); attachable(anchor,0,UP, r1=r1, r2=r2, l=l, axis=BACK) { cyl(l=l, h=h, r1=r1, r2=r2, orient=BACK, anchor=CENTER); children(); } } module zcyl(h, r, d, r1, r2, d1, d2, l, anchor=CENTER) { cyl(l=l, h=h, r=r, r1=r1, r2=r2, d=d, d1=d1, d2=d2, orient=UP, anchor=anchor) children(); } module tube( h, or, ir, center, od, id, wall, or1, or2, od1, od2, ir1, ir2, id1, id2, realign=false, l, anchor, spin=0, orient=UP ) { h = first_defined([h,l,1]); orr1 = get_radius(r1=or1, r=or, d1=od1, d=od, dflt=undef); orr2 = get_radius(r1=or2, r=or, d1=od2, d=od, dflt=undef); irr1 = get_radius(r1=ir1, r=ir, d1=id1, d=id, dflt=undef); irr2 = get_radius(r1=ir2, r=ir, d1=id2, d=id, dflt=undef); r1 = default(orr1, u_add(irr1,wall)); r2 = default(orr2, u_add(irr2,wall)); ir1 = default(irr1, u_sub(orr1,wall)); ir2 = default(irr2, u_sub(orr2,wall)); assert(ir1 <= r1, "Inner radius is larger than outer radius."); assert(ir2 <= r2, "Inner radius is larger than outer radius."); sides = segs(max(r1,r2)); anchor = get_anchor(anchor, center, BOT, BOT); attachable(anchor,spin,orient, r1=r1, r2=r2, l=h) { zrot(realign? 180/sides : 0) { difference() { cyl(h=h, r1=r1, r2=r2, $fn=sides) children(); cyl(h=h+0.05, r1=ir1, r2=ir2); } } children(); } } module pie_slice( h, r, ang=30, center, r1, r2, d, d1, d2, l, anchor, spin=0, orient=UP ) { l = first_defined([l, h, 1]); r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=10); r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=10); maxd = max(r1,r2)+0.1; anchor = get_anchor(anchor, center, BOT, BOT); attachable(anchor,spin,orient, r1=r1, r2=r2, l=l) { difference() { cyl(r1=r1, r2=r2, h=l); if (ang<180) rotate(ang) back(maxd/2) cube_BOSL2([2*maxd, maxd, l+0.1], center=true); difference() { fwd(maxd/2) cube_BOSL2([2*maxd, maxd, l+0.2], center=true); if (ang>180) rotate(ang-180) back(maxd/2) cube_BOSL2([2*maxd, maxd, l+0.1], center=true); } } children(); } } function pie_slice( h, r, ang=30, center, r1, r2, d, d1, d2, l, anchor, spin=0, orient=UP ) = let( anchor = get_anchor(anchor, center, BOT, BOT), l = first_defined([l, h, 1]), r1 = get_radius(r1=r1, r=r, d1=d1, d=d, dflt=10), r2 = get_radius(r1=r2, r=r, d1=d2, d=d, dflt=10), maxd = max(r1,r2)+0.1, sides = ceil(segs(max(r1,r2))*ang/360), step = ang/sides, vnf = vnf_vertex_array( points=[ for (u = [0,1]) let( h = lerp(-l/2,l/2,u), r = lerp(r1,r2,u) ) [ for (theta = [0:step:ang+EPSILON]) cylindrical_to_xyz(r,theta,h), [0,0,h] ] ], col_wrap=true, caps=true, reverse=true ) ) reorient(anchor,spin,orient, r1=r1, r2=r2, l=l, p=vnf); module sphere_BOSL2(r, d, circum=false, style="orig", anchor=CENTER, spin=0, orient=UP) { r = get_radius(r=r, d=d, dflt=1); if (!circum && style=="orig" && is_num(r)) { attachable(anchor,spin,orient, r=r) { _sphere(r=r); children(); } } else { spheroid( r=r, circum=circum, style=style, anchor=anchor, spin=spin, orient=orient ) children(); } } function sphere_BOSL2(r, d, circum=false, style="orig", anchor=CENTER, spin=0, orient=UP) = spheroid(r=r, d=d, circum=circum, style=style, anchor=anchor, spin=spin, orient=orient); module spheroid(r, style="aligned", d, circum=false, dual=false, anchor=CENTER, spin=0, orient=UP) { r = get_radius(r=r, d=d, dflt=1); sides = segs(r); vsides = ceil(sides/2); attachable(anchor,spin,orient, r=r) { if (style=="orig" && !circum) { merids = [ for (i=[0:1:vsides-1]) 90-(i+0.5)*180/vsides ]; path = [ let(a = merids[0]) [0, sin(a)], for (a=merids) [cos(a), sin(a)], let(a = last(merids)) [0, sin(a)] ]; scale(r) rotate(180) rotate_extrude(convexity=2,$fn=sides) polygon(path); } else if (circum && (style=="octa" || style=="icosa")) { orig_sphere = spheroid(r,style,circum=false); dualvert = _dual_vertices(orig_sphere); hull_points(dualvert,fast=true); } else { vnf = spheroid(r=r, circum=circum, style=style); vnf_polyhedron(vnf, convexity=2); } children(); } } function _subsample_triangle(p,N) = [for(i=[0:N+1]) [for (j=[0:N+1-i]) unit(lerp(p[0],p[1],i/(N+1)) + (p[2]-p[0])*j/(N+1))]]; function _dual_vertices(vnf) = let(vert=vnf[0]) [for(face=vnf[1]) let(planes = select(vert,face)) linear_solve3(select(planes,0,2), [for(i=[0:2]) planes[i]*planes[i]]) ]; function spheroid(r, style="aligned", d, circum=false, anchor=CENTER, spin=0, orient=UP) = let( r = get_radius(r=r, d=d, dflt=1), hsides = segs(r), vsides = max(2,ceil(hsides/2)), octa_steps = round(max(4,hsides)/4), icosa_steps = round(max(5,hsides)/5), stagger = style=="stagger" ) circum && style=="orig" ? let( orig_sphere = spheroid(r,"aligned",circum=false), dualvert = zrot(360/hsides/2,_dual_vertices(orig_sphere)), culledvert = [ [for(i=[0:2:2*hsides-1]) dualvert[i]], for(j=[1:vsides-2]) [for(i=[0:2:2*hsides-1]) dualvert[j*2*hsides+i]], [for(i=[1:2:2*hsides-1]) dualvert[i]] ], vnf = vnf_vertex_array(culledvert,col_wrap=true,caps=true) ) [reorient(anchor,spin,orient, r=r, p=vnf[0]), vnf[1]] : circum && (style=="octa" || style=="icosa") ? let( orig_sphere = spheroid(r,style,circum=false), dualvert = _dual_vertices(orig_sphere), faces = hull(dualvert) ) [reorient(anchor,spin,orient, r=r, p=dualvert), faces] : style=="icosa" ? let( N = icosa_steps-1, icovert=[ for(i=[-1,1], j=[-1,1]) each [[0,i,j*PHI], [i,j*PHI,0], [j*PHI,0,i]]], icoface = hull(icovert), face0 = select(icovert,icoface[0]), sampled = r * _subsample_triangle(face0,N), dir0 = mean(face0), point0 = face0[0]-dir0, tri_list = [sampled, for(i=[1:1:len(icoface)-1]) let(face = select(icovert,icoface[i])) apply(frame_map(z=mean(face),x=face[0]-mean(face)) *frame_map(z=dir0,x=point0,reverse=true), sampled)], faces = vnf_tri_array(tri_list[0],reverse=true)[1], size = repeat((N+2)*(N+3)/2,3), fullfaces = [for(i=idx(tri_list)) each [for(f=faces) f+i*size]], fullvert = flatten(flatten(tri_list)) ) [reorient(anchor,spin,orient, r=r, p=fullvert), fullfaces] : let( verts = circum && style=="stagger" ? _dual_vertices(spheroid(r,style,circum=false)) : circum && style=="aligned" ? let( orig_sphere = spheroid(r,"orig",circum=false), dualvert = _dual_vertices(orig_sphere), culledvert = zrot(360/hsides/2, [dualvert[0], for(i=[2:2:len(dualvert)-1]) dualvert[i], dualvert[1]]) ) culledvert : style=="orig"? [ for (i=[0:1:vsides-1]) let(phi = (i+0.5)*180/(vsides)) for (j=[0:1:hsides-1]) let(theta = j*360/hsides) spherical_to_xyz(r, theta, phi), ] : style=="aligned" || style=="stagger"? [ spherical_to_xyz(r, 0, 0), for (i=[1:1:vsides-1]) let(phi = i*180/vsides) for (j=[0:1:hsides-1]) let(theta = (j+((stagger && i%2!=0)?0.5:0))*360/hsides) spherical_to_xyz(r, theta, phi), spherical_to_xyz(r, 0, 180) ] : style=="octa"? let( meridians = [ 1, for (i = [1:1:octa_steps]) i*4, for (i = [octa_steps-1:-1:1]) i*4, 1, ] ) [ for (i=idx(meridians), j=[0:1:meridians[i]-1]) spherical_to_xyz(r, j*360/meridians[i], i*180/(len(meridians)-1)) ] : assert(in_list(style,["orig","aligned","stagger","octa","icosa"])), lv = len(verts), faces = circum && style=="stagger" ? let(ptcount=2*hsides) [ [for(i=[ptcount-2:-2:0]) i], for(j=[0:hsides-1]) [j*2, (j*2+2)%ptcount,ptcount+(j*2+2)%ptcount,ptcount+(j*2+3)%ptcount,ptcount+j*2], for(i=[1:vsides-3]) let(base=ptcount*i) for(j=[0:hsides-1]) i%2==0 ? [base+2*j, base+(2*j+1)%ptcount, base+(2*j+2)%ptcount, base+ptcount+(2*j)%ptcount, base+ptcount+(2*j+1)%ptcount, base+ptcount+(2*j-2+ptcount)%ptcount] : [base+(1+2*j)%ptcount, base+(2*j)%ptcount, base+(2*j+3)%ptcount, base+ptcount+(3+2*j)%ptcount, base+ptcount+(2*j+2)%ptcount,base+ptcount+(2*j+1)%ptcount], for(j=[0:hsides-1]) vsides%2==0 ? [(j*2+3)%ptcount, j*2+1, lv-ptcount+(2+j*2)%ptcount, lv-ptcount+(3+j*2)%ptcount, lv-ptcount+(4+j*2)%ptcount] : [(j*2+3)%ptcount, j*2+1, lv-ptcount+(1+j*2)%ptcount, lv-ptcount+(j*2)%ptcount, lv-ptcount+(3+j*2)%ptcount], [for(i=[1:2:ptcount-1]) i], ] : style=="aligned" || style=="stagger" ? [ for (i=[0:1:hsides-1]) let(b2 = lv-2-hsides) each [ [i+1, 0, ((i+1)%hsides)+1], [lv-1, b2+i+1, b2+((i+1)%hsides)+1], ], for (i=[0:1:vsides-3], j=[0:1:hsides-1]) let(base = 1 + hsides*i) each ( (stagger && i%2!=0)? [ [base+j, base+hsides+j%hsides, base+hsides+(j+hsides-1)%hsides], [base+j, base+(j+1)%hsides, base+hsides+j], ] : [ [base+j, base+(j+1)%hsides, base+hsides+(j+1)%hsides], [base+j, base+hsides+(j+1)%hsides, base+hsides+j], ] ) ] : style=="orig"? [ [for (i=[0:1:hsides-1]) hsides-i-1], [for (i=[0:1:hsides-1]) lv-hsides+i], for (i=[0:1:vsides-2], j=[0:1:hsides-1]) each [ [(i+1)*hsides+j, i*hsides+j, i*hsides+(j+1)%hsides], [(i+1)*hsides+j, i*hsides+(j+1)%hsides, (i+1)*hsides+(j+1)%hsides], ] ] : /*style=="octa"?*/ let( meridians = [ 0, 1, for (i = [1:1:octa_steps]) i*4, for (i = [octa_steps-1:-1:1]) i*4, 1, ], offs = cumsum(meridians), pc = last(offs)-1, os = octa_steps * 2 ) [ for (i=[0:1:3]) [0, 1+(i+1)%4, 1+i], for (i=[0:1:3]) [pc-0, pc-(1+(i+1)%4), pc-(1+i)], for (i=[1:1:octa_steps-1]) let(m = meridians[i+2]/4) for (j=[0:1:3], k=[0:1:m-1]) let( m1 = meridians[i+1], m2 = meridians[i+2], p1 = offs[i+0] + (j*m1/4 + k+0) % m1, p2 = offs[i+0] + (j*m1/4 + k+1) % m1, p3 = offs[i+1] + (j*m2/4 + k+0) % m2, p4 = offs[i+1] + (j*m2/4 + k+1) % m2, p5 = offs[os-i+0] + (j*m1/4 + k+0) % m1, p6 = offs[os-i+0] + (j*m1/4 + k+1) % m1, p7 = offs[os-i-1] + (j*m2/4 + k+0) % m2, p8 = offs[os-i-1] + (j*m2/4 + k+1) % m2 ) each [ [p1, p4, p3], if (k<m-1) [p1, p2, p4], [p5, p7, p8], if (k<m-1) [p5, p8, p6], ], ] ) [reorient(anchor,spin,orient, r=r, p=verts), faces]; module torus( r_maj, r_min, center, d_maj, d_min, or, od, ir, id, anchor, spin=0, orient=UP ) { _or = get_radius(r=or, d=od, dflt=undef); _ir = get_radius(r=ir, d=id, dflt=undef); _r_maj = get_radius(r=r_maj, d=d_maj, dflt=undef); _r_min = get_radius(r=r_min, d=d_min, dflt=undef); maj_rad = is_finite(_r_maj)? _r_maj : is_finite(_ir) && is_finite(_or)? (_or + _ir)/2 : is_finite(_ir) && is_finite(_r_min)? (_ir + _r_min) : is_finite(_or) && is_finite(_r_min)? (_or - _r_min) : assert(false, "Bad Parameters"); min_rad = is_finite(_r_min)? _r_min : is_finite(_ir)? (maj_rad - _ir) : is_finite(_or)? (_or - maj_rad) : assert(false, "Bad Parameters"); anchor = get_anchor(anchor, center, BOT, CENTER); attachable(anchor,spin,orient, r=(maj_rad+min_rad), l=min_rad*2) { rotate_extrude(convexity=4) { right_half(s=min_rad*2, planar=true) right(maj_rad) circle_BOSL2(r=min_rad); } children(); } } function torus( r_maj, r_min, center, d_maj, d_min, or, od, ir, id, anchor, spin=0, orient=UP ) = let( _or = get_radius(r=or, d=od, dflt=undef), _ir = get_radius(r=ir, d=id, dflt=undef), _r_maj = get_radius(r=r_maj, d=d_maj, dflt=undef), _r_min = get_radius(r=r_min, d=d_min, dflt=undef), maj_rad = is_finite(_r_maj)? _r_maj : is_finite(_ir) && is_finite(_or)? (_or + _ir)/2 : is_finite(_ir) && is_finite(_r_min)? (_ir + _r_min) : is_finite(_or) && is_finite(_r_min)? (_or - _r_min) : assert(false, "Bad Parameters"), min_rad = is_finite(_r_min)? _r_min : is_finite(_ir)? (maj_rad - _ir) : is_finite(_or)? (_or - maj_rad) : assert(false, "Bad Parameters"), anchor = get_anchor(anchor, center, BOT, CENTER), maj_sides = segs(maj_rad+min_rad), maj_step = 360 / maj_sides, min_sides = segs(min_rad), min_step = 360 / min_sides, xyprofile = min_rad <= maj_rad? right(maj_rad, p=circle_BOSL2(r=min_rad)) : right_half(p=right(maj_rad, p=circle_BOSL2(r=min_rad)))[0], profile = xrot(90, p=path3d(xyprofile)), vnf = vnf_vertex_array( points=[for (a=[0:maj_step:360-EPSILON]) zrot(a, p=profile)], caps=false, col_wrap=true, row_wrap=true, reverse=true ) ) reorient(anchor,spin,orient, r=(maj_rad+min_rad), l=min_rad*2, p=vnf); module teardrop(h, r, ang=45, cap_h, r1, r2, d, d1, d2, cap_h1, cap_h2, l, anchor=CENTER, spin=0, orient=UP) { r1 = get_radius(r=r, r1=r1, d=d, d1=d1, dflt=1); r2 = get_radius(r=r, r1=r2, d=d, d1=d2, dflt=1); l = first_defined([l, h, 1]); cap_h1 = first_defined([cap_h1, cap_h]); cap_h2 = first_defined([cap_h2, cap_h]); sides = segs(max(r1,r2)); profile1 = teardrop2d(r=r1, ang=ang, cap_h=cap_h1, $fn=sides); profile2 = teardrop2d(r=r2, ang=ang, cap_h=cap_h2, $fn=sides); tip_y1 = max(column(profile1,1)); tip_y2 = max(column(profile2,1)); _cap_h1 = min(default(cap_h1, tip_y1), tip_y1); _cap_h2 = min(default(cap_h2, tip_y2), tip_y2); capvec = unit([0, _cap_h1-_cap_h2, l]); anchors = [ named_anchor("cap",      [0,0,(_cap_h1+_cap_h2)/2], capvec), named_anchor("cap_fwd",  [0,-l/2,_cap_h1],         unit((capvec+FWD)/2)), named_anchor("cap_back", [0,+l/2,_cap_h2],         unit((capvec+BACK)/2), 180), ]; attachable(anchor,spin,orient, r1=r1, r2=r2, l=l, axis=BACK, anchors=anchors) { rot(from=UP,to=FWD) { if (l > 0) { if (r1 == r2) { linear_extrude(height=l, center=true, slices=2) { polygon(profile1); } } else { hull() { up(l/2-0.001) { linear_extrude(height=0.001, center=false) { polygon(profile1); } } down(l/2) { linear_extrude(height=0.001, center=false) { polygon(profile2); } } } } } } children(); } } function teardrop(h, r, ang=45, cap_h, r1, r2, d, d1, d2, cap_h1, cap_h2, l, anchor=CENTER, spin=0, orient=UP) = let( r1 = get_radius(r=r, r1=r1, d=d, d1=d1, dflt=1), r2 = get_radius(r=r, r1=r2, d=d, d1=d2, dflt=1), l = first_defined([l, h, 1]), cap_h1 = first_defined([cap_h1, cap_h]), cap_h2 = first_defined([cap_h2, cap_h]), sides = segs(max(r1,r2)), profile1 = teardrop2d(r=r1, ang=ang, cap_h=cap_h1, $fn=sides), profile2 = teardrop2d(r=r2, ang=ang, cap_h=cap_h2, $fn=sides), tip_y1 = max(column(profile1,1)), tip_y2 = max(column(profile2,1)), feef=echo(tip_y1=tip_y1, tip_y2=tip_y2), _cap_h1 = min(default(cap_h1, tip_y1), tip_y1), _cap_h2 = min(default(cap_h2, tip_y2), tip_y2), capvec = unit([0, _cap_h1-_cap_h2, l]), anchors = [ named_anchor("cap",      [0,0,(_cap_h1+_cap_h2)/2], capvec), named_anchor("cap_fwd",  [0,-l/2,_cap_h1],         unit((capvec+FWD)/2)), named_anchor("cap_back", [0,+l/2,_cap_h2],         unit((capvec+BACK)/2), 180), ], vnf = vnf_vertex_array( points = [ fwd(l/2, p=xrot(90, p=path3d(profile1))), back(l/2, p=xrot(90, p=path3d(profile2))), ], caps=true, col_wrap=true, reverse=true ) ) reorient(anchor,spin,orient, r1=r1, r2=r2, l=l, axis=BACK, anchors=anchors, p=vnf); module onion(r, ang=45, cap_h, d, anchor=CENTER, spin=0, orient=UP) { r = get_radius(r=r, d=d, dflt=1); xyprofile = teardrop2d(r=r, ang=ang, cap_h=cap_h); tip_h = max(column(xyprofile,1)); _cap_h = min(default(cap_h,tip_h), tip_h); anchors = [ ["cap", [0,0,_cap_h], UP, 0], ["tip", [0,0,tip_h], UP, 0] ]; attachable(anchor,spin,orient, r=r, anchors=anchors) { rotate_extrude(convexity=2) { difference() { polygon(xyprofile); square_BOSL2([2*r,2*max(_cap_h,r)+1], anchor=RIGHT); } } children(); } } function onion(r, ang=45, cap_h, d, anchor=CENTER, spin=0, orient=UP) = let( r = get_radius(r=r, d=d, dflt=1), xyprofile = right_half(p=teardrop2d(r=r, ang=ang, cap_h=cap_h))[0], profile = xrot(90, p=path3d(xyprofile)), tip_h = max(column(xyprofile,1)), _cap_h = min(default(cap_h,tip_h), tip_h), anchors = [ ["cap", [0,0,_cap_h], UP, 0], ["tip", [0,0,tip_h], UP, 0] ], sides = segs(r), step = 360 / sides, vnf = vnf_vertex_array( points=[for (a = [0:step:360-EPSILON]) zrot(a, p=profile)], caps=false, col_wrap=true, row_wrap=true, reverse=true ) ) reorient(anchor,spin,orient, r=r, anchors=anchors, p=vnf); module text3d(text, h=1, size=10, font="Helvetica", halign, valign, spacing=1.0, direction="ltr", language="em", script="latin", anchor="baseline[-1,0,-1]", spin=0, orient=UP) { no_children($children); dummy1 = assert(is_undef(anchor) || is_vector(anchor) || is_string(anchor), str("Got: ",anchor)) assert(is_undef(spin)   || is_vector(spin,3) || is_num(spin), str("Got: ",spin)) assert(is_undef(orient) || is_vector(orient,3), str("Got: ",orient)); anchor = default(anchor, CENTER); spin =   default(spin,   0); orient = default(orient, UP); geom = _attach_geom(size=[size,size,h]); anch = !any([for (c=anchor) c=="["])? anchor : let( parts = str_split(str_split(str_split(anchor,"]")[0],"[")[1],","), vec = [for (p=parts) parse_float(str_strip(p," ",start=true))] ) vec; ha = anchor=="baseline"? "left" : anchor==anch && is_string(anchor)? "center" : anch.x<0? "left" : anch.x>0? "right" : "center"; va = starts_with(anchor,"baseline")? "baseline" : anchor==anch && is_string(anchor)? "center" : anch.y<0? "bottom" : anch.y>0? "top" : "center"; base = anchor=="baseline"? CENTER : anchor==anch && is_string(anchor)? CENTER : anch.z<0? BOTTOM : anch.z>0? TOP : CENTER; m = _attach_transform(base,spin,orient,geom); multmatrix(m) { $parent_anchor = anchor; $parent_spin   = spin; $parent_orient = orient; $parent_geom   = geom; $parent_size   = _attach_geom_size(geom); $attach_to   = undef; do_show = _attachment_is_shown($tags); if (do_show) { _color($color) { linear_extrude(height=h, center=true) _text( text=text, size=size, font=font, halign=ha, valign=va, spacing=spacing, direction=direction, language=language, script=script ); } } } } function _cut_interp(pathcut, path, data) = [for(entry=pathcut) let( a = path[entry[1]-1], b = path[entry[1]], c = entry[0], i = max_index(v_abs(b-a)), factor = (c[i]-a[i])/(b[i]-a[i]) ) (1-factor)*data[entry[1]-1]+ factor * data[entry[1]] ]; module path_text(path, text, font, size, thickness, lettersize, offset=0, reverse=false, normal, top, center=false, textmetrics=false) { dummy2=assert(is_path(path,[2,3]),"Must supply a 2d or 3d path") assert(num_defined([normal,top])<=1, "Cannot define both \"normal\" and \"top\""); dim = len(path[0]); normalok = is_undef(normal) || is_vector(normal,3) || (is_path(normal,3) && len(normal)==len(path)); topok = is_undef(top) || is_vector(top,dim) || (dim==2 && is_vector(top,3) && top[2]==0) || (is_path(top,dim) && len(top)==len(path)); dummy4 = assert(dim==3 || is_undef(thickness), "Cannot give a thickness with 2d path") assert(dim==3 || !reverse, "Reverse not allowed with 2d path") assert(dim==3 || offset==0, "Cannot give offset with 2d path") assert(dim==3 || is_undef(normal), "Cannot define \"normal\" for a 2d path, only \"top\"") assert(normalok,"\"normal\" must be a vector or path compatible with the given path") assert(topok,"\"top\" must be a vector or path compatible with the given path"); thickness = first_defined([thickness,1]); normal = is_vector(normal) ? repeat(normal, len(path)) : is_def(normal) ? normal : undef; top = is_vector(top) ? repeat(dim==2?point2d(top):top, len(path)) : is_def(top) ? top : undef; lsize = is_def(lettersize) ? force_list(lettersize, len(text)) : textmetrics ? [for(letter=text) let(t=textmetrics(letter, font=font, size=size)) t.advance[0]] : assert(false, "textmetrics disabled: Must specify letter size"); textlength = sum(lsize); dummy1 = assert(textlength<=path_length(path),"Path is too short for the text"); start = center ? (path_length(path) - textlength)/2 : 0; pts = _path_cut_points(path, add_scalar([0, each cumsum(lsize)],start+lsize[0]/2), direction=true); usernorm = is_def(normal); usetop = is_def(top); normpts = is_undef(normal) ? (reverse?1:-1)*column(pts,3) : _cut_interp(pts,path, normal); toppts = is_undef(top) ? undef : _cut_interp(pts,path,top); for(i=idx(text)) let( tangent = pts[i][2] ) assert(!usetop || !approx(tangent*toppts[i],norm(top[i])*norm(tangent)), str("Specified top direction parallel to path at character ",i)) assert(usetop || !approx(tangent*normpts[i],norm(normpts[i])*norm(tangent)), str("Specified normal direction parallel to path at character ",i)) let( adjustment = usetop ?  (tangent*toppts[i])*toppts[i]/(toppts[i]*toppts[i]) : usernorm ?  (tangent*normpts[i])*normpts[i]/(normpts[i]*normpts[i]) : [0,0,0] ) move(pts[i][0]) if(dim==3){ frame_map(x=tangent-adjustment, z=usetop ? undef : normpts[i], y=usetop ? toppts[i] : undef) up(offset-thickness/2) linear_extrude(height=thickness) left(lsize[0]/2)text(text[i], font=font, size=size); } else { frame_map(x=point3d(tangent-adjustment), y=point3d(usetop ? toppts[i] : -normpts[i])) left(lsize[0]/2)text(text[i], font=font, size=size); } } module interior_fillet(l=1.0, r, ang=90, overlap=0.01, d, anchor=FRONT+LEFT, spin=0, orient=UP) { r = get_radius(r=r, d=d, dflt=1); dy = r/tan(ang/2); steps = ceil(segs(r)*ang/360); step = ang/steps; attachable(anchor,spin,orient, size=[r,r,l]) { if (l > 0) { linear_extrude(height=l, convexity=4, center=true) { path = concat( [[0,0]], [for (i=[0:1:steps]) let(a=270-i*step) r*[cos(a),sin(a)]+[dy,r]] ); translate(-[r,r]/2) polygon(path); } } children(); } } module heightfield(data, size=[100,100], bottom=-20, maxz=100, xrange=[-1:0.04:1], yrange=[-1:0.04:1], style="default", convexity=10, anchor=CENTER, spin=0, orient=UP) { size = is_num(size)? [size,size] : point2d(size); vnf = heightfield(data=data, size=size, xrange=xrange, yrange=yrange, bottom=bottom, maxz=maxz, style=style); attachable(anchor,spin,orient, vnf=vnf) { vnf_polyhedron(vnf, convexity=convexity); children(); } } function heightfield(data, size=[100,100], bottom=-20, maxz=100, xrange=[-1:0.04:1], yrange=[-1:0.04:1], style="default", anchor=CENTER, spin=0, orient=UP) = assert(is_list(data) || is_function(data)) let( size = is_num(size)? [size,size] : point2d(size), xvals = is_list(data) ? [for (i=idx(data[0])) i] : assert(is_list(xrange)||is_range(xrange)) [for (x=xrange) x], yvals = is_list(data) ? [for (i=idx(data)) i] : assert(is_list(yrange)||is_range(yrange)) [for (y=yrange) y], xcnt = len(xvals), minx = min(xvals), maxx = max(xvals), ycnt = len(yvals), miny = min(yvals), maxy = max(yvals), verts = is_list(data) ? [ for (y = [0:1:ycnt-1]) [ for (x = [0:1:xcnt-1]) [ size.x * (x/(xcnt-1)-0.5), size.y * (y/(ycnt-1)-0.5), data[y][x] ] ] ] : [ for (y = yrange) [ for (x = xrange) let( z = data(x,y) ) [ size.x * ((x-minx)/(maxx-minx)-0.5), size.y * ((y-miny)/(maxy-miny)-0.5), min(maxz, max(bottom+0.1, default(z,0))) ] ] ], vnf = vnf_join([ vnf_vertex_array(verts, style=style, reverse=true), vnf_vertex_array([ verts[0], [for (v=verts[0]) [v.x, v.y, bottom]], ]), vnf_vertex_array([ [for (v=verts[ycnt-1]) [v.x, v.y, bottom]], verts[ycnt-1], ]), vnf_vertex_array([ [for (r=verts) let(v=r[0]) [v.x, v.y, bottom]], [for (r=verts) let(v=r[0]) v], ]), vnf_vertex_array([ [for (r=verts) let(v=r[xcnt-1]) v], [for (r=verts) let(v=r[xcnt-1]) [v.x, v.y, bottom]], ]), vnf_vertex_array([ [ for (v=verts[0]) [v.x, v.y, bottom], for (r=verts) let(v=r[xcnt-1]) [v.x, v.y, bottom], ], [ for (r=verts) let(v=r[0]) [v.x, v.y, bottom], for (v=verts[ycnt-1]) [v.x, v.y, bottom], ] ]) ]) ) reorient(anchor,spin,orient, vnf=vnf, p=vnf); module ruler(length=100, width, thickness=1, depth=3, labels=false, pipscale=1/3, maxscale, colors=["black","white"], alpha=1.0, unit=1, inch=false, anchor=LEFT+BACK+TOP, spin=0, orient=UP) { inchfactor = 25.4; assert(depth<=5, "Cannot render scales smaller than depth=5"); assert(len(colors)==2, "colors must contain a list of exactly two colors."); length = inch ? inchfactor * length : length; unit = inch ? inchfactor*unit : unit; maxscale = is_def(maxscale)? maxscale : floor(log(length/unit-EPSILON)); scales = unit * [for(logsize = [maxscale:-1:maxscale-depth+1]) pow(10,logsize)]; widthfactor = (1-pipscale) / (1-pow(pipscale,depth)); width = default(width, scales[0]); widths = width * widthfactor * [for(logsize = [0:-1:-depth+1]) pow(pipscale,-logsize)]; offsets = concat([0],cumsum(widths)); attachable(anchor,spin,orient, size=[length,width,thickness]) { translate([-length/2, -width/2, 0]) for(i=[0:1:len(scales)-1]) { count = ceil(length/scales[i]); fontsize = 0.5*min(widths[i], scales[i]/ceil(log(count*scales[i]/unit))); back(offsets[i]) { xcopies(scales[i], n=count, sp=[0,0,0]) union() { actlen = ($idx<count-1) || approx(length%scales[i],0) ? scales[i] : length % scales[i]; color(colors[$idx%2], alpha=alpha) { w = i>0 ? quantup(widths[i],1/1024) : widths[i]; cube_BOSL2([quantup(actlen,1/1024),quantup(w,1/1024),thickness], anchor=FRONT+LEFT); } mark = i == 0 && $idx % 10 == 0 && $idx != 0 ? 0 : i == 0 && $idx % 10 == 9 && $idx != count-1 ? 1 : $idx % 10 == 4 ? 1 : $idx % 10 == 5 ? 0 : -1; flip = 1-mark*2; if (mark >= 0) { marklength = min(widths[i]/2, scales[i]*2); markwidth = marklength*0.4; translate([mark*scales[i], widths[i], 0]) { color(colors[1-$idx%2], alpha=alpha) { linear_extrude(height=thickness+scales[i]/100, convexity=2, center=true) { polygon(scale([flip*markwidth, marklength],p=[[0,0], [1, -1], [0,-0.9]])); } } } } if (labels && scales[i]/unit+EPSILON >= 1) { color(colors[($idx+1)%2], alpha=alpha) { linear_extrude(height=thickness+scales[i]/100, convexity=2, center=true) { back(scales[i]*.02) { text(text=str( $idx * scales[i] / unit), size=fontsize, halign="left", valign="baseline"); } } } } } } } children(); } }function approx(a,b,eps=EPSILON) = a == b? is_bool(a) == is_bool(b) : is_num(a) && is_num(b)? abs(a-b) <= eps : is_list(a) && is_list(b) && len(a) == len(b)? ( [] == [ for (i=idx(a)) let(aa=a[i], bb=b[i]) if( is_num(aa) && is_num(bb)? abs(aa-bb) > eps : !approx(aa,bb,eps=eps) ) 1 ] ) : false; function all_zero(x, eps=EPSILON) = is_finite(x)? abs(x)<eps : is_vector(x) && [for (xx=x) if(abs(xx)>eps) 1] == []; function all_nonzero(x, eps=EPSILON) = is_finite(x)? abs(x)>eps : is_vector(x) && [for (xx=x) if(abs(xx)<eps) 1] == []; function all_positive(x,eps=0) = is_num(x)? x>eps : is_vector(x) && [for (xx=x) if(xx<=0) 1] == []; function all_negative(x, eps=0) = is_num(x)? x<-eps : is_vector(x) && [for (xx=x) if(xx>=-eps) 1] == []; function all_nonpositive(x,eps=0) = is_num(x)? x<=eps : is_vector(x) && [for (xx=x) if(xx>eps) 1] == []; function all_nonnegative(x,eps=0) = is_num(x)? x>=-eps : is_vector(x) && [for (xx=x) if(xx<-eps) 1] == []; function all_equal(vec,eps=0) = eps==0 ? [for(v=vec) if (v!=vec[0]) v] == [] : [for(v=vec) if (!approx(v,vec[0],eps)) v] == []; function is_increasing(list,strict=false) = assert(is_list(list)||is_string(list)) strict ? len([for (p=pair(list)) if(p.x>=p.y) true])==0 : len([for (p=pair(list)) if(p.x>p.y) true])==0; function is_decreasing(list,strict=false) = assert(is_list(list)||is_string(list)) strict ? len([for (p=pair(list)) if(p.x<=p.y) true])==0 : len([for (p=pair(list)) if(p.x<p.y) true])==0; function _type_num(x) = is_undef(x)?  0 : is_bool(x)?   1 : is_num(x)?    2 : is_nan(x)?    3 : is_string(x)? 4 : is_list(x)?   5 : 6; function compare_vals(a, b) = (a==b)? 0 : let(t1=_type_num(a), t2=_type_num(b)) (t1!=t2)? (t1-t2) : is_list(a)? compare_lists(a,b) : is_nan(a)? 0 : (a<b)? -1 : (a>b)? 1 : 0; function compare_lists(a, b) = a==b? 0 : let( cmps = [ for (i = [0:1:min(len(a),len(b))-1]) let( cmp = compare_vals(a[i],b[i]) ) if (cmp!=0) cmp ] ) cmps==[]? (len(a)-len(b)) : cmps[0]; function min_index(vals, all=false) = assert( is_vector(vals) && len(vals)>0 , "Invalid or empty list of numbers.") all ? search(min(vals),vals,0) : search(min(vals), vals)[0]; function max_index(vals, all=false) = assert( is_vector(vals) && len(vals)>0 , "Invalid or empty list of numbers.") all ? search(max(vals),vals,0) : search(max(vals), vals)[0]; function find_approx(val, list, start=0, all=false, eps=EPSILON) = all ? [for (i=[start:1:len(list)-1]) if (approx(val, list[i], eps=eps)) i] :  __find_approx(val, list, eps=eps, i=start); function __find_approx(val, list, eps, i=0) = i >= len(list)? undef : approx(val, list[i], eps=eps) ? i : __find_approx(val, list, eps=eps, i=i+1); function deduplicate(list, closed=false, eps=EPSILON) = assert(is_list(list)||is_string(list)) let( l = len(list), end = l-(closed?0:1) ) is_string(list) ? str_join([for (i=[0:1:l-1]) if (i==end || list[i] != list[(i+1)%l]) list[i]]) : eps==0 ? [for (i=[0:1:l-1]) if (i==end || list[i] != list[(i+1)%l]) list[i]] : [for (i=[0:1:l-1]) if (i==end || !approx(list[i], list[(i+1)%l], eps)) list[i]]; function deduplicate_indexed(list, indices, closed=false, eps=EPSILON) = assert(is_list(list)||is_string(list), "Improper list or string.") indices==[]? [] : assert(is_vector(indices), "Indices must be a list of numbers.") let( ll = len(list), l = len(indices), end = l-(closed?0:1) ) [ for (i = [0:1:l-1]) let( idx1 = indices[i], idx2 = indices[(i+1)%l], a = assert(idx1>=0,"Bad index.") assert(idx1<len(list),"Bad index in indices.") list[idx1], b = assert(idx2>=0,"Bad index.") assert(idx2<len(list),"Bad index in indices.") list[idx2], eq = (a == b)? true : (a*0 != b*0) || (eps==0)? false : is_num(a) || is_vector(a) ? approx(a, b, eps=eps) : false ) if (i==end || !eq) indices[i] ]; function unique(list) = assert(is_list(list)||is_string(list), "Invalid input." ) is_string(list)? str_join(unique([for (x = list) x])) : len(list)<=1? list : is_homogeneous(list,1) && ! is_list(list[0]) ?   _unique_sort(list) :   let( sorted = sort(list)) [ for (i=[0:1:len(sorted)-1]) if (i==0 || (sorted[i] != sorted[i-1])) sorted[i] ]; function _unique_sort(l) = len(l) <= 1 ? l : let( pivot   = l[floor(len(l)/2)], equal   = [ for(li=l) if( li==pivot) li ], lesser  = [ for(li=l) if( li<pivot ) li ], greater = [ for(li=l) if( li>pivot) li ] ) concat( _unique_sort(lesser), equal[0], _unique_sort(greater) ); function unique_count(list) = assert(is_list(list) || is_string(list), "Invalid input." ) list == [] ? [[],[]] : is_homogeneous(list,1) && ! is_list(list[0]) ?    let( sorted = _group_sort(list) ) [ [for(s=sorted) s[0] ], [for(s=sorted) len(s) ] ] :   let( list = sort(list), ind = [0, for(i=[1:1:len(list)-1]) if (list[i]!=list[i-1]) i] ) [ select(list,ind), deltas( concat(ind,[len(list)]) ) ]; function _valid_idx(idx,imin,imax) = is_undef(idx) || ( is_finite(idx) && ( is_undef(imin) || idx>=imin ) && ( is_undef(imax) || idx< imax ) ) || ( is_list(idx) && ( is_undef(imin) || min(idx)>=imin ) && ( is_undef(imax) || max(idx)< imax ) ) || ( is_range(idx) && ( is_undef(imin) || (idx[1]>0 && idx[0]>=imin ) || (idx[1]<0 && idx[0]<=imax ) ) && ( is_undef(imax) || (idx[1]>0 && idx[2]<=imax ) || (idx[1]<0 && idx[2]>=imin ) ) ); function _group_sort_by_index(l,idx) = len(l) == 0 ? [] : len(l) == 1 ? [l] : let( pivot   = l[floor(len(l)/2)][idx], equal   = [ for(li=l) if( li[idx]==pivot) li ], lesser  = [ for(li=l) if( li[idx]< pivot) li ], greater = [ for(li=l) if( li[idx]> pivot) li ] ) concat( _group_sort_by_index(lesser,idx), [equal], _group_sort_by_index(greater,idx) ); function _group_sort(l) = len(l) == 0 ? [] : len(l) == 1 ? [l] : let( pivot   = l[floor(len(l)/2)], equal   = [ for(li=l) if( li==pivot) li ], lesser  = [ for(li=l) if( li< pivot) li ], greater = [ for(li=l) if( li> pivot) li ] ) concat( _group_sort(lesser), [equal], _group_sort(greater) ); function _sort_scalars(arr) = len(arr)<=1 ? arr : let( pivot   = arr[floor(len(arr)/2)], lesser  = [ for (y = arr) if (y  < pivot) y ], equal   = [ for (y = arr) if (y == pivot) y ], greater = [ for (y = arr) if (y  > pivot) y ] ) concat( _sort_scalars(lesser), equal, _sort_scalars(greater) ); function _sort_vectors(arr, _i=0) = len(arr)<=1 || _i>=len(arr[0]) ? arr : let( pivot   = arr[floor(len(arr)/2)][_i], lesser  = [ for (entry=arr) if (entry[_i]  < pivot ) entry ], equal   = [ for (entry=arr) if (entry[_i] == pivot ) entry ], greater = [ for (entry=arr) if (entry[_i]  > pivot ) entry ] ) concat( _sort_vectors(lesser,  _i   ), _sort_vectors(equal,   _i+1 ), _sort_vectors(greater, _i ) ); function _sort_vectors(arr, idxlist, _i=0) = len(arr)<=1 || ( is_list(idxlist) && _i>=len(idxlist) ) || _i>=len(arr[0])  ? arr : let( k = is_list(idxlist) ? idxlist[_i] : _i, pivot   = arr[floor(len(arr)/2)][k], lesser  = [ for (entry=arr) if (entry[k]  < pivot ) entry ], equal   = [ for (entry=arr) if (entry[k] == pivot ) entry ], greater = [ for (entry=arr) if (entry[k]  > pivot ) entry ] ) concat( _sort_vectors(lesser,  idxlist, _i  ), _sort_vectors(equal,   idxlist, _i+1), _sort_vectors(greater, idxlist, _i  ) ); function _sort_general(arr, idx=undef, indexed=false) = (len(arr)<=1) ? arr : ! indexed && is_undef(idx) ? _lexical_sort(arr) : let( labeled = is_undef(idx) ? [for(i=idx(arr)) [i,arr[i]]] : [for(i=idx(arr)) [i, for(j=idx) arr[i][j]]], arrind = _indexed_sort(labeled)) indexed ? arrind : [for(i=arrind) arr[i]]; function _lexical_sort(arr) = len(arr)<=1? arr : let( pivot = arr[floor(len(arr)/2)] ) let( lesser  = [ for (entry=arr) if (compare_vals(entry, pivot) <0 ) entry ], equal   = [ for (entry=arr) if (compare_vals(entry, pivot)==0 ) entry ], greater = [ for (entry=arr) if (compare_vals(entry, pivot) >0 ) entry ] ) concat(_lexical_sort(lesser), equal, _lexical_sort(greater)); function _indexed_sort(arrind) = arrind==[] ? [] : len(arrind)==1? [arrind[0][0]] : let( pivot = arrind[floor(len(arrind)/2)][1] ) let( lesser  = [ for (entry=arrind) if (compare_vals(entry[1], pivot) <0 ) entry ], equal   = [ for (entry=arrind) if (compare_vals(entry[1], pivot)==0 ) entry[0] ], greater = [ for (entry=arrind) if (compare_vals(entry[1], pivot) >0 ) entry ] ) concat(_indexed_sort(lesser), equal, _indexed_sort(greater)); function sort(list, idx=undef) = assert(is_list(list)||is_string(list), "Invalid input." ) is_string(list)? str_join(sort([for (x = list) x],idx)) : !is_list(list) || len(list)<=1 ? list : is_homogeneous(list,1) ?   let(size = list_shape(list[0])) size==0 ?         _sort_scalars(list) : len(size)!=1 ?  _sort_general(list,idx) : is_undef(idx) ? _sort_vectors(list) : assert( _valid_idx(idx) , "Invalid indices.") _sort_vectors(list,[for(i=idx) i]) : _sort_general(list,idx); function sortidx(list, idx=undef) = assert(is_list(list)||is_string(list), "Invalid input." ) !is_list(list) || len(list)<=1 ? list : is_homogeneous(list,1) ?   let( size = list_shape(list[0]), aug  = ! (size==0 || len(size)==1) ? 0 : [for(i=[0:len(list)-1]) concat(i,list[i])], lidx = size==0? [1] : len(size)==1 ? is_undef(idx) ? [for(i=[0:len(list[0])-1]) i+1] : [for(i=idx) i+1] : 0 ) assert( ! ( size==0 && is_def(idx) ), "The specification of `idx` is incompatible with scalar sorting." ) assert( _valid_idx(idx) , "Invalid indices." ) lidx!=0 ?   let( lsort = _sort_vectors(aug,lidx) ) [for(li=lsort) li[0] ] :   _sort_general(list,idx,indexed=true) : _sort_general(list,idx,indexed=true); function group_sort(list, idx) = assert(is_list(list), "Input should be a list." ) assert(is_undef(idx) || (is_finite(idx) && idx>=0) , "Invalid index." ) len(list)<=1 ? [list] : is_vector(list)? _group_sort(list) : let( idx = is_undef(idx) ? 0 : idx ) assert( [for(entry=list) if(!is_list(entry) || len(entry)<idx || !is_num(entry[idx]) ) 1]==[], "Some entry of the list is a list shorter than `idx` or the indexed entry of it is not a number.") _group_sort_by_index(list,idx); function group_data(groups, values) = assert(all_integer(groups) && all_nonnegative(groups)) assert(is_list(values)) assert(len(groups)==len(values), "The groups and values arguments should be lists of matching length.") let( sorted = _group_sort_by_index([for(i=idx(groups))[groups[i],values[i]]],0) ) [ for (i = idx(sorted)) let( a  = i==0? 0 : sorted[i-1][0][0]+1, g0 = sorted[i] ) each [ for (j = [a:1:g0[0][0]-1]) [], [for (g1 = g0) g1[1]] ] ]; function list_smallest(list, k) = assert(is_list(list)) assert(is_finite(k) && k>=0, "k must be nonnegative") let( v       = list[rand_int(0,len(list)-1,1)[0]], smaller = [for(li=list) if(li<v) li ], equal   = [for(li=list) if(li==v) li ] ) len(smaller)   == k ? smaller : len(smaller)<k && len(smaller)+len(equal) >= k ? [ each smaller, for(i=[1:k-len(smaller)]) v ] : len(smaller)   >  k ? list_smallest(smaller, k) : let( bigger  = [for(li=list) if(li>v) li ] ) concat(smaller, equal, list_smallest(bigger, k-len(smaller) -len(equal)));function typeof(x) = is_undef(x)? "undef" : is_bool(x)? "boolean" : is_num(x)? "number" : is_nan(x)? "nan" : is_string(x)? "string" : is_list(x)? "list" : is_range(x) ? "range" : version_num()>20210000 && is_function(x) ? "function" : "invalid"; function is_type(x,types) = is_list(types)? in_list(typeof(x),types) : is_string(types)? typeof(x) == types : assert(is_list(types)||is_string(types)); function is_def(x) = !is_undef(x); function is_str(x) = is_string(x); function is_int(n) = is_finite(n) && n == round(n); function is_integer(n) = is_finite(n) && n == round(n); function is_nan(x) = (x!=x); function is_finite(x) = is_num(x) && !is_nan(0*x); function is_range(x) = !is_list(x) && is_finite(x[0]) && is_finite(x[1]) && is_finite(x[2]) ; function valid_range(x) = is_range(x) && ( x[1]>0 ? x[0]<=x[2] : ( x[1]<0 && x[0]>=x[2] ) ); function is_func(x) = version_num()>20210000 && is_function(x); function is_consistent(list, pattern) = is_list(list) && (len(list)==0 || (let(pattern = is_undef(pattern) ? _list_pattern(list[0]): _list_pattern(pattern) ) []==[for(entry=0*list) if (entry != pattern) entry])); function _list_pattern(list) = is_list(list) ? [for(entry=list) is_list(entry) ? _list_pattern(entry) : 0] : 0; function same_shape(a,b) = is_def(b) && _list_pattern(a) == b*0; function is_bool_list(list, length) = is_list(list) && (is_undef(length) || len(list)==length) && []==[for(entry=list) if (!is_bool(entry)) 1]; function default(v,dflt=undef) = is_undef(v)? dflt : v; function first_defined(v,recursive=false,_i=0) = _i<len(v) && ( is_undef(v[_i]) || ( recursive && is_list(v[_i]) && is_undef(first_defined(v[_i],recursive=recursive)) ) )? first_defined(v,recursive=recursive,_i=_i+1) : v[_i]; function one_defined(vals, names, dflt=_UNDEF) = let( checkargs = is_list(names)? assert(len(vals) == len(names)) : is_string(names)? let( name_cnt = len([for (c=names) if (c==",") 1]) + 1 ) assert(len(vals) == name_cnt) : assert(is_list(names) || is_string(names)) 0, ok = num_defined(vals)==1 || (dflt!=_UNDEF && num_defined(vals)==0) ) ok? default(first_defined(vals), dflt) : let( names = is_string(names) ? str_split(names,",") : names, defd = [for (i=idx(vals)) if (is_def(vals[i])) names[i]], msg = str( "Must define ", dflt==_UNDEF? "exactly" : "at most", " one of ", num_defined(vals) == 0 ? names : defd ) ) assert(ok,msg); function num_defined(v) = len([for(vi=v) if(!is_undef(vi)) 1]); function any_defined(v,recursive=false) = first_defined(v,recursive=recursive) != undef; function all_defined(v,recursive=false) = []==[for (x=v) if(is_undef(x)||(recursive && is_list(x) && !all_defined(x,recursive))) 0 ]; function get_anchor(anchor,center,uncentered=BOT,dflt=CENTER) = !is_undef(center)? (center? CENTER : uncentered) : !is_undef(anchor)? anchor : dflt; function get_radius(r1, r2, r, d1, d2, d, dflt) = assert(num_defined([r1,d1,r2,d2])<2, "Conflicting or redundant radius/diameter arguments given.") assert(num_defined([r,d])<2, "Conflicting or redundant radius/diameter arguments given.") let( rad = !is_undef(r1) ?  r1 : !is_undef(d1) ?  d1/2 : !is_undef(r2) ?  r2 : !is_undef(d2) ?  d2/2 : !is_undef(r)  ?  r : !is_undef(d)  ?  d/2 : dflt ) assert(is_undef(dflt) || is_finite(rad) || is_vector(rad), "Invalid radius." ) rad; function scalar_vec3(v, dflt) = is_undef(v)? undef : is_list(v)? [for (i=[0:2]) default(v[i], default(dflt, 0))] : !is_undef(dflt)? [v,dflt,dflt] : [v,v,v]; function segs(r) = $fn>0? ($fn>3? $fn : 3) : let( r = is_finite(r)? r : 0 ) ceil(max(5, min(360/$fa, abs(r)*2*PI/$fs))); module no_children(count) { assert($children==0, "Module no_children() does not support child modules"); if ($parent_modules>0) { assert(count==0, str("Module ",parent_module(1),"() does not support child modules")); } } function no_function(name) = assert(false,str("You called ",name,"() as a function, but it is available only as a module")); module no_module() { assert(false, str("You called ",parent_module(1),"() as a module but it is available only as a function")); } function _valstr(x) = is_string(x)? str("\"",str_replace_char(x, "\"", "\\\""),"\"") : is_list(x)? str("[",str_join([for (xx=x) _valstr(xx)],","),"]") : is_num(x) && x==floor(x)? format_int(x) : is_finite(x)? format_float(x,12) : x; module assert_approx(got, expected, info) { no_children($children); if (!approx(got, expected)) { echo(); echo(str("EXPECT: ", _valstr(expected))); echo(str("GOT   : ", _valstr(got))); if (same_shape(got, expected)) { echo(str("DELTA : ", _valstr(got - expected))); } if (is_def(info)) { echo(str("INFO  : ", _valstr(info))); } assert(approx(got, expected)); } } module assert_equal(got, expected, info) { no_children($children); if (got != expected || (is_nan(got) && is_nan(expected))) { echo(); echo(str("EXPECT: ", _valstr(expected))); echo(str("GOT   : ", _valstr(got))); if (same_shape(got, expected)) { echo(str("DELTA : ", _valstr(got - expected))); } if (is_def(info)) { echo(str("INFO  : ", _valstr(info))); } assert(got == expected); } } module shape_compare(eps=1/1024) { union() { difference() { children(0); if (eps==0) { children(1); } else { minkowski() { children(1); spheroid(r=eps, style="octa"); } } } difference() { children(1); if (eps==0) { children(0); } else { minkowski() { children(0); spheroid(r=eps, style="octa"); } } } } } function looping(state) = state < 2; function loop_while(state, continue) = state > 0 ? 2 : continue ? 0 : 1; function loop_done(state) = state > 0;function is_vector(v, length, zero, all_nonzero=false, eps=EPSILON) = is_list(v) && len(v)>0 && []==[for(vi=v) if(!is_num(vi)) 0] && (is_undef(length) || len(v)==length) && (is_undef(zero) || ((norm(v) >= eps) == !zero)) && (!all_nonzero || all_nonzero(v)) ; function add_scalar(v,s) = assert(is_vector(v), "Input v must be a vector") assert(is_finite(s), "Input s must be a finite scalar") [for(entry=v) entry+s]; function v_mul(v1, v2) = assert( is_list(v1) && is_list(v2) && len(v1)==len(v2), "Incompatible input") [for (i = [0:1:len(v1)-1]) v1[i]*v2[i]]; function v_div(v1, v2) = assert( is_vector(v1) && is_vector(v2,len(v1)), "Incompatible vectors") [for (i = [0:1:len(v1)-1]) v1[i]/v2[i]]; function v_abs(v) = assert( is_vector(v), "Invalid vector" ) [for (x=v) abs(x)]; function v_floor(v) = assert( is_vector(v), "Invalid vector" ) [for (x=v) floor(x)]; function v_ceil(v) = assert( is_vector(v), "Invalid vector" ) [for (x=v) ceil(x)]; function v_lookup(x, v) = is_num(v[0][1])? lookup(x,v) : let( i = lookup(x, [for (i=idx(v)) [v[i].x,i]]), vlo = v[floor(i)], vhi = v[ceil(i)], lo = vlo[1], hi = vhi[1] ) assert(is_vector(lo) && is_vector(hi), "Result values must all be numbers, or all be vectors.") assert(len(lo) == len(hi), "Vector result values must be the same length") vlo.x == vhi.x? vlo[1] : let( u = (x - vlo.x) / (vhi.x - vlo.x) ) lerp(lo,hi,u); function unit(v, error=[[["ASSERT"]]]) = assert(is_vector(v), "Invalid vector") norm(v)<EPSILON? (error==[[["ASSERT"]]]? assert(norm(v)>=EPSILON,"Cannot normalize a zero vector") : error) : v/norm(v); function v_theta(v) = assert( is_vector(v,2) || is_vector(v,3) , "Invalid vector") atan2(v.y,v.x); function vector_angle(v1,v2,v3) = assert( ( is_undef(v3) && ( is_undef(v2) || same_shape(v1,v2) ) ) || is_consistent([v1,v2,v3]) , "Bad arguments.") assert( is_vector(v1) || is_consistent(v1), "Bad arguments.") let( vecs = ! is_undef(v3) ? [v1-v2,v3-v2] : ! is_undef(v2) ? [v1,v2] : len(v1) == 3   ? [v1[0]-v1[1], v1[2]-v1[1]] : v1 ) assert(is_vector(vecs[0],2) || is_vector(vecs[0],3), "Bad arguments.") let( norm0 = norm(vecs[0]), norm1 = norm(vecs[1]) ) assert(norm0>0 && norm1>0, "Zero length vector.") acos(constrain((vecs[0]*vecs[1])/(norm0*norm1), -1, 1)); function vector_axis(v1,v2=undef,v3=undef) = is_vector(v3) ?   assert(is_consistent([v3,v2,v1]), "Bad arguments.") vector_axis(v1-v2, v3-v2) :   assert( is_undef(v3), "Bad arguments.") is_undef(v2) ?   assert( is_list(v1), "Bad arguments.") len(v1) == 2 ?   vector_axis(v1[0],v1[1]) :   vector_axis(v1[0],v1[1],v1[2]) :   assert( is_vector(v1,zero=false) && is_vector(v2,zero=false) && is_consistent([v1,v2]) , "Bad arguments.") let( eps = 1e-6, w1 = point3d(v1/norm(v1)), w2 = point3d(v2/norm(v2)), w3 = (norm(w1-w2) > eps && norm(w1+w2) > eps) ? w2 : (norm(v_abs(w2)-UP) > eps)? UP : RIGHT ) unit(cross(w1,w3)); function pointlist_bounds(pts) = assert(is_path(pts,dim=undef,fast=true) , "Invalid pointlist." ) let( select = ident(len(pts[0])), spread = [ for(i=[0:len(pts[0])-1]) let( spreadi = pts*select[i] ) [ min(spreadi), max(spreadi) ] ] ) transpose(spread); function closest_point(pt, points) = assert( is_vector(pt), "Invalid point." ) assert(is_path(points,dim=len(pt)), "Invalid pointlist or incompatible dimensions." ) min_index([for (p=points) norm(p-pt)]); function furthest_point(pt, points) = assert( is_vector(pt), "Invalid point." ) assert(is_path(points,dim=len(pt)), "Invalid pointlist or incompatible dimensions." ) max_index([for (p=points) norm(p-pt)]); function vector_search(query, r, target) = query==[] ? [] : is_list(query) && target==[] ? is_vector(query) ? [] : [for(q=query) [] ] : assert( is_finite(r) && r>=0, "The query radius should be a positive number." ) let( tgpts  = is_matrix(target), tgtree = is_list(target) && (len(target)==2) && is_matrix(target[0]) && is_list(target[1]) && (len(target[1])==4 || (len(target[1])==1 && is_list(target[1][0])) ) ) assert( tgpts || tgtree, "The target should be a list of points or a search tree compatible with the query." ) let( dim    = tgpts ? len(target[0]) : len(target[0][0]), simple = is_vector(query, dim) ) assert( simple || is_matrix(query,undef,dim), "The query points should be a list of points compatible with the target point list.") tgpts ?   len(target)<=400 ?   simple ? [for(i=idx(target)) if(norm(target[i]-query)<r) i ] : [for(q=query) [for(i=idx(target)) if(norm(target[i]-q)<r) i ] ] :   let( tree = _bt_tree(target, count(len(target)), leafsize=25) ) simple ? _bt_search(query, r, target, tree) : [for(q=query) _bt_search(q, r, target, tree)] :   simple ?  _bt_search(query, r, target[0], target[1]) : [for(q=query) _bt_search(q, r, target[0], target[1])]; function _bt_search(query, r, points, tree) = assert( is_list(tree) && (   ( len(tree)==1 && is_list(tree[0]) ) || ( len(tree)==4 && is_num(tree[0]) && is_num(tree[1]) ) ), "The tree is invalid.") len(tree)==1 ?   assert( tree[0]==[] || is_vector(tree[0]), "The tree is invalid." ) [for(i=tree[0]) if(norm(points[i]-query)<=r) i ] :   norm(query-points[tree[0]]) > r+tree[1] ? [] : concat( [ if(norm(query-points[tree[0]])<=r) tree[0] ], _bt_search(query, r, points, tree[2]), _bt_search(query, r, points, tree[3]) ) ; function vector_search_tree(points, leafsize=25, treemin=400) = points==[] ? [] : assert( is_matrix(points), "The input list entries should be points." ) assert( is_int(leafsize) && leafsize>=1, "The tree leaf size should be an integer greater than zero.") len(points)<treemin ? points : [ points, _bt_tree(points, count(len(points)), leafsize) ]; function _bt_tree(points, ind, leafsize=25) = len(ind)<=leafsize ? [ind] : let( bounds = pointlist_bounds(select(points,ind)), coord  = max_index(bounds[1]-bounds[0]), projc  = [for(i=ind) points[i][coord] ], meanpr = mean(projc), pivot  = min_index([for(p=projc) abs(p-meanpr)]), radius = max([for(i=ind) norm(points[ind[pivot]]-points[i]) ]), Lind   = [for(i=idx(ind)) if(projc[i]<=meanpr && i!=pivot) ind[i] ], Rind   = [for(i=idx(ind)) if(projc[i] >meanpr && i!=pivot) ind[i] ] ) [ ind[pivot], radius, _bt_tree(points, Lind, leafsize), _bt_tree(points, Rind, leafsize) ]; function vector_nearest(query, k, target) = assert(is_int(k) && k>0) assert(is_vector(query), "Query must be a vector.") let( tgpts  = is_matrix(target,undef,len(query)), tgtree = is_list(target) && (len(target)==2) && is_matrix(target[0],undef,len(query)) && (len(target[1])==4 || (len(target[1])==1 && is_list(target[1][0])) ) ) assert( tgpts || tgtree, "The target should be a list of points or a search tree compatible with the query." ) assert((tgpts && (k<=len(target))) || (tgtree && (k<=len(target[0]))), "More results are requested than the number of points.") tgpts ?   let( tree = _bt_tree(target, count(len(target))) ) column(_bt_nearest( query, k, target,  tree),0) :   column(_bt_nearest( query, k, target[0], target[1]),0); function _bt_nearest(p, k, points, tree, answers=[]) = assert( is_list(tree) && (   ( len(tree)==1 && is_list(tree[0]) ) || ( len(tree)==4 && is_num(tree[0]) && is_num(tree[1]) ) ), "The tree is invalid.") len(tree)==1 ?   _insert_many(answers, k, [for(entry=tree[0]) [entry, norm(points[entry]-p)]]) :   let( d = norm(p-points[tree[0]]) ) len(answers)==k && ( d > last(answers)[1]+tree[1] ) ? answers : let( answers1 = _insert_sorted(answers, k, [tree[0],d]), answers2 = _bt_nearest(p, k, points, tree[2], answers1), answers3 = _bt_nearest(p, k, points, tree[3], answers2) ) answers3; function _insert_sorted(list, k, new) = (len(list)==k && new[1]>= last(list)[1]) ? list : [ for(entry=list) if (entry[1]<=new[1]) entry, new, for(i=[0:1:min(k-1,len(list))-1]) if (list[i][1]>new[1]) list[i] ]; function _insert_many(list, k, newlist,i=0) = i==len(newlist) ? list : assert(is_vector(newlist[i],2), "The tree is invalid.") _insert_many(_insert_sorted(list,k,newlist[i]),k,newlist,i+1);function point2d(p, fill=0) = assert(is_list(p)) [for (i=[0:1]) (p[i]==undef)? fill : p[i]]; function path2d(points) = assert(is_path(points,dim=undef,fast=true),"Input to path2d is not a path") let (result = points * concat(ident(2), repeat([0,0], len(points[0])-2))) assert(is_def(result), "Invalid input to path2d") result; function point3d(p, fill=0) = assert(is_list(p)) [for (i=[0:2]) (p[i]==undef)? fill : p[i]]; function path3d(points, fill=0) = assert(is_num(fill)) assert(is_path(points, dim=undef, fast=true), "Input to path3d is not a path") let ( change = len(points[0])-3, M = change < 0? [[1,0,0],[0,1,0]] : concat(ident(3), repeat([0,0,0],change)), result = points*M ) assert(is_def(result), "Input to path3d is invalid") fill == 0 || change>=0 ? result : result + repeat([0,0,fill], len(result)); function point4d(p, fill=0) = assert(is_list(p)) [for (i=[0:3]) (p[i]==undef)? fill : p[i]]; function path4d(points, fill=0) = assert(is_num(fill) || is_vector(fill)) assert(is_path(points, dim=undef, fast=true), "Input to path4d is not a path") let ( change = len(points[0])-4, M = change < 0 ? select(ident(4), 0, len(points[0])-1) : concat(ident(4), repeat([0,0,0,0],change)), result = points*M ) assert(is_def(result), "Input to path4d is invalid") fill == 0 || change >= 0 ? result : let( addition = is_list(fill) ? concat(0*points[0],fill) : concat(0*points[0],repeat(fill,-change)) ) assert(len(addition) == 4, "Fill is the wrong length") result + repeat(addition, len(result)); function polar_to_xy(r,theta=undef) = let( rad = theta==undef? r[0] : r, t = theta==undef? r[1] : theta ) rad*[cos(t), sin(t)]; function xy_to_polar(x,y=undef) = let( xx = y==undef? x[0] : x, yy = y==undef? x[1] : y ) [norm([xx,yy]), atan2(yy,xx)]; function project_plane(plane,p) = is_matrix(plane,3,3) && is_undef(p) ? assert(!is_collinear(plane),"Points defining the plane must not be collinear") let( v = plane[2]-plane[0], y = unit(plane[1]-plane[0]), x = unit(v-(v*y)*y) ) frame_map(x,y) * move(-plane[0]) : is_vector(plane,4) && is_undef(p) ? assert(_valid_plane(plane), "Plane is not valid") let( n = point3d(plane), cp = n * plane[3] / (n*n) ) rot(from=n, to=UP) * move(-cp) : is_path(plane,3) && is_undef(p) ? assert(len(plane)>=3, "Need three points to define a plane") let(plane = plane_from_points(plane)) assert(is_def(plane), "Point list is not coplanar") project_plane(plane) : assert(is_def(p), str("Invalid plane specification: ",plane)) is_vnf(p) ? [project_plane(plane,p[0]), p[1]] : is_list(p) && is_list(p[0]) && is_vector(p[0][0],3) ? [for(plist=p) project_plane(plane,plist)] : assert(is_vector(p,3) || is_path(p,3),str("Data must be a 3d point, path, region, vnf or bezier patch",p)) is_matrix(plane,3,3) ? assert(!is_collinear(plane),"Points defining the plane must not be collinear") let( v = plane[2]-plane[0], y = unit(plane[1]-plane[0]), x = unit(v-(v*y)*y) ) move(-plane[0],p) * transpose([x,y]) : is_vector(p) ? point2d(apply(project_plane(plane),p)) : path2d(apply(project_plane(plane),p)); function lift_plane(plane, p) = is_matrix(plane,3,3) && is_undef(p) ? let( v = plane[2]-plane[0], y = unit(plane[1]-plane[0]), x = unit(v-(v*y)*y) ) move(plane[0]) * frame_map(x,y,reverse=true) : is_vector(plane,4) && is_undef(p) ? assert(_valid_plane(plane), "Plane is not valid") let( n = point3d(plane), cp = n * plane[3] / (n*n) ) move(cp) * rot(from=UP, to=n) : is_path(plane,3) && is_undef(p) ? assert(len(plane)>=3, "Need three p to define a plane") let(plane = plane_from_points(plane)) assert(is_def(plane), "Point list is not coplanar") lift_plane(plane) : is_vnf(p) ? [lift_plane(plane,p[0]), p[1]] : is_list(p) && is_list(p[0]) && is_vector(p[0][0],3) ? [for(plist=p) lift_plane(plane,plist)] : assert(is_vector(p,2) || is_path(p,2),"Data must be a 2d point, path, region, vnf or bezier patch") is_matrix(plane,3,3) ? let( v = plane[2]-plane[0], y = unit(plane[1]-plane[0]), x = unit(v-(v*y)*y) ) move(plane[0],p * [x,y]) : apply(lift_plane(plane),is_vector(p) ? point3d(p) : path3d(p)); function cylindrical_to_xyz(r,theta=undef,z=undef) = let( rad = theta==undef? r[0] : r, t = theta==undef? r[1] : theta, zed = theta==undef? r[2] : z ) [rad*cos(t), rad*sin(t), zed]; function xyz_to_cylindrical(x,y=undef,z=undef) = let( p = is_num(x)? [x, default(y,0), default(z,0)] : point3d(x) ) [norm([p.x,p.y]), atan2(p.y,p.x), p.z]; function spherical_to_xyz(r,theta=undef,phi=undef) = let( rad = theta==undef? r[0] : r, t = theta==undef? r[1] : theta, p = theta==undef? r[2] : phi ) rad*[sin(p)*cos(t), sin(p)*sin(t), cos(p)]; function xyz_to_spherical(x,y=undef,z=undef) = let( p = is_num(x)? [x, default(y,0), default(z,0)] : point3d(x) ) [norm(p), atan2(p.y,p.x), atan2(norm([p.x,p.y]),p.z)]; function altaz_to_xyz(alt,az=undef,r=undef) = let( p = az==undef? alt[0] : alt, t = 90 - (az==undef? alt[1] : az), rad = az==undef? alt[2] : r ) rad*[cos(p)*cos(t), cos(p)*sin(t), sin(p)]; function xyz_to_altaz(x,y=undef,z=undef) = let( p = is_num(x)? [x, default(y,0), default(z,0)] : point3d(x) ) [atan2(p.z,norm([p.x,p.y])), atan2(p.x,p.y), norm(p)];function is_homogeneous(l, depth=10) = !is_list(l) || l==[] ? false : let( l0=l[0] ) [] == [for(i=[1:1:len(l)-1]) if( ! _same_type(l[i],l0, depth+1) )  0 ]; function is_homogenous(l, depth=10) = is_homogeneous(l, depth); function _same_type(a,b, depth) = (depth==0) || (is_undef(a) && is_undef(b)) || (is_bool(a) && is_bool(b)) || (is_num(a) && is_num(b)) || (is_string(a) && is_string(b)) || (is_list(a) && is_list(b) && len(a)==len(b) && []==[for(i=idx(a)) if( ! _same_type(a[i],b[i],depth-1) ) 0] ); function min_length(list) = assert(is_list(list), "Invalid input." ) min([for (v = list) len(v)]); function max_length(list) = assert(is_list(list), "Invalid input." ) max([for (v = list) len(v)]); function _list_shape_recurse(v) = !is_list(v[0]) ?   len( [for(entry=v) if(!is_list(entry)) 0] ) == 0 ? [] : [undef] :   let( firstlen = is_list(v[0]) ? len(v[0]): undef, first = len( [for(entry = v) if(! is_list(entry) || (len(entry) != firstlen)) 0  ]   ) == 0 ? firstlen : undef, leveldown = flatten(v) ) is_list(leveldown[0]) ?  concat([first],_list_shape_recurse(leveldown)) : [first]; function _list_shape_recurse(v) = let( alen = [for(vi=v) is_list(vi) ? len(vi): -1] ) v==[] || max(alen)==-1 ? [] : let( add = max(alen)!=min(alen) ? undef : alen[0] ) concat( add, _list_shape_recurse(flatten(v))); function list_shape(v, depth=undef) = assert( is_undef(depth) || ( is_finite(depth) && depth>=0 ), "Invalid depth.") ! is_list(v) ? 0 : (depth == undef) ?   concat([len(v)], _list_shape_recurse(v)) :   (depth == 0) ?  len(v) :  let( dimlist = _list_shape_recurse(v)) (depth > len(dimlist))? 0 : dimlist[depth-1] ; function in_list(val,list,idx) = assert(is_list(list),"Input is not a list") assert(is_undef(idx) || is_finite(idx), "Invalid idx value.") let( firsthit = search([val], list, num_returns_per_match=1, index_col_num=idx)[0] ) firsthit==[] ? false : is_undef(idx) && val==list[firsthit] ? true : is_def(idx) && val==list[firsthit][idx] ? true : let ( allhits = search([val], list, 0, idx)[0]) is_undef(idx) ? [for(hit=allhits) if (list[hit]==val) 1] != [] : [for(hit=allhits) if (list[hit][idx]==val) 1] != []; function select(list, start, end) = assert( is_list(list) || is_string(list), "Invalid list.") let(l=len(list)) l==0 ? [] : end==undef ? is_num(start) ? list[ (start%l+l)%l ] : assert( start==[] || is_vector(start) || is_range(start), "Invalid start parameter") [for (i=start) list[ (i%l+l)%l ] ] : assert(is_finite(start), "When `end` is given, `start` parameter should be a number.") assert(is_finite(end), "Invalid end parameter.") let( s = (start%l+l)%l, e = (end%l+l)%l ) (s <= e) ? [ for (i = [s:1:e])   list[i] ] : [ for (i = [s:1:l-1]) list[i], for (i = [0:1:e])   list[i] ] ; function slice(list,s=0,e=-1) = assert(is_list(list)) assert(is_int(s)) assert(is_int(e)) !list? [] : let( l = len(list), s = constrain(s + (s<0? l : 0), 0, l-1), e = constrain(e + (e<0? l : 0), 0, l-1) ) [if (e>=s) for (i=[s:1:e]) list[i]]; function last(list) = list[len(list)-1]; function list_head(list, to=-2) = assert(is_list(list)) assert(is_finite(to)) to<0? [for (i=[0:1:len(list)+to]) list[i]] : to<len(list)? [for (i=[0:1:to]) list[i]] : list; function list_tail(list, from=1) = assert(is_list(list)) assert(is_finite(from)) from>=0? [for (i=[from:1:len(list)-1]) list[i]] : let(from = from + len(list)) from>=0? [for (i=[from:1:len(list)-1]) list[i]] : list; function bselect(list,index) = assert(is_list(list)||is_string(list), "Improper list." ) assert(is_list(index) && len(index)>=len(list) , "Improper index list." ) is_string(list)? str_join(bselect( [for (x=list) x], index)) : [for(i=[0:len(list)-1]) if (index[i]) list[i]]; function repeat(val, n, i=0) = is_num(n)? [for(j=[1:1:n]) val] : assert( is_list(n), "Invalid count number.") (i>=len(n))? val : [for (j=[1:1:n[i]]) repeat(val, n, i+1)]; function count(n,s=0,step=1,reverse=false) = let(n=is_list(n) ? len(n) : n) reverse? [for (i=[n-1:-1:0]) s+i*step] : [for (i=[0:1:n-1]) s+i*step]; function list_bset(indexset, valuelist, dflt=0) = assert(is_list(indexset), "The index set is not a list." ) assert(is_list(valuelist), "The `valuelist` is not a list." ) let( trueind = search([true], indexset,0)[0] ) assert( !(len(trueind)>len(valuelist)), str("List `valuelist` too short; its length should be ",len(trueind)) ) assert( !(len(trueind)<len(valuelist)), str("List `valuelist` too long; its length should be ",len(trueind)) ) concat( list_set([],trueind, valuelist, dflt=dflt), repeat(dflt,len(indexset)-max(trueind)-1) ); function list(l) = is_list(l)? l : [for (x=l) x]; function force_list(value, n=1, fill) = is_list(value) ? value : is_undef(fill)? [for (i=[1:1:n]) value] : [value, for (i=[2:1:n]) fill]; function reverse(x) = assert(is_list(x)||is_string(x), str("Input to reverse must be a list or string. Got: ",x)) let (elems = [ for (i = [len(x)-1 : -1 : 0]) x[i] ]) is_string(x)? str_join(elems) : elems; function list_rotate(list,n=1) = assert(is_list(list)||is_string(list), "Invalid list or string.") assert(is_int(n), "The rotation number should be integer") let ( ll = len(list), n = ((n % ll) + ll) % ll, elems = [ for (i=[n:1:ll-1]) list[i], for (i=[0:1:n-1]) list[i] ] ) is_string(list)? str_join(elems) : elems; function shuffle(list,seed) = assert(is_list(list)||is_string(list), "Invalid input." ) is_string(list)? str_join(shuffle([for (x = list) x],seed=seed)) : len(list)<=1 ? list : let( rval = is_num(seed) ? rands(0,1,len(list),seed_value=seed) : rands(0,1,len(list)), left  = [for (i=[0:len(list)-1]) if (rval[i]< 0.5) list[i]], right = [for (i=[0:len(list)-1]) if (rval[i]>=0.5) list[i]] ) concat(shuffle(left), shuffle(right)); function repeat_entries(list, N, exact=true) = assert(is_list(list) && len(list)>0, "The list cannot be void.") assert((is_finite(N) && N>0) || is_vector(N,len(list)), "Parameter N must be a number greater than zero or vector with the same length of `list`") let( length = len(list), reps_guess = is_list(N)? N : repeat(N/length,length), reps = exact ? _sum_preserving_round(reps_guess) : [for (val=reps_guess) round(val)] ) [for(i=[0:length-1]) each repeat(list[i],reps[i])]; function list_pad(list, minlen, fill) = assert(is_list(list), "Invalid input." ) concat(list,repeat(fill,minlen-len(list))); function list_set(list=[],indices,values,dflt=0,minlen=0) = assert(is_list(list)) !is_list(indices)? ( (is_finite(indices) && indices<len(list)) ? concat([for (i=idx(list)) i==indices? values : list[i]], repeat(dflt, minlen-len(list))) : list_set(list,[indices],[values],dflt) ) : indices==[] && values==[] ? concat(list, repeat(dflt, minlen-len(list))) : assert(is_vector(indices) && is_list(values) && len(values)==len(indices), "Index list and value list must have the same length") let( midx = max(len(list)-1, max(indices)) ) [ for (i=[0:1:midx]) let( j = search(i,indices,0), k = j[0] ) assert( len(j)<2, "Repeated indices are not allowed." ) k!=undef ? values[k] : i<len(list) ? list[i] : dflt, each repeat(dflt, minlen-max(len(list),max(indices))) ]; function list_insert(list, indices, values) = assert(is_list(list)) !is_list(indices) ? assert( is_finite(indices) && is_finite(values), "Invalid indices/values." ) assert( indices<=len(list), "Indices must be <= len(list) ." ) [ for (i=idx(list)) each ( i==indices?  [ values, list[i] ] : [ list[i] ] ), if (indices==len(list)) values ] : indices==[] && values==[] ? list : assert( is_vector(indices) && is_list(values) && len(values)==len(indices), "Index list and value list must have the same length") assert( max(indices)<=len(list), "Indices must be <= len(list)." ) let( maxidx = max(indices), minidx = min(indices) ) [ for (i=[0:1:minidx-1] ) list[i], for (i=[minidx : min(maxidx, len(list)-1)] ) let( j = search(i,indices,0), k = j[0], x = assert( len(j)<2, "Repeated indices are not allowed." ) ) each ( k != undef  ? [ values[k], list[i] ] : [ list[i] ] ), for ( i = [min(maxidx, len(list)-1)+1 : 1 : len(list)-1] ) list[i], if (maxidx == len(list)) values[max_index(indices)] ]; function list_remove(list, ind) = assert(is_list(list), "Invalid list in list_remove") is_finite(ind) ? ( (ind<0 || ind>=len(list)) ? list : [ for (i=[0:1:ind-1]) list[i], for (i=[ind+1:1:len(list)-1]) list[i] ] ) :   ind==[] ? list :   assert( is_vector(ind), "Invalid index list in list_remove") let(sres = search(count(list),ind,1)) [ for(i=idx(list)) if (sres[i] == []) list[i] ]; function list_remove_values(list,values=[],all=false) = !is_list(values)? list_remove_values(list, values=[values], all=all) : assert(is_list(list), "Invalid list") len(values)==0 ? list : len(values)==1 ? ( !all ? ( let(firsthit = search(values,list,1)[0]) firsthit==[] ? list : list[firsthit]==values[0] ? list_remove(list,firsthit) : let(allhits = search(values,list,0)[0], allind = [for(i=allhits) if (list[i]==values[0]) i] ) allind==[] ? list : list_remove(list,min(allind)) ) : ( let(allhits = search(values,list,0)[0], allind = [for(i=allhits) if (list[i]==values[0]) i] ) allind==[] ? list : list_remove(list,allind) ) ) :!all ? list_remove_values(list_remove_values(list, values[0],all=all), list_tail(values),all=all) : [ for(i=idx(list)) let(hit=search([list[i]],values,0)[0]) if (hit==[]) list[i] else let(check = [for(j=hit) if (values[j]==list[i]) 1]) if (check==[]) list[i] ]; function idx(list, s=0, e=-1, step=1) = assert(is_list(list)||is_string(list), "Invalid input." ) let( ll = len(list) ) ll == 0 ? [0:1:ll-1] : let( _s = posmod(s,ll), _e = posmod(e,ll) ) [_s : step : _e]; function pair(list, wrap=false) = assert(is_list(list)||is_string(list), "Invalid input." ) assert(is_bool(wrap)) let( L = len(list)-1) L<1 ? [] : [ for (i=[0:1:L-1]) [list[i], list[i+1]], if(wrap) [list[L], list[0]] ]; function triplet(list, wrap=false) = assert(is_list(list)||is_string(list), "Invalid input." ) assert(is_bool(wrap)) let(L=len(list)) L<3 ? [] : [ if(wrap) [list[L-1], list[0], list[1]], for (i=[0:1:L-3]) [list[i],list[i+1],list[i+2]], if(wrap) [list[L-2], list[L-1], list[0]] ]; function combinations(l,n=2,_s=0) = assert(is_list(l), "Invalid list." ) assert( is_finite(n) && n>=1 && n<=len(l), "Invalid number `n`." ) n==1 ? [for (i=[_s:1:len(l)-1]) [l[i]]] : [for (i=[_s:1:len(l)-n], p=combinations(l,n=n-1,_s=i+1)) concat([l[i]], p)]; function permutations(l,n=2) = assert(is_list(l), "Invalid list." ) assert( is_finite(n) && n>=1 && n<=len(l), "Invalid number `n`." ) n==1 ? [for (i=[0:1:len(l)-1]) [l[i]]] : [for (i=idx(l), p=permutations([for (j=idx(l)) if (i!=j) l[j]], n=n-1)) concat([l[i]], p)]; function list_to_matrix(v, cnt, dflt=undef) = [for (i = [0:cnt:len(v)-1]) [for (j = [0:1:cnt-1]) default(v[i+j], dflt)]]; function flatten(l) = !is_list(l)? l : [for (a=l) if (is_list(a)) (each a) else a]; function full_flatten(l) = !is_list(l)? l : [for (a=l) if (is_list(a)) (each full_flatten(a)) else a]; function set_union(a, b, get_indices=false) = assert( is_list(a) && is_list(b), "Invalid sets." ) let( found1 = search(b, a), found2 = search(b, b), c = [ for (i=idx(b)) if (found1[i] == [] && found2[i] == i) b[i] ], nset = concat(a, c) ) ! get_indices ? nset : let( la = len(a), found3 = search(b, c), idxs =  [ for (i=idx(b)) (found1[i] != [])? found1[i] : la + found3[i] ] ) [idxs, nset]; function set_difference(a, b) = assert( is_list(a) && is_list(b), "Invalid sets." ) let( found = search(a, b, num_returns_per_match=1) ) [ for (i=idx(a)) if(found[i]==[]) a[i] ]; function set_intersection(a, b) = assert( is_list(a) && is_list(b), "Invalid sets." ) let( found = search(a, b, num_returns_per_match=1) ) [ for (i=idx(a)) if(found[i]!=[]) a[i] ];function is_matrix(A,m,n,square=false) = is_list(A) && (( is_undef(m) && len(A) ) || len(A)==m) && (!square || len(A) == len(A[0])) && is_vector(A[0],n) && is_consistent(A); function is_matrix_symmetric(A,eps=1e-12) = approx(A,transpose(A), eps); function is_rotation(A,dim,centered=false) = let(n=len(A)) is_matrix(A,square=true) && ( n==3 || n==4 && (is_undef(dim) || dim==n-1)) && ( let( rotpart =  [for(i=[0:n-2]) [for(j=[0:n-2]) A[j][i]]] ) approx(determinant(rotpart),1) ) && (!centered || [for(row=[0:n-2]) if (!approx(A[row][n-1],0)) row]==[]); function echo_matrix(M,description,sig=4,sep=1,eps=1e-9) = let( horiz_line = chr(8213), matstr = _format_matrix(M,sig=sig,sep=sep,eps=eps), separator = str_join(repeat(horiz_line,10)), dummy=echo(str(separator,is_def(description) ? str("  ",description) : "")) [for(row=matstr) echo(row)] ) echo(separator); module echo_matrix(M,description,sig=4,sep=1,eps=1e-9) { dummy = echo_matrix(M,description,sig,sep,eps); } function column(M, i) = assert( is_list(M), "The input is not a list." ) assert( is_int(i) && i>=0, "Invalid index") [for(row=M) row[i]]; function submatrix(M,idx1,idx2) = [for(i=idx1) [for(j=idx2) M[i][j] ] ]; function ident(n) = [ for (i = [0:1:n-1]) [ for (j = [0:1:n-1]) (i==j)? 1 : 0 ] ]; function diagonal_matrix(diag, offdiag=0) = assert(is_list(diag) && len(diag)>0) [for(i=[0:1:len(diag)-1]) [for(j=[0:len(diag)-1]) i==j?diag[i] : offdiag]]; function transpose(M, reverse=false) = assert( is_list(M) && len(M)>0, "Input to transpose must be a nonempty list.") is_list(M[0]) ?   let( len0 = len(M[0]) ) assert([for(a=M) if(!is_list(a) || len(a)!=len0) 1 ]==[], "Input to transpose has inconsistent row lengths." ) reverse ? [for (i=[0:1:len0-1]) [ for (j=[0:1:len(M)-1]) M[len(M)-1-j][len0-1-i] ] ] : [for (i=[0:1:len0-1]) [ for (j=[0:1:len(M)-1]) M[j][i] ] ] :  assert( is_vector(M), "Input to transpose must be a vector or list of lists.") M; function outer_product(u,v) = assert(is_vector(u) && is_vector(v), "The inputs must be vectors.") [for(ui=u) ui*v]; function submatrix_set(M,A,m=0,n=0) = assert(is_list(M)) assert(is_list(A)) assert(is_int(m)) assert(is_int(n)) let( badrows = [for(i=idx(A)) if (!is_list(A[i])) i]) assert(badrows==[], str("Input submatrix malformed rows: ",badrows)) [for(i=[0:1:len(M)-1]) assert(is_list(M[i]), str("Row ",i," of input matrix is not a list")) [for(j=[0:1:len(M[i])-1]) i>=m && i <len(A)+m && j>=n && j<len(A[0])+n ? A[i-m][j-n] : M[i][j]]]; function hstack(M1, M2, M3) = (M3!=undef)? hstack([M1,M2,M3]) : (M2!=undef)? hstack([M1,M2]) : assert(all([for(v=M1) is_list(v)]), "One of the inputs to hstack is not a list") let( minlen = min_length(M1), maxlen = max_length(M1) ) assert(minlen==maxlen, "Input vectors to hstack must have the same length") [for(row=[0:1:minlen-1]) [for(matrix=M1) each matrix[row] ] ]; function block_matrix(M) = let( bigM = [for(bigrow = M) each hstack(bigrow)], len0 = len(bigM[0]), badrows = [for(row=bigM) if (len(row)!=len0) 1] ) assert(badrows==[], "Inconsistent or invalid input") bigM; function linear_solve(A,b,pivot=true) = assert(is_matrix(A), "Input should be a matrix.") let( m = len(A), n = len(A[0]) ) assert(is_vector(b,m) || is_matrix(b,m),"Invalid right hand side or incompatible with the matrix") let ( qr = m<n? qr_factor(transpose(A),pivot) : qr_factor(A,pivot), maxdim = max(n,m), mindim = min(n,m), Q = submatrix(qr[0],[0:maxdim-1], [0:mindim-1]), R = submatrix(qr[1],[0:mindim-1], [0:mindim-1]), P = qr[2], zeros = [for(i=[0:mindim-1]) if (approx(R[i][i],0)) i] ) zeros != [] ? [] : m<n ? Q*back_substitute(R,transpose(P)*b,transpose=true) : P*_back_substitute(R, transpose(Q)*b); function linear_solve3(A,b) = assert(b*0==[0,0,0], "Input b must be a 3-vector") assert(A*0==[[0,0,0],[0,0,0],[0,0,0]],"Input A must be a 3x3 matrix") let( Az = [for(i=[0:2])[A[i][0], A[i][1], b[i]]], Ay = [for(i=[0:2])[A[i][0], b[i], A[i][2]]], Ax = [for(i=[0:2])[b[i], A[i][1], A[i][2]]], detA = det3(A) ) detA==0 ? undef : [det3(Ax), det3(Ay), det3(Az)] / detA; function matrix_inverse(A) = assert(is_matrix(A) && len(A)==len(A[0]),"Input to matrix_inverse() must be a square matrix") linear_solve(A,ident(len(A))); function rot_inverse(T) = assert(is_matrix(T,square=true),"Matrix must be square") let( n = len(T)) assert(n==3 || n==4, "Matrix must be 3x3 or 4x4") let( rotpart =  [for(i=[0:n-2]) [for(j=[0:n-2]) T[j][i]]], transpart = [for(row=[0:n-2]) T[row][n-1]] ) assert(approx(determinant(T),1),"Matrix is not a rotation") concat(hstack(rotpart, -rotpart*transpart),[[for(i=[2:n]) 0, 1]]); function null_space(A,eps=1e-12) = assert(is_matrix(A)) let( Q_R = qr_factor(transpose(A),pivot=true), R = Q_R[1], zrows = [for(i=idx(R)) if (all_zero(R[i],eps)) i] ) len(zrows)==0 ? [] : select(transpose(Q_R[0]), zrows); function qr_factor(A, pivot=false) = assert(is_matrix(A), "Input must be a matrix." ) let( m = len(A), n = len(A[0]) ) let( qr = _qr_factor(A, Q=ident(m),P=ident(n), pivot=pivot, col=0, m = m, n = n), Rzero = let( R = qr[1]) [ for(i=[0:m-1]) [ let( ri = R[i] ) for(j=[0:n-1]) i>j ? 0 : ri[j] ] ] ) [qr[0], Rzero, qr[2]]; function _qr_factor(A,Q,P, pivot, col, m, n) = col >= min(m-1,n) ? [Q,A,P] : let( swap = !pivot ? 1 : _swap_matrix(n,col,col+max_index([for(i=[col:n-1]) sqr([for(j=[col:m-1]) A[j][i]])])), A = pivot ? A*swap : A, x = [for(i=[col:1:m-1]) A[i][col]], alpha = (x[0]<=0 ? 1 : -1) * norm(x), u = x - concat([alpha],repeat(0,m-1)), v = alpha==0 ? u : u / norm(u), Qc = ident(len(x)) - 2*outer_product(v,v), Qf = [for(i=[0:m-1]) [for(j=[0:m-1]) i<col || j<col ? (i==j ? 1 : 0) : Qc[i-col][j-col]]] ) _qr_factor(Qf*A, Q*Qf, P*swap, pivot, col+1, m, n); function _swap_matrix(n,i,j) = assert(i<n && j<n && i>=0 && j>=0, "Swap indices out of bounds") [for(y=[0:n-1]) [for (x=[0:n-1]) x==i ? (y==j ? 1 : 0) : x==j ? (y==i ? 1 : 0) : x==y ? 1 : 0]]; function back_substitute(R, b, transpose = false) = assert(is_matrix(R, square=true)) let(n=len(R)) assert(is_vector(b,n) || is_matrix(b,n),str("R and b are not compatible in back_substitute ",n, len(b))) transpose ? reverse(_back_substitute(transpose(R, reverse=true), reverse(b))) : _back_substitute(R,b); function _back_substitute(R, b, x=[]) = let(n=len(R)) len(x) == n ? x : let(ind = n - len(x) - 1) R[ind][ind] == 0 ? [] : let( newvalue = len(x)==0 ? b[ind]/R[ind][ind] : (b[ind]-list_tail(R[ind],ind+1) * x)/R[ind][ind] ) _back_substitute(R, b, concat([newvalue],x)); function cholesky(A) = assert(is_matrix(A,square=true),"A must be a square matrix") assert(is_matrix_symmetric(A),"Cholesky factorization requires a symmetric matrix") _cholesky(A,ident(len(A)), len(A)); function _cholesky(A,L,n) = A[0][0]<0 ? undef : len(A) == 1 ? submatrix_set(L,[[sqrt(A[0][0])]], n-1,n-1): let( i = n+1-len(A) ) let( sqrtAii = sqrt(A[0][0]), Lnext = [for(j=[0:n-1]) [for(k=[0:n-1]) j<i-1 || k<i-1 ?  (j==k ? 1 : 0) : j==i-1 && k==i-1 ? sqrtAii : j==i-1 ? 0 : k==i-1 ? A[j-(i-1)][0]/sqrtAii : j==k ? 1 : 0]], Anext = submatrix(A,[1:n-1], [1:n-1]) - outer_product(list_tail(A[0]), list_tail(A[0]))/A[0][0] ) _cholesky(Anext,L*Lnext,n); function det2(M) = assert(is_def(M) && M*0==[[0,0],[0,0]], "Expected square matrix (2x2)") cross(M[0],M[1]); function det3(M) = assert(is_def(M) && M*0==[[0,0,0],[0,0,0],[0,0,0]], "Expected square matrix (3x3).") M[0][0] * (M[1][1]*M[2][2]-M[2][1]*M[1][2]) - M[1][0] * (M[0][1]*M[2][2]-M[2][1]*M[0][2]) + M[2][0] * (M[0][1]*M[1][2]-M[1][1]*M[0][2]); function det4(M) = assert(is_def(M) && M*0==[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], "Expected square matrix (4x4).") M[0][0]*M[1][1]*M[2][2]*M[3][3] + M[0][0]*M[1][2]*M[2][3]*M[3][1] + M[0][0]*M[1][3]*M[2][1]*M[3][2] + M[0][1]*M[1][0]*M[2][3]*M[3][2] + M[0][1]*M[1][2]*M[2][0]*M[3][3] + M[0][1]*M[1][3]*M[2][2]*M[3][0] + M[0][2]*M[1][0]*M[2][1]*M[3][3] + M[0][2]*M[1][1]*M[2][3]*M[3][0] + M[0][2]*M[1][3]*M[2][0]*M[3][1] + M[0][3]*M[1][0]*M[2][2]*M[3][1] + M[0][3]*M[1][1]*M[2][0]*M[3][2] + M[0][3]*M[1][2]*M[2][1]*M[3][0] - M[0][0]*M[1][1]*M[2][3]*M[3][2] - M[0][0]*M[1][2]*M[2][1]*M[3][3] - M[0][0]*M[1][3]*M[2][2]*M[3][1] - M[0][1]*M[1][0]*M[2][2]*M[3][3] - M[0][1]*M[1][2]*M[2][3]*M[3][0] - M[0][1]*M[1][3]*M[2][0]*M[3][2] - M[0][2]*M[1][0]*M[2][3]*M[3][1] - M[0][2]*M[1][1]*M[2][0]*M[3][3] - M[0][2]*M[1][3]*M[2][1]*M[3][0] - M[0][3]*M[1][0]*M[2][1]*M[3][2] - M[0][3]*M[1][1]*M[2][2]*M[3][0] - M[0][3]*M[1][2]*M[2][0]*M[3][1]; function determinant(M) = assert(is_list(M), "Input must be a square matrix." ) len(M)==1? M[0][0] : len(M)==2? det2(M) : len(M)==3? det3(M) : len(M)==4? det4(M) : assert(is_matrix(M, square=true), "Input must be a square matrix." ) sum( [for (col=[0:1:len(M)-1]) ((col%2==0)? 1 : -1) * M[col][0] * determinant( [for (r=[1:1:len(M)-1]) [for (c=[0:1:len(M)-1]) if (c!=col) M[c][r] ] ] ) ] ); function norm_fro(A) = assert(is_matrix(A) || is_vector(A)) norm(flatten(A)); function matrix_trace(M) = assert(is_matrix(M,square=true), "Input to trace must be a square matrix") [for(i=[0:1:len(M)-1])1] * [for(i=[0:1:len(M)-1]) M[i][i]];function affine2d_identity() = ident(3); function affine2d_translate(v=[0,0]) = assert(is_vector(v),2) [ [1, 0, v.x], [0, 1, v.y], [0 ,0,   1] ]; function affine2d_scale(v=[1,1]) = assert(is_vector(v,2)) [ [v.x,   0, 0], [  0, v.y, 0], [  0,   0, 1] ]; function affine2d_zrot(ang=0) = assert(is_finite(ang)) [ [cos(ang), -sin(ang), 0], [sin(ang),  cos(ang), 0], [       0,         0, 1] ]; function affine2d_mirror(v) = assert(is_vector(v,2)) let(v=unit(point2d(v)), a=v.x, b=v.y) [ [1-2*a*a, 0-2*a*b, 0], [0-2*a*b, 1-2*b*b, 0], [      0,       0, 1] ]; function affine2d_skew(xa=0, ya=0) = assert(is_finite(xa)) assert(is_finite(ya)) [ [1,       tan(xa), 0], [tan(ya), 1,       0], [0,       0,       1] ]; function affine3d_identity() = ident(4); function affine3d_translate(v=[0,0,0]) = assert(is_list(v)) let( v = [for (i=[0:2]) default(v[i],0)] ) [ [1, 0, 0, v.x], [0, 1, 0, v.y], [0, 0, 1, v.z], [0 ,0, 0,   1] ]; function affine3d_scale(v=[1,1,1]) = assert(is_list(v)) let( v = [for (i=[0:2]) default(v[i],1)] ) [ [v.x,   0,   0, 0], [  0, v.y,   0, 0], [  0,   0, v.z, 0], [  0,   0,   0, 1] ]; function affine3d_xrot(ang=0) = assert(is_finite(ang)) [ [1,        0,         0,   0], [0, cos(ang), -sin(ang),   0], [0, sin(ang),  cos(ang),   0], [0,        0,         0,   1] ]; function affine3d_yrot(ang=0) = assert(is_finite(ang)) [ [ cos(ang), 0, sin(ang),   0], [        0, 1,        0,   0], [-sin(ang), 0, cos(ang),   0], [        0, 0,        0,   1] ]; function affine3d_zrot(ang=0) = assert(is_finite(ang)) [ [cos(ang), -sin(ang), 0, 0], [sin(ang),  cos(ang), 0, 0], [       0,         0, 1, 0], [       0,         0, 0, 1] ]; function affine3d_rot_by_axis(u=UP, ang=0) = assert(is_finite(ang)) assert(is_vector(u,3)) approx(ang,0)? affine3d_identity() : let( u = unit(u), c = cos(ang), c2 = 1-c, s = sin(ang) ) [ [u.x*u.x*c2+c    , u.x*u.y*c2-u.z*s, u.x*u.z*c2+u.y*s, 0], [u.y*u.x*c2+u.z*s, u.y*u.y*c2+c    , u.y*u.z*c2-u.x*s, 0], [u.z*u.x*c2-u.y*s, u.z*u.y*c2+u.x*s, u.z*u.z*c2+c    , 0], [               0,                0,                0, 1] ]; function affine3d_rot_from_to(from, to) = assert(is_vector(from)) assert(is_vector(to)) assert(len(from)==len(to)) let( from = unit(point3d(from)), to = unit(point3d(to)) ) approx(from,to)? affine3d_identity() : from.z==0 && to.z==0 ?  affine3d_zrot(v_theta(point2d(to)) - v_theta(point2d(from))) : let( u = vector_axis(from,to), ang = vector_angle(from,to), c = cos(ang), c2 = 1-c, s = sin(ang) ) [ [u.x*u.x*c2+c    , u.x*u.y*c2-u.z*s, u.x*u.z*c2+u.y*s, 0], [u.y*u.x*c2+u.z*s, u.y*u.y*c2+c    , u.y*u.z*c2-u.x*s, 0], [u.z*u.x*c2-u.y*s, u.z*u.y*c2+u.x*s, u.z*u.z*c2+c    , 0], [               0,                0,                0, 1] ]; function affine3d_mirror(v) = assert(is_vector(v)) let( v=unit(point3d(v)), a=v.x, b=v.y, c=v.z ) [ [1-2*a*a,  -2*a*b,  -2*a*c, 0], [ -2*b*a, 1-2*b*b,  -2*b*c, 0], [ -2*c*a,  -2*c*b, 1-2*c*c, 0], [      0,       0,       0, 1] ]; function affine3d_skew(sxy=0, sxz=0, syx=0, syz=0, szx=0, szy=0) = [ [  1, sxy, sxz, 0], [syx,   1, syz, 0], [szx, szy,   1, 0], [  0,   0,   0, 1] ]; function affine3d_skew_xy(xa=0, ya=0) = assert(is_finite(xa)) assert(is_finite(ya)) [ [1, 0, tan(xa), 0], [0, 1, tan(ya), 0], [0, 0,       1, 0], [0, 0,       0, 1] ]; function affine3d_skew_xz(xa=0, za=0) = assert(is_finite(xa)) assert(is_finite(za)) [ [1, tan(xa), 0, 0], [0,       1, 0, 0], [0, tan(za), 1, 0], [0,       0, 0, 1] ]; function affine3d_skew_yz(ya=0, za=0) = assert(is_finite(ya)) assert(is_finite(za)) [ [      1, 0, 0, 0], [tan(ya), 1, 0, 0], [tan(za), 0, 1, 0], [      0, 0, 0, 1] ];function substr(str, pos=0, len=undef) = is_list(pos) ? _substr(str, pos[0], pos[1]-pos[0]+1) : len == undef ? _substr(str, pos, len(str)-pos) : _substr(str,pos,len); function _substr(str,pos,len,substr="") = len <= 0 || pos>=len(str) ? substr : _substr(str, pos+1, len-1, str(substr, str[pos])); function suffix(str,len) = len>=len(str)? str : substr(str, len(str)-len,len); function str_find(str,pattern,start=undef,last=false,all=false) = all? _str_find_all(str,pattern) : let( start = first_defined([start,last?len(str)-len(pattern):0]) ) pattern==""? start : last? _str_find_last(str,pattern,start) : _str_find_first(str,pattern,len(str)-len(pattern),start); function _str_find_first(str,pattern,max_sindex,sindex) = sindex<=max_sindex && !_str_cmp(str,sindex, pattern)? _str_find_first(str,pattern,max_sindex,sindex+1) : (sindex <= max_sindex ? sindex : undef); function _str_find_last(str,pattern,sindex) = sindex>=0 && !_str_cmp(str,sindex, pattern)? _str_find_last(str,pattern,sindex-1) : (sindex >=0 ? sindex : undef); function _str_find_all(str,pattern) = pattern == "" ? count(len(str)) : [for(i=[0:1:len(str)-len(pattern)]) if (_str_cmp(str,i,pattern)) i]; function _str_cmp(str,sindex,pattern) = len(str)-sindex <len(pattern)? false : _str_cmp_recurse(str,sindex,pattern,len(pattern)); function _str_cmp_recurse(str,sindex,pattern,plen,pindex=0,) = pindex < plen && pattern[pindex]==str[sindex] ? _str_cmp_recurse(str,sindex+1,pattern,plen,pindex+1): (pindex==plen); function starts_with(str,pattern) = _str_cmp(str,0,pattern); function ends_with(str,pattern) = _str_cmp(str,len(str)-len(pattern),pattern); function str_split(str,sep,keep_nulls=true) = !keep_nulls ? _remove_empty_strs(str_split(str,sep,keep_nulls=true)) : is_list(sep) ? _str_split_recurse(str,sep,i=0,result=[]) : let( cutpts = concat([-1],sort(flatten(search(sep, str,0))),[len(str)])) [for(i=[0:len(cutpts)-2]) substr(str,cutpts[i]+1,cutpts[i+1]-cutpts[i]-1)]; function _str_split_recurse(str,sep,i,result) = i == len(sep) ? concat(result,[str]) : let( pos = search(sep[i], str), end = pos==[] ? len(str) : pos[0] ) _str_split_recurse( substr(str,end+1), sep, i+1, concat(result, [substr(str,0,end)]) ); function _remove_empty_strs(list) = list_remove(list, search([""], list,0)[0]); function str_join(list,sep="",_i=0, _result="") = _i >= len(list)-1 ? (_i==len(list) ? _result : str(_result,list[_i])) : str_join(list,sep,_i+1,str(_result,list[_i],sep)); function _str_count_leading(s,c,_i=0) = (_i>=len(s)||!in_list(s[_i],[each c]))? _i : _str_count_leading(s,c,_i=_i+1); function _str_count_trailing(s,c,_i=0) = (_i>=len(s)||!in_list(s[len(s)-1-_i],[each c]))? _i : _str_count_trailing(s,c,_i=_i+1); function str_strip(s,c,start,end) = let( nstart = (is_undef(start) && !end) ? true : start, nend = (is_undef(end) && !start) ? true : end, startind = nstart ? _str_count_leading(s,c) : 0, endind = len(s) - (nend ? _str_count_trailing(s,c) : 0) ) substr(s,startind, endind-startind); function str_pad(str,length,char=" ",left=false) = assert(is_str(str)) assert(is_str(char) && len(char)==1, "char must be a single character string") assert(is_bool(left)) let( padding = str_join(repeat(char,length-len(str))) ) left ? str(padding,str) : str(str,padding); function str_replace_char(str,char,replace) = assert(is_str(str)) assert(is_str(char) && len(char)==1, "Search pattern 'char' must be a single character string") assert(is_str(replace)) str_join([for(c=str) c==char ? replace : c]); function downcase(str) = str_join([for(char=str) let(code=ord(char)) code>=65 && code<=90 ? chr(code+32) : char]); function upcase(str) = str_join([for(char=str) let(code=ord(char)) code>=97 && code<=122 ? chr(code-32) : char]); function parse_int(str,base=10) = str==undef ? undef : len(str)==0 ? 0 : let(str=downcase(str)) str[0] == "-" ? -_parse_int_recurse(substr(str,1),base,len(str)-2) : str[0] == "+" ?  _parse_int_recurse(substr(str,1),base,len(str)-2) : _parse_int_recurse(str,base,len(str)-1); function _parse_int_recurse(str,base,i) = let( digit = search(str[i],"0123456789abcdef"), last_digit = digit == [] || digit[0] >= base ? (0/0) : digit[0] ) i==0 ? last_digit : _parse_int_recurse(str,base,i-1)*base + last_digit; function parse_float(str) = str==undef ? undef : len(str) == 0 ? 0 : in_list(str[1], ["+","-"]) ? (0/0) : str[0]=="-" ? -parse_float(substr(str,1)) : str[0]=="+" ?  parse_float(substr(str,1)) : let(esplit = str_split(str,"eE") ) len(esplit)==2 ? parse_float(esplit[0]) * pow(10,parse_int(esplit[1])) : let( dsplit = str_split(str,["."])) parse_int(dsplit[0])+parse_int(dsplit[1])/pow(10,len(dsplit[1])); function parse_frac(str,mixed=true,improper=true,signed=true) = str == undef ? undef : len(str)==0 ? 0 : signed && str[0]=="-" ? -parse_frac(substr(str,1),mixed=mixed,improper=improper,signed=false) : signed && str[0]=="+" ?  parse_frac(substr(str,1),mixed=mixed,improper=improper,signed=false) : mixed ? ( !in_list(str_find(str," "), [undef,0]) || is_undef(str_find(str,"/"))? ( let(whole = str_split(str,[" "])) _parse_int_recurse(whole[0],10,len(whole[0])-1) + parse_frac(whole[1], mixed=false, improper=improper, signed=false) ) : parse_frac(str,mixed=false, improper=improper) ) : ( let(split = str_split(str,"/")) len(split)!=2 ? (0/0) : let( numerator =  _parse_int_recurse(split[0],10,len(split[0])-1), denominator = _parse_int_recurse(split[1],10,len(split[1])-1) ) !improper && numerator>=denominator? (0/0) : denominator<0 ? (0/0) : numerator/denominator ); function parse_num(str) = str == undef ? undef : let( val = parse_frac(str) ) val == val ? val : parse_float(str); function format_int(i,mindigits=1) = i<0? str("-", format_int(-i,mindigits)) : let(i=floor(i), e=floor(log(i))) i==0? str_join([for (j=[0:1:mindigits-1]) "0"]) : str_join( concat( [for (j=[0:1:mindigits-e-2]) "0"], [for (j=[e:-1:0]) str(floor(i/pow(10,j)%10))] ) ); function format_fixed(f,digits=6) = assert(is_int(digits)) assert(digits>0) is_list(f)? str("[",str_join(sep=", ", [for (g=f) format_fixed(g,digits=digits)]),"]") : str(f)=="nan"? "nan" : str(f)=="inf"? "inf" : f<0? str("-",format_fixed(-f,digits=digits)) : assert(is_num(f)) let( sc = pow(10,digits), scaled = floor(f * sc + 0.5), whole = floor(scaled/sc), part = floor(scaled-(whole*sc)) ) str(format_int(whole),".",format_int(part,digits)); function format_float(f,sig=12) = assert(is_int(sig)) assert(sig>0) is_list(f)? str("[",str_join(sep=", ", [for (g=f) format_float(g,sig=sig)]),"]") : f==0? "0" : str(f)=="nan"? "nan" : str(f)=="inf"? "inf" : f<0? str("-",format_float(-f,sig=sig)) : assert(is_num(f)) let( e = floor(log(f)), mv = sig - e - 1 ) mv == 0? format_int(floor(f + 0.5)) : (e<-sig/2||mv<0)? str(format_float(f*pow(10,-e),sig=sig),"e",e) : let( ff = f + pow(10,-mv)*0.5, whole = floor(ff), part = floor((ff-whole) * pow(10,mv)) ) str_join([ str(whole), str_strip(end=true, str_join([ ".", format_int(part, mindigits=mv) ]), "0." ) ]); function _format_matrix(M, sig=4, sep=1, eps=1e-9) = let( figure_dash = chr(8210), space_punc = chr(8200), space_figure = chr(8199), sep = is_num(sep) && sep>=0 ? str_join(repeat(space_figure,sep)) : is_string(sep) ? sep : assert(false,"Invalid separator: must be a string or positive integer giving number of spaces"), strarr= [for(row=M) [for(entry=row) let( text = is_undef(entry) ? "und" : !is_num(entry) ? str_join(repeat(figure_dash,2)) : abs(entry) < eps ? "0" : str_replace_char(format_float(entry, sig),"-",figure_dash), have_dot = is_def(str_find(text, ".")) ) str(have_dot ? "" : space_punc, text) ] ], maxwidth = max([for(row=M) len(row)]), maxlen = [for(i=[0:1:maxwidth-1]) max( [for(j=idx(M)) i>=len(M[j]) ? 0 : len(strarr[j][i])]) ], padded = [for(row=strarr) str_join([for(i=idx(row)) let( extra = ends_with(row[i],"inf") ? 1 : 0 ) str_pad(row[i],maxlen[i]+extra,space_figure,left=true)],sep=sep)] ) padded; function format(fmt, vals) = let( parts = str_split(fmt,"{") ) str_join([ for(i = idx(parts)) let( found_brace = i==0 || [for (c=parts[i]) if(c=="}") c] != [], err = assert(found_brace, "Unbalanced { in format string."), p = i==0? [undef,parts[i]] : str_split(parts[i],"}"), fmta = p[0], raw = p[1] ) each [ assert(i<99) is_undef(fmta)? "" : let( fmtb = str_split(fmta,":"), num = is_digit(fmtb[0])? parse_int(fmtb[0]) : (i-1), left = fmtb[1][0] == "-", fmtb1 = default(fmtb[1],""), fmtc = left? substr(fmtb1,1) : fmtb1, zero = fmtc[0] == "0", lch = fmtc==""? "" : fmtc[len(fmtc)-1], hastyp = is_letter(lch), typ = hastyp? lch : "s", fmtd = hastyp? substr(fmtc,0,len(fmtc)-1) : fmtc, fmte = str_split((zero? substr(fmtd,1) : fmtd), "."), wid = parse_int(fmte[0]), prec = parse_int(fmte[1]), val = assert(num>=0&&num<len(vals)) vals[num], unpad = typ=="s"? ( let( sval = str(val) ) is_undef(prec)? sval : substr(sval, 0, min(len(sval)-1, prec)) ) : (typ=="d" || typ=="i")? format_int(val) : typ=="b"? (val? "true" : "false") : typ=="B"? (val? "TRUE" : "FALSE") : typ=="f"? downcase(format_fixed(val,default(prec,6))) : typ=="F"? upcase(format_fixed(val,default(prec,6))) : typ=="g"? downcase(format_float(val,default(prec,6))) : typ=="G"? upcase(format_float(val,default(prec,6))) : assert(false,str("Unknown format type: ",typ)), padlen = max(0,wid-len(unpad)), padfill = str_join([for (i=[0:1:padlen-1]) zero? "0" : " "]), out = left? str(unpad, padfill) : str(padfill, unpad) ) out, raw ] ]); function is_lower(s) = assert(is_string(s)) s==""? false : len(s)>1? all([for (v=s) is_lower(v)]) : let(v = ord(s[0])) (v>=ord("a") && v<=ord("z")); function is_upper(s) = assert(is_string(s)) s==""? false : len(s)>1? all([for (v=s) is_upper(v)]) : let(v = ord(s[0])) (v>=ord("A") && v<=ord("Z")); function is_digit(s) = assert(is_string(s)) s==""? false : len(s)>1? all([for (v=s) is_digit(v)]) : let(v = ord(s[0])) (v>=ord("0") && v<=ord("9")); function is_hexdigit(s) = assert(is_string(s)) s==""? false : len(s)>1? all([for (v=s) is_hexdigit(v)]) : let(v = ord(s[0])) (v>=ord("0") && v<=ord("9")) || (v>=ord("A") && v<=ord("F")) || (v>=ord("a") && v<=ord("f")); function is_letter(s) = assert(is_string(s)) s==""? false : all([for (v=s) is_lower(v) || is_upper(v)]);module _square(size,center=false) square(size,center=center); module _circle(r,d) circle(r=r,d=d); module _text(text,size,font,halign,valign,spacing,direction,language,script)     text(text, size=size, font=font,         halign=halign, valign=valign,         spacing=spacing, direction=direction,         language=language, script=script     ); module _color(color) if (color==undef) children(); else color(color) children(); module _cube(size,center) cube(size,center=center); module _cylinder(h,r1,r2,center,r,d,d1,d2) cylinder(h,r=r,d=d,r1=r1,r2=r2,d1=d1,d2=d2,center=center); module _sphere(r,d) sphere(r=r,d=d); module _multmatrix(m) multmatrix(m) children(); module _translate(v) translate(v) children(); module _rotate(a,v) rotate(a=a,v=v) children(); module _scale(v) scale(v) children();EMPTY_VNF = [[],[]]; function vnf_vertex_array( points, caps, cap1, cap2, col_wrap=false, row_wrap=false, reverse=false, style="default" ) = assert(!(any([caps,cap1,cap2]) && !col_wrap), "col_wrap must be true if caps are requested") assert(!(any([caps,cap1,cap2]) && row_wrap), "Cannot combine caps with row_wrap") assert(in_list(style,["default","alt","quincunx", "convex","concave", "min_edge"])) assert(is_matrix(points[0], n=3),"Point array has the wrong shape or points are not 3d") assert(is_consistent(points), "Non-rectangular or invalid point array") let( pts = flatten(points), pcnt = len(pts), rows = len(points), cols = len(points[0]) ) rows<=1 || cols<=1 ? EMPTY_VNF : let( cap1 = first_defined([cap1,caps,false]), cap2 = first_defined([cap2,caps,false]), colcnt = cols - (col_wrap?0:1), rowcnt = rows - (row_wrap?0:1), verts = [ each pts, if (style=="quincunx") for (r = [0:1:rowcnt-1], c = [0:1:colcnt-1]) let( i1 = ((r+0)%rows)*cols + ((c+0)%cols), i2 = ((r+1)%rows)*cols + ((c+0)%cols), i3 = ((r+1)%rows)*cols + ((c+1)%cols), i4 = ((r+0)%rows)*cols + ((c+1)%cols) ) mean([pts[i1], pts[i2], pts[i3], pts[i4]]) ], allfaces = [ if (cap1) count(cols,reverse=!reverse), if (cap2) count(cols,(rows-1)*cols, reverse=reverse), for (r = [0:1:rowcnt-1], c=[0:1:colcnt-1]) each let( i1 = ((r+0)%rows)*cols + ((c+0)%cols), i2 = ((r+1)%rows)*cols + ((c+0)%cols), i3 = ((r+1)%rows)*cols + ((c+1)%cols), i4 = ((r+0)%rows)*cols + ((c+1)%cols), faces = style=="quincunx"? let(i5 = pcnt + r*colcnt + c) [[i1,i5,i2],[i2,i5,i3],[i3,i5,i4],[i4,i5,i1]] : style=="alt"? [[i1,i4,i2],[i2,i4,i3]] : style=="min_edge"? let( d42=norm(pts[i4]-pts[i2]), d13=norm(pts[i1]-pts[i3]), shortedge = d42<=d13 ? [[i1,i4,i2],[i2,i4,i3]] : [[i1,i3,i2],[i1,i4,i3]] ) shortedge : style=="convex"? let( n = (reverse?-1:1)*cross(pts[i2]-pts[i1],pts[i3]-pts[i1]), convexfaces = n==0 ? [[i1,i4,i3]] : n*pts[i4] > n*pts[i1] ? [[i1,i4,i2],[i2,i4,i3]] : [[i1,i3,i2],[i1,i4,i3]] ) convexfaces : style=="concave"? let( n = (reverse?-1:1)*cross(pts[i2]-pts[i1],pts[i3]-pts[i1]), concavefaces = n==0 ? [[i1,i4,i3]] : n*pts[i4] <= n*pts[i1] ? [[i1,i4,i2],[i2,i4,i3]] : [[i1,i3,i2],[i1,i4,i3]] ) concavefaces : [[i1,i3,i2],[i1,i4,i3]], culled_faces= [for(face=faces) if (norm(verts[face[0]]-verts[face[1]])>EPSILON && norm(verts[face[1]]-verts[face[2]])>EPSILON && norm(verts[face[2]]-verts[face[0]])>EPSILON) face ], rfaces = reverse? [for (face=culled_faces) reverse(face)] : culled_faces ) rfaces, ] ) [verts,allfaces]; function vnf_tri_array(points, row_wrap=false, reverse=false) = let( lens = [for(row=points) len(row)], rowstarts = [0,each cumsum(lens)], faces = [for(i=[0:1:len(points) - 1 - (row_wrap ? 0 : 1)]) each let( rowstart = rowstarts[i], nextrow = select(rowstarts,i+1), delta = select(lens,i+1)-lens[i] ) delta == 0 ? [for(j=[0:1:lens[i]-2]) reverse ? [j+rowstart+1, j+rowstart, j+nextrow] : [j+rowstart, j+rowstart+1, j+nextrow], for(j=[0:1:lens[i]-2]) reverse ? [j+rowstart+1, j+nextrow, j+nextrow+1] : [j+rowstart+1, j+nextrow+1, j+nextrow]] : delta == 1 ? [for(j=[0:1:lens[i]-2]) reverse ? [j+rowstart+1, j+rowstart, j+nextrow+1] : [j+rowstart, j+rowstart+1, j+nextrow+1], for(j=[0:1:lens[i]-1]) reverse ? [j+rowstart, j+nextrow, j+nextrow+1] : [j+rowstart, j+nextrow+1, j+nextrow]] : delta == -1 ? [for(j=[0:1:lens[i]-3]) reverse ? [j+rowstart+1, j+nextrow, j+nextrow+1]: [j+rowstart+1, j+nextrow+1, j+nextrow], for(j=[0:1:lens[i]-2]) reverse ? [j+rowstart+1, j+rowstart, j+nextrow] : [j+rowstart, j+rowstart+1, j+nextrow]] : let(count = floor((lens[i]-1)/2)) delta == 2 ? [ for(j=[0:1:count-1]) reverse ? [j+rowstart+1, j+rowstart, j+nextrow+1] : [j+rowstart, j+rowstart+1, j+nextrow+1], for(j=[count:1:lens[i]-2]) reverse ? [j+rowstart+1, j+rowstart, j+nextrow+2] : [j+rowstart, j+rowstart+1, j+nextrow+2], for(j=[0:1:count]) reverse ? [j+rowstart, j+nextrow, j+nextrow+1] : [j+rowstart, j+nextrow+1, j+nextrow], for(j=[count+1:1:select(lens,i+1)-2]) reverse ? [j+rowstart-1, j+nextrow, j+nextrow+1] : [j+rowstart-1, j+nextrow+1, j+nextrow], ] : delta == -2 ? [ for(j=[0:1:count-2]) reverse ? [j+nextrow, j+nextrow+1, j+rowstart+1] : [j+nextrow, j+rowstart+1, j+nextrow+1], for(j=[count-1:1:lens[i]-4]) reverse ? [j+nextrow,j+nextrow+1,j+rowstart+2] : [j+nextrow,j+rowstart+2, j+nextrow+1], for(j=[0:1:count-1]) reverse ? [j+nextrow, j+rowstart+1, j+rowstart] : [j+nextrow, j+rowstart, j+rowstart+1], for(j=[count:1:select(lens,i+1)]) reverse ? [ j+nextrow-1, j+rowstart+1, j+rowstart]: [ j+nextrow-1, j+rowstart, j+rowstart+1], ] : assert(false,str("Unsupported row length difference of ",delta, " between row ",i," and ",(i+1)%len(points))) ], verts = flatten(points), culled_faces= [for(face=faces) if (norm(verts[face[0]]-verts[face[1]])>EPSILON && norm(verts[face[1]]-verts[face[2]])>EPSILON && norm(verts[face[2]]-verts[face[0]])>EPSILON) face ] ) [flatten(points), culled_faces]; function vnf_join(vnfs) = assert(is_vnf_list(vnfs) , "Input must be a list of VNFs") len(vnfs)==1 ? vnfs[0] : let ( offs  = cumsum([ 0, for (vnf = vnfs) len(vnf[0]) ]), verts = [for (vnf=vnfs) each vnf[0]], faces = [ for (i = idx(vnfs)) let( faces = vnfs[i][1] ) for (face = faces) if ( len(face) >= 3 ) [ for (j = face) assert( j>=0 && j<len(vnfs[i][0]), str("VNF number ", i, " has a face indexing an nonexistent vertex") ) offs[i] + j ] ] ) [verts,faces]; function vnf_from_polygons(polygons) = assert(is_list(polygons) && is_path(polygons[0]),"Input should be a list of polygons") let( offs = cumsum([0, for(p=polygons) len(p)]), faces = [for(i=idx(polygons)) [for (j=idx(polygons[i])) offs[i]+j] ] ) [flatten(polygons), faces]; function _path_path_closest_vertices(path1,path2) = let( dists = [for (i=idx(path1)) let(j=closest_point(path1[i],path2)) [j,norm(path2[j]-path1[i])]], i1 = min_index(column(dists,1)), i2 = dists[i1][0] ) [dists[i1][1], i1, i2]; function _join_paths_at_vertices(path1,path2,v1,v2) = let( repeat_start = !approx(path1[v1],path2[v2]), path1 = clockwise_polygon(list_rotate(path1,v1)), path2 = ccw_polygon(list_rotate(path2,v2)) ) [ each path1, if (repeat_start) path1[0], each path2, if (repeat_start) path2[0], ]; function _cleave_connected_region(region, eps=EPSILON) = len(region)==1 ? region[0] : let( outer   = deduplicate(region[0]), holes   = [for(i=[1:1:len(region)-1]) deduplicate( region[i] ) ], extridx = [for(li=holes) max_index(column(li,0)) ], extremes = sort( [for(i=idx(holes)) [ i, extridx[i], -holes[i][extridx[i]].x] ], idx=2 ) ) _polyHoles(outer, holes, extremes, eps, 0); function _polyHoles(outer, holes, extremes, eps=EPSILON, n=0) = let( extr = extremes[n], hole = holes[extr[0]], ipt  = extr[1], brdg = _bridge(hole[ipt], outer, eps) ) brdg == undef ? undef : let( l  = len(outer), lh = len(hole), npoly = approx(outer[brdg], hole[ipt], eps) ?   [ for(i=[brdg:  1: brdg+l])   outer[i%l] , for(i=[ipt+1: 1: ipt+lh-1]) hole[i%lh] ] :   [ for(i=[brdg:  1: brdg+l])   outer[i%l] , for(i=[ipt:   1: ipt+lh])   hole[i%lh] ] ) n==len(holes)-1 ?  npoly : _polyHoles(npoly, holes, extremes, eps, n+1); function _bridge(pt, outer,eps) = let( l    = len(outer), crxs = let( edges = pair(outer,wrap=true) ) [for( i = idx(edges) ) let( edge = edges[i] ) if(    (edge[0].y >  pt.y) && (edge[1].y <= pt.y) && _is_at_left(pt, [edge[1], edge[0]], eps) ) [ i, abs(pt.y-edge[1].y)<eps ? edge[1] : let( u = (pt-edge[1]).y / (edge[0]-edge[1]).y ) (1-u)*edge[1] + u*edge[0] ] ] ) crxs == [] ? undef : let( minX    = min([for(p=crxs) p[1].x]), crxcand = [for(crx=crxs) if(crx[1].x < minX+eps) crx ], nearest = min_index([for(crx=crxcand) (outer[crx[0]].x - pt.x) / (outer[crx[0]].y - pt.y) ]), proj    = crxcand[nearest], vert0   = outer[proj[0]], vert1   = outer[(proj[0]+1)%l], isect   = proj[1] ) norm(pt-vert1) < eps ? (proj[0]+1)%l : norm(pt-isect) < eps ? undef : let( cand  = (vert0.x > pt.x) ?   [ proj[0], for(i=idx(outer)) if( _tri_class(select(outer,i-1,i+1),eps) <= 0 && _pt_in_tri(outer[i], [pt, vert0, isect], eps)>=0 ) i ] :   [ (proj[0]+1)%l, for(i=idx(outer)) if( _tri_class(select(outer,i-1,i+1),eps) <= 0 &&  _pt_in_tri(outer[i], [pt, isect, vert1], eps)>=0 ) i ], slopes  = [for(i=cand) 1-abs(outer[i].x-pt.x)/norm(outer[i]-pt) ], min_slp = min(slopes), cand2   = [for(i=idx(cand)) if(slopes[i]<=min_slp+eps) cand[i] ], nearest = min_index([for(i=cand2) norm(pt-outer[i]) ]) ) cand2[nearest]; function vnf_from_region(region, transform, reverse=false) = let ( regions = region_parts(force_region(region)), vnfs = [ for (rgn = regions) let( cleaved = path3d(_cleave_connected_region(rgn)) ) assert( cleaved, "The region is invalid") let( face = is_undef(transform)? cleaved : apply(transform,cleaved), faceidxs = reverse? [for (i=[len(face)-1:-1:0]) i] : [for (i=[0:1:len(face)-1]) i] ) [face, [faceidxs]] ], outvnf = vnf_join(vnfs) ) vnf_triangulate(outvnf); function is_vnf(x) = is_list(x) && len(x)==2 && is_list(x[0]) && is_list(x[1]) && (x[0]==[] || (len(x[0])>=3 && is_vector(x[0][0],3))) && (x[1]==[] || is_vector(x[1][0])); function is_vnf_list(x) = is_list(x) && all([for (v=x) is_vnf(v)]); function vnf_vertices(vnf) = vnf[0]; function vnf_faces(vnf) = vnf[1]; function vnf_reverse_faces(vnf) = [vnf[0], [for (face=vnf[1]) reverse(face)]]; function vnf_quantize(vnf,q=pow(2,-12)) = [[for (pt = vnf[0]) quant(pt,q)], vnf[1]]; function vnf_merge_points(vnf,eps=EPSILON) = let( verts = vnf[0], dedup  = vector_search(verts,eps,verts), map    = [for(i=idx(verts)) min(dedup[i]) ], offset = cumsum([for(i=idx(verts)) map[i]==i ? 0 : 1 ]), map2   = list(idx(verts))-offset, nverts = [for(i=idx(verts)) if(map[i]==i) verts[i] ], nfaces = [ for(face=vnf[1]) let( nface = [ for(vi=face) map2[map[vi]] ], dface = [for (i=idx(nface)) if( nface[i]!=nface[(i+1)%len(nface)]) nface[i] ] ) if(len(dface) >= 3) dface ] ) [nverts, nfaces]; function vnf_drop_unused_points(vnf) = let( flat = flatten(vnf[1]), ind  = _link_indicator(flat,0,len(vnf[0])-1), verts = [for(i=idx(vnf[0])) if(ind[i]==1) vnf[0][i] ], map   = cumsum(ind) ) [ verts, [for(face=vnf[1]) [for(v=face) map[v]-1 ] ] ]; function _link_indicator(l,imin,imax) = len(l) == 0  ? repeat(imax-imin+1,0) : imax-imin<100 || len(l)<400 ? [for(si=search(list([imin:1:imax]),l,1)) si!=[] ? 1: 0 ] : let( pivot   = floor((imax+imin)/2), lesser  = [ for(li=l) if( li< pivot) li ], greater = [ for(li=l) if( li> pivot) li ] ) concat( _link_indicator(lesser ,imin,pivot-1), search(pivot,l,1) ? 1 : 0 , _link_indicator(greater,pivot+1,imax) ) ; function vnf_triangulate(vnf) = let( verts = vnf[0], faces = [for (face=vnf[1]) each (len(face)==3 ? [face] : let( tris = polygon_triangulate(verts, face) ) assert( tris!=undef, "Some `vnf` face cannot be triangulated.") tris ) ] ) [verts, faces]; function vnf_slice(vnf,dir,cuts) = let( vert = vnf[0], faces = [for(face=vnf[1]) select(vert,face)], poly_list = _slice_3dpolygons(faces, dir, cuts) ) vnf_merge_points(vnf_from_polygons(poly_list)); function _split_polygon_at_x(poly, x) = let( xs = column(poly,0) ) (min(xs) >= x || max(xs) <= x)? [poly] : let( poly2 = [ for (p = pair(poly,true)) each [ p[0], if( (p[0].x < x && p[1].x > x) || (p[1].x < x && p[0].x > x) ) let( u = (x - p[0].x) / (p[1].x - p[0].x) ) [ x, u*(p[1].y-p[0].y)+p[0].y ] ] ], out1 = [for (p = poly2) if(p.x <= x) p], out2 = [for (p = poly2) if(p.x >= x) p], out3 = [ if (len(out1)>=3) each split_path_at_self_crossings(out1), if (len(out2)>=3) each split_path_at_self_crossings(out2), ], out = [for (p=out3) if (len(p) > 2) cleanup_path(p)] ) out; function _split_2dpolygons_at_each_x(polys, xs, _i=0) = _i>=len(xs)? polys : _split_2dpolygons_at_each_x( [ for (poly = polys) each _split_polygon_at_x(poly, xs[_i]) ], xs, _i=_i+1 ); function _slice_3dpolygons(polys, dir, cuts) = assert( [for (poly=polys) if (!is_path(poly,3)) 1] == [], "Expects list of 3D paths.") assert( is_vector(cuts), "The split list must be a vector.") assert( in_list(dir, ["X", "Y", "Z"])) let( I = ident(3), dir_ind = ord(dir)-ord("X") ) flatten([for (poly = polys) let( plane = plane_from_polygon(poly) ) assert(plane,"Found non-coplanar face.") let( normal = point3d(plane), pnormal = normal - (normal*I[dir_ind])*I[dir_ind] ) approx(pnormal,[0,0,0]) ? [poly] : let ( pind = max_index(v_abs(pnormal)), otherind = 3-pind-dir_ind, keep = [I[dir_ind], I[otherind]], poly2d = poly*transpose(keep), poly_list = [for(p=_split_2dpolygons_at_each_x([poly2d], cuts)) let( a = p*keep, ofs = outer_product((repeat(plane[3], len(a))-a*normal)/plane[pind],I[pind]) ) a+ofs] ) poly_list ]); module vnf_polyhedron(vnf, convexity=2, extent=true, cp="centroid", anchor="origin", spin=0, orient=UP, atype="hull") { vnf = is_vnf_list(vnf)? vnf_join(vnf) : vnf; assert(in_list(atype, _ANCHOR_TYPES), "Anchor type must be \"hull\" or \"intersect\""); attachable(anchor,spin,orient, vnf=vnf, extent=atype=="hull", cp=cp) { polyhedron(vnf[0], vnf[1], convexity=convexity); children(); } } module vnf_wireframe(vnf, width=1) { vertex = vnf[0]; edges = unique([for (face=vnf[1], i=idx(face)) sort([face[i], select(face,i+1)]) ]); for (e=edges) extrude_from_to(vertex[e[0]],vertex[e[1]]) circle_BOSL2(d=width); vertused = search(count(len(vertex)), flatten(edges), 1); for(i=idx(vertex)) if(vertused[i]!=[]) move(vertex[i]) sphere_BOSL2(d=width); } function vnf_volume(vnf) = let(verts = vnf[0]) sum([ for(face=vnf[1], j=[1:1:len(face)-2]) cross(verts[face[j+1]], verts[face[j]]) * verts[face[0]] ])/6; function vnf_area(vnf) = let(verts=vnf[0]) sum([for(face=vnf[1]) polygon_area(select(verts,face))]); function _vnf_centroid(vnf,eps=EPSILON) = assert(is_vnf(vnf) && len(vnf[0])!=0 && len(vnf[1])!=0,"Invalid or empty VNF given to centroid") let( verts = vnf[0], pos = sum([ for(face=vnf[1], j=[1:1:len(face)-2]) let( v0  = verts[face[0]], v1  = verts[face[j]], v2  = verts[face[j+1]], vol = cross(v2,v1)*v0 ) [ vol, (v0+v1+v2)*vol ] ]) ) assert(!approx(pos[0],0, eps), "The vnf has self-intersections.") pos[1]/pos[0]/4; function vnf_halfspace(plane, vnf, closed=true) = assert(_valid_plane(plane), "Invalid plane") assert(is_vnf(vnf), "Invalid vnf") let( inside = [for(x=vnf[0]) plane*[each x,-1] >= 0 ? 1 : 0], vertexmap = [0,each cumsum(inside)], faces_edges_vertices = _vnfcut(plane, vnf[0],vertexmap,inside, vnf[1], last(vertexmap)), newvert = concat(bselect(vnf[0],inside), faces_edges_vertices[2]) ) closed==false ? [newvert, faces_edges_vertices[0]] : let( allpaths = _assemble_paths(newvert, faces_edges_vertices[1]), newpaths = [for(p=allpaths) if (len(p)>=3) p else assert(approx(p[0],p[1]),"Orphan edge found when assembling cut edges.") ] ) len(newpaths)<=1 ? [newvert, concat(faces_edges_vertices[0], newpaths)] : let( M = project_plane(plane), faceregion = [for(path=newpaths) path2d(apply(M,select(newvert,path)))], facevnf = vnf_from_region(faceregion,transform=rot_inverse(M),reverse=true) ) vnf_join([[newvert, faces_edges_vertices[0]], facevnf]); function _assemble_paths(vertices, edges, paths=[],i=0) = i==len(edges) ? paths : norm(vertices[edges[i][0]]-vertices[edges[i][1]])<EPSILON ? _assemble_paths(vertices,edges,paths,i+1) : let( left = [for(j=idx(paths)) if (approx(vertices[last(paths[j])],vertices[edges[i][0]])) j], right = [for(j=idx(paths)) if (approx(vertices[edges[i][1]],vertices[paths[j][0]])) j] ) assert(len(left)<=1 && len(right)<=1) let( keep_path = list_remove(paths,concat(left,right)), update_path = left==[] && right==[] ? edges[i] : left==[] ? concat([edges[i][0]],paths[right[0]]) : right==[] ?  concat(paths[left[0]],[edges[i][1]]) : left != right ? concat(paths[left[0]], paths[right[0]]) : paths[left[0]] ) _assemble_paths(vertices, edges, concat(keep_path, [update_path]), i+1); function _vnfcut(plane, vertices, vertexmap, inside, faces, vertcount, newfaces=[], newedges=[], newvertices=[], i=0) = i==len(faces) ? [newfaces, newedges, newvertices] : let( pts_inside = select(inside,faces[i]) ) all(pts_inside) ? _vnfcut(plane, vertices, vertexmap, inside, faces, vertcount, concat(newfaces, [select(vertexmap,faces[i])]), newedges, newvertices, i+1): !any(pts_inside) ? _vnfcut(plane, vertices, vertexmap,inside, faces, vertcount, newfaces, newedges, newvertices, i+1): let( first = search([[1,0]],pair(pts_inside,wrap=true),0)[0], second = search([[0,1]],pair(pts_inside,wrap=true),0)[0] ) assert(len(first)==1 && len(second)==1, "Found concave face in VNF.  Run vnf_triangulate first to ensure convex faces.") let( newface = [each select(vertexmap,select(faces[i],second[0]+1,first[0])),vertcount, vertcount+1], newvert = [plane_line_intersection(plane, select(vertices,select(faces[i],first[0],first[0]+1)),eps=0), plane_line_intersection(plane, select(vertices,select(faces[i],second[0],second[0]+1)),eps=0)] ) true ? _vnfcut(plane, vertices, vertexmap, inside, faces, vertcount+2, concat(newfaces, [newface]), concat(newedges,[[vertcount+1,vertcount]]),concat(newvertices,newvert),i+1) :len(newface)>3 ? _vnfcut(plane, vertices, vertexmap, inside, faces, vertcount+1, concat(newfaces, [list_head(newface)]), newedges,concat(newvertices,[newvert[0]]),i+1) : _vnfcut(plane, vertices, vertexmap, inside, faces, vertcount,newfaces, newedges, newvert, i+1); function _triangulate_planar_convex_polygons(polys) = polys==[]? [] : let( tris = [for (poly=polys) if (len(poly)==3) poly], bigs = [for (poly=polys) if (len(poly)>3) poly], newtris = [for (poly=bigs) select(poly,-2,0)], newbigs = [for (poly=bigs) select(poly,0,-2)], newtris2 = _triangulate_planar_convex_polygons(newbigs), outtris = concat(tris, newtris, newtris2) ) outtris; function vnf_bend(vnf,r,d,axis="Z") = let( chk_axis = assert(in_list(axis,["X","Y","Z"])), verts = vnf[0], bounds = pointlist_bounds(verts), bmin = bounds[0], bmax = bounds[1], dflt = axis=="Z"? max(abs(bmax.y), abs(bmin.y)) : max(abs(bmax.z), abs(bmin.z)), r = get_radius(r=r,d=d,dflt=dflt), extent = axis=="X" ? [bmin.y, bmax.y] : [bmin.x, bmax.x] ) let( span_chk = axis=="Z"? assert(bmin.y > 0 || bmax.y < 0, "Entire shape MUST be completely in front of or behind y=0.") : assert(bmin.z > 0 || bmax.z < 0, "Entire shape MUST be completely above or below z=0."), steps = 1+ceil(segs(r) * (extent[1]-extent[0])/(2*PI*r)), step = (extent[1]-extent[0]) / steps, bend_at = [for(i = [1:1:steps-1]) i*step+extent[0]], slicedir = axis=="X"? "Y" : "X", sliced = vnf_slice(vnf, slicedir, bend_at), coord = axis=="X" ? [0,sign(bmax.z),0] : axis=="Y" ? [sign(bmax.z),0,0] : [sign(bmax.y),0,0], new_vert = [for(p=sliced[0]) let(a=coord*p*180/(PI*r)) axis=="X"? [p.x, p.z*sin(a), p.z*cos(a)] : axis=="Y"? [p.z*sin(a), p.y, p.z*cos(a)] : [p.y*sin(a), p.y*cos(a), p.z]] ) [new_vert,sliced[1]]; module _show_vertices(vertices, size=1) { color("blue") { dups = vector_search(vertices, EPSILON, vertices); for (ind = dups){ numstr = str_join([for(i=ind) str(i)],","); v = vertices[ind[0]]; translate(v) { rot($vpr) back(size/8){ linear_extrude(height=size/10, center=true, convexity=10) { text(text=numstr, size=size, halign="center"); } } sphere_BOSL2(size/10); } } } } module _show_faces(vertices, faces, size=1) { vlen = len(vertices); color("red") { for (i = [0:1:len(faces)-1]) { face = faces[i]; if (face[0] < 0 || face[1] < 0 || face[2] < 0 || face[0] >= vlen || face[1] >= vlen || face[2] >= vlen) { echo("BAD FACE: ", vlen=vlen, face=face); } else { verts = select(vertices,face); c = mean(verts); v0 = verts[0]; v1 = verts[1]; v2 = verts[2]; dv0 = unit(v1 - v0); dv1 = unit(v2 - v0); nrm0 = cross(dv0, dv1); nrm1 = UP; axis = vector_axis(nrm0, nrm1); ang = vector_angle(nrm0, nrm1); theta = atan2(nrm0[1], nrm0[0]); translate(c) { rotate(a=180-ang, v=axis) { zrot(theta-90) linear_extrude(height=size/10, center=true, convexity=10) { union() { text(text=str(i), size=size, halign="center"); text(text=str("_"), size=size, halign="center"); } } } } } } } } module debug_vnf(vnf, faces=true, vertices=true, opacity=0.5, size=1, convexity=6 ) { no_children($children); if (faces) _show_faces(vertices=vnf[0], faces=vnf[1], size=size); if (vertices) _show_vertices(vertices=vnf[0], size=size); color([0.2, 1.0, 0, opacity]) vnf_polyhedron(vnf,convexity=convexity); } function vnf_validate(vnf, show_warns=true, check_isects=false) = assert(is_vnf(vnf), "Invalid VNF") let( vnf = vnf_merge_points(vnf), varr = vnf[0], faces = vnf[1], lvarr = len(varr), edges = sort([ for (face=faces, edge=pair(face,true)) edge[0]<edge[1]? edge : [edge[1],edge[0]] ]), dfaces = [ for (face=faces) let( face=deduplicate_indexed(varr,face,closed=true) ) if(len(face)>=3) face ], face_areas = [ for (face = faces) len(face) < 3? 0 : polygon_area([for (k=face) varr[k]]) ], edgecnts = unique_count(edges), uniq_edges = edgecnts[0], issues = [] ) let( big_faces = !show_warns? [] : [ for (face = faces) if (len(face) > 3) _vnf_validate_err("BIG_FACE", [for (i=face) varr[i]]) ], null_faces = !show_warns? [] : [ for (i = idx(faces)) let( face = faces[i], area = face_areas[i], faceverts = [for (k=face) varr[k]] ) if (is_num(area) && abs(area) < EPSILON) _vnf_validate_err("NULL_FACE", faceverts) ], issues = concat(big_faces, null_faces) ) let( bad_indices = [ for (face = faces, idx = face) if (idx < 0 || idx >= lvarr) _vnf_validate_err("BAD_INDEX", [idx]) ], issues = concat(issues, bad_indices) ) bad_indices? issues : let( repeated_faces = [ for (i=idx(dfaces), j=idx(dfaces)) if (i!=j) let( face1 = dfaces[i], face2 = dfaces[j] ) if (min(face1) == min(face2)) let( min1 = min_index(face1), min2 = min_index(face2) ) if (min1 == min2) let( sface1 = list_rotate(face1,min1), sface2 = list_rotate(face2,min2) ) if (sface1 == sface2) _vnf_validate_err("DUP_FACE", [for (i=sface1) varr[i]]) ], issues = concat(issues, repeated_faces) ) repeated_faces? issues : let( multconn_edges = unique([ for (i = idx(uniq_edges)) if (edgecnts[1][i]>2) _vnf_validate_err("MULTCONN", [for (i=uniq_edges[i]) varr[i]]) ]), issues = concat(issues, multconn_edges) ) multconn_edges? issues : let( reversals = unique([ for(i = idx(dfaces), j = idx(dfaces)) if(i != j) for(edge1 = pair(faces[i],true)) for(edge2 = pair(faces[j],true)) if(edge1 == edge2) if(_edge_not_reported(edge1, varr, multconn_edges)) _vnf_validate_err("REVERSAL", [for (i=edge1) varr[i]]) ]), issues = concat(issues, reversals) ) reversals? issues : let( t_juncts = unique([ for (v=idx(varr), edge=uniq_edges) let( ia = edge[0], ib = v, ic = edge[1] ) if (ia!=ib && ib!=ic && ia!=ic) let( a = varr[ia], b = varr[ib], c = varr[ic] ) if (!approx(a,b) && !approx(b,c) && !approx(a,c)) let( pt = line_closest_point([a,c],b,SEGMENT) ) if (approx(pt,b)) _vnf_validate_err("T_JUNCTION", [b]) ]), issues = concat(issues, t_juncts) ) t_juncts? issues : let( isect_faces = !check_isects? [] : unique([ for (i = [0:1:len(faces)-2]) let( f1 = faces[i], poly1   = select(varr, faces[i]), plane1  = plane3pt(poly1[0], poly1[1], poly1[2]), normal1 = [plane1[0], plane1[1], plane1[2]] ) for (j = [i+1:1:len(faces)-1]) let( f2 = faces[j], poly2 = select(varr, f2), val = poly2 * normal1 ) if( min(val)<=plane1[3] && max(val)>=plane1[3] ) let( plane2  = plane_from_polygon(poly2), normal2 = [plane2[0], plane2[1], plane2[2]], val = poly1 * normal2 ) if( min(val)<=plane2[3] && max(val)>=plane2[3] ) let( shared_edges = [ for (edge1 = pair(f1, true), edge2 = pair(f2, true)) if (edge1 == [edge2[1], edge2[0]]) 1 ] ) if (!shared_edges) let( line = plane_intersection(plane1, plane2) ) if (!is_undef(line)) let( isects = polygon_line_intersection(poly1, line) ) if (!is_undef(isects)) for (isect = isects) if (len(isect) > 1) let( isects2 = polygon_line_intersection(poly2, isect, bounded=true) ) if (!is_undef(isects2)) for (seg = isects2) if (seg[0] != seg[1]) _vnf_validate_err("FACE_ISECT", seg) ]), issues = concat(issues, isect_faces) ) isect_faces? issues : let( hole_edges = unique([ for (i=idx(uniq_edges)) if (edgecnts[1][i]<2) if (_pts_not_reported(uniq_edges[i], varr, t_juncts)) if (_pts_not_reported(uniq_edges[i], varr, isect_faces)) _vnf_validate_err("HOLE_EDGE", [for (i=uniq_edges[i]) varr[i]]) ]), issues = concat(issues, hole_edges) ) hole_edges? issues : let( nonplanars = unique([ for (i = idx(faces)) let( face = faces[i], area = face_areas[i], faceverts = [for (k=face) varr[k]] ) if (is_num(area) && abs(area) > EPSILON) if (!is_coplanar(faceverts)) _vnf_validate_err("NONPLANAR", faceverts) ]), issues = concat(issues, nonplanars) ) issues; _vnf_validate_errs = [ ["BIG_FACE",    "WARNING", "cyan",    "Face has more than 3 vertices, and may confuse CGAL"], ["NULL_FACE",   "WARNING", "blue",    "Face has zero area."], ["BAD_INDEX",   "ERROR",   "cyan",    "Invalid face vertex index."], ["NONPLANAR",   "ERROR",   "yellow",  "Face vertices are not coplanar"], ["DUP_FACE",    "ERROR",   "brown",   "Multiple instances of the same face."], ["MULTCONN",    "ERROR",   "orange",  "Multiply Connected Geometry. Too many faces attached at Edge"], ["REVERSAL",    "ERROR",   "violet",  "Faces Reverse Across Edge"], ["T_JUNCTION",  "ERROR",   "magenta", "Vertex is mid-edge on another Face"], ["FACE_ISECT",  "ERROR",   "brown",   "Faces intersect"], ["HOLE_EDGE",   "ERROR",   "red",     "Edge bounds Hole"] ]; function _vnf_validate_err(name, extra) = let( info = [for (x = _vnf_validate_errs) if (x[0] == name) x][0] ) concat(info, [extra]); function _pts_not_reported(pts, varr, reports) = [ for (i = pts, report = reports, pt = report[3]) if (varr[i] == pt) 1 ] == []; function _edge_not_reported(edge, varr, reports) = let( edge = sort([for (i=edge) varr[i]]) ) [ for (report = reports) let( pts = sort(report[3]) ) if (len(pts)==2 && edge == pts) 1 ] == []; module vnf_validate(vnf, size=1, show_warns=true, check_isects=false) { faults = vnf_validate( vnf, show_warns=show_warns, check_isects=check_isects ); for (fault = faults) { err = fault[0]; typ = fault[1]; clr = fault[2]; msg = fault[3]; pts = fault[4]; echo(str(typ, " ", err, " (", clr ,"): ", msg, " at ", pts)); color(clr) { if (is_vector(pts[0])) { if (len(pts)==2) { stroke(pts, width=size, closed=true, endcaps="butt", hull=false, $fn=8); } else if (len(pts)>2) { stroke(pts, width=size, closed=true, hull=false, $fn=8); polyhedron(pts,[[for (i=idx(pts)) i]]); } else { move_copies(pts) sphere_BOSL2(d=size*3, $fn=18); } } } } color([0.5,0.5,0.5,0.67]) vnf_polyhedron(vnf); }function is_path(list, dim=[2,3], fast=false) = fast ?   is_list(list) && is_vector(list[0]) :   is_matrix(list) && len(list)>1 && len(list[0])>0 && (is_undef(dim) || in_list(len(list[0]), force_list(dim))); function is_1region(path, name="path") = !is_region(path)? false :assert(len(path)==1,str("Parameter \"",name,"\" must be a path or singleton region, but is a multicomponent region")) true; function force_path(path, name="path") = is_region(path) ? assert(len(path)==1, str("Parameter \"",name,"\" must be a path or singleton region, but is a multicomponent region")) path[0] : path; function is_closed_path(path, eps=EPSILON) = approx(path[0], path[len(path)-1], eps=eps); function close_path(path, eps=EPSILON) = is_closed_path(path,eps=eps)? path : concat(path,[path[0]]); function cleanup_path(path, eps=EPSILON) = is_closed_path(path,eps=eps)? [for (i=[0:1:len(path)-2]) path[i]] : path; function _path_select(path, s1, u1, s2, u2, closed=false) = let( lp = len(path), l = lp-(closed?0:1), u1 = s1<0? 0 : s1>l? 1 : u1, u2 = s2<0? 0 : s2>l? 1 : u2, s1 = constrain(s1,0,l), s2 = constrain(s2,0,l), pathout = concat( (s1<l && u1<1)? [lerp(path[s1],path[(s1+1)%lp],u1)] : [], [for (i=[s1+1:1:s2]) path[i]], (s2<l && u2>0)? [lerp(path[s2],path[(s2+1)%lp],u2)] : [] ) ) pathout; function path_merge_collinear(path, closed, eps=EPSILON) = is_1region(path) ? path_merge_collinear(path[0], default(closed,true), eps) : let(closed=default(closed,false)) assert(is_bool(closed)) assert( is_path(path), "Invalid path in path_merge_collinear." ) assert( is_undef(eps) || (is_finite(eps) && (eps>=0) ), "Invalid tolerance." ) len(path)<=2 ? path : let( indices = [ 0, for (i=[1:1:len(path)-(closed?1:2)]) if (!is_collinear(path[i-1], path[i], select(path,i+1), eps=eps)) i, if (!closed) len(path)-1 ] ) [for (i=indices) path[i]]; function path_length(path,closed) = is_1region(path) ? path_length(path[0], default(closed,true)) : assert(is_path(path), "Invalid path in path_length") let(closed=default(closed,false)) assert(is_bool(closed)) len(path)<2? 0 : sum([for (i = [0:1:len(path)-2]) norm(path[i+1]-path[i])])+(closed?norm(path[len(path)-1]-path[0]):0); function path_segment_lengths(path, closed) = is_1region(path) ? path_segment_lengths(path[0], default(closed,true)) : let(closed=default(closed,false)) assert(is_path(path),"Invalid path in path_segment_lengths.") assert(is_bool(closed)) [ for (i=[0:1:len(path)-2]) norm(path[i+1]-path[i]), if (closed) norm(path[0]-last(path)) ]; function path_length_fractions(path, closed) = is_1region(path) ? path_length_fractions(path[0], default(closed,true)): let(closed=default(closed, false)) assert(is_path(path)) assert(is_bool(closed)) let( lengths = [ 0, each path_segment_lengths(path,closed) ], partial_len = cumsum(lengths), total_len = last(partial_len) ) partial_len / total_len; function _path_self_intersections(path, closed=true, eps=EPSILON) = let( path = closed ? close_path(path,eps=eps) : path, plen = len(path) ) [ for (i = [0:1:plen-3]) let( a1 = path[i], a2 = path[i+1], seg_normal = unit([-(a2-a1).y, (a2-a1).x],[0,0]), vals = path*seg_normal, ref  = a1*seg_normal, signals = [for(j=[i+2:1:plen-(i==0 && closed? 2: 1)]) abs(vals[j]-ref) <  eps ? 0 : sign(vals[j]-ref) ] ) if(max(signals)>=0 && min(signals)<=0 ) for(j=[i+2:1:plen-(i==0 && closed? 3: 2)]) if( signals[j-i-2]*signals[j-i-1]<=0 ) let( b1 = path[j], b2 = path[j+1], isect = _general_line_intersection([a1,a2],[b1,b2],eps=eps) ) if (isect && isect[1]>=-eps && isect[1]<= 1+eps && isect[2]>= -eps && isect[2]<= 1+eps) [isect[0], i, isect[1], j, isect[2]] ]; function _sum_preserving_round(data, index=0) = index == len(data)-1 ? list_set(data, len(data)-1, round(data[len(data)-1])) : let( newval = round(data[index]), error = newval - data[index] ) _sum_preserving_round( list_set(data, [index,index+1], [newval, data[index+1]-error]), index+1 ); function subdivide_path(path, N, refine, closed=true, exact=true, method="length") = let(path = force_path(path)) assert(is_path(path)) assert(method=="length" || method=="segment") assert(num_defined([N,refine]),"Must give exactly one of N and refine") let( N = !is_undef(N)? N : !is_undef(refine)? len(path) * refine : undef ) assert((is_num(N) && N>0) || is_vector(N),"Parameter N to subdivide_path must be postive number or vector") let( count = len(path) - (closed?0:1), add_guess = method=="segment"? ( is_list(N) ? assert(len(N)==count,"Vector parameter N to subdivide_path has the wrong length") add_scalar(N,-1) : repeat((N-len(path)) / count, count) ) : assert(is_num(N),"Parameter N to subdivide path must be a number when method=\"length\"") let( path_lens = path_segment_lengths(path,closed), add_density = (N - len(path)) / sum(path_lens) ) path_lens * add_density, add = exact? _sum_preserving_round(add_guess) : [for (val=add_guess) round(val)] ) [ for (i=[0:1:count-1]) each lerpn(path[i],select(path,i+1), 1+add[i],endpoint=false), if (!closed) last(path) ]; function subdivide_long_segments(path, maxlen, closed=true) = let(path=force_path(path)) assert(is_path(path)) assert(is_finite(maxlen)) assert(is_bool(closed)) [ for (p=pair(path,closed)) let( steps = ceil(norm(p[1]-p[0])/maxlen) ) each lerpn(p[0], p[1], steps, false), if (!closed) last(path) ]; function resample_path(path, N, spacing, closed=true) = let(path = force_path(path)) assert(is_path(path)) assert(num_defined([N,spacing])==1,"Must define exactly one of N and spacing") assert(is_bool(closed)) let( length = path_length(path,closed), N = is_def(N) ? N-(closed?0:1) : round(length/spacing), distlist = lerpn(0,length,N,false), cuts = _path_cut_points(path, distlist, closed=closed) ) [ each column(cuts,0), if (!closed) last(path) ]; function is_path_simple(path, closed, eps=EPSILON) = is_1region(path) ? is_path_simple(path[0], default(closed,true), eps) : let(closed=default(closed,false)) assert(is_path(path, 2),"Must give a 2D path") assert(is_bool(closed)) [for(i=[0:1:len(path)-(closed?2:3)]) let(v1=path[i+1]-path[i], v2=select(path,i+2)-path[i+1], normv1 = norm(v1), normv2 = norm(v2) ) if (approx(v1*v2/normv1/normv2,-1)) 1 ]  == [] && _path_self_intersections(path,closed=closed,eps=eps) == []; function path_closest_point(path, pt, closed=true) = let(path = force_path(path)) assert(is_path(path), "Input must be a path") assert(is_vector(pt, len(path[0])), "Input pt must be a compatible vector") assert(is_bool(closed)) let( pts = [for (seg=pair(path,closed)) line_closest_point(seg,pt,SEGMENT)], dists = [for (p=pts) norm(p-pt)], min_seg = min_index(dists) ) [min_seg, pts[min_seg]]; function path_tangents(path, closed, uniform=true) = is_1region(path) ? path_tangents(path[0], default(closed,true), uniform) : let(closed=default(closed,false)) assert(is_bool(closed)) assert(is_path(path)) !uniform ? [for(t=deriv(path,closed=closed, h=path_segment_lengths(path,closed))) unit(t)] : [for(t=deriv(path,closed=closed)) unit(t)]; function path_normals(path, tangents, closed) = is_1region(path) ? path_normals(path[0], tangents, default(closed,true)) : let(closed=default(closed,false)) assert(is_path(path,[2,3])) assert(is_bool(closed)) let( tangents = default(tangents, path_tangents(path,closed)), dim=len(path[0]) ) assert(is_path(tangents) && len(tangents[0])==dim,"Dimensions of path and tangents must match") [ for(i=idx(path)) let( pts = i==0 ? (closed? select(path,-1,1) : select(path,0,2)) : i==len(path)-1 ? (closed? select(path,i-1,i+1) : select(path,i-2,i)) : select(path,i-1,i+1) ) dim == 2 ? [tangents[i].y,-tangents[i].x] : let( v=cross(cross(pts[1]-pts[0], pts[2]-pts[0]),tangents[i])) assert(norm(v)>EPSILON, "3D path contains collinear points") unit(v) ]; function path_curvature(path, closed) = is_1region(path) ? path_curvature(path[0], default(closed,true)) : let(closed=default(closed,false)) assert(is_bool(closed)) assert(is_path(path)) let( d1 = deriv(path, closed=closed), d2 = deriv2(path, closed=closed) ) [ for(i=idx(path)) sqrt( sqr(norm(d1[i])*norm(d2[i])) - sqr(d1[i]*d2[i]) ) / pow(norm(d1[i]),3) ]; function path_torsion(path, closed=false) = assert(is_path(path,3), "Input path must be a 3d path") assert(is_bool(closed)) let( d1 = deriv(path,closed=closed), d2 = deriv2(path,closed=closed), d3 = deriv3(path,closed=closed) ) [ for (i=idx(path)) let( crossterm = cross(d1[i],d2[i]) ) crossterm * d3[i] / sqr(norm(crossterm)) ]; function _path_cut_points(path, dists, closed=false, direction=false) = let(long_enough = len(path) >= (closed ? 3 : 2)) assert(long_enough,len(path)<2 ? "Two points needed to define a path" : "Closed path must include three points") is_num(dists) ? _path_cut_points(path, [dists],closed, direction)[0] : assert(is_vector(dists)) assert(is_increasing(dists), "Cut distances must be an increasing list") let(cuts = _path_cut_points_recurse(path,dists,closed)) !direction ? cuts : let( dir = _path_cuts_dir(path, cuts, closed), normals = _path_cuts_normals(path, cuts, dir, closed) ) hstack(cuts, list_to_matrix(dir,1), list_to_matrix(normals,1)); function _path_cut_points_recurse(path, dists, closed=false, pind=0, dtotal=0, dind=0, result=[]) = dind == len(dists) ? result : let( lastpt = len(result)==0? [] : last(result)[0], dpartial = len(result)==0? 0 : norm(lastpt-select(path,pind)), nextpoint = dists[dind] < dpartial+dtotal ? [lerp(lastpt,select(path,pind),(dists[dind]-dtotal)/dpartial),pind] : _path_cut_single(path, dists[dind]-dtotal-dpartial, closed, pind) ) _path_cut_points_recurse(path, dists, closed, nextpoint[1], dists[dind],dind+1, concat(result, [nextpoint])); function _path_cut_single(path, dist, closed=false, ind=0, eps=1e-7) = ind==len(path)-(closed?0:1) ? assert(dist<eps,"Path is too short for specified cut distance") [select(path,ind),ind+1] :let(d = norm(path[ind]-select(path,ind+1))) d > dist ? [lerp(path[ind],select(path,ind+1),dist/d), ind+1] : _path_cut_single(path, dist-d,closed, ind+1, eps); function _path_cuts_normals(path, cuts, dirs, closed=false) = [for(i=[0:len(cuts)-1]) len(path[0])==2? [-dirs[i].y, dirs[i].x] : let( plane = len(path)<3 ? undef : let(start = max(min(cuts[i][1],len(path)-1),2)) _path_plane(path, start, start-2) ) plane==undef? ( dirs[i].x==0 && dirs[i].y==0 ? [1,0,0] : unit([-dirs[i].y, dirs[i].x,0])) : unit(cross(dirs[i],cross(plane[0],plane[1]))) ]; function _path_plane(path, ind, i,closed) = i<(closed?-1:0) ? undef : !is_collinear(path[ind],path[ind-1], select(path,i))? [select(path,i)-path[ind-1],path[ind]-path[ind-1]] : _path_plane(path, ind, i-1); function _path_cuts_dir(path, cuts, closed=false, eps=1e-2) = [for(ind=[0:len(cuts)-1]) let( zeros = path[0]*0, nextind = cuts[ind][1], nextpath = unit(select(path, nextind+1)-select(path, nextind),zeros), thispath = unit(select(path, nextind) - select(path,nextind-1),zeros), lastpath = unit(select(path,nextind-1) - select(path, nextind-2),zeros), nextdir = nextind==len(path) && !closed? lastpath : (nextind<=len(path)-2 || closed) && approx(cuts[ind][0], path[nextind],eps) ? unit(nextpath+thispath) : (nextind>1 || closed) && approx(cuts[ind][0],select(path,nextind-1),eps) ? unit(thispath+lastpath) :  thispath ) nextdir ]; function path_cut(path,cutdist,closed) = is_num(cutdist) ? path_cut(path,[cutdist],closed) : is_1region(path) ? path_cut(path[0], cutdist, default(closed,true)): let(closed=default(closed,false)) assert(is_bool(closed)) assert(is_vector(cutdist)) assert(last(cutdist)<path_length(path,closed=closed),"Cut distances must be smaller than the path length") assert(cutdist[0]>0, "Cut distances must be strictly positive") let( cutlist = _path_cut_points(path,cutdist,closed=closed) ) _path_cut_getpaths(path, cutlist, closed); function _path_cut_getpaths(path, cutlist, closed) = let( cuts = len(cutlist) ) [ [ each list_head(path,cutlist[0][1]-1), if (!approx(cutlist[0][0], path[cutlist[0][1]-1])) cutlist[0][0] ], for(i=[0:1:cuts-2]) cutlist[i][0]==cutlist[i+1][0] && cutlist[i][1]==cutlist[i+1][1] ? [] : [ if (!approx(cutlist[i][0], select(path,cutlist[i][1]))) cutlist[i][0], each slice(path, cutlist[i][1], cutlist[i+1][1]-1), if (!approx(cutlist[i+1][0], select(path,cutlist[i+1][1]-1))) cutlist[i+1][0], ], [ if (!approx(cutlist[cuts-1][0], select(path,cutlist[cuts-1][1]))) cutlist[cuts-1][0], each select(path,cutlist[cuts-1][1],closed ? 0 : -1) ] ]; function _cut_to_seg_u_form(pathcut, path, closed) = let(lastind = len(path) - (closed?0:1)) [for(entry=pathcut) entry[1] > lastind ? [lastind,0] : let( a = path[entry[1]-1], b = path[entry[1]], c = entry[0], i = max_index(v_abs(b-a)), factor = (c[i]-a[i])/(b[i]-a[i]) ) [entry[1]-1,factor] ]; function split_path_at_self_crossings(path, closed=true, eps=EPSILON) = let(path = force_path(path)) assert(is_path(path,2), "Must give a 2D path") assert(is_bool(closed)) let( path = cleanup_path(path, eps=eps), isects = deduplicate( eps=eps, concat( [[0, 0]], sort([ for ( a = _path_self_intersections(path, closed=closed, eps=eps), ss = [ [a[1],a[2]], [a[3],a[4]] ] ) if (ss[0] != undef) ss ]), [[len(path)-(closed?1:2), 1]] ) ) ) [ for (p = pair(isects)) let( s1 = p[0][0], u1 = p[0][1], s2 = p[1][0], u2 = p[1][1], section = _path_select(path, s1, u1, s2, u2, closed=closed), outpath = deduplicate(eps=eps, section) ) if (len(outpath)>1) outpath ]; function _tag_self_crossing_subpaths(path, nonzero, closed=true, eps=EPSILON) = let( subpaths = split_path_at_self_crossings( path, closed=true, eps=eps ) ) [ for (subpath = subpaths) let( seg = select(subpath,0,1), mp = mean(seg), n = line_normal(seg) / 2048, p1 = mp + n, p2 = mp - n, p1in = point_in_polygon(p1, path, nonzero=nonzero) >= 0, p2in = point_in_polygon(p2, path, nonzero=nonzero) >= 0, tag = (p1in && p2in)? "I" : "O" ) [tag, subpath] ]; function polygon_parts(poly, nonzero=false, eps=EPSILON) = let(poly = force_path(poly)) assert(is_path(poly,2), "Must give 2D polygon") assert(is_bool(nonzero)) let( poly = cleanup_path(poly, eps=eps), tagged = _tag_self_crossing_subpaths(poly, nonzero=nonzero, closed=true, eps=eps), kept = [for (sub = tagged) if(sub[0] == "O") sub[1]], outregion = _assemble_path_fragments(kept, eps=eps) ) outregion; function _extreme_angle_fragment(seg, fragments, rightmost=true, eps=EPSILON) = !fragments? [undef, []] : let( delta = seg[1] - seg[0], segang = atan2(delta.y,delta.x), frags = [ for (i = idx(fragments)) let( fragment = fragments[i], fwdmatch = approx(seg[1], fragment[0], eps=eps), bakmatch =  approx(seg[1], last(fragment), eps=eps) ) [ fwdmatch, bakmatch, bakmatch? reverse(fragment) : fragment ] ], angs = [ for (frag = frags) (frag[0] || frag[1])? let( delta2 = frag[2][1] - frag[2][0], segang2 = atan2(delta2.y, delta2.x) ) modang(segang2 - segang) : ( rightmost? 999 : -999 ) ], fi = rightmost? min_index(angs) : max_index(angs) ) abs(angs[fi]) > 360? [undef, fragments] : let( remainder = [for (i=idx(fragments)) if (i!=fi) fragments[i]], frag = frags[fi], foundfrag = frag[2] ) [foundfrag, remainder]; function _assemble_a_path_from_fragments(fragments, rightmost=true, startfrag=0, eps=EPSILON) = len(fragments)==0? _finished : let( path = fragments[startfrag], newfrags = [for (i=idx(fragments)) if (i!=startfrag) fragments[i]] ) is_closed_path(path, eps=eps)? ( [path, newfrags] ) : let( seg = select(path,-2,-1), extrema = _extreme_angle_fragment(seg=seg, fragments=newfrags, rightmost=rightmost, eps=eps), foundfrag = extrema[0], remainder = extrema[1] ) is_undef(foundfrag)? ( [path, remainder] ) : is_closed_path(foundfrag, eps=eps)? ( [foundfrag, concat([path], remainder)] ) : let( fragend = last(foundfrag), hits = [for (i = idx(path,e=-2)) if(approx(path[i],fragend,eps=eps)) i] ) hits? ( let( hitidx = last(hits), newpath = list_head(path,hitidx), newfrags = concat(len(newpath)>1? [newpath] : [], remainder), outpath = concat(slice(path,hitidx,-2), foundfrag) ) [outpath, newfrags] ) : let( newpath = concat(path, list_tail(foundfrag)), newfrags = concat([newpath], remainder) ) _assemble_a_path_from_fragments( fragments=newfrags, rightmost=rightmost, eps=eps ); function _assemble_path_fragments(fragments, eps=EPSILON, _finished=[]) = len(fragments)==0? _finished : let( minxidx = min_index([ for (frag=fragments) min(column(frag,0)) ]), result_l = _assemble_a_path_from_fragments( fragments=fragments, startfrag=minxidx, rightmost=false, eps=eps ), result_r = _assemble_a_path_from_fragments( fragments=fragments, startfrag=minxidx, rightmost=true, eps=eps ), l_area = abs(polygon_area(result_l[0])), r_area = abs(polygon_area(result_r[0])), result = l_area < r_area? result_l : result_r, newpath = cleanup_path(result[0]), remainder = result[1], finished = min(l_area,r_area)<eps ? _finished : concat(_finished, [newpath]) ) _assemble_path_fragments( fragments=remainder, eps=eps, _finished=finished );

/* --------- END BOSL2 --------- */
