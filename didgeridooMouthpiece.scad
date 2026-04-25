/*
 * Didgeridoo Mouthpiece — parametric, snap-fits onto standard PVC pipe.
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
 * Designed for support-free vertical FDM printing (rim up). Provides:
 *   - 40 mm / 50 mm / 1.5" pipe presets, plus custom override
 *   - Asymmetric rim (sharp inner edge for lip vibration, rounded outer
 *     edge for face comfort), thin lip-contact band
 *   - Internal acoustic taper from cup ID to pipe ID, sized for smooth
 *     impedance matching (per UNSW/Wolfe didgeridoo acoustics research)
 *   - Sub-nozzle slit along the bore-adjacent wall to force the slicer
 *     to print 100% solid plastic next to the air column
 *   - Smoothed transitions on inner and outer walls
 *   - Optional partial-revolution slice view for inspecting internals
 *
 * Recommended print settings: PETG, ≥4 perimeters, 100% infill if
 * available (else rely on the slit), ≥0.2 mm layer height, 5–10 mm brim.
 * Finish the rim with beeswax or food-grade epoxy for lip-safe contact.
 */

// --- Presets ---
// Select standard pipe size
pipe_size_preset = "40mm"; // ["40mm", "50mm", "1.5inch", "Custom"]

// --- Custom Dimensions (Only used if "Custom" is selected) ---
custom_outer_dia = 40.0;
custom_inner_dia = 36.0;

// --- General Parameters ---
// Inner diameter of the mouth opening (cup ID). Player consensus: 28-32 mm.
mouth_opening = 30.0;

// Height of the lip rim above the pipe end. 10 mm puts the rim peak in
// the player-consensus range (5-10 mm above the bore) while keeping
// enough body to flare out to the pipe diameter.
lip_height = 10.0;

// --- Rim profile (asymmetric: sharp inside, rounded outside) ---
// Small fillet on the inner edge — keeps lip-vibration freedom.
inner_rim_radius = 0.6;
// Larger fillet on the outer (face-side) edge for comfort.
outer_rim_radius = 2.0;
// Total radial width of the rim from the cup ID to the outer edge of the
// rim top. Must be >= 2 * outer_rim_radius (so the outer fillet does not
// protrude into the cup) and > inner_rim_radius + outer_rim_radius.
lip_top_width = 4.5;

// --- Inner-wall reinforcement slit ---
// When true, a sub-nozzle-width annular slit is subtracted from the lip
// section just outside the bore wall. After rotate-extrude this becomes
// a thin enclosed annular feature inside the material.
//
// The slit is too narrow (0.1 mm default) to print as an air gap, but
// wide enough to survive the slicer's gap-closing pass (typical default
// ~0.05 mm). The slicer detects the slit's two surfaces and lays down
// an extra perimeter trace there, forcing the bore-adjacent wall to be
// 100% solid plastic regardless of the slicer's infill setting. This is
// the acoustically critical wall — it bounds the air column.
//
// Reference: Prusa3D forum thread on tricking the slicer with sub-
// nozzle voids ("Tricking slicer to make 100% fill in certain areas").
acoustic_slit = true;          // [true, false]
acoustic_slit_offset = 1.5;    // distance from bore wall to slit (mm)
acoustic_slit_width = 0.1;     // slit width (mm; sub-nozzle = forces fill)

// --- Internal acoustic taper ---
// Depth of the constant-ID cup BELOW y=0 before the taper begins. Total
// constant-ID length above the taper = lip_height + cup_depth. 0 puts
// the entire joint_depth into the taper for the smoothest impedance
// transition (the "tall bell" geometry).
cup_depth = 0.0;
// Wall thickness of the insert at the bottom of the taper. Trades off
// bed-adhesion (bottom flat = taper_end_wall - 0.5 mm) against the
// impedance step at the pipe entrance (2 * taper_end_wall + 2 *
// tolerance, in diameter). 1.5 mm is a balanced default; drop toward
// 1.0 for cleaner acoustics (with a slicer brim for adhesion).
taper_end_wall = 1.5;

// Depth of the connection rings (both inner and outer share this for a flat base)
joint_depth = 20.0;
sleeve_thickness = 2.5;

// Printer tolerance (increases the gap for the PVC pipe slightly for a better fit)
tolerance = 0.2;

