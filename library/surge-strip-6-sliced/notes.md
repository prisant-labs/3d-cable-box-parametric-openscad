# Six-outlet strip, split for a 180 mm bed

Same as surge-strip-6, printed in two halves that clip together.

**Note:** Export each half with Slice_Piece_To_Render=1 then 2. The preview STL here shows both halves laid out side by side.

Printed box envelope: `270.0 x 100.0 x 62.6 mm`

## Parameters

| Parameter | Value |
|---|---|
| `All_Opening_Height` | `38` |
| `All_Opening_Width` | `20` |
| `Box_Depth` | `100` |
| `Box_Height` | `62` |
| `Box_Width` | `265` |
| `Clips_Per_Edge` | `3` |
| `Enable_Slicing` | `True` |
| `Slice_Count` | `2` |
| `Stabilizers_Front_Back_Count` | `5` |

Everything not listed uses the model default.

## Rebuild

```bash
python scripts/build_library.py --only surge-strip-6-sliced
```
