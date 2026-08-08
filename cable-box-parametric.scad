/*
Parametric Cable Management Box (OpenSCAD)
Repository: https://github.com/prisant-labs/3d-cable-box-parametric-openscad
License: MIT
SPDX-License-Identifier: MIT

See README.md for usage, docs/PARAMETER_REFERENCE.md for full parameter docs,
and THIRD_PARTY_NOTICES.md for third-party attributions.
*/

// Requires BOSL2: https://github.com/BelfrySCAD/BOSL2
// Install it into your OpenSCAD library folder, or use the single-file bundle
// attached to each GitHub Release, which has BOSL2 inlined and needs nothing.
// BOSL2 is BSD-2-Clause; see THIRD_PARTY_NOTICES.md.
include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

// Fail early and legibly when BOSL2 is missing.
//
// Without this, a missing library produces "Can't open include file" followed by
// a wall of "Ignoring unknown module" warnings, no geometry, and exit code 0.
// Nothing in that says what to install, and the zero exit makes it look like it
// worked. BOSL_VERSION comes from BOSL2 itself, so its absence is the signal.
assert(!is_undef(BOSL_VERSION),
       "BOSL2 is not installed, and this model needs it. Either install BOSL2 into your OpenSCAD library folder (see the README), or download the standalone bundle attached to any release, which has BOSL2 inlined and needs nothing.");

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
// Seam joint style. Snap is a real cantilever clip; Tab is the original friction fit.
Clip_Style = "Tab"; //["Tab", "Snap"]

/*[Slicing - Snap Clip Tuning]*/
// Only used when Clip_Style is Snap.
// How far the clip travels into its socket (mm). Must exceed half of Clip_Tab_Width.
Clip_Snap_Length = 8;
// Depth of the engagement bump that resists pull-out (mm). Larger holds harder.
Clip_Snap = 0.4;
// Thickness of the clip arm (mm). Too thin snaps off, too thick will not flex.
Clip_Arm_Thickness = 1.0;
// Extra width on the clip ears for a tighter fit (mm).
Clip_Compression = 0.1;
// Make the joint effectively permanent once assembled.
Clip_Lock = false;

/*[Gridfinity]*/
// Add a Gridfinity base under the box so it drops into a 42mm baseplate.
Enable_Gridfinity_Bottom = false;
// Add a Gridfinity baseplate on top of the lid, so bins or another box sit on
// the closed box. Adds 4.75mm to the closed height.
Enable_Gridfinity_Lid_Top = false;
// Fit clearance on Gridfinity mating profiles (mm). Increase if the fit is tight.
Gridfinity_Profile_Clearance = 0.25;
// Keepout from the model edges before the first cell (mm). Avoids thin corners.
Gridfinity_Edge_Keepout = 4;
// Add magnet pockets (and screw holes, bottom base only) to Gridfinity
// features. The lid gets pockets without screw holes: a through hole there
// would breach the closed box.
Enable_Gridfinity_Magnet_Screw = false;
// Magnet pocket diameter (mm).
Gridfinity_Magnet_Diameter = 6.2;
// Magnet pocket depth (mm).
Gridfinity_Magnet_Depth = 2.4;
// Through screw hole diameter (mm).
Gridfinity_Screw_Diameter = 3.2;

/* [Hidden] */

// ---- Gridfinity specification constants ----
// These describe the Gridfinity standard itself rather than a user preference,
// so they are hidden from the Customizer: changing one produces a part that no
// longer mates with anyone else's Gridfinity gear. They remain overridable with
// -D or a parameter set for anyone who genuinely needs to.
// Gridfinity is by Zack Freedman and is MIT licensed. See THIRD_PARTY_NOTICES.md.
GF_PITCH               = 42;    // grid spacing
GF_BASE_HEIGHT         = 4.75;  // height the base profile adds below the box
GF_BASE_CELL           = 41.5;  // outer square of one base cell
GF_CAVITY_ENTRY_SIZE   = 39.4;  // lower (wider) mating cavity
GF_CAVITY_UPPER_SIZE   = 37.2;  // upper (narrower) mating cavity
GF_CAVITY_ENTRY_DEPTH  = 3.2;
GF_CAVITY_TOTAL_DEPTH  = 4.3;
// Baseplate slab added to the lid's exposed face. The mating sockets cut into
// it reuse GF_CAVITY_* above, because a socket on the lid and the mating cavity
// under the box are the same feature: both accept a Gridfinity foot.
// Thicker than GF_CAVITY_TOTAL_DEPTH so material remains under each socket.
GF_LIDTOP_PLATE_HEIGHT = 4.75;
GF_HOLE_OFFSET         = 13;    // magnet/screw offset from cell centre
GF_MIN_FLOOR           = 0.8;   // solid material kept above magnet pockets
GF_SCREW_CBORE_DIA     = 6.5;
GF_SCREW_CBORE_DEPTH   = 2.2;
// Model version. Must match the git tag and the top CHANGELOG.md section on a
// release build; CI enforces that. Echoed at render so an exported STL can be
// traced back to the source that produced it, which matters for a model
// distributed as loose files.
Model_Version = "2.0.0";
echo(str("cable-box-parametric ", Model_Version));