// Resolution. 240 facets per full revolution gives ~1 µm circular
// approximation error at the largest radius — well below FDM print
// precision and noticeably smoother than the OpenSCAD default in the
// preview. Drop to 120 if rendering speed matters more than accuracy.
$fn = 240;

// --- Surface smoothing ---
// Radius of the rounding applied to all corners of the cross-section
// (both the cup-to-taper transition on the bore side and the lip-to-
// sleeve transition on the outer face). Small values look refined
// without compromising the chamfers or thin walls; keep <= 0.4 mm so
// the insert's bottom flat (taper_end_wall - 0.5 mm wide) survives.
transition_smoothing = 0.3;

// --- Slice / cutaway view ---
// When true, the model is rendered as a partial revolution (slice_angle
// degrees) so the cross-section is visible at the cut faces. Useful for
// inspecting the internal acoustic taper, the cup-to-pipe transition,
// and the angled acoustic void inside the lip section. Set false for a
// full 360° print-ready part.
slice_view = false;          // [true, false]
slice_angle = 270;           // [90, 180, 270, 315]

// --- Logic for Presets ---
// 40mm Metric: OD = 40.0mm, ID = 36.0mm (assuming 2mm wall)
// 50mm Metric: OD = 50.0mm, ID = 46.0mm (assuming 2mm wall)
// 1.5" Imperial (Schedule 40): OD = 48.26mm, ID = 40.89mm
pipe_outer_dia = 
    (pipe_size_preset == "40mm") ? 40.0 :
    (pipe_size_preset == "50mm") ? 50.0 :
    (pipe_size_preset == "1.5inch") ? 48.26 :
    custom_outer_dia;

pipe_inner_dia = 
    (pipe_size_preset == "40mm") ? 36.0 :
    (pipe_size_preset == "50mm") ? 46.0 :
    (pipe_size_preset == "1.5inch") ? 40.89 :
    custom_inner_dia;

// --- Calculated Radii ---
r_mouth = mouth_opening / 2;
r_pipe_in = (pipe_inner_dia / 2) - tolerance;
r_pipe_out = (pipe_outer_dia / 2) + tolerance;
t_out = sleeve_thickness;

// --- Sanity checks ---
assert(lip_top_width >= 2 * outer_rim_radius,
       "lip_top_width must be >= 2 * outer_rim_radius (otherwise the outer rim fillet protrudes into the cup)");
assert(lip_top_width > inner_rim_radius + outer_rim_radius,
       "lip_top_width must exceed inner_rim_radius + outer_rim_radius for a well-formed rim");
assert(cup_depth + 2.0 < joint_depth,
       "cup_depth must leave room for the taper and the 2 mm chamfer (cup_depth + 2 < joint_depth)");
assert(taper_end_wall >= 0.4,
       "taper_end_wall must be at least 0.4 mm for printability");
assert(r_pipe_in - taper_end_wall > r_mouth,
       "taper_end_wall is too large: the air channel would narrow at the pipe entrance instead of widening (mouth bigger than pipe ID minus end wall)");
assert(!acoustic_slit || acoustic_slit_offset >= 0.8,
       "acoustic_slit_offset must be >= 0.8 mm (= 2 perimeter widths) so the bore-adjacent sub-wall is fully solid");
assert(!acoustic_slit || acoustic_slit_width >= 0.05 && acoustic_slit_width <= 0.2,
       "acoustic_slit_width should be 0.05-0.2 mm: narrower gets closed by the slicer's gap-closing pass, wider prints as a real void");
assert(!acoustic_slit ||
       r_mouth + acoustic_slit_offset + acoustic_slit_width + 1.0 < r_pipe_out + t_out,
       "acoustic_slit position is too far from the bore — it would penetrate the outer face of the lip section");

// --- Main Render ---
rotate_extrude(angle = slice_view ? slice_angle : 360) {
    cross_section();
}

