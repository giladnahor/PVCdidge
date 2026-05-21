/*
 * Didgeridoo Bell End — parametric, snap-fits onto standard PVC pipe.
 *
 * Author:  Gilad Nahor
 * Version: 1.0
 *
 * Copyright (c) 2026 Gilad Nahor
 *
 * Licensed under the Creative Commons Attribution-NonCommercial 4.0
 * International License (CC BY-NC 4.0).
 *
 *   You are free to share and adapt this work for non-commercial
 *   purposes, provided you give appropriate credit. Resale or
 *   commercial distribution of the model or printed parts is NOT
 *   permitted.
 *
 *   Full license text: https://creativecommons.org/licenses/by-nc/4.0/
 *
 * Designed for support-free FDM printing. Mirrors the mouthpiece's
 * three-piece cross-section pattern (bell body + inner insert + outer
 * sleeve), smoothed via the double-offset trick, with the same sub-
 * nozzle slicer-fill slit running along the bore-adjacent wall.
 * Provides:
 *   - 40 mm / 50 mm / 1.5" pipe presets, plus custom override (same as
 *     the mouthpiece — the bell and mouthpiece share a pipe size)
 *   - Exponential bore flare from pipe ID outward to the bell mouth,
 *     for a smooth radiating-end impedance transition (per UNSW/Wolfe
 *     didgeridoo acoustics research)
 *   - Dual-exponential outer profile: thick at the base (~7 mm),
 *     thinning to bell_wall_top at the rim — looks like a real bell
 *     and aids bed adhesion when printed bell-down
 *   - Rolled rim fillet for handle comfort
 *   - Sub-nozzle slit along the bore-adjacent wall to force the slicer
 *     to print 100 % solid plastic next to the air column (same trick
 *     as the mouthpiece)
 *   - Smoothed transitions on inner and outer walls
 *   - Optional partial-revolution slice view for inspecting internals
 *
 * Recommended print: PETG, >=4 perimeters, 100 % infill if available
 * (else rely on the slit), <=0.2 mm layer height. Print bell-down for
 * best bed adhesion (the ~105 mm rim is the natural flat face).
 */

// --- Presets ---
pipe_size_preset = "40mm"; // ["40mm", "50mm", "1.5inch", "Custom"]
custom_outer_dia = 40.0;
custom_inner_dia = 36.0;

// --- Bell geometry ---
// Outer diameter of the bell mouth opening (air column at the rim).
// 105 mm is mid-range for traditional and 3D-printed didgeridoo bells
// (typical 80-150 mm). There is no published study giving an "optimal"
// bell mouth size for didges — larger improves high-harmonic radiation
// and looks more dramatic, but eats filament and bed footprint.
bell_mouth_dia = 105.0;
// Total height of the flare above the pipe-joint plane (y=0). Shallower
// than a trumpet bell — more in line with traditional eucalyptus bells.
bell_height = 80.0;
// Wall thickness at the rim (top). The flare uses two different
// exponentials for inner and outer surfaces, so the wall is thick at
// the base and thins to this value at the rim.
bell_wall_top = 3.0;
// Radius of the rounded rim fillet at the top of the bell. Clamped to
// bell_wall_top/2 — at the cap, the rim becomes a perfect half-pipe.
bell_rim_radius = 1.5;
// Number of polygon vertices along the exponential curve.
bell_segments = 48;
// Number of segments per 90° of the rim fillet arcs.
rim_segments = 16;

// --- Connection (identical to mouthpiece) ---
joint_depth = 20.0;
sleeve_thickness = 2.5;
tolerance = 0.2;
taper_end_wall = 2.5;

// --- Acoustic slit (sub-nozzle, bore-wall reinforcement) ---
acoustic_slit = true;
acoustic_slit_offset = 1.5;
acoustic_slit_width = 0.1;

// --- Surface smoothing ---
transition_smoothing = 0.1;

// --- Slice / cutaway view ---
slice_view = false;          // [true, false]
slice_angle = 270;           // [90, 180, 270, 315]

$fn = 240;

// --- Logic for Presets ---
pipe_outer_dia =
    (pipe_size_preset == "40mm")    ? 40.0   :
    (pipe_size_preset == "50mm")    ? 50.0   :
    (pipe_size_preset == "1.5inch") ? 48.26  :
    custom_outer_dia;

pipe_inner_dia =
    (pipe_size_preset == "40mm")    ? 36.0   :
    (pipe_size_preset == "50mm")    ? 46.0   :
    (pipe_size_preset == "1.5inch") ? 40.89  :
    custom_inner_dia;

// --- Calculated Radii ---
r_pipe_in  = (pipe_inner_dia / 2) - tolerance;
r_pipe_out = (pipe_outer_dia / 2) + tolerance;
t_out      = sleeve_thickness;

r_bell_in_start  = r_pipe_in - taper_end_wall;     // bore at y=0 (matches insert bore)
r_bell_in_end    = bell_mouth_dia / 2;             // bore at y=flare_h (top of flare)
r_bell_out_start = r_pipe_out + t_out;             // outer at y=0 (matches sleeve OD)
r_bell_out_end   = r_bell_in_end + bell_wall_top;  // outer at y=flare_h

// Rim geometry — flare ends at flare_h, fillets carry the wall to y=bell_height.
rim_r   = min(bell_rim_radius, bell_wall_top / 2);
flare_h = bell_height - rim_r;

// Exponential flare constants: r(y) = r0 * exp(m * y), reaching the rim
// shoulder (r_bell_*_end) at y = flare_h.
m_in  = ln(r_bell_in_end  / r_bell_in_start)  / flare_h;
m_out = ln(r_bell_out_end / r_bell_out_start) / flare_h;