// Render the model when this file is opened or included. Set false (usually via
// -D on the command line) to use the file as a library: the modules and anchors
// become available without geometry appearing, so you can attach to m_box() and
// m_lid_part() from your own file.
Render_On_Include = true;

$fn = 40;
// SPACER breaks tangency on a CUT: a cut that stops exactly on a face leaves a
// zero-thickness edge. WELD is the opposite case, joining two solids that would
// otherwise meet on a shared plane with no overlap. Whether such a pair fuses
// into one body is kernel-dependent, and when it does not you get a detached
// part that looks correct on screen and fails in a slicer. Both are buried
// inside the part and invisible in the print.
SPACER=0.04;
WELD=0.2;

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

// Gap to leave between pieces in the all-slices preview.
//
// Slice_Preview_Spacing is the gap the user asked for, but a clip protrudes
// past its slice edge into that gap. A snap clip travels far enough
// (Clip_Snap_Length, default 8) to cross the default 5 mm spacing and touch the
// neighbouring piece, fusing the preview into one body: visually confusing, and
// it makes a solid count meaningless.
//
// Only Snap gets the extra allowance, so Tab previews lay out exactly as they
// did before. This affects preview layout only; a single-piece export is
// unchanged either way.
Slice_Preview_Gap = Slice_Preview_Spacing +
    (Clip_Style == "Snap" ? Clip_Snap_Length : 0);

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

// ---- Gridfinity derived values ----

// Lid footprint, needed to lay cells out on the lid top.
Lid_Outer_Width = Box_Width + Wall_Thickness*2 + Lid_Lip_Gap;
Lid_Outer_Depth = Box_Depth + Wall_Thickness*2 + Lid_Lip_Gap;

// Which lid face ends up on top when the box is closed.
//
// The lid is modelled as it prints: a solid panel spanning z 0..Lid_Height,
// then an engagement lip ring from Lid_Height to Lid_Height+Lid_Lip_Gap_Height
// that exists only around the perimeter. That lip is what drops onto the box,
// so in use the lid is inverted and the panel's z=0 face is the exposed top.
//
// Gridfinity features therefore grow DOWNWARD from z=0, and the lid is lifted
// by their height at render time, exactly as the box is lifted over its base.
// Putting them at Lid_Height+Lid_Lip_Gap_Height instead would bury them inside
// the closed box, on the mating face.
GF_LID_TOTAL_HEIGHT = GF_LIDTOP_PLATE_HEIGHT;

// How many whole 42 mm cells fit across a span once the edge keepout is taken
// off both sides. Arbitrary box sizes rarely land on a grid multiple, so the
// array is clipped and centred rather than forcing the user's dimensions.
function gf_cell_count(span) = max(0, floor((span - 2 * Gridfinity_Edge_Keepout) / GF_PITCH));
function gf_cell_start(count) = -(count - 1) * GF_PITCH / 2;

GF_Bottom_Cells_X = Enable_Gridfinity_Bottom ? gf_cell_count(Box_Width) : 0;
GF_Bottom_Cells_Y = Enable_Gridfinity_Bottom ? gf_cell_count(Box_Depth) : 0;
GF_Lid_Cells_X    = Enable_Gridfinity_Lid_Top ? gf_cell_count(Lid_Outer_Width) : 0;
GF_Lid_Cells_Y    = Enable_Gridfinity_Lid_Top ? gf_cell_count(Lid_Outer_Depth) : 0;

GF_Bottom_Active = GF_Bottom_Cells_X > 0 && GF_Bottom_Cells_Y > 0;
GF_Lid_Active    = GF_Lid_Cells_X > 0 && GF_Lid_Cells_Y > 0;

