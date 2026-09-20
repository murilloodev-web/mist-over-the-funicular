-- Grimoire pages.
--
-- Markup understood by build.lua:
--   [[page-id]] or [[page-id|label]]  internal link (checked at build time)
--   {{source-id}}                     numbered citation to data/sources.lua
--   **bold**   *italic*
--   ## Heading     - list item     > quotation
--
-- kind: "history" = documented fact, "fiction" = invented for the scenario,
--       "mixed"   = fiction built directly on documented fact.

return {

  ---------------------------------------------------------------- SCENARIO
  {
    id = "synopsis", section = "The Scenario", kind = "mixed",
    title = "Synopsis",
    summary = "What the government thinks it is closing, and what it is really setting loose.",
    body = [==[
In 1974 the Brazilian federal railway network opens a modern rack line down the Serra do Mar and begins winding down the old cable-hauled funicular that had carried coffee from the plateau to the port of Santos since 1867 {{spr-wiki}} {{funicular-wiki}}. On paper it is a cost-cutting modernisation.

What no ministry in Brasília knows is that the funicular was never only a railway. Every train that climbed from the coast hauled one more wagon than the timetable admitted: a sealed tank car of seawater thick with iron filings and crushed stone, bound for [[fourth-landing|the Fourth Landing]] and the tunnels below [[grota-funda|Grota Funda]]. The seawater keeps a pre-human sea-thing drowsy. The iron and stone feed its body of [[amethyst-heart|amethyst]], grown for a century until it is too vast to ever leave the mountain.

The creature was captured here in 1866, carried up from the south by [[the-fugitive|a man it had taken over]], a few kilometres short of the sea it was fleeing toward. Since then it has had only one way to reach anyone: [[the-mist|the mist]]. Everyone who breathes it hears it, a little more each night.

As the funicular slows, the tank cars stop coming. The mist turns cold, heavy and insistent. The [[company-of-shadows|Company of Shadows]], whose members have breathed it for generations, is losing control, and three strangers who came up the mountain for very different reasons start to hear their own names in the fog.

## The dilemma at the bottom of the tunnel
The investigators must choose between two bad endings: [[ending-sea|cut the creature's heart free and return it to the ocean]], or [[ending-shatter|shatter it with railway dynamite]] and bind the mist to the village forever. There is no clean victory. That is the point.
]==],
  },
  {
    id = "fact-and-fiction", section = "The Scenario", kind = "mixed",
    title = "Fact & Fiction",
    summary = "Where the history ends and the Mythos begins, and the liberties this scenario takes.",
    body = [==[
This scenario is built on real places and real machines. Every historical claim in the grimoire carries a numbered citation; everything tagged *Fiction* is invented. The [[timeline]] shows both side by side.

## Liberties taken, on purpose
- **The Serra Nova as the dying line.** Historically the older Serra Velha funicular stopped in 1970 and its track bed became the 1974 rack line; the Serra Nova funicular kept running into the early 1980s {{funicular-wiki}} {{museu-funicular}}. The scenario sets the "threat of closure" on the Serra Nova, which is where the [[locobreques]] actually worked.
- **The tank wagon never existed.** The heavy cable haulage was built for coffee, freight and a 796 m climb {{unesco}}, not for seawater.
- **Amethyst is not native to the Serra do Mar.** Brazil's great amethyst geodes form in the volcanic rocks of the far south {{amethyst-wiki}} {{amethyst-usp}}. In the fiction, that is exactly what makes the stone wrong: [[the-fugitive|someone carried it here]].
- **Amethyst really is quartz coloured by iron.** Its violet comes from iron impurities in the crystal, activated by radiation {{amethyst-wiki}}. The fiction takes that literally: the Company grew the creature's body by feeding it silica and iron from the railway itself.
- **The Winter Festival is older than the record.** Officially, Paranapiacaba's Winter Festival began in July 2001 {{festival-origins}}. In the scenario it has been held every winter since the 19th century as a private village rite of the [[company-of-shadows|Company of Shadows]]. 2001 is only the year outsiders were first invited: see [[winter-festival]].

## Respect for a living place
Paranapiacaba is a real, inhabited, heritage-listed village {{unesco}}. The cult and its crimes are fiction and are not meant to describe any real person, family or institution.
]==],
  },
  {
    id = "timeline", section = "The Scenario", kind = "mixed",
    title = "Timeline",
    summary = "1859 to 2001, with documented history and scenario fiction side by side.",
    body = "@timeline",  -- rendered from data/timeline.lua
  },
  {
    id = "scenario-flow", section = "The Scenario", kind = "fiction",
    title = "Scenario Flow",
    summary = "The branching structure of the investigation, from arrival to the three endings.",
    body = "@flow",  -- rendered from data/flow.lua
  },

  ---------------------------------------------------------------- PLACES
  {
    id = "paranapiacaba", section = "Places", kind = "history",
    title = "Paranapiacaba",
    summary = "The British railway village at the top of the Serra do Mar, and the fog it lives in.",
    body = [==[
In Tupi, *Paranapiacaba* means "the place from which one sees the sea" {{paranapiacaba-wiki}}. It is a cruel name: most days the sea is invisible behind the fog.

The São Paulo Railway called the site **Alto da Serra** and raised a company village there. It began as a camp for construction workers and grew into a planned town of wooden houses of Baltic pine on masonry bases, with the planned district of Vila Martin Smith laid out beside it {{vitruvius}}. Around 450 buildings housed about 1,100 people {{unesco}}.

## The fog
Dense fog rolls over the village at dusk, fed by the forest, the altitude and the nearby Atlantic {{unesco}} {{paranapiacaba-wiki}}. Locals say footballers here learned to play by ear. In this scenario the fog is something more: see [[the-mist]].

## In 1974
The investigators find a village already in decline. The railway that built it is modernising without it, and the old British order survives only in the houses and at the [[castelinho]].
]==],
  },
  {
    id = "castelinho", section = "Places", kind = "mixed",
    title = "The Castelinho",
    summary = "The chief engineer's Victorian house, set above the yard so he could watch every move.",
    body = [==[
The "Little Castle" was built by the British in 1897 as the home of the railway's chief engineer. It stands on raised ground so that its occupant could watch the rail yard, the station clock and the workers' homes at every hour {{castelinho-folha}}. It is a two-storey Victorian house of 507 m² with 33 windows and six fireplaces, roofed in tiles from Marseille. Today it is a museum {{museu-castelo}}.

## In the scenario *(Fiction)*
Whoever holds the post of chief engineer is, by ritual right, Grand Master of the [[company-of-shadows|Company of Shadows]]. The panoramic windows are for more than watching workers: from here the [[chief-engineer]] reads the density of [[the-mist|the mist]] like a barometer.

## What the investigators can find here
- Telegraph logs where "ballast water" figures do not match any cargo manifest.
- A locked study with 19th-century correspondence in English and a geological sketch of an amethyst geode.
- A barometer-like instrument with a violet crystal needle that points downhill, towards [[grota-funda]].
- Bento Arruda's water-stained notebook from 1866 (see [[the-fugitive]]).
]==],
  },
  {
    id = "funicular", section = "Places", kind = "history",
    title = "The Funicular",
    summary = "Two cable railways that hauled trains up an 800-metre wall of forest.",
    body = [==[
The São Paulo Railway opened on 16 February 1867, linking the port of Santos to the coffee plateau across the Serra do Mar, a climb that ordinary locomotives could not make {{spr-wiki}}.

## Serra Velha (1867–1970)
The first system climbed in **four inclined planes**, with a fixed steam engine at each landing hauling the wagons up by cable. It could lift about 60 tonnes per trip {{funicular-wiki}}.

## Serra Nova (1900–1980s)
The second system doubled capacity with **five inclined planes and five landings** and an "endless rope" running continuously along the track {{funicular-wiki}}. Trains were driven by [[locobreques]] that gripped the moving cable. It ran commercially until 1983 {{museu-funicular}}.

## 1974: the rack line
With the railway nationalised in 1946 {{spr-wiki}}, the federal network replaced the old Serra Velha bed with an Abt rack-and-adhesion line in 1974, built by Marubeni with electric locomotives {{spr-wiki}} {{funicular-wiki}}. From then on the funicular's days were numbered.

## In the scenario *(Fiction)*
Every up-train from Santos carried one extra, unlisted car: see [[company-car]]. The rack line cannot carry it, and the Serra Nova is being wound down. That is how the story starts.
]==],
  },
  {
    id = "locobreques", section = "Places", kind = "history",
    title = "The Locobreques",
    summary = "British 'brake locomotives' that gripped a moving steel cable.",
    body = [==[
A *locobreque* is a small steam locomotive with a claw that clamps onto the steel cable running between the rails {{locobreque-wiki}}. Twenty were built in Britain around 1900–1901 by Kerr, Stewart & Co. and Robert Stephenson & Co., and they served the Serra Nova from 1901 to 1976, pushing and braking trains across its five inclined planes {{locobreque-wiki}}.

Locobreque nº 14, built in 1902, was the last one fired up, on 22 October 1994, for visiting railway enthusiasts. It survives at the Museu do Funicular {{museu-funicular}}.

## In the scenario *(Fiction)*
Old drivers say the locobreques "pulled heavier going up than the scales said". A locobreque in steam is also the only way to move the [[amethyst-heart|amethyst]] in [[ending-sea]].
]==],
  },
  {
    id = "fourth-landing", section = "Places", kind = "mixed",
    title = "The Fourth Landing",
    summary = "A machine house halfway up the Serra Nova, and the drain beneath it.",
    body = [==[
Each of the Serra Nova's five landings (*patamares*) housed a fixed steam engine that drove the cable for the plane below it {{funicular-wiki}}.

## In the scenario *(Fiction)*
Beneath the Fourth Landing's machine house, a brick culvert runs away from the track and into the rock. At each stop, the [[company-car]] opened a valve and drained its seawater, iron and crushed stone there. Beside every landing's engine stood a bin where the filings from the worn cables were swept. The culvert ends in the tunnels under [[grota-funda]].

Eduardo Fonseca's father helped assemble these engines. His madness began here: see [[dudu]].
]==],
  },
  {
    id = "grota-funda", section = "Places", kind = "mixed",
    title = "Grota Funda",
    summary = "A 60-metre-deep gorge, a famous viaduct, and something sleeping under it.",
    body = [==[
Grota Funda ("Deep Hollow") is a gorge about 60 m deep and 200 m wide. The viaduct that carries the railway across it is counted among the great engineering feats of the São Paulo Railway {{unesco}}.

## In the scenario *(Fiction)*
Under the gorge, abandoned construction tunnels open into a flooded chamber that is no longer made of stone: walls, floor and ceiling are violet crystal, the Body of the [[amethyst-heart]], grown for a century around the Seed at its centre. By July 1974 the seawater pools are drying up and the salt ringing the altar is cracking. The desperate members of the [[company-of-shadows|cult]] haul buckets of brine down by hand.

This is where the scenario ends: [[ending-sea]] or [[ending-shatter]].
]==],
  },

  ---------------------------------------------------------------- MYTHOS
  {
    id = "the-mist", section = "The Mythos", kind = "fiction",
    title = "The Mist",
    summary = "The creature's voice: breathe it and you are in contact with the thing under the mountain.",
    body = [==[
The entity has two halves. Its **body** is a mass of violet crystal grown into the rock under [[grota-funda]] (see [[amethyst-heart]]). Its **voice** is the mist. It cannot move, so it speaks, and it speaks the only way it can: through the air people breathe.

The real fog of [[paranapiacaba]] {{unesco}} gives it the perfect disguise.

## Breathing is listening
Every lungful of the mist is a moment of contact with the creature. Villagers have breathed it lightly for a century and hear no more than a murmur, blunted by the salt they throw into the drains at the [[winter-festival]]. The [[company-of-shadows|cult]] breathes it on purpose, and its members are deep in contact. The investigators are exposed from their first night in the village.

This is the heart of the scenario's horror: the players are **constantly being infected**. The deeper they go, the more they understand, and the more they are understood. Rules: [[mist-contact]].

## What the mist wants
It wants to go home to the sea, the way it almost did in 1866 (see [[the-fugitive]]). Everything it whispers bends that way: it shows people the path to Grota Funda, asks them to open the drains, to "bring the sea up" or "carry me down".

## The drying
As the [[company-car]] stops arriving, the creature dehydrates and grows frantic, and its voice gets louder:
- **May:** thicker than usual; metal rusts overnight; dogs refuse to go out.
- **June:** cold enough to fog the inside of closed rooms. Voices call people by name.
- **July:** toxic and relentless. Contact rolls every hour outdoors after dusk, and exposure costs 1D2 HP per hour.

## Using it at the table
Treat the mist as a clock and as a temptation. Every wasted scene it thickens; every deep breath gives a true clue at a price. Describe it tightening rather than announcing rules.
]==],
  },
  {
    id = "mist-contact", section = "The Mythos", kind = "fiction",
    title = "Mist Contact",
    summary = "Rules for the slow infection of everyone who breathes the mist, investigators and cultists alike.",
    body = [==[
Breathing the [[the-mist|mist]] puts a person in contact with the entity. Contact is tracked from 0 to 10 for every investigator and every important NPC.

## Gaining Contact
- **Exposure.** Each scene outdoors after dusk, or any scene in the tunnels: roll POW. On a failure, gain 1 Contact (1D3 in July).
- **Breathing deep.** An investigator may choose to breathe the mist on purpose: gain 1D2 Contact and receive one true clue from the Keeper as a vision.
- **Touch.** Touching the crystal body or the Seed of the [[amethyst-heart]]: gain 2 Contact.
- **Carrying the Seed.** Gain 1 Contact every hour. This is how [[the-fugitive]] was taken.

## Losing Contact
- **Salt.** A pinch of salt on the tongue before entering the mist gives a bonus die on the POW roll. This is the cult's oldest secret, and the reason salt is thrown into the drains at the [[winter-festival]].
- **The coast.** A full night below the Serra, near the sea at Santos, removes 1D3 Contact.
- Contact 9 or higher can never be reduced.

## The track
@contact

## Who is where
- Villagers: 1–2, kept low by salt and habit.
- Ordinary cultists of the [[company-of-shadows|Company]]: 5–7, stabilised with brine and salt.
- The [[chief-engineer]]: 8, and holding on with difficulty.
- [[dudu|Eduardo's]] father reached 10 in the 1950s. [[lenita|Lenita's]] brother is at 9 somewhere in the tunnels.

## Keeper note
Contact is a curse and a gift. The visions are true clues, and the Pull always points the right way. Let the players *choose* to breathe.
]==],
  },
  {
    id = "the-fugitive", section = "The Mythos", kind = "fiction",
    title = "The Fugitive",
    summary = "The man who carried the creature to the edge of the sea in 1866, and why it never arrived.",
    body = [==[
In 1866, while the São Paulo Railway was still cutting its way up the Serra {{spr-wiki}}, a man walked into the construction camp at Alto da Serra from the interior. He was starving, barefoot, and carried on his back a geode the size of a child's head, wrapped in wet sacking. He gave his name as **Bento Arruda**, a prospector from the amethyst country of the far south {{amethyst-wiki}}, and said he had been walking for months.

He said he was running. He never said from what.

## The truth
Bento was not running with the stone. **The stone was running, and he was its legs.** It had filled his lungs with mist in a flooded cave in the south and steered him east, always east, toward the sea it had been cut off from. Alto da Serra was the last ridge before the coast: Paranapiacaba, "the place from which one sees the sea" {{paranapiacaba-wiki}}. It could finally see the ocean.

It never reached it.

## The capture
The British engineers noticed that the fog followed Bento, that crews working near him never tired, and that they woke with solutions to engineering problems they had not been able to solve. They took the stone from him. That night Bento tried to carry it down the mountain in the dark. He was found at dawn at the foot of the first incline, **drowned on dry land, his lungs full of seawater.**

## Why they fed it
The engineers understood something quickly: a stone that can be carried will always find new legs. So they made sure no one could ever carry it again. They began to feed it, with seawater to keep it drowsy and with iron and stone to make it grow, until its body filled the tunnels under [[grota-funda]] and fused with the mountain. See [[amethyst-heart]] and [[company-car]].

Those engineers became the first [[company-of-shadows|Company of Shadows]].

## What the investigators can find
- In the [[castelinho]] study: Bento's water-stained notebook in Portuguese. The entries grow shorter as they near the coast. The last line reads: *"Daqui se vê o mar"*, "From here you can see the sea."
- In the camp register of 1866: a burial with the cause of death given as "drowning", on a mountain 800 m above the sea.
]==],
  },
  {
    id = "amethyst-heart", section = "The Mythos", kind = "mixed",
    title = "The Amethyst Heart",
    summary = "A seed of crystal carried here in 1866, fed for a century until its body became part of the mountain.",
    body = [==[
The creature has a heart and a body, and they are no longer the same size.

## The Seed
The original geode that [[the-fugitive|Bento Arruda]] carried up the mountain in 1866: about the size of a child's head, violet crystal inside, and on the outside a surface of coiled, finned shapes that no human hand carved. This is the creature's true core.

## The Body
For more than a century the [[company-of-shadows|Company]] fed the Seed, and it grew. Today a cathedral of violet crystal fills the chamber under [[grota-funda]], with veins running deep into the rock of the Serra. It weighs hundreds of tonnes and is part of the mountain. **It can never be moved.** That was the whole point. The Seed is still at its centre, sealed inside the crystal.

## Why amethyst, and what it eats *(History → Fiction)*
Amethyst is quartz, which is silica, coloured violet by iron impurities activated by radiation {{amethyst-wiki}}. Brazil's giant geodes form in the volcanic rocks of the far south, not in the granite of the Serra do Mar {{amethyst-usp}}.

The fiction takes this literally. The Company feeds the creature exactly what amethyst is made of:
- **Silica**: crushed granite ballast from the railway bed.
- **Iron**: filings from the worn steel cables, brake shoes and wheel tyres of the funicular, swept up at every landing.
- **Seawater**: the medium the crystals grow in, and the sedative that keeps the creature drowsy.

The creature supplies the radiance itself. The railway literally built its body. See [[company-car]].

## Game notes
- Touching the Body or the Seed: SAN 1/1D6, +2 [[mist-contact|Contact]], and a vision of the ocean floor.
- Cutting the Seed free takes an hour with railway tools and a successful Science (Geology) or Mechanical Repair roll. The noise draws the cult.
- The freed Seed weighs about 20 kg and can be carried, but its carrier gains 1 Contact every hour, which is how Bento died.
- Industrial dynamite from the railway stores can shatter the Seed: see [[ending-shatter]].
]==],
  },
  {
    id = "winter-festival", section = "The Mythos", kind = "mixed",
    title = "The Winter Festival",
    summary = "A tourist festival since 2001. A secret rite for more than a century before that.",
    body = [==[
## The public record *(History)*
Paranapiacaba's Winter Festival held its first public edition in July 2001: modest, spread over two weekends, and visited by about 11,000 people {{festival-origins}}. Today it is one of the village's best-known events.

## What the village knows *(Fiction)*
The festival did not begin in 2001. **That was the year the rest of São Paulo found out about it.**

Since the first [[company-car]] climbed the mountain, the [[company-of-shadows|Company of Shadows]] has held a festival every winter, on the coldest nights, when [[the-mist|the mist]] is thickest. To the railway families it was simply *the Festival*: bonfires in the fog, music, hot drinks, and nobody from outside. It was never advertised, never printed in a newspaper, and strangers who arrived during it were politely put on the next train down.

Underneath the celebration is the rite:
- Salt is thrown into the drains of the village. It keeps the villagers' [[mist-contact|contact]] shallow for another year.
- The brick culvert at the [[fourth-landing]] is "fed" by hand with brine and iron filings.
- The names of the year's dead and missing are read aloud at the [[castelinho]] by the [[chief-engineer]].
- At midnight every lamp goes out, and the village listens to the fog breathe.

## In 1974
With the tank car runs cut, the 1974 festival is desperate. The rite is bigger, louder and less careful, and for the first time outsiders are in the village to see it. The investigators arrive as it is being prepared.

## In 2001 *(Fiction)*
After the events of 1974, what was left of the Company could no longer keep the festival secret, so they did the opposite: they opened it to the public. Tourists now dance in the same fog, and nobody asks why the locals still throw salt into the drains.
]==],
  },
  {
    id = "company-car", section = "The Mythos", kind = "fiction",
    title = "The Company Car",
    summary = "The unlisted tank wagon of seawater, iron and stone that rode every up-train for a century.",
    body = [==[
Every train that climbed from Santos to the plateau was required to carry one extra car: a modified tank wagon listed in the books as "ballast", or not listed at all.

## The cargo
The tank held tons of seawater, and in it, a slurry of **crushed granite and iron filings**: the dust of the railway itself, collected from worn cables, brake shoes and wheels at every landing. At the [[fourth-landing]] the car drained its load underground towards [[grota-funda]].

The seawater kept the creature drowsy. The iron and stone fed the crystal body that keeps it chained to the mountain. See [[amethyst-heart]].

## The mechanical secret
In the fiction, the dead weight of this car is the hidden reason the railway needed such powerful fixed engines, steel cables and [[locobreques]]. The real reason was freight and a 796 m climb {{unesco}}, which makes the lie easy to believe.

## Clues
- Rust stains shaped like tide lines inside an abandoned tank car in the yard.
- Sealed barrels labelled "FILINGS — 4th LANDING" stacked behind the engine shed.
- Accounts showing "ballast water" costs no auditor has ever questioned (see [[dudu]]).
- A missing worker's last letter about "something alive at the bottom of the tank" (see [[lenita]]).
]==],
  },

  ---------------------------------------------------------------- FACTIONS
  {
    id = "company-of-shadows", section = "Factions", kind = "fiction",
    title = "The Company of Shadows",
    summary = "The old British shareholders' secret order, and the local families that serve it.",
    body = [==[
A secret order founded by the British engineers who captured [[the-fugitive|Bento Arruda's]] stone in 1866, later joined by the railway's shareholders and a handful of local families. They serve the entity for prosperity and for the engineering and alchemical secrets it whispers. The impossible railway was their first miracle.

After nationalisation in 1946 {{spr-wiki}}, the shareholders lost the railway but kept the cult. Its members stayed on as engineers, foremen and clerks, and kept the [[company-car]] running under a new flag.

## Infected by devotion
Every member of the Company breathes the mist on purpose, and every one of them is deep in [[mist-contact|Contact]]. They keep themselves from drowning in it with salt on the tongue and brine in their tea. Their silent hand-signs are something they learned from the creature, not from each other.

Every winter since 1868 the Company has hidden its rite inside a private village celebration, which the public only discovered in 2001: see [[winter-festival]].

## In 1974
The order is frightened and split. Without the tank cars the mist is louder in their heads every night. Some want to drag the creature to the new rack line; others plan a sacrifice large enough to buy time. All of them want the RFFSA auditors gone. They are led by the [[chief-engineer]].
]==],
  },
  {
    id = "chief-engineer", section = "Factions", kind = "fiction",
    title = "The Chief Engineer",
    summary = "Grand Master of the cult, resident of the Castelinho, keeper of the telegraphs.",
    body = [==[
Whoever holds the post of chief engineer and lives in the [[castelinho]] is, by ritual right, Grand Master of the [[company-of-shadows|Company of Shadows]]. Every appointee since the 19th century has been recruited, one way or another. The office passes on when a chief engineer finally "drowns".

The current chief engineer uses the railway's telegraphs and logbooks to arrange sacrifices and hide the enormous consumption of seawater and iron. He is courteous, tired and very afraid. He is at [[mist-contact|Contact]] 8, sucks salt pastilles constantly, and hears the creature every waking minute. He knows better than anyone what happens when the water runs out.

## Playing him
He does not want the investigators dead at first. He wants them to *understand*, and then to help. Offer them a deal before offering them a knife. If an investigator is Tide-touched, he will speak to them in the cult's silent signs, and they will understand.
]==],
  },

  ---------------------------------------------------------------- ENDINGS
  {
    id = "ending-sea", section = "Endings", kind = "fiction",
    title = "Ending A — Return to the Sea",
    summary = "Cut the Seed free and carry it down to the ocean it was fleeing toward.",
    body = [==[
**Action.** The investigators cut the Seed free from the crystal Body of the [[amethyst-heart]] and carry it down to the sea at Santos, on the last funicular train pulled by a [[locobreques|locobreque]] in steam, or through the old drainage culverts. Every hour the carrier gains 1 [[mist-contact|Contact]], and the creature sings the whole way down. Someone has to make the trip Bento Arruda never finished.

**Consequence.** Without its Seed, the crystal Body under the mountain goes dark, and the deadly mist lifts from [[paranapiacaba|Paranapiacaba]]. But the horror returns to its element. Strange events, mysterious shipwrecks and sightings of a maelstrom return to the São Paulo coast.

**For the table.** A bittersweet ending that sets up a sequel on the coast. Surviving investigators each lose 1D6 SAN as they watch the sea "breathe", and their Contact never quite falls back to zero.
]==],
  },
  {
    id = "ending-shatter", section = "Endings", kind = "fiction",
    title = "Ending B — Shatter the Stone",
    summary = "Break the amethyst with railway dynamite, and pay for it with the village.",
    body = [==[
**Action.** The investigators shatter the Seed at the centre of the [[amethyst-heart]] with industrial dynamite from the railway stores.

**Consequence.** The entity is "killed", but a century of energy stored in its crystal Body is released at once in a pneumatic blast. [[the-mist|The mist]] settles on the village for good, now voiceless and endless, leaving Paranapiacaba forever inside a timeless fog, maddened and cut off from the rest of Brazil.

**For the table.** A pyrrhic victory. The coast is safe; the village is lost. Anyone in the chamber makes a CON roll or loses 2D6 HP, and a SAN roll or loses 1D10. Everyone at Contact 7 or higher hears the creature's last scream, and loses an extra 1D6 SAN.
]==],
  },
  {
    id = "ending-lost", section = "Endings", kind = "fiction",
    title = "Ending C — The Mist Keeps Its Own",
    summary = "Optional failure state: the investigators run out of time.",
    body = [==[
*Optional ending, for tables that like real stakes.*

If the investigators waste too many scenes, the mist reaches its July stage before they reach [[grota-funda]]. The creature does not wake; it simply *spreads*. The cult is found drowned in a dry tunnel. The investigators wake in Santos with no memory of the last week, and a lingering taste of salt.

The same ending applies to any investigator who reaches [[mist-contact|Contact]] 10: they are simply not there when the others wake.

This ending exists so that the [[the-mist|mist clock]] actually matters.
]==],
  },

  ---------------------------------------------------------------- REFERENCE
  {
    id = "sources", section = "Reference", kind = "history",
    title = "Sources",
    summary = "Every real-world reference cited in this grimoire.",
    body = "@sources",
  },
  {
    id = "about", section = "Reference", kind = "mixed",
    title = "About this Grimoire",
    summary = "Who wrote it, how it is built, and how to use it.",
    body = [==[
*The Mist over the Funicular* is an original investigation scenario for [[sources|Call of Cthulhu 7th Edition]] {{coc7}}, written by **Murillo França M. da Silva**, a game master for over ten years (D&D, Tormenta and others).

## How it is built
The whole grimoire is plain **Lua** data: pages, investigators, sources, a timeline and a scenario graph. A small Lua build script turns them into this website. At build time the script:
- checks that every internal link and every citation points to something real;
- recomputes each investigator's derived stats (HP, MP, Sanity, Move, Damage Bonus, Build) from the Call of Cthulhu 7e rules and fails if the sheet disagrees;
- walks the [[scenario-flow]] graph and fails if any scene is unreachable or any path dead-ends before an ending;
- generates the backlinks ("Referenced from") shown at the bottom of each page.

Treat it as content and scripting practice together: narrative written as data, then checked by code.

## Political context
The scenario is set under Brazil's military government {{dictatorship-wiki}}. Censorship, a state-run railway and an activist on the train give the table real pressure without needing a villain in uniform.
]==],
  },
}
