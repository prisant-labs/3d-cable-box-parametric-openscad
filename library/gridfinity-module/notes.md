# Gridfinity desk module

Sits in a Gridfinity baseplate on a 3 x 2 cell footprint.

**Note:** Gridfinity bottom requires Closed_Post. Total height is Box_Height plus 4.75 mm of feet. The footprint is whole cells, so the base does not round it up.

Printed box envelope: `125.5 x 83.5 x 59.8 mm`

## Parameters

| Parameter | Value |
|---|---|
| `All_Opening_Height` | `30` |
| `All_Opening_Width` | `14` |
| `Box_Depth` | `83.5` |
| `Box_Height` | `55` |
| `Box_Width` | `125.5` |
| `Closed_Post` | `True` |
| `Enable_Gridfinity_Bottom` | `True` |
| `Enable_Gridfinity_Lid_Top` | `True` |

Everything not listed uses the model default.

## Rebuild

```bash
python scripts/build_library.py --only gridfinity-module
```