// The base is ADDED below the box rather than carved out of the floor, so
// Box_Height keeps meaning "the box body" and enabling Gridfinity never
// silently steals interior height. Carving instead would require a separate
// Floor_Thickness threaded through stabilizer, bottom-opening, clip, and post
// placement, all of which currently treat Wall_Thickness as "the floor".
//
// The whole box is then lifted by this offset at render time so the printed
// object still sits on z=0 and "opening flush with the box bottom" keeps
// meaning what it says.
//
// Gated on GF_Bottom_Active: with no cells there is nothing under the box, and
// lifting it anyway would leave it floating.
Gridfinity_Base_Offset = GF_Bottom_Active ? GF_BASE_HEIGHT : 0;
Gridfinity_Lid_Offset  = GF_Lid_Active ? GF_LID_TOTAL_HEIGHT : 0;

// A box too small for even one cell is a silent no-op otherwise.
if (Enable_Gridfinity_Bottom && !GF_Bottom_Active)
    echo(str("Gridfinity bottom enabled but no 42mm cell fits in ",
             Box_Width, " x ", Box_Depth,
             " with a ", Gridfinity_Edge_Keepout, "mm keepout; base omitted"));
if (Enable_Gridfinity_Lid_Top && !GF_Lid_Active)
    echo(str("Gridfinity lid top enabled but no 42mm cell fits in ",
             Lid_Outer_Width, " x ", Lid_Outer_Depth,
             " with a ", Gridfinity_Edge_Keepout, "mm keepout; studs omitted"));

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
assert(Clip_Style == "Tab" || Clip_Style == "Snap", "Clip_Style must be Tab or Snap");
assert(Clip_Style != "Snap" || Clip_Snap > 0, "Clip_Snap must be > 0 for snap clips");
// rabbit_clip cannot build an arm shorter than half its width; it aborts with an
// internal message that names neither parameter. Catch it here instead. Measured
// against BOSL2 2.0.747: the floor is exactly Clip_Tab_Width/2, and comfortable
// flex wants noticeably more.
assert(Clip_Style != "Snap" || Clip_Snap_Length > Clip_Tab_Width / 2, "Clip_Snap_Length must exceed half of Clip_Tab_Width; a snap clip needs travel to flex. Try Clip_Snap_Length >= Clip_Tab_Width * 0.8, or reduce Clip_Tab_Width.");
assert(Clip_Style != "Snap" || Clip_Arm_Thickness > 0, "Clip_Arm_Thickness must be > 0 for snap clips");
assert(Clip_Style != "Snap" || Clip_Compression >= 0, "Clip_Compression must be >= 0");
assert(Clip_Style != "Snap" || Clip_Arm_Thickness * 2 < Clip_Tab_Width, "Clip_Arm_Thickness is too large for Clip_Tab_Width; the arm would fill the clip");
assert(!(Enable_Gridfinity_Bottom && Enable_Bottom_Openings), "Gridfinity bottom and bottom openings are mutually exclusive; the base would cover the cutouts");
assert(!Enable_Gridfinity_Bottom || !Enable_Post || Closed_Post, "Gridfinity bottom requires Closed_Post=true; the base would block an open post bore");
assert(Gridfinity_Profile_Clearance >= 0, "Gridfinity_Profile_Clearance must be >= 0");
assert(Gridfinity_Edge_Keepout >= 0, "Gridfinity_Edge_Keepout must be >= 0");
assert(!Enable_Gridfinity_Lid_Top || Lid_Height + Lid_Lip_Gap_Height > 0, "Lid is too thin for the lid-top Gridfinity interface");
assert(!Enable_Gridfinity_Magnet_Screw || GF_HOLE_OFFSET < GF_PITCH/2, "Gridfinity hole offset must fit inside one cell");
assert(!Enable_Gridfinity_Magnet_Screw || Gridfinity_Magnet_Diameter > 0, "Gridfinity_Magnet_Diameter must be > 0");

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

// Seam clips come in two styles.
//
// "Tab" is the original: a rectangle in a slightly larger rectangular hole,
// held by friction alone. Clip_Tolerance is the only tuning knob and it trades
// "will not go in" against "falls apart" with nothing in between.
//
// "Snap" uses BOSL2's rabbit_clip, a real cantilever snap with an engagement
// bump. The arm flexes, so it absorbs print inaccuracy instead of jamming, and
// the bump resists pull-out rather than relying on interference.
//
// The clips protrude along X, across the seam. rabbit_clip builds its pin
// pointing UP with width on X and depth on Y, so it needs both orient and spin:
//
//   orient=RIGHT           puts length (travel) on X
//   spin=90                puts width on Y (along the seam) and depth on Z
//
// orient alone leaves width on Z, giving a clip 10 mm tall and 3 mm along the
// seam instead of the reverse. That renders cleanly and passes a solid count,
// so it is only caught by measuring the bounding box.

