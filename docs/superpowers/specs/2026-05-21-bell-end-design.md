# Didgeridoo Bell End — Design Spec

**Date:** 2026-05-21
**Author:** Gilad Nahor
**Status:** Approved (brainstorming) — ready for implementation plan

## Purpose

Add a printable bell end that snap-fits onto the same standard PVC pipe as the existing mouthpiece, completing the PVCdidge instrument as a three-part assembly (mouthpiece + pipe + bell). The bell should:

- Reduce the "plasticky" timbre of bare-PVC pipe ends by providing a smooth flare from the pipe ID outward to a wider radiating mouth.
- Be visually similar to a traditional eucalyptus didgeridoo bell.
- Snap-fit interchangeably onto the same pipe sizes the mouthpiece supports (DN40, DN50, 1½″ Sch 40, custom).
- Reuse the project's existing print-orientation, slicer-trick, and presets infrastructure.

## Acoustic basis

The design follows the same research lineage as the mouthpiece (see `RESEARCH.md`):

- **UNSW / Wolfe** — sharp impedance peaks in the 1–2 kHz band are the strongest predictor of subjectively bad didgeridoos. These peaks are caused by abrupt cross-section changes in the bore. The same physics applies at *both* ends of the pipe; the mouthpiece smooths the cup→pipe transition, and the bell smooths the pipe→radiating-mouth transition.
- **Didge Project (PVC DIY guide)** — calls out flared bell ends and rasp-tapered bell-end interiors as the standard fix for PVC's harsh harmonics. Our printed bell is the support-free, repeatable version of that fix.
- **General horn acoustics** — an exponential flare is the textbook impedance-matching horn shape: every cross-section change is proportional, so there's no localised reflection *along the flare itself*. On a short bell added to a long cylindrical pipe, the bell's job is primarily to **smooth the open-end reflection** (the pipe sees a gradually growing air column instead of an abrupt jump to free space) — not to act as a stand-alone radiating horn. Webster cutoff at defaults is `fc ≈ 430 Hz`, well above the didge fundamental (~75 Hz); the bell helps higher harmonics radiate and softens the bore-end reflection, but doesn't horn-load the drone.
- **Junction discontinuity is real but small.** All flare profiles starting at a cylindrical pipe have a first-derivative discontinuity at the junction (the cylinder's slope is 0, the flare's initial slope is non-zero). The exponential's initial slope `m · r₀ ≈ 0.24` is roughly half of what a comparable cone would have (`≈ 0.47`), and the `offset(r) offset(-r)` smoothing softens the geometric kink further. The honest framing is "exponential has a smaller, smoother-onset junction discontinuity than a cone of comparable mouth diameter" — not "exponential is kink-free." Tractrix improves on exponential at the junction too, by a similar fractional amount, at significant parametric complexity cost — not worth the engineering overhead on this instrument.

A "Bell-end acoustics" subsection has been added to `RESEARCH.md` §1, covering the Webster horn equation, junction-discontinuity comparison between cone/exponential/tractrix profiles, and the Levine–Schwinger end correction.

## Geometry

The bell end uses the **same cross-section / rotate_extrude architecture as the mouthpiece**. The three-piece union pattern is preserved; only the "lip" piece is replaced with a "bell body" piece.

### Top-level pipeline

```
rotate_extrude(angle = slice_view ? slice_angle : 360) {
    cross_section();
}

cross_section() = difference(
    offset(r=R) offset(r=-R) bell_and_rings(),   // smoothed material
    acoustic_slit_polygon                        // sub-nozzle slit (subtractive)
);

bell_and_rings() = union(
    bell_body,           // (1) Exponential flare with rolled rim
    inner_ring_polygon,  // (2) Insert — fits inside the pipe
    outer_ring_polygon   // (3) Sleeve — wraps around the pipe
);
```

### (1) Bell body — dual-exponential flare with rolled rim

Built as a single `polygon()` traced in this order:

1. **Inner exponential curve** — `r_in(y) = r_bell_in_start · exp(m_in · y)` sampled at `bell_segments` points from `y=0` to `y=flare_h`. Reaches `r_bell_in_end` at the rim shoulder.
2. **Inner rim fillet** — a quarter-circle arc of radius `rim_r` from `(r_bell_in_end, flare_h)` over to `(r_bell_in_end + rim_r, bell_height)`. Sampled at `rim_segments` points.
3. **Outer rim fillet** — a quarter-circle arc of radius `rim_r` from `(r_bell_out_end - rim_r, bell_height)` down to `(r_bell_out_end, flare_h)`. When `rim_r == bell_wall_top / 2`, the two arcs meet at the rim midpoint, producing a perfect half-pipe rolled lip; when `rim_r < bell_wall_top / 2`, a short flat sits between them at `y = bell_height`.
4. **Outer exponential curve** — `r_out(y) = r_bell_out_start · exp(m_out · y)` sampled top-to-bottom. Starts at `r_pipe_out + sleeve_thickness` at `y=0` (flush with the outer sleeve) and reaches `r_bell_in_end + bell_wall_top` at `y=flare_h`.
5. **Base overlap** — small overlapping strip at `y ∈ [-0.1, 0]` from `r_bell_in_start` to `r_bell_out_start`, sealing the union with the two rings beneath.

`m_in` and `m_out` are computed from the endpoints:
- `m_in  = ln(r_bell_in_end  / r_bell_in_start)  / flare_h`
- `m_out = ln(r_bell_out_end / r_bell_out_start) / flare_h`

The dual-exponential gives a wall that is **thick at the base (~7 mm) and thins to `bell_wall_top` at the rim** — a real-bell look that also helps bed adhesion when printed bell-down, with no abrupt step where the bell meets the sleeve.

### (2) Inner ring (insert) — fits inside the PVC pipe

Polygon identical in dimensions to the mouthpiece's insert, except the **bore is constant** at `r_bell_in_start = r_pipe_in - taper_end_wall` throughout the joint depth — there's no internal cup-taper here because the air column transition happens entirely in the bell flare above.

The outer side keeps the same shape as the mouthpiece insert: vertical wall at `r_pipe_in`, with a steep chamfer (0.5 mm × 2 mm) at the bottom-outer corner to guide the pipe in.

### (3) Outer ring (sleeve) — wraps the PVC pipe

**Identical to the mouthpiece's outer ring.** Same `joint_depth`, `sleeve_thickness`, `tolerance`, `r_pipe_out + 0.5 / -joint_depth` chamfer for pipe guidance. Friction-fit behavior is therefore identical to the mouthpiece.

### Acoustic slit — same sub-nozzle slicer-fill trick

A 6-vertex-strip polygon following the bore at `acoustic_slit_offset` from the air column:

- `y ∈ [-joint_depth + 3, 0]` (inside the insert) — vertical at `r_bell_in_start + acoustic_slit_offset`.
- `y ∈ [0, slit_y_top]` (in the bell flare) — follows the inner exponential, offset radially.
- Capped at `slit_y_top = min(bell_height - 5, flare_h - 2)` so the outer sub-wall stays ≥ 0.8 mm.

The slit is 0.1 mm wide — same as the mouthpiece. Sub-nozzle width forces the slicer to deposit an extra perimeter against the bore wall, giving 100 %-solid plastic next to the air column regardless of infill setting.

## Parameters

### New (bell-specific)

| Parameter | Default | Notes |
|---|---|---|
| `bell_mouth_dia` | 105 mm | Outer-air diameter at the rim. Player-feel/aesthetics knob. |
| `bell_height` | 80 mm | Total flare height above the pipe joint. Shallower than a trumpet bell. |
| `bell_wall_top` | 3.0 mm | Wall thickness at the rim. Base wall is thicker (dual-exponential). |
| `bell_rim_radius` | 1.5 mm | Rolled-rim fillet radius. Clamped to `bell_wall_top / 2`. |
| `bell_segments` | 48 | Polygon samples along each exponential. |
| `rim_segments` | 16 | Samples per 90° of rim arc. |

### Inherited from mouthpiece (identical defaults)

`pipe_size_preset`, `custom_outer_dia`, `custom_inner_dia`, `joint_depth = 20`, `sleeve_thickness = 2.5`, `tolerance = 0.2`, `taper_end_wall = 2.5`, `acoustic_slit = true`, `acoustic_slit_offset = 1.5`, `acoustic_slit_width = 0.1`, `transition_smoothing = 0.1`, `slice_view = false`, `slice_angle = 270`, `$fn = 240`.

### Presets

Same `pipe_size_preset` ternary as the mouthpiece — adding a new pipe size means extending both files in sync. (See `CLAUDE.md` "Presets" section.)

## Invariants worth preserving

These follow the mouthpiece's invariants list and are likewise load-bearing for the bell design:

- **Flat base.** Both rings end at `y = -joint_depth`. The bell body ends at `y = -0.1`. The print-bed-facing face of the part is the rim (if printed bell-down) or the joint base (if printed joint-down). Either way, one continuous flat surface — no support material needed.
- **Chamfer placement.** Same as the mouthpiece — chamfers only on the tube-facing edges (outer edge of the insert, inner edge of the sleeve). Bed-contact edges stay sharp for adhesion.
- **Tolerance applied at the radii** — `r_pipe_in -= tolerance`, `r_pipe_out += tolerance` — printed slot is slightly larger than nominal for an interference fit.
- **Manifold seam at y ≈ 0.** The bell body's base strip (`y = -0.1` to `0`) overlaps the rings (`y = 0.1`) by design. Don't "clean up" these tiny overlaps.
- **`rim_r ≤ bell_wall_top / 2`.** Enforced by `min()`; if the user sets a larger `bell_rim_radius`, it silently clamps. The rim fillet must not exceed half the wall thickness or the two fillets cross and form a knife-edge.
- **Slit envelope inside the flare.** `slit_y_top` is capped at `flare_h - 2` so the slit never enters the rim-fillet region (where the simple radial-offset slit formula would no longer make sense). Asserted.
- **Smoothing radius bounded.** `transition_smoothing ≤ 0.4` — same as the mouthpiece.

## Print orientation

The part is FDM-printable support-free in **two orientations**:

- **Bell-down (recommended)** — rim is the bed face, giving a ~105 mm-diameter solid first-layer footprint with excellent adhesion. Walls slope inward toward the pipe joint (always supported by the layer below). Joint is at the top of the print. Fits any 200 mm+ bed.
- **Joint-down (mouthpiece convention)** — sleeve base is on the bed. Outer wall slopes outward; with the exponential flare the steepest overhang is at the rim, slope `dr/dy = m_out · r_bell_out_end ≈ 0.74` (≈ 36° from vertical) — under the typical 45° support-free limit. First-layer footprint is small (~50 mm dia) so a brim is recommended.

Recommended print settings carry over from the mouthpiece (PETG, ≥4 perimeters, ≥0.2 mm layer, 5–10 mm brim if joint-down). Slit trick remains the safety net for 100 % bore-wall solidity at print services like Slant 3D.

## Sanity checks (asserts in code)

- `bell_mouth_dia > pipe_inner_dia` — bell must flare outward.
- `bell_mouth_dia <= 200` — soft upper bound; beyond this gets unprintable on most consumer beds and is beyond the range any traditional didge uses.
- `bell_wall_top >= 1.5` — printability minimum.
- `taper_end_wall >= 0.4` — printability minimum.
- `bell_height > 2 * rim_r` — must have room for the flare below the fillet.
- (If slit enabled:) wall thickness at `slit_y_top` is at least `acoustic_slit_offset + acoustic_slit_width + 0.8` (= 2.4 mm with defaults) — protects the outer sub-wall.

## File structure

- `didgeridooBellEnd.scad` — the model (new). Sits alongside `didgeridooMouthpiece.scad` in the project root. A working preview already exists from the brainstorming session; it will be polished and made the final version during implementation.
- `RESEARCH.md` — add a bell-end subsection summarising the acoustic basis (exponential horn theory + UNSW impedance-matching argument applied to the radiating end).
- `README.md` — mention the bell end alongside the mouthpiece (parts list, render commands, the print-on-demand link if applicable).
- `CLAUDE.md` — update "Project" intro (now two parts), copy the presets-ternary maintenance note to apply to both files, and add a brief "Architecture" section for the bell mirroring the mouthpiece's.

## Out of scope (future work)

These are deliberately *not* part of the v1 bell:

- **Bell flare profile selector** (cone / exponential / tractrix). Single profile keeps the parameter surface small. Can be added later.
- **Oval rim** — same architectural cost as for the mouthpiece (breaks rotational symmetry).
- **Decorative ribbing or external texture.** Smooth bell only; cosmetic features can come in a remix.
- **Threaded connection** (Modgeridoo-style). Snap-fit only; consistent with the mouthpiece.
- **Direct acoustic measurement** of the printed bell vs. the bare pipe end (UNSW-style input-impedance sweep). Open question across the whole project, listed in `RESEARCH.md` §9.

## Open questions / decisions deferred

- Whether to add a "bell-mouth oval" custom mode using a non-axisymmetric extrusion. Out of scope for v1 but worth a stub note.
- README photo: the project's README does not currently show a photo of the printed bell; one should be added once the part has been printed and assembled.
