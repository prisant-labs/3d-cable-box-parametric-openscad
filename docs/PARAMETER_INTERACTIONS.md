# Parameter Interactions

This page captures interactions that most affect model behavior and print outcomes.

## Side Openings

## Global vs per-side dimensions

- Global: `All_Opening_Width`, `All_Opening_Height`, `All_Opening_Corner_Radius`
- Per-side width/height overrides apply when override value is greater than `0`.
- Per-side corner-radius overrides apply when override value is `>= 0`.

Practical effect:

- Override set to `0` means "inherit global".

Corner-radius behavior:

- `All_Opening_Corner_Radius = -1` keeps fully rounded slot ends.
- Side override radius `>= 0` takes precedence (`0` square, `>0` rounded rectangle).

## Global and local offsets combine

Global offset terms are added to side-local terms, but axis semantics differ by wall.

Implication:

- If placement looks wrong, zero global offsets first and tune side-local offsets independently.

## Stabilizers and Side Openings

Opening-avoid toggles suppress stabilizers that would overlap opening zones:

- `Stabilizer_Avoid_Front_Opening`
- `Stabilizer_Avoid_Back_Opening`
- `Stabilizer_Avoid_Left_Opening`
- `Stabilizer_Avoid_Right_Opening`

Interaction risks:

- High fin counts + wide openings can remove many fins, making spacing appear irregular.

Tuning order:

1. Set opening sizes/positions
2. Set stabilizer count/alignment
3. Use avoid toggles
4. Adjust spacing (`Stabilizer_FB_Spacing`, `Stabilizer_LR_Spacing`) for `Centered`/`Custom`
5. Adjust margins

## Bottom Openings and Center Post

When both are enabled:

- `Enable_Post=true`
- `Enable_Bottom_Openings=true`
- `Bottom_Opening_Avoid_Post=true`
- Tune `Bottom_Opening_Post_Margin` for required clearance around the post.

Openings are split around center clearance.

Interaction risks:

- High opening count plus large post diameter can crowd one side.
- Orientation and axis combinations can make expected spacing non-intuitive.

## Bottom Axis vs Orientation

These are independent controls:

- `Bottom_Opening_Axis`: sequence direction
- `Bottom_Opening_Orientation`: opening rotation

Result:

- You can arrange along X while each slot is rotated along Y, and vice versa.

## Alignment + Margins

Primary and secondary alignments consume margins differently depending on axis.

Examples:

- `Along X`: left/right margins are primary bounds
- `Along Y`: front/back margins are primary bounds

## Slicing and Clip Fit

Key interaction group:

- `Clip_Tolerance`
- `Clip_Tab_Width`
- `Clip_Tab_Depth`
- `Clip_Tab_Height`
- `Clips_Per_Edge`

Behavior:

- Larger tolerance loosens fit.
- More clips improve registration but increase insertion/removal force and cumulative fit error.

Recommended tuning sequence:

1. Keep default clip dimensions
2. Tune `Clip_Tolerance` first
3. Adjust `Clips_Per_Edge` second
4. Adjust tab geometry only if needed

## Slicing Preview vs Single Slice Export

- `Slice_Piece_To_Render = 0`: preview all slices
- `Slice_Piece_To_Render > 0`: exportable single index

Common mistake:

- Exporting with `0` when intent was one printable part.

## Lid Fit Parameters

- `Lid_Lip_Gap` controls mating clearance
- `Lid_Lip_Gap_Height` and `Lid_Height` affect engagement and rigidity

Interaction pattern:

- Tightening `Lid_Lip_Gap` may require small increases in height or stronger cooling control for consistent fit.

## Post and Lid

With `Enable_Post=true`, both box and lid include post-interface geometry.

Interaction implications:

- `Post_Diameter` affects center clearance and mating geometry.
- `Closed_Post` modifies box post cavity behavior but does not remove lid-side post logic.

## Edge Treatment and Gridfinity

Key interaction group:

- `Bottom_Edge_Fillet`
- `Top_Edge_Chamfer`
- `Enable_Gridfinity_Bottom`
- `Enable_Gridfinity_Lid_Top`

Behavior:

- A Gridfinity interface owns the face it sits on, and its profile is
  dimensioned by the Gridfinity standard. Softening that perimeter would move a
  mating surface, so the treatment is suppressed there rather than applied and
  hoped for.
- Suppression is gated on whether an interface actually rendered, not on the
  `Enable_` parameter. A box too small for even one 42 mm cell renders no base,
  and keeps its fillet.
- The box bottom and the lid's exposed face are the two suppressed cases. The
  box rim is never suppressed, because no Gridfinity feature touches it.

## Lid Relief and Side Openings

Key interaction group:

- `Lid_Relief_Style`, `Lid_Relief_On_*`
- `All_Opening_Height`, `Override_Opening_Height_*`, `All_Openings_Up`

Behavior:

- Relief is cut into the lid; openings are cut into the box. At default sizes
  they are nowhere near each other, so most configurations need no thought.
- They meet only when an opening runs to the box rim. Then the relief on that
  wall is dropped: a tab would stand over a hole and a scallop would open into
  it, and neither gives anything to grip.
- The skip is automatic and silent. If a relief you asked for is missing, check
  whether that wall's opening reaches the rim.

## Lid Magnets and Everything Else

Key interaction group:

- `Enable_Lid_Magnets`, `Lid_Magnet_Diameter`, `Lid_Magnet_Wall`
- `Post_Diameter`, `Enable_Slicing`, `Box_Corner_Radius`

Behavior:

- Magnets sit in bosses at the four inside corners. That placement is what keeps
  them clear of everything else: openings sit on wall centres, stabilizers carry
  end margins, the post is central, and slice seams sit at interior x.
- The only collisions left are with the post on a small box, and with the
  opposite corner on a very small one. Both assert rather than merging silently.
- `Box_Corner_Radius` does not need to accommodate the boss. The boss is pushed
  `WELD` into both walls, so it fuses whether or not the rounded corner reaches
  it.

## Quick Diagnostic Matrix

If issue is mostly...

- Opening placement drift: inspect global+local opening offsets.
- Missing stabilizers: inspect opening-avoid toggles and fin count/margins.
- Bottom opening crowding: inspect axis/orientation/post-avoid combination.
- Slice fit too tight/loose: inspect clip tolerance before tab dimensions.
- Lid fit issues: inspect lip gap first, then print-process factors.