// A socket must be deeper than its pin or insertion binds at the bottom.
CLIP_SOCKET_EXTRA_DEPTH = 0.4;

module m_floor_clip_male() {
    if (Clip_Style == "Snap") {
        rabbit_clip(type = "pin",
                    length = Clip_Snap_Length,
                    width = Clip_Tab_Width,
                    depth = Clip_Tab_Height,
                    thickness = Clip_Arm_Thickness,
                    snap = Clip_Snap,
                    compression = Clip_Compression,
                    lock = Clip_Lock,
                    anchor = BOTTOM, orient = RIGHT, spin = 90);
    } else {
        cube([Clip_Tab_Depth, Clip_Tab_Width, Clip_Tab_Height], center=true);
    }
}

module m_floor_clip_female() {
    if (Clip_Style == "Snap") {
        rabbit_clip(type = "socket",
                    length = Clip_Snap_Length,
                    width = Clip_Tab_Width,
                    depth = Clip_Tab_Height + CLIP_SOCKET_EXTRA_DEPTH,
                    thickness = Clip_Arm_Thickness,
                    snap = Clip_Snap,
                    compression = 0,
                    clearance = Clip_Tolerance,
                    lock = Clip_Lock,
                    anchor = BOTTOM, orient = RIGHT, spin = 90);
    } else {
        cube([Clip_Tab_Depth + Clip_Tolerance*2 + SPACER,
              Clip_Tab_Width + Clip_Tolerance*2,
              Clip_Tab_Height + Clip_Tolerance*2 + SPACER], center=true);
    }
}

