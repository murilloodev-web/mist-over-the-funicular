# Design Brief — *The Mist over the Funicular*

Visual prototypes to generate for the grimoire. Each item says what to make, how big, where it will be used, and gives a ready prompt. Generate them in Claude Design, export PNGs to `assets/art/`, and they can be dropped into the site.

---

## 1. Art direction

**Dark fantasy, 16-bit, with the energy of classic gothic console platformers.** The feel is late-night: stone, ember skies, moonlight and fog. The subject is a real 1974 Brazilian railway village, **not** a medieval castle. The Castlevania energy comes from *mood, palette and pixel craft*, never from copying its characters, logos or sprites.

| Principle | In practice |
|---|---|
| Real pixels | Draw at native resolution, scale up ×3 or ×4 with nearest-neighbour. No anti-aliasing, no blur, no gradients except dithered ones. |
| Limited palette | Stay within the palette below (≈19 colours). Add at most 4 extra per piece. |
| Dithering for air | Fog, sky and glow are ordered (Bayer) dithering, not transparency. |
| Silhouette first | Every piece must read as a black silhouette against the sky. |
| One warm light | Each scene has a single warm source (lamp window, ember sky, dynamite spark) against cold blues and violets. |
| Amethyst = wrongness | Violet is reserved for the entity and its stone. Never use it for decoration. |
| Period-true objects | 1974 Brazil: Leica M3, cassette recorder, RFFSA uniforms, Rossi .38, VW Beetles, British Victorian timber houses, a clock-tower station. |

### Palette (shared with the website and the procedural banner)

| Role | Hex | | Role | Hex |
|---|---|---|---|---|
| Void | `#0b0b14` | | Ember sky | `#b8433e` |
| Night | `#15162a` | | Glow | `#e27a3f` |
| Dusk blue | `#1f1f3d` | | Lamp | `#f3b04a` |
| Violet | `#2e2550` | | Moon | `#dfe7d9` |
| Plum | `#4a2a55` | | Moon shade | `#9fa8a6` |
| Wine | `#7a2f45` | | Stone / rail | `#8e8aae` |
| Far ridge | `#262543` | | Fog light | `#8a86a8` |
| Near ridge | `#0a0a12` | | Fog dark | `#3b3860` |
| Moss | `#3e4a2c` / `#9dbb6a` | | **Amethyst (entity only)** | `#9b6bd6` / `#b48cf0` |

### Type on images
If lettering is needed, use pixel fonts (Silkscreen-like) for labels and a blackletter-inspired display face (Pirata One-like) for titles, matching the site. Never imitate a real game's logo.

### References supplied by the author
Three pixel-art pieces: a green castle on a coastal hill; a ruined castle against a blood-red sunset; broken arches under a full moon. Take from them: the heavy stone textures, the ember-and-indigo sky, the moonlit ruins, the painterly clouds made of pixel clusters.

---

## 2. Deliverables

Priority: **P1** = needed for the first public version · **P2** = strengthens the portfolio · **P3** = nice to have.

### P1 — Key art

**1.1 Cover key art** · native 480×180 → export 1920×720 · `assets/art/cover.png`
Replaces the procedural banner at the top of the home page.
> 16-bit pixel art, dark fantasy mood. Dusk over a steep forested mountain wall in southeastern Brazil. A cable railway incline climbs diagonally from the bottom left toward a Victorian timber house with a pitched roof and two chimneys on the crest; its windows glow amber. A small steam locomotive pushes a sealed tank wagon up the incline; a faint violet glint leaks from the tank. Ember-red and indigo clouds, a pale moon, a thin line of distant sea on the left horizon. Thick dithered fog rising from the valley and swallowing the bottom third. Limited palette, no anti-aliasing, nearest-neighbour scaling.

**1.2 Social preview** · 1280×640 · `assets/art/social.png`
The image GitHub and LinkedIn show when the link is shared. Crop of 1.1 with the title in blackletter pixel type and the kicker "A Call of Cthulhu 7e scenario · Paranapiacaba, 1974".

**1.3 Favicon** · 16×16 and 32×32 · `assets/art/favicon.png`
A violet amethyst diamond with one amber pixel of lamplight, on transparency.

### P1 — Investigator portraits
Native 64×64 bust, export 256×256, inside a shared stone portrait frame (9-slice, see 4.1). `assets/art/portrait-<id>.png`

**2.1 Eduardo "Dudu" Fonseca** — mid-40s civil engineer and RFFSA auditor, grey suit too warm for the fog, thick glasses, clipboard under his arm, a heavy metal flashlight throwing a cone of cold light. Tired, stubborn eyes.

**2.2 Helena "Lenita" Castro** — early-20s social sciences student and organiser from Santos, dark curly hair tied back, denim jacket over a protest T-shirt, hand megaphone, a folded hand-drawn map in her pocket. Defiant, grieving.