// Slit envelope — stays inside the flare region, away from the rim curve.
slit_y_top = min(bell_height - 5.0, flare_h - 2.0);
slit_y_bot = -joint_depth + 3.0;
wall_at_slit_top = r_bell_out_start * exp(m_out * slit_y_top)
                 - r_bell_in_start  * exp(m_in  * slit_y_top);

// --- Sanity checks ---
assert(r_bell_in_end > r_bell_in_start,
       "bell_mouth_dia must exceed pipe inner diameter (the bell must flare outward)");
assert(bell_mouth_dia <= 200,
       "bell_mouth_dia > 200 mm gets unprintable on most consumer beds and is beyond the range any traditional didge uses; check before raising the cap");
assert(bell_wall_top >= 1.5,
       "bell_wall_top must be >= 1.5 mm for printability");
assert(taper_end_wall >= 0.4,
       "taper_end_wall must be at least 0.4 mm for printability");
assert(bell_height > 2 * rim_r,
       "bell_height must exceed 2 * bell_rim_radius (need room for the flare below the fillet)");
assert(!acoustic_slit || wall_at_slit_top >= acoustic_slit_offset + acoustic_slit_width + 0.8,
       "Bell wall too thin near the rim for the acoustic slit. Increase bell_wall_top or shorten bell_height.");

// --- Main Render ---
rotate_extrude(angle = slice_view ? slice_angle : 360) {
    cross_section();
}

module cross_section() {
    difference() {
        offset(r=transition_smoothing) offset(r=-transition_smoothing)
            bell_and_rings();

        if (acoustic_slit)
            slit_polygon();
    }
}

module bell_and_rings() {
    union() {
        bell_body();
        inner_ring();
        outer_ring();
    }
}

// (1) Bell body — dual-exponential flare from sleeve OD (y=0) to the
// rim shoulder (y=flare_h), then a quarter-circle fillet on each side
// up to y=bell_height. The two arcs meet at the centre when
// rim_r == bell_wall_top/2; otherwise there's a small flat between them.
module bell_body() {
    inner_pts = [
        for (i = [0 : bell_segments])
            let (y = i * flare_h / bell_segments)
            [r_bell_in_start * exp(m_in * y), y]
    ];
    // Inner rim fillet: arc from (r_bell_in_end, flare_h) over to
    // (r_bell_in_end + rim_r, bell_height). Start at i=1 to skip the
    // vertex already in inner_pts.
    inner_arc = [
        for (i = [1 : rim_segments])
            let (theta = 180 - 90 * i / rim_segments,
                 cx = r_bell_in_end + rim_r,
                 cy = flare_h)
            [cx + rim_r * cos(theta), cy + rim_r * sin(theta)]
    ];
    // Outer rim fillet: arc from (r_bell_out_end - rim_r, bell_height)
    // down to (r_bell_out_end, flare_h).
    outer_arc = [
        for (i = [0 : rim_segments - 1])
            let (theta = 90 - 90 * i / rim_segments,
                 cx = r_bell_out_end - rim_r,
                 cy = flare_h)
            [cx + rim_r * cos(theta), cy + rim_r * sin(theta)]
    ];
    outer_pts = [
        for (i = [bell_segments : -1 : 0])
            let (y = i * flare_h / bell_segments)
            [r_bell_out_start * exp(m_out * y), y]
    ];
    polygon(concat(
        [[r_bell_in_start,  -0.1]],   // bottom-inside, overlapping inner ring
        inner_pts,                     // up the inner exponential
        inner_arc,                     // inner rim fillet (over the top)
        outer_arc,                     // outer rim fillet (over the top)
        outer_pts,                     // down the outer exponential
        [[r_bell_out_start, -0.1]]    // bottom-outside, overlapping outer sleeve
    ));
}

// (2) Inner ring (insert) — sits inside PVC pipe.
// Bore is constant at r_bell_in_start (matches where the bell flare
// starts), so the air column has no step at the bell/insert junction.
module inner_ring() {
    polygon([
        [r_bell_in_start,  0.1],                  // top-inside
        [r_bell_in_start, -joint_depth],          // bottom-inside
        [r_pipe_in - 0.5, -joint_depth],          // small flat for bed adhesion
        [r_pipe_in,       -joint_depth + 2.0],    // top of steep chamfer
        [r_pipe_in,        0.1]                   // outer wall top
    ]);
}

// (3) Outer ring (sleeve) — identical to mouthpiece sleeve.
module outer_ring() {
    polygon([
        [r_pipe_out,           0.1],
        [r_pipe_out,          -joint_depth + 2.0],
        [r_pipe_out + 0.5,    -joint_depth],
        [r_pipe_out + t_out,  -joint_depth],
        [r_pipe_out + t_out,   0.1]
    ]);
}

// Slit follows the bore profile: vertical at r_bell_in_start through
// the insert (y < 0), then along the inner exponential (y >= 0).
module slit_polygon() {
    slit_d = acoustic_slit_offset;
    slit_w = acoustic_slit_width;
    seg = 32;

    inner_edge = [
        for (i = [0 : seg])
            let (y = slit_y_bot + i * (slit_y_top - slit_y_bot) / seg,
                 r = (y < 0) ? r_bell_in_start
                             : r_bell_in_start * exp(m_in * y))
            [r + slit_d, y]
    ];
    outer_edge = [
        for (i = [seg : -1 : 0])
            let (y = slit_y_bot + i * (slit_y_top - slit_y_bot) / seg,
                 r = (y < 0) ? r_bell_in_start
                             : r_bell_in_start * exp(m_in * y))
            [r + slit_d + slit_w, y]
    ];
    polygon(concat(inner_edge, outer_edge));
}