module m_place_floor_clips(x_pos, is_male) {
    z_pos = Wall_Thickness / 2;
    usable_depth = Box_Depth - Wall_Thickness*2 - Clip_Tab_Width;
    female_depth = Clip_Tab_Depth + Clip_Tolerance*2 + SPACER;
    // Offsets intentionally overlap seam slightly to avoid tangent-only booleans.
    //
    // The two styles anchor differently and cannot share these numbers. A Tab is
    // a CENTRED cube, so half its depth is subtracted to bring its near face back
    // to the seam. A Snap clip is BASE-anchored: its geometry starts at the
    // placement point and grows away from the slice, so the same offset would
    // leave the pin floating in the gap with nothing to bond to.
    //
    // That is not hypothetical. It shipped working against BOSL2 2.0.716 purely
    // because that version placed the anchor 4.19 mm further back; under the
    // pinned 2.0.747 the pin detaches and the slice exports in three pieces.
    male_x_offset = Clip_Style == "Snap"
        ? -WELD                              // start inside the slice and grow out
        : Clip_Tab_Depth/2 - SPACER;
    female_x_offset = Clip_Style == "Snap"
        ? -SPACER                            // cut from the seam inward
        : female_depth/2 - SPACER;
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
    // SPACER sinks the clip so its top face is NOT coplanar with the top of the
    // lid panel. Flush, the two faces merge into one facet on the slice seam
    // whose straight boundary then carries the clip's corners as extra
    // collinear vertices, and OpenSCAD's tessellator fans across them into
    // zero-area triangles. Four of them per sliced lid piece, which are valid
    // enough for a slicer but make CGAL assert on re-import: every point probe
    // against an exported sliced lid returned a confident wrong answer.
    // Male and female clips share this offset, so the fit is unchanged, and
    // 0.04 mm is a fifth of a typical layer, so the print is too.
    z_pos = Lid_Height - Clip_Tab_Height/2 - SPACER;
    lid_depth = Box_Depth + Wall_Thickness*2 + Lid_Lip_Gap;
    usable_depth = lid_depth - Clip_Tab_Width*2;
    female_depth = Clip_Tab_Depth + Clip_Tolerance*2 + SPACER;
    // Offsets intentionally overlap seam slightly to avoid tangent-only booleans.
    //
    // The two styles anchor differently and cannot share these numbers. A Tab is
    // a CENTRED cube, so half its depth is subtracted to bring its near face back
    // to the seam. A Snap clip is BASE-anchored: its geometry starts at the
    // placement point and grows away from the slice, so the same offset would
    // leave the pin floating in the gap with nothing to bond to.
    //
    // That is not hypothetical. It shipped working against BOSL2 2.0.716 purely
    // because that version placed the anchor 4.19 mm further back; under the
    // pinned 2.0.747 the pin detaches and the slice exports in three pieces.
    male_x_offset = Clip_Style == "Snap"
        ? -WELD                              // start inside the slice and grow out
        : Clip_Tab_Depth/2 - SPACER;
    female_x_offset = Clip_Style == "Snap"
        ? -SPACER                            // cut from the seam inward
        : female_depth/2 - SPACER;
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
// GRIDFINITY INTERFACES
// ============================================
//
// Two independent interfaces, both optional:
//
//   Bottom   a Gridfinity base profile ADDED below the box floor, so the box
//            drops into a standard 42 mm baseplate.
//   Lid top  a Gridfinity baseplate profile on the closed lid, so other
//            Gridfinity bins stack on top of the box. This is the one that
//            turns the lid into usable desk area.
//
// Geometry is self-contained rather than pulling a Gridfinity library, because
// MakerWorld's parametric customizer permits only its own bundled libraries.

// Lays children out on the clipped, centred cell grid for a given footprint.
module m_gridfinity_cells(count_x, count_y) {
    if (count_x > 0 && count_y > 0)
        for (ix = [0:count_x-1])
            for (iy = [0:count_y-1])
                translate([gf_cell_start(count_x) + ix * GF_PITCH,
                           gf_cell_start(count_y) + iy * GF_PITCH,
                           0])
                    children();
}

// Solid stock for the base, sitting directly under the box floor.
//
// It reaches WELD *into* the floor rather than stopping flush against it.
// Two solids that meet on a shared plane with zero overlap are a coplanar-face
// degeneracy: whether they fuse into one body depends on the CSG kernel, and
// when they do not you get a detached part that looks fine on screen and fails
// in a slicer. Overlapping slightly makes the union unambiguous.
module m_gridfinity_bottom_solid() {
    cell = min(GF_BASE_CELL, GF_PITCH - Gridfinity_Profile_Clearance);
    h = GF_BASE_HEIGHT + WELD;
    m_gridfinity_cells(GF_Bottom_Cells_X, GF_Bottom_Cells_Y)
        translate([0, 0, -GF_BASE_HEIGHT + h/2])
            cube([cell, cell, h], center = true);
}

// The two-stage mating cavity cut up into each base cell from below.
module m_gridfinity_bottom_cavities() {
    entry_depth = min(GF_CAVITY_ENTRY_DEPTH, GF_CAVITY_TOTAL_DEPTH - 0.01);
    upper_depth = GF_CAVITY_TOTAL_DEPTH - entry_depth;
    entry_size = GF_CAVITY_ENTRY_SIZE + Gridfinity_Profile_Clearance;
    upper_size = GF_CAVITY_UPPER_SIZE + Gridfinity_Profile_Clearance;

    m_gridfinity_cells(GF_Bottom_Cells_X, GF_Bottom_Cells_Y) {
        translate([0, 0, -GF_BASE_HEIGHT + entry_depth/2])
            cube([entry_size, entry_size, entry_depth + SPACER*2], center = true);

        if (upper_depth > 0.01)
            translate([0, 0, -GF_BASE_HEIGHT + entry_depth + upper_depth/2])
                cube([upper_size, upper_size, upper_depth + SPACER*2], center = true);
    }
}

// Magnet pockets and screw holes, cut downward from the base's top face so
// GF_MIN_FLOOR of material always remains between the pocket and the box floor.
module m_gridfinity_bottom_holes() {
    usable = max(0, GF_BASE_HEIGHT - GF_MIN_FLOOR);
    magnet_depth = min(Gridfinity_Magnet_Depth, usable);
    cbore_depth = min(GF_SCREW_CBORE_DEPTH, usable);

    if (usable > 0.2)
        m_gridfinity_cells(GF_Bottom_Cells_X, GF_Bottom_Cells_Y)
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * GF_HOLE_OFFSET, sy * GF_HOLE_OFFSET, SPACER])
                rotate([180, 0, 0]) {
                    cylinder(d = Gridfinity_Screw_Diameter + Gridfinity_Profile_Clearance,
                             h = usable + SPACER*3);
                    if (cbore_depth > 0.05)
                        cylinder(d = GF_SCREW_CBORE_DIA + Gridfinity_Profile_Clearance,
                                 h = cbore_depth + SPACER*3);
                    if (magnet_depth > 0.05)
                        cylinder(d = Gridfinity_Magnet_Diameter + Gridfinity_Profile_Clearance,
                                 h = magnet_depth + SPACER*3);
                }
}

