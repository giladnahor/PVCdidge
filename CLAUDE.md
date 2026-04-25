# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Single-file OpenSCAD parametric model of a didgeridoo mouthpiece that snap-fits onto standard PVC pipe. Designed for support-free vertical FDM printing (rim up).

- `didgeridooMouthpiece.scad` — the model (only source file)
- `README.md` — public-facing documentation
- `LICENSE` — CC BY-NC 4.0

STLs are gitignored — render the variant you need from source.

## Common commands

Open the customizer GUI:
```bash
openscad didgeridooMouthpiece.scad
```

Render to STL non-interactively:
```bash
openscad -D 'pipe_size_preset="40mm"' -o didgeridoo_40mm.stl didgeridooMouthpiece.scad
```

Override any parameter on the command line:
```bash
openscad -D 'pipe_size_preset="Custom"' -D 'custom_outer_dia=42' -D 'custom_inner_dia=38' \
  -o custom.stl didgeridooMouthpiece.scad
```

Render a partial-revolution slice for inspecting internals:
```bash
openscad -D 'slice_view=true' -D 'slice_angle=270' -o slice.stl didgeridooMouthpiece.scad
```

## Architecture

The model is built as a **2D cross-section rotated 360° via `rotate_extrude`** — not as a 3D solid. This is a deliberate performance choice (the design previously used 3D `minkowski`, which was orders of magnitude slower). When modifying geometry, edit the 2D cross-section; do not reach for 3D primitives unless you have a specific reason.

The top-level pipeline is:

```
rotate_extrude(angle = slice_view ? slice_angle : 360) {
    cross_section();
}

cross_section() = difference(
    offset(r=R) offset(r=-R) lip_and_rings(),   // smoothed material
    acoustic_slit_polygon                       // sub-nozzle slit (subtractive)
);

lip_and_rings() = union(
    lip_hull,           // (1) Top lip — hull of two circles + base square
    inner_ring_polygon, // (2) Inner insert — polygon with cosine-friendly taper
    outer_ring_polygon  // (3) Outer sleeve — polygon
);
```

### Three-piece union

1. **Top lip** — `hull()` of an inner-edge fillet circle (small radius, sharp feel against lips), an outer-edge fillet circle (larger radius, face-comfort), plus a thin base square. Produces an asymmetric rim.
2. **Inner ring (insert)** — `polygon()` that sits *inside* the PVC pipe. The bore wall is vertical at `r=r_mouth` from `y=0` down to `y=-cup_depth`, then tapers conically out to `(r_pipe_in - taper_end_wall)` at `y=-joint_depth`.
3. **Outer ring (sleeve)** — `polygon()` that wraps *outside* the PVC pipe. Together with the insert, sandwiches the pipe wall for an airtight friction fit.

### Two operations on top of the union

- **Smoothing** — `offset(r=R) offset(r=-R)` applied to the union rounds all corners by `transition_smoothing` (0.3 mm default). Both convex (lip-to-sleeve) and concave (cup-to-taper) corners get rounded.
- **Acoustic slit** — a 6-vertex polygon following the bore contour at a small offset (vertical above `y=0`, angled along the taper below) is subtracted from the smoothed material. The slit is sub-nozzle-width (0.1 mm) so it survives the slicer's gap-closing pass but is filled with material at print time, forcing extra perimeter traces along the bore wall.

### Invariants worth preserving

- **Flat base.** Both rings end at `y = -joint_depth`. Don't change one without the other — this is what makes the print support-free.
- **Chamfer placement.** Chamfers (0.5 mm × 2.0 mm steep) live *only on the tube-facing edges* — outer edge of the inner ring, inner edge of the outer ring. They guide the pipe in without compromising bed adhesion.
- **Tolerance is applied at the radii** (`r_pipe_in -= tolerance`, `r_pipe_out += tolerance`) so the printed slot is slightly larger than nominal pipe dimensions for an interference fit.
- **Manifold seam at y ≈ 0.** The lip's base square (`y = -0.1` to `0.1`) overlaps the rings (`y = 0.1`) by design to keep the union watertight after rotate-extrusion. Don't "clean up" these tiny overlaps.
- **Smoothing radius is bounded by thinnest wall.** `transition_smoothing` must stay <= ~0.4 mm or `offset(r=-R)` will erase thin features (insert bottom = `taper_end_wall` mm thick by default).
- **Slit must be enclosed.** The slit polygon must stay strictly inside the lip+insert material — verified by computed `slit_y_bot` (where wall thickness = slit + sub-walls) and constrained by an `assert`.

## Presets

`pipe_size_preset` resolves to `pipe_outer_dia` / `pipe_inner_dia` via a chained ternary. Adding a new standard pipe means extending both ternaries — keep them in sync.

| Preset    | OD (mm) | ID (mm) | Notes                                |
|-----------|---------|---------|--------------------------------------|
| `40mm`    | 40.00   | 36.00   | Metric, 2 mm wall                    |
| `50mm`    | 50.00   | 46.00   | Metric, 2 mm wall                    |
| `1.5inch` | 48.26   | 40.89   | Imperial Schedule 40                 |
| `Custom`  | `custom_outer_dia` | `custom_inner_dia` | Used only when preset is `Custom` |
