# Under-desk pass-through

A junction box where cables enter one side and leave the other. No post, so the interior is one clear channel.

Printed box envelope: `180.0 x 85.0 x 50.0 mm`

## Parameters

| Parameter | Value |
|---|---|
| `All_Opening_Height` | `34` |
| `All_Opening_Width` | `24` |
| `Box_Depth` | `85` |
| `Box_Height` | `50` |
| `Box_Width` | `180` |
| `Enable_Post` | `False` |
| `Opening_On_Back` | `False` |
| `Opening_On_Front` | `False` |
| `Stabilizers_Front_Back_Count` | `3` |

Everything not listed uses the model default.

## Rebuild

```bash
python scripts/build_library.py --only under-desk-passthrough
```