// Baseplate slab on the lid's exposed face, grown downward from z=0 (see
// GF_LID_TOTAL_HEIGHT above for why that face and that direction).
//
// This is a plate with sockets cut into it, not studs standing proud of it.
// The lid inverts in use, so anything added here ends up pointing at the
// ceiling on a closed box: studs would leave a row of feet nothing can sit on.
// Sockets instead let a Gridfinity bin, or another box's base, drop onto the
// closed lid.
//
// The slab spans the whole lid rather than one square per cell, so the top face
// stays flat and unbroken and no 0.5 mm gaps appear between cells.
module m_gridfinity_lid_top_solid() {
    // Reaches WELD into the lid panel rather than stopping flush against it,
    // for the same coplanar-face reason as the box base.
    translate([0, 0, -GF_LIDTOP_PLATE_HEIGHT])
    cuboid([Box_Width + Wall_Thickness*2 + Lid_Lip_Gap,
            Box_Depth + Wall_Thickness*2 + Lid_Lip_Gap,
            GF_LIDTOP_PLATE_HEIGHT + WELD],
        rounding = Corner_Radius,
        except = [TOP, BOTTOM],
        anchor = [0, 0, -1]);
}

// The two-stage mating socket cut into each cell of that slab, opening on the
// exposed face. Same geometry as the cavity under the box base, so a foot that
// fits one fits the other, and clearance is added rather than subtracted
// because this is the female half.
module m_gridfinity_lid_top_cavities() {
    entry_depth = min(GF_CAVITY_ENTRY_DEPTH, GF_CAVITY_TOTAL_DEPTH - 0.01);
    upper_depth = GF_CAVITY_TOTAL_DEPTH - entry_depth;

    // The mouth is sized from the widest part of a foot, not from
    // GF_CAVITY_ENTRY_SIZE. That constant describes the cavity hollowed *into*
    // the box base, which is the inside of the male half and 39.4 across. A
    // Gridfinity foot is 41.5 at its widest, so a 39.4 mouth would hold every
    // part proud of the plate instead of seating it.
    entry_size = min(GF_BASE_CELL + Gridfinity_Profile_Clearance, GF_PITCH);
    upper_size = GF_CAVITY_UPPER_SIZE + Gridfinity_Profile_Clearance;

    m_gridfinity_cells(GF_Lid_Cells_X, GF_Lid_Cells_Y) {
        translate([0, 0, -GF_LIDTOP_PLATE_HEIGHT + entry_depth/2])
            cube([entry_size, entry_size, entry_depth + SPACER*2], center = true);

        if (upper_depth > 0.01)
            translate([0, 0, -GF_LIDTOP_PLATE_HEIGHT + entry_depth + upper_depth/2])
                cube([upper_size, upper_size, upper_depth + SPACER*2], center = true);
    }
}

// Magnet pockets only, no screw holes. On a real baseplate the screw fastens
// the plate to a surface; here that surface is the closed lid, so a through
// hole would breach the box. Magnets keep their purpose: a bin with magnets
// in its feet snaps onto the closed lid.
//
// Each pocket opens at its socket's floor and reaches AWAY from the socket,
// into the sliver of plate under the floor and on into the lid panel. Cutting
// from the panel interface outward instead (as the stud version did) overlaps
// the socket void: only the 0.45mm between socket and panel would remain as
// pocket, and a 2.4mm magnet glued there would stand proud into the socket
// and hold every foot off the floor.
module m_gridfinity_lid_top_holes() {
    floor_z = -GF_LIDTOP_PLATE_HEIGHT + GF_CAVITY_TOTAL_DEPTH;
    // Depth available: plate under the socket floor plus the panel itself,
    // always keeping GF_MIN_FLOOR of panel solid above the pocket.
    usable = (GF_LIDTOP_PLATE_HEIGHT - GF_CAVITY_TOTAL_DEPTH)
             + Lid_Height - GF_MIN_FLOOR;
    magnet_depth = min(Gridfinity_Magnet_Depth, usable);

