-- Scenario graph. Each node is a scene; `next` lists the exits and the
-- condition that opens them. build.lua checks that every scene is reachable
-- from `start`, and that every path ends in an ending (no dead ends).

return {
  start = "arrival",
  nodes = {
    { id = "arrival", title = "Arrival at Alto da Serra", page = "paranapiacaba",
      text = "The three investigators reach the village by train and by road on a winter night, as the village prepares a festival nobody outside has heard of. The mist is already wrong.",
      next = {
        { to = "yard",       when = "Dudu starts his audit" },
        { to = "festivities",when = "Lenita joins the protest at the station" },
        { to = "tunnel",     when = "Arthur goes looking for his negative" },
      } },
    { id = "yard", title = "The Rail Yard", page = "company-car",
      text = "An abandoned tank car with tide-line rust. Ledgers full of 'ballast water'.",
      next = {
        { to = "castelinho", when = "Accounting or Spot Hidden reveals the telegraph codes" },
        { to = "landing",    when = "Mechanical Repair traces the drain pipes" },
      } },
    { id = "festivities", title = "The Winter Festival", page = "winter-festival",
      text = "A private village festival: bonfires in the fog, salt thrown into the drains, names read aloud. An old railwayman speaks of the car that never appears on timetables.",
      next = {
        { to = "yard",       when = "Persuade the old railwayman" },
        { to = "castelinho", when = "The chief engineer invites the 'troublemakers' to dinner" },
      } },
    { id = "tunnel", title = "The Tunnel", page = "the-mist",
      text = "Arthur's old shot, retaken. The mist has faces. Someone is watching from the Castelinho.",
      next = {
        { to = "castelinho", when = "Follow the watcher uphill" },
        { to = "landing",    when = "Follow the sound of water under the rock" },
      } },
    { id = "castelinho", title = "Dinner at the Castelinho", page = "castelinho",
      text = "The chief engineer offers a deal. The study holds the geode sketch and the 19th-century letters.",
      next = {
        { to = "landing",    when = "Accept the deal, or steal the study key" },
        { to = "grota",      when = "The chief engineer leads them down himself" },
      } },
    { id = "landing", title = "The Fourth Landing", page = "fourth-landing",
      text = "The machine house and the brick culvert that swallows seawater.",
      next = {
        { to = "grota",      when = "Crawl the culvert" },
      } },
    { id = "grota", title = "Beneath Grota Funda", page = "grota-funda",
      text = "A chamber of violet crystal grown from the rock, the Seed sealed at its centre, cultists hauling brine by hand while the dying mist screams in every head. The choice.",
      next = {
        { to = "ending-sea",     when = "Free the creature to the ocean" },
        { to = "ending-shatter", when = "Shatter the amethyst" },
        { to = "ending-lost",    when = "Too slow: the July mist arrives first" },
      } },
    { id = "ending-sea",     title = "Ending A — Return to the Sea",       page = "ending-sea",     ending = true },
    { id = "ending-shatter", title = "Ending B — Shatter the Stone",       page = "ending-shatter", ending = true },
    { id = "ending-lost",    title = "Ending C — The Mist Keeps Its Own",  page = "ending-lost",    ending = true },
  },
}