**2.3 Arthur Mendes** — late-30s investigative photojournalist, trench coat, a Leica M3 at his chest, flashbulb light catching his face from below, the bulge of a revolver under the coat. Haunted.

**2.4 The Chief Engineer** (NPC) — elderly, immaculate Victorian-style waistcoat in 1974, pocket watch, a violet crystal pin at his collar, a tin of salt pastilles in his hand. Courteous and terrified.

**2.5 Bento Arruda, the Fugitive** (1866) — gaunt, barefoot prospector from the far south, soaked to the skin on a dry mountain, a geode wrapped in wet sacking on his back, mist pouring from his mouth as he breathes. Eyes fixed on the sea.

### P2 — Location vignettes
Native 320×180, export 1280×720. Shown at the top of each place page. `assets/art/place-<id>.png`

**3.1 Paranapiacaba** — the British timber village at night, the station clock tower above the yard, streetlamps making halos in the fog, the secret Winter Festival's bonfires glowing through the mist while villagers throw salt into the drains.

**3.2 The Castelinho** — the chief engineer's study: a desk under a window overlooking the yard, telegraph key, ledgers, a geological sketch of a geode pinned to the wall, a strange barometer with a violet crystal needle.

**3.3 The Funicular** — the incline seen from below: steel cable between the rails, a steam brake locomotive gripping it, a fixed engine house at the landing above.

**3.4 The Fourth Landing** — inside the engine house: huge flywheels and cable drums, and in the floor a brick culvert with seawater running down into darkness.

**3.5 Grota Funda** — the iron viaduct spanning a deep forested gorge, seen from beneath; a tunnel mouth in the rock below the viaduct, fog pouring out of it.

**3.6 The crystal chamber** — a flooded chamber whose walls, floor and ceiling are violet crystal grown out of the rock; at its centre, sealed in the crystal, the small carved Seed on a salt-ringed altar; robed figures hauling buckets of brine and iron filings, the mist taking shape above them. The only strong violet light in the whole set.

### P2 — The entity and the artefact

**4.2 The Mist, three stages** · native 160×90 each, one sheet · `assets/art/mist-stages.png`
Same village street in May (thicker than normal fog), June (cold fog with half-formed faces) and July (toxic violet-grey fog, rusted metal, a shape of coiled fins inside it).

**4.3 The Amethyst Heart** · 32×32 item sprite + 128×128 detail · `assets/art/amethyst.png`
The Seed: a geode the size of a child's head, violet crystals inside, its outside grown into coiled finned shapes. Readable as an inventory icon. Add a second 128×128 detail of the grown Body: crystal veins spreading through dark rock.

**4.5 Mist Contact track** · 7 pixel icons, 16×16 each · `assets/art/contact-<n>.png`
One icon per Contact tier (Clear, Whispers, Visions, The Pull, Tide-touched, Brine-speaker, Drowned), going from clear air to a drowned face in violet fog.

**4.4 The Company Car** · 96×48 sprite · `assets/art/company-car.png`
A 1900s riveted railway tank wagon, tide-line rust stains, a stencilled "BALLAST" in English, a violet glow at the valve, sealed barrels of iron filings on the flat car behind it.

### P2 — Handouts for players
Native 240×320, export 960×1280; "photographed paper" look in pixel art. `assets/art/handout-<n>.png`

**5.1 Telegraph log** — a ruled ledger page with "ballast water" entries in two different hands, one entry circled.
**5.2 Lenita's brother's letter** — handwritten, water-stained, ending "…and it calls me by name."
**5.3 Closure notice** — a typewritten 1974 railway memo announcing the wind-down of the cable line, with a fictional stamp.
**5.4 Arthur's photograph** — a black-and-white print of a tunnel mouth where the fog forms agonised faces.
**5.5 Bento's notebook** — a water-stained 1866 notebook page in Portuguese, the last line: "Daqui se vê o mar".

### P3 — UI kit and map

**4.1 Pixel UI kit** · `assets/art/ui/`
9-slice stone frame (for portraits and cards), dividers, the three tag badges (History / Fiction / History + Fiction) as pixel icons, an arrow cursor, a pixel "next / previous" button pair.

**6.1 Map of the Serra** · native 320×240, export 1280×960 · `assets/art/map.png`
A top-down pixel map: the plateau and village at the top, the five landings of the cable line going down the mountain, the rack line, Grota Funda, and Santos with the sea at the bottom. Pixel labels, a compass rose, fog patches.

---

## 3. How the art plugs into the site

- Put files under `assets/art/` with the names above.
- `build.lua` already copies the stylesheet and generates the banner; add one line to copy `assets/art/` into `docs/art/`, then reference images from the page data (for example an `image = "art/place-castelinho.png"` field on each page).
- Always write alt text that describes the scene, as the banner already does.

## 4. Guardrails

- Original work only. No characters, logos, fonts or sprites from existing games.
- Real people and the real village are treated with respect. The cult and its crimes are fiction.
- Do not use violet anywhere except for the entity and its stone.