    if (magnet_depth > 0.05)
        m_gridfinity_cells(GF_Lid_Cells_X, GF_Lid_Cells_Y)
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * GF_HOLE_OFFSET, sy * GF_HOLE_OFFSET,
                           floor_z - SPACER])
                    cylinder(d = Gridfinity_Magnet_Diameter + Gridfinity_Profile_Clearance,
                             h = magnet_depth + SPACER);
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

                if (GF_Bottom_Active)
                    color("#7A5CFF")
                    m_gridfinity_bottom_solid();
            }
        }

        if (GF_Bottom_Active)
            m_gridfinity_bottom_cavities();

        if (GF_Bottom_Active && Enable_Gridfinity_Magnet_Screw)
            m_gridfinity_bottom_holes();

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

    // Explicit vertical envelope, same reasoning as m_lid_slice: the
    // Gridfinity base hangs Gridfinity_Base_Offset below z=0, and a cutter
    // sized from Box_Height alone only covers it while Box_Height/2 happens
    // to exceed the base height.
    cutter_lo = -Gridfinity_Base_Offset - 1;
    cutter_hi = Box_Height + 1;

    translate([-slice_center_x, 0, 0])
    union() {
        difference() {
            m_box_with_openings();

            if (!is_first_slice) {
                translate([slice_start_x - Box_Width, 0, (cutter_lo + cutter_hi)/2])
                    cube([Box_Width*2, Box_Depth*2, cutter_hi - cutter_lo], center=true);
            }

            if (!is_last_slice) {
                translate([slice_end_x + Box_Width, 0, (cutter_lo + cutter_hi)/2])
                    cube([Box_Width*2, Box_Depth*2, cutter_hi - cutter_lo], center=true);
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
                up(Lid_Height - WELD)
                cyl(d = Post_Diameter + Wall_Thickness,
                    h = Lid_Lip_Gap_Height + WELD, anchor = [0, 0, -1]);
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
                translate([0, 0, Lid_Height - WELD])
                cuboid([Box_Width + Lid_Lip_Gap,
                        Box_Depth + Lid_Lip_Gap,
                        Lid_Lip_Gap_Height + WELD],
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

            if (GF_Lid_Active)
                color("#7A5CFF")
                m_gridfinity_lid_top_solid();
        }

        if (GF_Lid_Active)
            m_gridfinity_lid_top_cavities();

        if (GF_Lid_Active && Enable_Gridfinity_Magnet_Screw)
            m_gridfinity_lid_top_holes();

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

    // The cutters must span the lid's full vertical envelope explicitly. The
    // Gridfinity plate hangs Gridfinity_Lid_Offset below z=0, so a cutter
    // sized from Lid_Height alone stops short of it whenever Lid_Height drops
    // below the plate height: a legal Lid_Height=4.6 left a 0.15mm full-width
    // plate layer welded to every slice, making piece 1 the width of the whole
    // lid and useless on the small bed slicing exists for.
    cutter_lo = -Gridfinity_Lid_Offset - 1;
    cutter_hi = Lid_Height + Lid_Lip_Gap_Height + 1;

    translate([-slice_center_x, 0, 0])
    union() {
        difference() {
            m_lid();

            if (!is_first_slice) {
                translate([slice_start_x - lid_width, 0, (cutter_lo + cutter_hi)/2])
                    cube([lid_width*2, Box_Depth*2, cutter_hi - cutter_lo], center=true);
            }

            if (!is_last_slice) {
                translate([slice_end_x + lid_width, 0, (cutter_lo + cutter_hi)/2])
                    cube([lid_width*2, Box_Depth*2, cutter_hi - cutter_lo], center=true);
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

// The box body is modelled from z=0 up, with any Gridfinity base hanging below
// it in negative z. Lifting the box by that offset here is what keeps the
// exported object sitting on the build plate, and keeps every z-coordinate
// inside the box modules measured from the box floor regardless of whether a
// base is attached. The lid needs no lift: nothing is added below it.
module m_box_placed() {
    up(Gridfinity_Base_Offset) children();
}

module m_lid_placed() {
    up(Gridfinity_Lid_Offset) children();
}

// ============================================
// ATTACHABLE WRAPPERS
// ============================================
//
// m_box() and m_lid_part() expose the box and lid as BOSL2 attachables, so
// things can be placed against a named feature instead of a coordinate
// expression.
//
// This model has shipped two bugs that a named anchor would have made
// unrepresentable:
//
//   v1.1.0  m_opening() put its origin at the shape's centre while the caller
//           assumed the bottom edge, so every opening came out half height.
//   v1.2.0  the Gridfinity lid interface was placed at Lid_Height +
//           Lid_Lip_Gap_Height, which is the MATING face, so it would have been
//           buried inside the closed box.
//
// Both are origin-mismatch bugs, and neither is visible at the call site,
// because the call site is arithmetic with no statement of intent to check
// against. "lid-face" below is the second bug written down once as a name.
//
// These are wrappers, not a rewrite. Internal placement still uses arithmetic
// that is covered by tests; converting it would be a large diff whose main
// output is a different spelling of working code. See
// docs/internal/E-02-P3_attachables.md for that reasoning.

// Total printed envelope, including any Gridfinity base below the box floor.
Box_Total_Height = Box_Height + Gridfinity_Base_Offset;
Lid_Total_Height = Lid_Height + Lid_Lip_Gap_Height + Gridfinity_Lid_Offset;

// Inner face of each wall, at floor level, pointing into the box interior.
function _wall_anchor(name, pos, dir) = named_anchor(name, pos, dir, 0);

module m_box(anchor = BOTTOM, spin = 0, orient = UP) {
    // Anchor positions are expressed in the centred frame attachable() uses,
    // so world z maps to z - Box_Total_Height/2.
    floor_z = Gridfinity_Base_Offset + Wall_Thickness - Box_Total_Height/2;
    rim_z   = Box_Total_Height/2;
    inner_y = Box_Depth/2 - Wall_Thickness;
    inner_x = Box_Width/2 - Wall_Thickness;

    anchors = [
        named_anchor("floor",      [0, 0, floor_z], UP, 0),
        named_anchor("rim",        [0, 0, rim_z],   UP, 0),
        named_anchor("wall-front", [0, -inner_y, floor_z], BACK,  0),
        named_anchor("wall-back",  [0,  inner_y, floor_z], FRONT, 0),
        named_anchor("wall-left",  [-inner_x, 0, floor_z], RIGHT, 0),
        named_anchor("wall-right", [ inner_x, 0, floor_z], LEFT,  0),
        named_anchor("post-top",   [0, 0, rim_z], UP, 0),
    ];

    attachable(anchor, spin, orient,
               size = [Box_Width, Box_Depth, Box_Total_Height],
               anchors = anchors) {
        // attachable() expects its child centred on the origin; the geometry is
        // built sitting on z=0, so drop it by half the envelope.
        down(Box_Total_Height/2) m_box_placed() m_box_with_openings();
        children();
    }
}

module m_lid_part(anchor = BOTTOM, spin = 0, orient = UP) {
    // The lid prints face-down: its solid panel is at the bottom of the model
    // and the engagement lip points up, into the box. So the face that ends up
    // EXPOSED when the box is closed is the model's z=0 face, and anything
    // mounted on it (Gridfinity, labels, feet) grows downward from there.
    anchors = [
        named_anchor("lid-face", [0, 0, -Lid_Total_Height/2], DOWN, 0),
        named_anchor("lip",      [0, 0,  Lid_Total_Height/2], UP,   0),
    ];

    attachable(anchor, spin, orient,
               size = [Lid_Outer_Width, Lid_Outer_Depth, Lid_Total_Height],
               anchors = anchors) {
        down(Lid_Total_Height/2) m_lid_placed() m_lid();
        children();
    }
}

module full_render() {
    if (Enable_Slicing) {
        if (Slice_Piece_To_Render == 0) {
            for (i = [1:Slice_Count]) {
                x_offset = (i - 1) * (Slice_Width + Slice_Preview_Gap) - (Slice_Count - 1) * (Slice_Width + Slice_Preview_Gap) / 2;

                translate([x_offset, 0, 0]) {
                    if (Part_To_Render != "Lid Only") {
                        m_box_placed() m_box_slice(i);
                    }
                    if (Part_To_Render != "Box Only") {
                        lid_slice_width = (Box_Width + Wall_Thickness*2 + Lid_Lip_Gap) / Slice_Count;
                        lid_x_offset = (i - 1) * (lid_slice_width + Slice_Preview_Gap) - (Slice_Count - 1) * (lid_slice_width + Slice_Preview_Gap) / 2;
                        translate([lid_x_offset - x_offset, Box_Depth + 20, 0])
                            m_lid_placed() m_lid_slice(i);
                    }
                }
            }
        } else {
            if (Part_To_Render != "Lid Only") {
                m_box_placed() m_box_slice(Slice_Piece_To_Render);
            }
            if (Part_To_Render != "Box Only") {
                translate([0, Box_Depth + 20, 0])
                    m_lid_placed() m_lid_slice(Slice_Piece_To_Render);
            }
        }
    } else {
        if (Part_To_Render != "Box Only") {
            right((Part_To_Render != "Lid Only") ? Box_Width + 20 : 0)
                m_lid_part();
        }
        if (Part_To_Render != "Lid Only") {
            m_box();
        }
    }
}

if (Render_On_Include) full_render();