module cross_section() {
    difference() {
        // Smooth all corners of the lip+insert+sleeve union by
        // transition_smoothing. The double-offset idiom rounds convex
        // corners (lip-to-sleeve outer face, chamfer corners) and fills
        // concave corners (cup-to-taper kink, etc.) by the same radius.
        offset(r=transition_smoothing) offset(r=-transition_smoothing)
            lip_and_rings();

        if (acoustic_slit) {
            // Slit follows the bore contour at acoustic_slit_offset from the
            // air channel surface — vertical along the cup wall (above y=0
            // and through the constant-ID portion at y in [-cup_depth, 0]),
            // then angled along the conical taper from y=-cup_depth down
            // to wherever the wall thins below the printable threshold.
            //
            // 6-vertex polygon: top-outer, top-inner, kink-inner-at-cup-base,
            // bottom-inner-on-taper, bottom-outer-on-taper, kink-outer-at-cup-base.
            slit_d = acoustic_slit_offset;
            slit_w = acoustic_slit_width;
            slit_y_top = lip_height - 2.0;

            // Wall thickness in the taper goes from (r_pipe_in - r_mouth) at
            // y = -cup_depth down to taper_end_wall at y = -joint_depth.
            // Stop the slit where thickness = slit_d + slit_w + 0.8, so the
            // outer sub-wall stays >= 2 perimeter widths.
            insert_top_thick = r_pipe_in - r_mouth;
            insert_bot_thick = taper_end_wall;
            min_wall = slit_d + slit_w + 0.8;
            taper_y_thin =
                (insert_top_thick - insert_bot_thick > 0.001)
                ? -cup_depth - (insert_top_thick - min_wall)
                                / (insert_top_thick - insert_bot_thick)
                                * (joint_depth - cup_depth)
                : -joint_depth + 0.5;
            slit_y_bot = max(taper_y_thin, -joint_depth + 0.5);

            // Bore radius at the slit's bottom — on the taper if we got
            // there, else still on the constant-ID cup.
            bore_y_bot =
                (slit_y_bot < -cup_depth)
                ? r_mouth + (r_pipe_in - taper_end_wall - r_mouth)
                            * (-slit_y_bot - cup_depth)
                            / (joint_depth - cup_depth)
                : r_mouth;

            polygon([
                [r_mouth   + slit_d + slit_w,  slit_y_top],   // top-outer
                [r_mouth   + slit_d,           slit_y_top],   // top-inner
                [r_mouth   + slit_d,          -cup_depth ],   // kink-inner
                [bore_y_bot + slit_d,          slit_y_bot],   // bottom-inner
                [bore_y_bot + slit_d + slit_w, slit_y_bot],   // bottom-outer
                [r_mouth   + slit_d + slit_w, -cup_depth ]    // kink-outer
            ]);
        }
    }
}

module lip_and_rings() {
    union() {
        // 1. Top Lip Section — asymmetric rim (sharp inside, rounded outside)
        hull() {
            // Inner top edge — small fillet for "sharp" feel against the lips
            translate([r_mouth + inner_rim_radius,
                       lip_height - inner_rim_radius])
                circle(r=inner_rim_radius);

            // Outer top edge — larger rounded edge for face comfort
            translate([r_mouth + lip_top_width - outer_rim_radius,
                       lip_height - outer_rim_radius])
                circle(r=outer_rim_radius);

            // Base of the lip (overlapping slightly with rings to ensure manifold geometry)
            translate([r_mouth, -0.1])
                square([r_pipe_out + t_out - r_mouth, 0.2]);
        }

        // 2. Inner Ring (Insert) — internal acoustic taper.
        // Constant-ID cup from y=0 down to y=-cup_depth, then a smooth
        // conical taper to (r_pipe_in - taper_end_wall) at the pipe end.
        // Emulates beeswax acoustic coupling and minimises the impedance
        // step at the pipe entrance.
        polygon([
            [r_mouth,                    0.1],                  // top-inside corner
            [r_mouth,                   -cup_depth],            // bottom of constant-ID cup
            [r_pipe_in - taper_end_wall, -joint_depth],         // bottom of conical taper
            [r_pipe_in - 0.5,           -joint_depth],          // small flat for bed adhesion
            [r_pipe_in,                 -joint_depth + 2.0],    // top of steep chamfer
            [r_pipe_in,                  0.1]                   // outer wall of the insert
        ]);
        
        // 3. Outer Ring (Sleeve)
        polygon([
            [r_pipe_out, 0.1],                       // Inner wall top
            [r_pipe_out, -joint_depth + 2.0],        // Straight down inner wall to start of steep chamfer
            [r_pipe_out + 0.5, -joint_depth],        // Steep chamfer to guide PVC pipe inside
            [r_pipe_out + t_out, -joint_depth],      // Extended flat bottom edge for max bed adhesion
            [r_pipe_out + t_out, 0.1]                // Outer wall top
        ]);
    }
}