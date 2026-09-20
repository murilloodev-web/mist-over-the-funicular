-- Mist Contact track. Breathing the mist puts an investigator in contact with
-- the entity. build.lua checks that the tiers cover 0..max with no gaps or
-- overlaps, so every possible Contact score has exactly one effect.

return {
  max = 10,
  tiers = {
    { from = 0, to = 0, name = "Clear",
      effect = "Ordinary fog. Nothing speaks." },
    { from = 1, to = 2, name = "Whispers",
      effect = "You hear your own name in the fog. Take a bonus die on Listen rolls while inside the mist." },
    { from = 3, to = 4, name = "Visions",
      effect = "Dreams of the ocean floor. Once per night the Keeper gives you one true clue as a vision (SAN 0/1)." },
    { from = 5, to = 6, name = "The Pull",
      effect = "You always know which way Grota Funda lies. Leaving the mist of your own free will requires a POW roll." },
    { from = 7, to = 8, name = "Tide-touched",
      effect = "Cold, damp skin and a craving for salt. You understand the cult's silent gestures. Once per scene the entity may ask something of you: resist with an opposed POW roll or obey." },
    { from = 9, to = 9, name = "Brine-speaker",
      effect = "The entity speaks through your mouth when the mist is thick. Contact can no longer be reduced below 9." },
    { from = 10, to = 10, name = "Drowned",
      effect = "You walk into the mist and do not come back as yourself. The investigator becomes a voice of the entity and is lost." },
  },
}
