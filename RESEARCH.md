# Research notes

This document collects the research that informed PVCdidge's design decisions. Future development should consult these findings before changing geometry, materials, or print parameters — most of the "why" behind v1.0 lives here, not in code comments.

Organized by topic. Each section: short synthesis + links with annotations.

---

## 1. Acoustics & physics

### UNSW didgeridoo acoustics (most important reference)

**Joe Wolfe et al., University of New South Wales** — [What Makes a Good Didgeridoo](https://www.phys.unsw.edu.au/jw/GoodDidj.html)

Wolfe's group measured the input impedance and output sound spectrum of 38 didgeridoos, then correlated them with subjective player ratings. Key findings that **directly drive PVCdidge's geometry**:

- The single largest negative quality factor is the presence of **strong impedance peaks in the 1–2 kHz band**. Players consistently rate didgeridoos with smooth response in this band as "good"; ones with sharp peaks as "plasticky" or "harsh."
- These 1–2 kHz peaks are caused by **abrupt cross-section changes in the bore**, especially at the mouthpiece-to-bore junction.
- The bore's characteristic impedance is "on a similar scale to that of the vocal tract," so the mouthpiece is acoustically the player's vocal tract extension. Smooth impedance matching at the lips matters more than for, say, a trumpet (where the lips' impedance is much smaller than the tube's).
- Larger mouth-end diameters correlated with higher subjective quality across their sample (30–60 mm range). This is physics-based, not just ergonomic preference.

**Implication for PVCdidge**: the internal acoustic taper from cup ID (30 mm) to pipe ID (36–46 mm depending on preset), spread smoothly over the full 20 mm joint depth, exists specifically to flatten the 1–2 kHz peak that beeswax solves on traditional instruments. This is the single biggest acoustic improvement over typical 3D-printed PVC mouthpieces.

### Companion UNSW pages worth reading

- [Didgeridoo physics overview (UNSW)](https://www.phys.unsw.edu.au/jw/dij.html)
- [How does a didgeridoo work? (UNSW)](https://www.phys.unsw.edu.au/jw/Didjeridu.html)

---

## 2. Player preferences — consensus numerical geometry

Distilled from specialty retailers, players, and DIY guides. These are the numbers PVCdidge defaults are built around.

| Parameter | Consensus value | Sources |
|---|---|---|
| **Mouth opening (round)** | **28–32 mm**, with **30 mm** as universal default | didjshop, didgeridoodojo, duende, didgeridoobreath, wakademy |
| Mouth opening (oval, advanced/low) | 35–38 mm × 30–32 mm (W × H) | wetdidgeridoo |
| Hard upper bound before backpressure collapses | ~45 mm | pamelamortensen, soundadventurer |
| **Rim contact-edge thickness** | **1–4 mm, ~2.5 mm average** | didjshop, didgeridoodojo |
| **Inner edge profile** | **Sharp / ~45° bevel** for free lip vibration | didjshop |
| Outer edge profile | Flat-to-slightly-concave to hug face | wetdidgeridoo |
| **Rim height above bore** | **5–10 mm** of rim material above the pipe end | didgeridoobreath, didjshop |
| Internal taper from cup→bore | Smooth tuba/trumpet-style; **NOT a steep funnel**; ≥10 mm constant cup before tapering | wetdidgeridoo, didjshop, didgeworkshops |

**Implication for PVCdidge defaults**: `mouth_opening = 30`, `lip_top_width = 4.5` (3 mm flat band + fillets), `inner_rim_radius = 0.6` (small/sharp), `outer_rim_radius = 2.0` (rounded for face), `lip_height = 10`, `cup_depth = 0` (pure taper, no constant cup below the rim, since the lip section already provides 10 mm of constant-ID).

### Player guides — primary references

- [Didgeridoo Dojo — What Mouthpiece Should my Didgeridoo Have?](https://www.didgeridoodojo.com/didgeridoo-buyers-guide/what-mouthpiece/) — beginner-focused, gives the "1 inch ≈ 25 mm" beginner rule of thumb
- [Wet Didgeridoo — Modifying Your Mouth Piece To Get Low](https://www.wetdidgeridoo.com/didgeridoo-school/modifying-your-mouth-piece-to-get-low/) — detailed geometry recommendations including the brass-mouthpiece analogy and oval-rim case for low-drone players
- [Didjshop — How to Make a Beeswax Mouthpiece](https://www.didjshop.com/didgeridoo_care/didgeridoo_mouthpieces.html) — strongly opinionated on sharp inner edge ("a pointed inner rim allows lips to vibrate freely")
- [Didgeworkshops — Making a Mouthpiece](https://didgeworkshops.com.au/Making-a-Mouthpiece) — the 45° bevel recommendation
- [Duende Didgeridoo — Mouthpieces](http://www.duendedidgeridoo.com/the-way-of-didgeridoo/mouthpieces/) — 30 mm finished diameter
- [Didgeridoo Breath — Replace your Beeswax Mouthpiece](https://www.didgeridoobreath.com/how-to-replace-your-beeswax-didgeridoo-mouthpiece/) — practical wax-application tutorial
- [Wakademy — 4 steps to make your beeswax mouthpiece](https://www.wakademy.online/en/blog/didgeridoo-beginner/4-steps-to-make-your-beeswax-mouthpiece-for-your-didgeridoo/) — beginner-friendly walkthrough
- [You Didgeridoo — Wax on Wax off (wooden mouthpiece)](https://www.youdidgeridoo.com/blog/wooden-mouthpiece-creation/) — wood vs. wax comparison; ~29 mm typical for carved wooden rim

---

## 3. Existing 3D-printed didgeridoo designs (for comparison and inspiration)

The most-engaged 3D-printed didgeridoo projects on Printables / MakerWorld / Thingiverse. Each has lessons embedded in its comments and remix history.

### HEXADIDG

- [HEXADIDG and HEXADIDG MINI on Printables](https://www.printables.com/model/440736-hexadidg-and-hexadidg-mini-3d-printable-didgeridoo)
- Largest/most-engaged 3D-printed didgeridoo project
- Creator's own note: *"Use beeswax for best seal around lips, at least for me it gives the best sound"* — the universal end-state of all FDM mouthpieces is hybrid-with-beeswax
- Recommended print: **minimum 4 perimeters, 0.2–0.28 mm layer height, 10 mm brim minimum**
- The community add-on mouthpiece (a separate 30 mm rim that drops onto the existing one) is praised for solving comfort

### DIN 40/50 mouthpiece

- [Didgeridoo Mouthpiece for DIN 40/50 on Printables](https://www.printables.com/model/62916-didgeridoo-mouthpiece)
- The closest analog to PVCdidge in geometry intent
- Recommends "30 mm for DIN40 (beginners), 38 mm for DIN50 (advanced)"
- Sized for European metric plumbing pipes (the same 40 mm and 50 mm DIN that PVCdidge supports)

### Modgeridoo (modular)

- [Modgeridoo on MakerWorld](https://makerworld.com/en/models/13826-modgeridoo-modular-didgeridoo)
- Most-favorited modular 3D-printed didgeridoo
- 2 mouthpieces × 4 body sections × 3 end pieces, all threaded
- Reveals strong demand for **interchangeable mouthpiece rims** so a player can swap 30 mm and 38 mm rims on the same body
- Reviewer comment: *"I printed it with wood PLA and it feels like the sound is absorbed. I can play my hexadidge found on printables without any issues but it is made from PETG."* — direct evidence that filament choice matters for sound

### DN50 with conical taper (the proto-PVCdidge)

- [DN50 Didgeridoo Mouthpiece on Thingiverse](https://www.thingiverse.com/thing:3338471)
- Explicitly designed to "emulate the acoustic coupling of a traditional beeswax mouthpiece" via internal conical shape — same insight that drives PVCdidge's internal taper
- Older design but demonstrates the principle works

### Custom mouthpiece add-on (Walt Adler)

- [Custom mouthpiece for didgeridoo on MakerWorld](https://makerworld.com/en/models/1195328-custom-mouthpiece-for-didgeridoo)
- An add-on rim that drops onto the existing mouthpiece, hot-glued for sealing
- Reviewer: *"I've been playing this instrument since 1996... It seems like a great practice instrument for my students when I give lessons"* — validates the "cheap printed practice instrument" use case

### Other notable

- [Didgeridoo D2 Full Size (MakerWorld)](https://makerworld.com/en/models/1145396-didgeridoo-d2-full-size)
- [Didgeridoo Mouthpiece Parameterisable (Thingiverse 2857074)](https://www.thingiverse.com/thing:2857074)
- [Modular Didgeridoo (Printables 565875)](https://www.printables.com/model/565875-modular-didgeridoo)

### Common complaints across 3D-printed designs

Compiled from the comment sections of the above:

1. **"Plasticky" sound** — caused by abrupt cup-to-bore impedance step (the UNSW 1–2 kHz peak)
2. **Doesn't seal on lips** — players add beeswax to fix
3. **Cold/slippy on lips** — players add beeswax or hot-glue a soft material
4. **Layer lines on rim** — players sand or vapor-smooth or wrap with wax
5. **Dampened sound from filled filaments** — wood-PLA, silk-PLA, metal-PLA
6. **Thick part with default infill = soggy mass** — insufficient perimeters / low infill kills tone

PVCdidge addresses #1 (smooth taper), #4 (smoothed surfaces), and #6 (bore-wall reinforcement slit). #2/#3 are still solved by beeswax finishing — the printed shell is intended as the *substrate* for traditional finishing, not a replacement for it.

---

## 4. Traditional & commercial mouthpieces (the targets to emulate)

### Beeswax — the gold standard

Why it works:
- Heated by body warmth or hot water, becomes "play dough"-pliable, **moldable to each player's lips in seconds**
- Naturally antimicrobial (mild — not a substitute for cleaning, but doesn't grow biofilm the way porous plastic does)
- Slightly damps the rim so it doesn't feel cold or buzzy
- Smoothly fills the cup-to-bore impedance discontinuity (this is the acoustic insight Wolfe et al. quantify)

Geometry (consolidated):
- Inner diameter ≈ **30 mm** finished (a 35 mm donut shrinks during mounting)
- **7–15 mm strip thickness**, projecting ~5–10 mm above the pipe rim
- Pressed ~1 cm into the bore for adhesion
- Inside edge beveled at ~45° to a fairly sharp lip
- Top profile flattened by thumb or rolling pin

Failure modes (why a 3D-printed alternative exists):
- Sticky, picks up dirt, "feeling around the mouth is not very pleasant" after long play
- Melts in hot sun or hot car
- Pets nibble it
- Looks visibly grimy and gets replaced more from looking dirty than from wearing out
- Pollen-allergic players need refined/microcrystalline white wax instead of raw yellow

### Wooden / carved mouthpieces

- Common on traditional eucalyptus didges and premium handmade instruments
- Players value: **dimensional stability** (no melting), no taste, professional consistency
- Typical carved inner diameter: **28–30 mm** (Youdidgeridoo cites 29 mm)
- Eucalyptus bores often come out >35 mm (too wide for most players), so even commercial wooden rims are frequently waxed down to ~30 mm
- Less forgiving than wax — once carved wrong, can't be reshaped

### Commercial silicone / rubber

- Found on travel didges (Didge Project travel didge, Meinl plastic didges, Charlie McMahon's Didjeribone)
- Praised: "great and feels very comfortable"; can be slightly bent into oval to fit non-flat face
- Standard commercial Meinl pre-rings: **OD 60 mm, ID 30 mm**
- Wins on hygiene (washable), durability, no melt
- Loses: can't be reshaped to embouchure; some players find them "slippy" or rubbery-tasting; deadens lip feedback

### Sources for traditional/commercial

- [Didgeridoo Breath — Didjeribone replacement rubber mouthpiece](https://www.didgeridoobreath.com/didjeribone-replacement-rubber-mouth-piece/)
- [Positive Vibrations — Silicone Mouthpiece](https://www.didgeridoo-onlineshop.de/en/p/silicone-mouthpiece)
- [Sound Adventurer — Best Didgeridoo for Beginners](https://soundadventurer.com/best-didgeridoo-for-beginners/)
- [Pamela Mortensen — Didgeridoo FAQ](https://pamelamortensen.net/didgeridoo-faq)
- [Google Groups rec.music.misc — alternatives to beeswax (allergy thread)](https://groups.google.com/g/rec.music.misc/c/KGoDHTQE6dQ)

---

## 5. PVC didgeridoo specifics & DIY guides

### The Didge Project DIY guide (the canonical resource)

- [The Ultimate Guide to DIY PVC/ABS Didgeridoo](https://www.didgeproject.com/instrument-making/the-ultimate-guide-to-diy-didgeridoo-making-with-pvc-and-abs-pipe/)
- Standard cheap mouthpiece: **1½″ × 1¼″ DWV trap adapter** that snaps on without solvent
- Common acoustic complaints about PVC:
  - Thin/buzzy/plasticky timbre
  - Harsh harmonics
  - Lack of "wood warmth"
- DIY fixes that recur:
  - **Wax/coat the inside** ("dip the small end of the pipe about 2.5 cm in and out of melted beeswax… until a thin layer of wax forms")
  - **Thin the bell wall to ~1/4″** and rasp-taper the inside
  - **Heat-form a flare** by softening with a heat gun and pushing over a bottle
- Stiff cylindrical bore + abrupt mouthpiece reduction = exactly the 1–2 kHz impedance peaks UNSW flagged as quality-killers — PVCdidge's taper directly addresses this

### Cleaning, maintenance, and care

- [Didge Project — Cleaning, Maintenance and Care](https://www.didgeproject.com/free-didgeridoo-lessons/cleaning-maintaining-and-caring-for-your-didgeridoo/)
- [Primaltones — Mouthpiece Sanitizer](https://primaltones.com/shop/shop/mouthpiece-sanitizer/) — tea tree + lavender in distilled water; commercial sanitizer specifically for didgeridoo mouthpieces

### Pipe specifications

- [Engineering Toolbox — PVC Pipes Schedule 40 Dimensions](https://www.engineeringtoolbox.com/pvc-cpvc-pipes-dimensions-d_795.html)
- [Engineering Toolbox — Metric PVC Pipe Dimensions (EN 1452)](https://www.engineeringtoolbox.com/en-1452-pvc-pipe-dimensions-d_1631.html)

---

## 6. Materials & filaments

### Stiffness ranking (acoustic relevance)

| Material | Young's modulus | Acoustic verdict | Other notes |
|---|---|---|---|
| **PLA** | ~3.5 GPa | Brightest sound, stiffest | Brittle, softens at 60 °C, no hot-water cleaning. Mostly food-safe but additives uncertain. |
| **PETG** | 2.0–3.0 GPa | Slightly less bright than PLA but very close | **Recommended for didgeridoo mouthpieces.** Heat-tolerant, food-grade variants exist, layer adhesion superior, slightly more forgiving against drops. |
| **ABS** | ~2.0 GPa | Moderate; some damping | Off-gases ABS fumes, harder to print, not food-safe in mouth-contact applications. |
| **TPU / flexible** | <0.05 GPa | Terrible — high damping | Don't use for the mouthpiece body. Sometimes used for rim overlays for comfort. |
| **Wood-PLA** | <3.0 GPa, with damping additives | **Damps sound noticeably** | Confirmed by Modgeridoo reviewers (see section 3). Avoid. |
| **Silk PLA / Metal-filled PLA** | Lower than plain PLA | Likely dampens sound | Not directly tested by didj makers but pattern matches wood-PLA reports. Avoid for acoustic parts. |

### Mouth contact safety

- FDM layer lines harbor bacteria — porosity is the issue, not the polymer
- PLA softens at ~60 °C → cannot be sterilised in hot water
- PETG tolerates hot rinses → preferred for shared/cleaned mouthpieces
- Standard fix: **food-grade epoxy** or polyurethane sealant on the lip-contact band
- Or finish with beeswax (the hybrid approach used by ~all successful 3D-printed designs)

### Sources for materials

- [Prusa Forum — What filament can be used in the mouth?](https://forum.prusa3d.com/forum/english-forum-general-discussion-announcements-and-releases/what-filament-material-can-be-used-in-the-mouth/)
- [Sax on the Web — On the safety of 3D printed mouthpieces](https://www.saxontheweb.net/threads/on-the-safety-of-3d-printed-mouthpieces.382425/)
- [Stony Brook — Making 3D Prints Mouth-Safe](https://you.stonybrook.edu/jadams/2025/05/09/making-your-3d-prints-mouth-safe-and-food-friendly-what-you-need-to-know/)

---

## 7. Slicer techniques (the gap-closing trick)

### Sub-nozzle slits as wall hints

PVCdidge's bore-wall reinforcement slit (parameter `acoustic_slit_width = 0.1`, default 0.1 mm) uses a documented slicer behavior:

- PrusaSlicer's `slice_gap_closing_radius` defaults to ~**0.049 mm**
- Voids ≤ 0.049 mm wide are silently merged by the slicer (treated as numerical artifacts)
- Voids > 0.049 mm survive and are detected as **thin gaps** by the slicer
- "Detect thin walls" / Arachne / gap-fill features then lay down extra perimeter traces along these surfaces
- Result: a 0.1 mm slit forces the slicer to produce *more* perimeters near the slit, with the gap itself filling via extrusion overlap (since extrusion width ~0.4 mm ≫ 0.1 mm)

Net acoustic effect: **the bore-adjacent wall is forced to print 100 % solid plastic** regardless of the slicer's infill density setting. Critical for print services like Slant 3D where customers can't override slicer settings.

### Sources

- [Tricking slicer to make 100% fill in certain areas — Prusa Forum](https://forum.prusa3d.com/forum/prusaslicer/tricking-slicer-to-make-100-fill-in-certain-areas/) — primary source of the technique
- [Layers and perimeters — Prusa Knowledge Base](https://help.prusa3d.com/article/layers-and-perimeters_1748)
- [Arachne perimeter generator — Prusa Knowledge Base](https://help.prusa3d.com/article/arachne-perimeter-generator_352769)
- [strength_settings_walls — OrcaSlicer Wiki](https://github.com/OrcaSlicer/OrcaSlicer/wiki/strength_settings_walls)
- [Detect Thin Walls Question — Prusa Forum](https://forum.prusa3d.com/forum/prusaslicer/thin-wall-detection-question/)
- [3D Printing Thin Walls and Small Features — Simplify3D](https://www.simplify3d.com/resources/articles/printing-thin-walls-and-small-features/)

### Caveats

- Slot widths < 0.05 mm are silently closed → useless as wall hints
- Slot widths > ~0.4 mm print as actual air voids → not what we want for acoustic boundary
- **Sweet spot: 0.05–0.2 mm**, with 0.1 mm as the safe default for unknown slicer configurations
- Slicer default settings vary — Slant 3D's farm-tuned settings might differ from PrusaSlicer defaults; keeping `acoustic_slit_width` ≥ 0.1 mm provides safety margin

---

## 8. Print services & production printing

### Slant 3D (the user's print service for this project)

- [Slant 3D — Quick Ordering blog post](https://www.slant3d.com/slant3d-blog/new-quick-ordering-for-mass-production-3d-printing)
- [Slant 3D — Production Printing Quote](https://www.slant3d.com/production-3d-printing-quote-auto-2)
- [Slant 3D Portals service — Fabbaloo coverage](https://www.fabbaloo.com/news/slant-3d-launches-portals-v2-direct-to-consumer-3d-print-storefronts)
- [Slant 3D Portal Print on Demand — TCT Magazine](https://www.tctmagazine.com/slant-3d-portal-print-on-demand-service/)
- [Slant POD — Filament options](https://www.slantpod.com/post/exploring-filament-options-at-slant3d-for-your-print-on-demand-needs)

Constraints (as of 2026):
- **Customer cannot specify infill, perimeter count, or layer height** — settings are locked at the production-line level
- Materials: PLA in 7 colors (Glossy Black, Matte Black, White, Grey, Red, Yellow, Gold-PLA-with-additives), PETG in 2 colors (Glossy Black, White)
- Email `info@slant3d.com` for custom requests
- → This is precisely *why* PVCdidge embeds the bore-wall reinforcement slit in the geometry rather than relying on slicer-side settings

### Alternative services (where settings are exposed)

- **Craftcloud, Treatstock, Hubs**: can specify infill / perimeters; some providers happy to do 100 % infill in PETG for a small surcharge
- **MJF / SLS nylon**: fully solid by definition (powder-bed fusion has no infill concept). Best path for acoustic-grade solidity if FDM-with-tricks isn't enough.
- **Resin (SLA/DLP)**: fully solid but typically not food-safe at the lip contact, and brittle.

---

## 9. What PVCdidge does NOT yet address (future work)

Areas where the current v1.0 design is a pragmatic compromise, with documented improvements possible:

### Oval rim for face conformance

Wet Didgeridoo strongly recommends an **oval mouth opening (~36 × 32 mm) for big mouthpieces** because human faces aren't flat. PVCdidge is round to keep the rotate_extrude pipeline simple. A future version could break the 360° rotation invariant to support oval — but it's a significant architectural change.

### Concave outer rim face

The lip contact surface is currently a flat-topped rounded ring. A slightly **concave** outer face (curving inward toward the cheeks/chin) would seal better with less facial pressure. Same architectural issue — needs to break rotational symmetry.

### Threaded modularity

Modgeridoo and other modular designs show clear demand for **interchangeable rims** on a shared body (swap 30 mm and 38 mm rims). PVCdidge currently bakes the rim into the same part as the joint clamp — could be split.

### Vapor-smoothed lip surface

Players consistently report **layer lines feel rough on lips and harbor bacteria**. Vapor smoothing with MEK/ethyl acetate (PETG) or THF (PLA) addresses this but is risky for dimensional accuracy and rarely reported by didj makers. Beeswax overlay remains the dominant fix.

### Acoustic measurement

Wolfe et al. measured impedance with a sweep tube; we're inferring quality from geometric arguments. **Direct measurement of PVCdidge's input impedance** (compared to a beeswax-finished pipe end) would either validate or refute the design's acoustic claims.

---

## How to update this document

When research findings change a design decision in `didgeridooMouthpiece.scad`:

1. Add the new finding under the relevant section above with a working URL
2. If it overturns a previous assumption, mark the old entry with `(superseded by X — date)` rather than deleting — design history matters for future maintainers
3. Update CLAUDE.md's "Architecture" or "Invariants" section if the change affects the code structure
4. Reflect the practical implication in `didgeridooMouthpiece.scad` parameter comments
