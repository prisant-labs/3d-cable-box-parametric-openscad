# Gridfinity desk module

Sits in a Gridfinity baseplate on a 3 x 2 cell footprint.

**Note:** Gridfinity bottom requires Closed_Post. Total height is Box_Height plus 4.75 mm of base.

Printed box envelope: `140.0 x 100.0 x 59.8 mm`

## Parameters

| Parameter | Value |
|---|---|
| `All_Opening_Height` | `30` |
| `All_Opening_Width` | `14` |
| `Box_Depth` | `100` |
| `Box_Height` | `55` |
| `Box_Width` | `140` |
| `Closed_Post` | `True` |
| `Enable_Gridfinity_Bottom` | `True` |
| `Enable_Gridfinity_Lid_Top` | `True` |

Everything not listed uses the model default.

## Rebuild

```bash
python scripts/build_library.py --only gridfinity-module
```
