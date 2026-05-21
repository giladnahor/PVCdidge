# PVCdidge

**Parametric 3D-printable didgeridoo mouthpiece and bell end that snap-fit onto standard PVC pipe.**

Acoustically tuned, support-free FDM printable, beeswax-finishable. Designed in OpenSCAD with player-research-informed geometry: asymmetric rim, smooth internal taper, and a slicer-aware reinforcement slit that forces the bore-adjacent wall to print fully solid plastic. The bell end uses an exponential flare to smooth the open-end impedance — completing the instrument as a three-part assembly (mouthpiece + pipe + bell).

---

## Don't have a 3D printer?

You can order PVCdidge from [Slant 3D's print-on-demand store](https://teleportpod.com/portals/profile/PVCdidge) — they print in PETG and ship to you. All three pipe-size variants (DN40, DN50, 1.5″ Schedule 40) are listed there.

---

## Quick start

1. Install [OpenSCAD](https://openscad.org/) (free, Linux / macOS / Windows).
2. Open `didgeridooMouthpiece.scad` (and/or `didgeridooBellEnd.scad`). The Customizer panel shows all parameters.
3. Pick your pipe size — `pipe_size_preset` → one of `40mm`, `50mm`, `1.5inch`, or `Custom`. Use the *same* preset for the mouthpiece and bell so both parts fit the same pipe.
4. Press **F6** to render, then **File → Export → as STL**.
5. Print and snap onto your PVC pipe — mouthpiece at one end, bell at the other.

Or render straight from the command line without opening the GUI:

```bash
openscad -D 'pipe_size_preset="40mm"' -o didgeridoo_mouthpiece_40mm.stl didgeridooMouthpiece.scad
openscad -D 'pipe_size_preset="40mm"' -o didgeridoo_bell_40mm.stl       didgeridooBellEnd.scad
```

Pre-rendered STLs are not committed to the repo — render the variant you need from source.

---

## Pipe variants

| Variant | Pipe spec | Mouth ID | Best for |
|---|---|---|---|
| **DN40 PVC** | 40 mm OD / 36 mm ID metric | 30 mm | Beginners, intermediate. Most common metric plumbing pipe in Europe and Asia. |
| **DN50 PVC** | 50 mm OD / 46 mm ID metric | 30 mm | Deeper drone, advanced players. Larger bore = fuller low end. |
| **1.5″ Schedule 40** | 48.26 mm OD / 40.89 mm ID | 30 mm | US makers — fits any hardware-store 1.5″ Schedule 40 pipe. |

Mouth opening stays at 30 mm across all variants — your lips feel the same regardless of pipe size. Only the joint geometry changes to match the pipe.

### Custom pipe sizes

Set `pipe_size_preset = "Custom"` and override `custom_outer_dia` / `custom_inner_dia` for any pipe. The model parametrically adapts the inner insert, outer sleeve, and acoustic taper to the new dimensions.

---

## Why it sounds better than other 3D-printed mouthpieces

- **Internal acoustic taper at the mouthpiece.** The air channel widens smoothly from the 30 mm cup to the pipe ID over the full 20 mm joint depth, instead of stepping abruptly at the pipe entrance. This eliminates the impedance discontinuity that produces the 1–2 kHz "plasticky" peak — the single largest negative quality factor identified in [UNSW didgeridoo acoustics research (Wolfe et al.)](https://www.phys.unsw.edu.au/jw/GoodDidj.html).
- **Exponential flare at the bell.** Same physics, applied to the *other* end: the bell starts at pipe ID and flares exponentially to a ~105 mm mouth, smoothing the radiating-end reflection so the pipe doesn't terminate in an abrupt step to free air. Dual-exponential outer profile makes the bell thick at the base and thin at the rim — strong base + rolled rim that's comfortable to handle.
- **Asymmetric rim profile (mouthpiece).** Sharp 0.6 mm fillet on the inner edge so lips can vibrate freely inside the bore; rounded 2.0 mm fillet on the outer edge for face comfort. Thin 4.5 mm contact band per traditional beeswax-rim norms.
- **Bore-wall reinforcement slit (both parts).** A 0.1 mm sub-nozzle-width slit, parallel to the bore wall, tricks the slicer into laying down extra perimeter traces along the air-column boundary. The wall directly facing the air is forced solid plastic regardless of infill density — even at 15 % infill on a print farm.
- **Smoothed transitions.** Fillets on every corner of the cross-section for a refined finish on both inner bore and outer body.

---

## Print recommendations

| Setting | Recommendation | Notes |
|---|---|---|
| Material | **PETG** preferred, PLA acceptable | PETG is heat-tolerant for cleaning; PLA is brighter acoustically but softens at 60 °C |
| Perimeters / walls | **≥ 4** | Combined with the reinforcement slit, ensures bore-wall is solid plastic |
| Infill | **100 %** if your service exposes the setting; otherwise rely on the slit | The bore-adjacent wall prints solid either way |
| Layer height | **≤ 0.20 mm**; use 0.12 mm on the rim if your slicer has adaptive layers | Smoother layer lines on the lip-contact area |
| Brim | **5–10 mm** | The insert's bottom flat is 1 mm wide — brim helps adhesion |
| Orientation (mouthpiece) | **Rim up**, no supports | The whole design is engineered around this orientation |
| Orientation (bell) | **Bell down** (rim on bed), no supports | ~105 mm flat first layer = excellent adhesion. Joint-down also works but needs a brim |
| Lip finish | **Food-grade beeswax** (or food-safe epoxy) | Don't put bare PETG against your lips for hours; bring beeswax |

---

## Avoid metal-filled or wood-filled filaments
Filaments with additives have lower stiffness and dampen sound. Stick with plain PETG/PLA in any colour.

---

## Customizable parameters

### Mouthpiece — `didgeridooMouthpiece.scad`

- `mouth_opening` — cup ID. 30 mm default; 28–32 mm typical for beginners, up to 35 mm for low-drone advanced players.
- `lip_height` — height of the rim above the pipe. 10 mm default; 5–12 mm reasonable.
- `inner_rim_radius` / `outer_rim_radius` / `lip_top_width` — rim profile.
- `cup_depth` — constant-ID cup below the rim before the taper begins. 0 by default for max taper length.
- `taper_end_wall` — wall thickness at the bottom of the taper. Smaller = better acoustics, less bed contact.
- `acoustic_slit` / `acoustic_slit_offset` / `acoustic_slit_width` — bore-reinforcement slit.
- `transition_smoothing` — corner fillet radius.
- `slice_view` / `slice_angle` — render a partial revolution for inspecting internals.
- `tolerance` — pipe-fit clearance. 0.2 mm default.

### Bell end — `didgeridooBellEnd.scad`

- `bell_mouth_dia` — outer diameter of the bell mouth. 105 mm default.
- `bell_height` — total flare height above the pipe joint. 80 mm default; lower = tulip-shaped, higher = trumpet-shaped.
- `bell_wall_top` — wall thickness at the rim. The base wall is thicker (dual-exponential).
- `bell_rim_radius` — rolled-rim fillet at the top. Auto-clamped to `bell_wall_top / 2`.
- `bell_segments` / `rim_segments` — polygon resolution for the flare and rim arcs.
- `acoustic_slit`, `joint_depth`, `sleeve_thickness`, `tolerance`, `taper_end_wall`, `transition_smoothing`, `slice_view` / `slice_angle` — same meanings as the mouthpiece.

---

## Inspiration & references

For the full annotated bibliography — including geometry-decision rationales, acoustic physics, slicer technique sources, and material/hygiene research — see [**RESEARCH.md**](RESEARCH.md).

**Acoustics (the most important reference)**
- Joe Wolfe et al., UNSW — [What Makes a Good Didgeridoo](https://www.phys.unsw.edu.au/jw/GoodDidj.html)

**Pipe specifications**
- [PVC Pipes — Schedule 40 Dimensions](https://www.engineeringtoolbox.com/pvc-cpvc-pipes-dimensions-d_795.html)
- [Metric PVC Pipe Dimensions (EN 1452)](https://www.engineeringtoolbox.com/en-1452-pvc-pipe-dimensions-d_1631.html)

**Other 3D-printed didgeridoo designs (for comparison)**
- [HEXADIDG (Printables)](https://www.printables.com/model/440736-hexadidg-and-hexadidg-mini-3d-printable-didgeridoo)
- [Didgeridoo Mouthpiece for DIN 40/50 (Printables)](https://www.printables.com/model/62916-didgeridoo-mouthpiece)
- [Modular Didgeridoo (Printables)](https://www.printables.com/model/565875-modular-didgeridoo)
- [DN50 Didgeridoo Mouthpiece (Thingiverse)](https://www.thingiverse.com/thing:3338471)

**Player guides on rim geometry**
- [Didgeridoo Dojo — Mouthpiece guide](https://www.didgeridoodojo.com/didgeridoo-buyers-guide/what-mouthpiece/)
- [Wet Didgeridoo — Modifying Your Mouthpiece](https://www.wetdidgeridoo.com/didgeridoo-school/modifying-your-mouth-piece-to-get-low/)
- [Didjshop — How to Make a Beeswax Mouthpiece](https://www.didjshop.com/didgeridoo_care/didgeridoo_mouthpieces.html)

**Slicer technique**
- [Tricking the slicer for 100% fill in specific areas (Prusa Forum)](https://forum.prusa3d.com/forum/prusaslicer/tricking-slicer-to-make-100-fill-in-certain-areas/) — basis for the bore-wall reinforcement slit

---

## License

This work is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to share, adapt, print, and use this work for personal and non-commercial purposes, with attribution. **Resale or commercial distribution of the model or printed parts is NOT permitted.** See the [LICENSE](LICENSE) file for the full text.

## Author

Designed by **Gilad Nahor** ([@giladnahor](https://github.com/giladnahor)).

If you print one, I'd love to see it — open an issue with a photo, or post it on Printables / MakerWorld and link back.
