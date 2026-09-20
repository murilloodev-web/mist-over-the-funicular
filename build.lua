-- build.lua — turns the grimoire's Lua data into a static website in docs/.
--
--   lua build.lua            validate + build
--   lua build.lua --check    validate only
--
-- Validation stops the build on: unknown internal links, unknown or unused
-- citations, investigator sheets that break the CoC 7e rules, timeline
-- entries without sources, and unreachable or dead-end scenes.

local CHECK_ONLY = arg and arg[1] == "--check"
local OUT = "docs"

local pages        = dofile("data/pages.lua")
local investigators= dofile("data/investigators.lua")
local sources      = dofile("data/sources.lua")
local timeline     = dofile("data/timeline.lua")
local flow         = dofile("data/flow.lua")
local contact      = dofile("data/contact.lua")

local SITE_TITLE = "The Mist over the Funicular"
local AUTHOR     = "Murillo França M. da Silva"

---------------------------------------------------------------------------
-- Error collection
---------------------------------------------------------------------------
local errors = {}
local function fail(fmt, ...) errors[#errors + 1] = string.format(fmt, ...) end

---------------------------------------------------------------------------
-- Registry: every addressable page, in reading order
---------------------------------------------------------------------------
local registry, order = {}, {}
local SECTION_ORDER = { "The Scenario", "Places", "The Mythos", "Factions",
                        "Investigators", "Endings", "Reference" }

local function register(p)
  if registry[p.id] then fail("duplicate page id '%s'", p.id) end
  registry[p.id] = p
end

for _, p in ipairs(pages) do register(p) end
for _, inv in ipairs(investigators) do
  register({
    id = inv.id, section = "Investigators", kind = "fiction",
    title = inv.name, summary = inv.role .. " — " .. inv.occupation,
    investigator = inv,
  })
end

for _, section in ipairs(SECTION_ORDER) do
  for _, p in ipairs(pages) do
    if p.section == section then order[#order + 1] = registry[p.id] end
  end
  if section == "Investigators" then
    for _, inv in ipairs(investigators) do order[#order + 1] = registry[inv.id] end
  end
end
for _, p in ipairs(pages) do
  local known = false
  for _, s in ipairs(SECTION_ORDER) do if s == p.section then known = true end end
  if not known then fail("page '%s' has unknown section '%s'", p.id, tostring(p.section)) end
end

local source_index, source_used = {}, {}
for i, s in ipairs(sources) do
  if source_index[s.id] then fail("duplicate source id '%s'", s.id) end
  source_index[s.id] = i
end

---------------------------------------------------------------------------
-- Call of Cthulhu 7e rules
---------------------------------------------------------------------------
local coc = {}

function coc.hp(c)  return (c.CON + c.SIZ) // 10 end
function coc.mp(c)  return c.POW // 5 end
function coc.san(c) return c.POW end

function coc.damage_bonus(c)
  local t = c.STR + c.SIZ
  if t <= 64  then return "−2", -2
  elseif t <= 84  then return "−1", -1
  elseif t <= 124 then return "None", 0
  elseif t <= 164 then return "+1D4", 1
  else return "+1D6", 2 end
end

function coc.move(c)
  if c.DEX < c.SIZ and c.STR < c.SIZ then return 7 end
  if c.DEX > c.SIZ and c.STR > c.SIZ then return 9 end
  return 8
end

function coc.split(v) return v, v // 2, v // 5 end  -- regular / hard / extreme

for _, inv in ipairs(investigators) do
  local c = inv.characteristics
  for _, k in ipairs({ "STR", "CON", "SIZ", "DEX", "APP", "INT", "POW", "EDU" }) do
    local v = c[k]
    if type(v) ~= "number" or v < 15 or v > 90 then
      fail("%s: %s = %s is outside the 15–90 human range", inv.id, k, tostring(v))
    end
  end
  local derived = { HP = coc.hp(c), SAN = coc.san(c) }
  for k, v in pairs(inv.declared or {}) do
    if derived[k] ~= v then
      fail("%s: sheet says %s = %d but the rules give %d", inv.id, k, v, derived[k])
    end
  end
end

---------------------------------------------------------------------------
-- Scenario graph checks
---------------------------------------------------------------------------
local nodes = {}
for _, n in ipairs(flow.nodes) do
  if nodes[n.id] then fail("flow: duplicate scene '%s'", n.id) end
  nodes[n.id] = n
  if n.page and not registry[n.page] then fail("flow: scene '%s' points to unknown page '%s'", n.id, n.page) end
end

local function reach(from, edges_of)
  local seen, queue = { [from] = true }, { from }
  while #queue > 0 do
    local id = table.remove(queue, 1)
    for _, to in ipairs(edges_of(id)) do
      if not seen[to] then seen[to] = true; queue[#queue + 1] = to end
    end
  end
  return seen
end

local forward, backward = {}, {}
for _, n in ipairs(flow.nodes) do forward[n.id], backward[n.id] = {}, {} end
for _, n in ipairs(flow.nodes) do
  if not n.ending and (not n.next or #n.next == 0) then
    fail("flow: scene '%s' is a dead end (no exits and not an ending)", n.id)
  end
  for _, e in ipairs(n.next or {}) do
    if not nodes[e.to] then fail("flow: '%s' exits to unknown scene '%s'", n.id, e.to)
    else
      table.insert(forward[n.id], e.to)
      table.insert(backward[e.to], n.id)
    end
  end
end

local depth = {}
do
  local queue = { flow.start }; depth[flow.start] = 0
  while #queue > 0 do
    local id = table.remove(queue, 1)
    for _, to in ipairs(forward[id] or {}) do
      if depth[to] == nil then depth[to] = depth[id] + 1; queue[#queue + 1] = to end
    end
  end
end

local reachable = reach(flow.start, function(id) return forward[id] or {} end)
local can_finish = {}
for _, n in ipairs(flow.nodes) do
  if n.ending then
    for id in pairs(reach(n.id, function(x) return backward[x] or {} end)) do can_finish[id] = true end
  end
end
local ending_count = 0
for _, n in ipairs(flow.nodes) do
  if n.ending then ending_count = ending_count + 1 end
  if not reachable[n.id] then fail("flow: scene '%s' can never be reached", n.id) end
  if not can_finish[n.id] then fail("flow: from scene '%s' no ending can be reached", n.id) end
end

---------------------------------------------------------------------------
-- Mist Contact track: tiers must cover 0..max exactly once
---------------------------------------------------------------------------
do
  local expect = 0
  for _, t in ipairs(contact.tiers) do
    if t.from ~= expect then fail("contact: tier '%s' starts at %d, expected %d (gap or overlap)", t.name, t.from, expect) end
    if t.to < t.from then fail("contact: tier '%s' ends before it starts", t.name) end
    expect = t.to + 1
  end
  if expect - 1 ~= contact.max then fail("contact: tiers stop at %d but max is %d", expect - 1, contact.max) end
end

---------------------------------------------------------------------------
-- Timeline checks
---------------------------------------------------------------------------
for i, t in ipairs(timeline) do
  if t.kind == "history" and not t.source then fail("timeline #%d (%s) is history but has no source", i, t.year) end
  if t.kind == "fiction" and t.source then fail("timeline #%d (%s) is fiction but cites a source", i, t.year) end
  if t.source then
    if not source_index[t.source] then fail("timeline #%d cites unknown source '%s'", i, t.source)
    else source_used[t.source] = true end
  end
end

---------------------------------------------------------------------------
-- Markup
---------------------------------------------------------------------------
local backlinks = {}   -- target id -> { [source page id] = true }

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- inline markup; `from` is the page id doing the linking
local function inline(s, from, cited)
  s = esc(s)
  -- "the [[castelinho]]" should read "the Castelinho", not "the The Castelinho"
  s = s:gsub("([Tt]he )%[%[([%w%-]+)%]%]", function(article, id)
    local t = registry[id] and registry[id].title
    if t and t:match("^The ") then return article .. "[[" .. id .. "|" .. t:sub(5) .. "]]" end
  end)
  s = s:gsub("%[%[([^%]|]+)|?([^%]]*)%]%]", function(id, label)
    local target = registry[id]
    if not target then fail("page '%s' links to unknown page '%s'", from, id); return label ~= "" and label or id end
    if id ~= from then
      backlinks[id] = backlinks[id] or {}
      backlinks[id][from] = true
    end
    return string.format('<a class="xref" href="%s.html">%s</a>', id, label ~= "" and label or target.title)
  end)
  s = s:gsub("{{([%w%-]+)}}", function(id)
    local n = source_index[id]
    if not n then fail("page '%s' cites unknown source '%s'", from, id); return "" end
    source_used[id] = true
    if cited then cited[id] = true end
    return string.format('<sup class="cite"><a href="sources.html#src-%s" title="%s">[%d]</a></sup>',
      id, esc(sources[n].title), n)
  end)
  s = s:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
  s = s:gsub("%*(.-)%*", "<em>%1</em>")
  s = s:gsub("%(Fiction%)", '<span class="tag tag-fiction">Fiction</span>')
  s = s:gsub("%(History%)", '<span class="tag tag-history">History</span>')
  s = s:gsub("%(History → Fiction%)", '<span class="tag tag-mixed">History → Fiction</span>')
  return s
end

local function slug(s) return (s:lower():gsub("[^%w]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")) end

local function blocks(text, from, cited, toc)
  local out, para, list = {}, {}, {}
  local function flush()
    if #para > 0 then out[#out + 1] = "<p>" .. inline(table.concat(para, " "), from, cited) .. "</p>"; para = {} end
    if #list > 0 then
      local items = {}
      for _, li in ipairs(list) do items[#items + 1] = "<li>" .. inline(li, from, cited) .. "</li>" end
      out[#out + 1] = "<ul>" .. table.concat(items) .. "</ul>"; list = {}
    end
  end
  for line in (text .. "\n"):gmatch("(.-)\n") do
    line = line:gsub("^%s+", ""):gsub("%s+$", "")
    if line == "" then flush()
    elseif line:sub(1, 3) == "## " then
      flush()
      local h = line:sub(4)
      local plain = h:gsub("%*", ""):gsub("%b()", "")
      local anchor = slug(plain)
      if toc then toc[#toc + 1] = { anchor = anchor, text = plain:gsub("%s+$", "") } end
      out[#out + 1] = string.format('<h2 id="%s">%s</h2>', anchor, inline(h, from, cited))
    elseif line:sub(1, 2) == "- " then
      if #para > 0 then local l = list; list = {}; flush(); list = l end
      list[#list + 1] = line:sub(3)
    elseif line:sub(1, 2) == "> " then
      flush(); out[#out + 1] = "<blockquote>" .. inline(line:sub(3), from, cited) .. "</blockquote>"
    else
      if #list > 0 then local p = para; para = {}; flush(); para = p end
      para[#para + 1] = line
    end
  end
  flush()
  return table.concat(out, "\n")
end

---------------------------------------------------------------------------
-- Special bodies
---------------------------------------------------------------------------
local KIND_LABEL = { history = "History", fiction = "Fiction", mixed = "History + Fiction" }

local function render_timeline(from, cited)
  local rows = {}
  for _, t in ipairs(timeline) do
    local cite = t.source and (" " .. inline("{{" .. t.source .. "}}", from, cited)) or ""
    rows[#rows + 1] = string.format(
      '<li class="tl tl-%s"><span class="tl-year">%s</span><span class="tag tag-%s">%s</span><p>%s%s</p></li>',
      t.kind, esc(t.year), t.kind, KIND_LABEL[t.kind], inline(t.text, from, cited), cite)
  end
  return '<p class="lede">Documented events carry a citation. Scenario events are marked <span class="tag tag-fiction">Fiction</span>.</p>'
    .. '<ol class="timeline">' .. table.concat(rows, "\n") .. "</ol>"
end

local function render_flow_svg()
  -- lay scenes out in rows by BFS depth from the start scene
  local rows, maxdepth = {}, 0
  for _, n in ipairs(flow.nodes) do
    local d = depth[n.id] or 0
    rows[d] = rows[d] or {}
    table.insert(rows[d], n)
    if d > maxdepth then maxdepth = d end
  end
  local W, BW, BH, RH, TOP = 800, 186, 46, 104, 20
  local pos = {}
  for d = 0, maxdepth do
    local r = rows[d] or {}
    local gap = W / (#r + 1)
    for i, n in ipairs(r) do pos[n.id] = { x = gap * i, y = TOP + d * RH } end
  end
  local H = TOP + maxdepth * RH + BH + 20
  local edges, boxes = {}, {}
  for _, n in ipairs(flow.nodes) do
    for _, e in ipairs(n.next or {}) do
      local a, b = pos[n.id], pos[e.to]
      if a and b then
        if math.abs(a.y - b.y) < 1 then
          local dir = b.x > a.x and 1 or -1
          edges[#edges + 1] = string.format(
            '<path d="M%.0f %.0f L%.0f %.0f" class="edge" marker-end="url(#arrow)"><title>%s</title></path>',
            a.x + dir * BW / 2, a.y + BH / 2, b.x - dir * (BW / 2 + 4), b.y + BH / 2, esc(e.when))
        else
          local y1, y2 = a.y + BH, b.y - 4
          local my = (y1 + y2) / 2
          edges[#edges + 1] = string.format(
            '<path d="M%.0f %.0f C%.0f %.0f %.0f %.0f %.0f %.0f" class="edge" marker-end="url(#arrow)"><title>%s</title></path>',
            a.x, y1, a.x, my, b.x, my, b.x, y2, esc(e.when))
        end
      end
    end
    local p = pos[n.id]
    local label = n.title:gsub(" — .*", "")
    boxes[#boxes + 1] = string.format(
      '<a href="#scene-%s"><rect x="%.0f" y="%.0f" width="%d" height="%d" rx="6" class="node%s"/>'
      .. '<text x="%.0f" y="%.0f" class="node-label">%s</text></a>',
      n.id, p.x - BW / 2, p.y, BW, BH, n.ending and " node-end" or "",
      p.x, p.y + BH / 2 + 5, esc(n.ending and n.title:match("^(Ending %a)") or label))
  end
  return string.format(
    '<figure class="flow"><svg viewBox="0 0 %d %d" role="img" aria-label="Scenario flow diagram">'
    .. '<defs><marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">'
    .. '<path d="M0 0 L10 5 L0 10 z" class="arrowhead"/></marker></defs>%s%s</svg>'
    .. '<figcaption>Each box is a scene; click one to jump to it. Hover an arrow to see what opens that path.</figcaption></figure>',
    W, H, table.concat(edges), table.concat(boxes))
end

local function render_flow(from, cited)
  local cards = {}
  for _, n in ipairs(flow.nodes) do
    local exits = {}
    for _, e in ipairs(n.next or {}) do
      exits[#exits + 1] = string.format('<li><a href="#scene-%s">%s</a> <span class="when">— %s</span></li>',
        e.to, esc(nodes[e.to].title), esc(e.when))
    end
    cards[#cards + 1] = string.format(
      '<section class="scene%s" id="scene-%s"><h3>%s</h3>%s%s<p class="scene-page">Read more: %s</p></section>',
      n.ending and " scene-end" or "", n.id, esc(n.title),
      n.text and ("<p>" .. inline(n.text, from, cited) .. "</p>") or "",
      #exits > 0 and ('<ul class="exits">' .. table.concat(exits) .. "</ul>") or "",
      inline("[[" .. n.page .. "]]", from, cited))
  end
  local reach_count = 0
  for _ in pairs(reachable) do reach_count = reach_count + 1 end
  return string.format('<p class="lede">%d scenes, %d endings. Every scene is reachable from the arrival, and every path leads to an ending; the build script checks both.</p>',
      #flow.nodes, ending_count)
    .. render_flow_svg() .. table.concat(cards, "\n")
end

local function render_contact()
  local rows = {}
  for _, t in ipairs(contact.tiers) do
    local range = t.from == t.to and tostring(t.from) or (t.from .. "–" .. t.to)
    local pips = {}
    for i = 1, contact.max do
      pips[#pips + 1] = string.format('<i class="pip%s"></i>', (i >= t.from and i <= t.to) and " on" or "")
    end
    rows[#rows + 1] = string.format(
      '<tr><td class="c-range">%s</td><td><strong>%s</strong><span class="pips" aria-hidden="true">%s</span><p>%s</p></td></tr>',
      range, esc(t.name), table.concat(pips), esc(t.effect))
  end
  return '<div class="table-wrap"><table class="contact"><thead><tr><th>Contact</th><th>Effect</th></tr></thead><tbody>'
    .. table.concat(rows) .. "</tbody></table></div>"
end

local function render_sources()
  local items = {}
  for i, s in ipairs(sources) do
    items[#items + 1] = string.format(
      '<li id="src-%s"><span class="src-n">[%d]</span><div><a href="%s" rel="noopener" target="_blank">%s</a>'
      .. '<span class="src-pub">%s</span><p>%s</p></div></li>',
      s.id, i, esc(s.url), esc(s.title), esc(s.publisher), esc(s.note))
  end
  return '<p class="lede">Real-world references behind the history in this grimoire. External links open in a new tab.</p>'
    .. '<ol class="sources">' .. table.concat(items, "\n") .. "</ol>"
end

local function render_investigator(inv, from, cited)
  local c = inv.characteristics
  local chars = {}
  for _, k in ipairs({ "STR", "CON", "SIZ", "DEX", "APP", "INT", "POW", "EDU" }) do
    local r, h, x = coc.split(c[k])
    chars[#chars + 1] = string.format('<div class="stat"><span class="stat-k">%s</span><span class="stat-v">%d</span><span class="stat-hx">%d / %d</span></div>', k, r, h, x)
  end
  local db, build = coc.damage_bonus(c)
  local derived = {
    { "Hit Points", coc.hp(c) }, { "Sanity", coc.san(c) }, { "Magic Points", coc.mp(c) },
    { "Move", coc.move(c) }, { "Damage Bonus", db }, { "Build", build },
  }
  local der = {}
  for _, d in ipairs(derived) do
    der[#der + 1] = string.format('<div class="derived"><span>%s</span><strong>%s</strong></div>', d[1], tostring(d[2]))
  end
  local skills = {}
  for _, s in ipairs(inv.skills) do
    local r, h, x = coc.split(s[2])
    skills[#skills + 1] = string.format('<tr><td>%s</td><td>%d%%</td><td>%d</td><td>%d</td></tr>', esc(s[1]), r, h, x)
  end
  local rel = {}
  for _, id in ipairs(inv.links or {}) do rel[#rel + 1] = inline("[[" .. id .. "]]", from, cited) end
  return table.concat({
    string.format('<blockquote class="epigraph">“%s”</blockquote>', esc(inv.quote)),
    string.format('<p class="occupation">%s</p>', esc(inv.occupation)),
    "<h2 id=\"motivation\">Motivation</h2><p>" .. inline(inv.motivation, from, cited) .. "</p>",
    "<h2 id=\"personal-hook\">Personal hook</h2><p>" .. inline(inv.hook, from, cited) .. "</p>",
    '<h2 id="characteristics">Characteristics</h2><p class="hint">Regular value, then Hard (½) / Extreme (⅕).</p>',
    '<div class="stats">' .. table.concat(chars) .. "</div>",
    '<div class="derived-row">' .. table.concat(der) .. "</div>",
    '<p class="hint">Derived values are computed by <code>build.lua</code> from the CoC 7e rules.</p>',
    '<h2 id="key-skills">Key skills</h2><div class="table-wrap"><table class="skills"><thead><tr><th>Skill</th><th>Regular</th><th>Hard</th><th>Extreme</th></tr></thead><tbody>'
      .. table.concat(skills) .. "</tbody></table></div>",
    '<h2 id="equipment">Equipment (1974)</h2><p>' .. esc(inv.gear) .. "</p>",
    '<h2 id="threads">Threads to pull</h2><ul class="pills"><li>' .. table.concat(rel, "</li><li>") .. "</li></ul>",
  }, "\n")
end

---------------------------------------------------------------------------
-- Layout
---------------------------------------------------------------------------
local function nav_html(current)
  local out = {}
  for _, section in ipairs(SECTION_ORDER) do
    local items = {}
    for _, p in ipairs(order) do
      if p.section == section then
        items[#items + 1] = string.format('<li><a href="%s.html"%s>%s</a></li>', p.id,
          p.id == current and ' aria-current="page"' or "", esc(p.title))
      end
    end
    out[#out + 1] = string.format('<h4>%s</h4><ul>%s</ul>', esc(section), table.concat(items))
  end
  return table.concat(out)
end

local FONTS = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
  .. '<link href="https://fonts.googleapis.com/css2?family=Pirata+One&family=Silkscreen:wght@400;700&family=EB+Garamond:ital,wght@0,400;0,500;0,600;1,400&display=swap" rel="stylesheet">'

local function layout(p, title, content, current)
  return string.format([[<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>%s</title>
<meta name="description" content="%s">
%s
<link rel="stylesheet" href="style.css">
</head>
<body>
<a class="skip" href="#main">Skip to content</a>
<header class="topbar">
  <a class="brand" href="index.html"><span class="sigil" aria-hidden="true"></span> %s</a>
  <button class="menu" aria-expanded="false" aria-controls="nav">Contents</button>
</header>
<div class="shell">
  <nav id="nav" class="nav" aria-label="Grimoire contents">%s</nav>
  <main id="main">%s</main>
</div>
<footer class="foot">
  <p><em>%s</em> — an original Call of Cthulhu 7e scenario by %s. Built from Lua data with <code>build.lua</code>.</p>
</footer>
<script>
  const b=document.querySelector('.menu'),n=document.getElementById('nav');
  b.addEventListener('click',()=>{const o=n.classList.toggle('open');b.setAttribute('aria-expanded',o)});
</script>
</body>
</html>
]], esc(title), esc(p and p.summary or "An investigation grimoire for Call of Cthulhu 7th Edition, set in Paranapiacaba, Brazil, 1974."),
    FONTS, esc(SITE_TITLE), nav_html(current), content, esc(SITE_TITLE), esc(AUTHOR))
end

local function render_page(p, idx)
  local cited, toc = {}, {}
  local body
  if p.investigator then body = render_investigator(p.investigator, p.id, cited)
  elseif p.body == "@timeline" then body = render_timeline(p.id, cited)
  elseif p.body == "@flow" then body = render_flow(p.id, cited)
  elseif p.body == "@sources" then body = render_sources()
  else
    body = blocks(p.body, p.id, cited, toc)
    body = body:gsub("<p>@contact</p>", function() return render_contact() end)
  end
  return { page = p, idx = idx, body = body, cited = cited, toc = toc }
end

local function finish_page(r)
  local p = r.page
  local parts = {
    string.format('<p class="crumb">%s</p>', esc(p.section)),
    string.format('<h1>%s</h1>', esc(p.title)),
    string.format('<p class="meta"><span class="tag tag-%s">%s</span> <span class="summary">%s</span></p>',
      p.kind, KIND_LABEL[p.kind], esc(p.summary or "")),
  }
  if #r.toc >= 3 then
    local t = {}
    for _, h in ipairs(r.toc) do t[#t + 1] = string.format('<li><a href="#%s">%s</a></li>', h.anchor, esc(h.text)) end
    parts[#parts + 1] = '<nav class="onpage" aria-label="On this page"><span>On this page</span><ul>' .. table.concat(t) .. "</ul></nav>"
  end
  parts[#parts + 1] = '<article class="prose">' .. r.body .. "</article>"

  local refs = {}
  for i, s in ipairs(sources) do
    if r.cited[s.id] then
      refs[#refs + 1] = string.format('<li><span class="src-n">[%d]</span> <a href="%s" rel="noopener" target="_blank">%s</a> <span class="src-pub">— %s</span></li>',
        i, esc(s.url), esc(s.title), esc(s.publisher))
    end
  end
  if #refs > 0 then
    parts[#parts + 1] = '<aside class="refs"><h2 id="references">References on this page</h2><ul>' .. table.concat(refs) .. "</ul></aside>"
  end

  local bl = {}
  for _, q in ipairs(order) do
    if backlinks[p.id] and backlinks[p.id][q.id] then
      bl[#bl + 1] = string.format('<li><a href="%s.html">%s</a></li>', q.id, esc(q.title))
    end
  end
  if #bl > 0 then
    parts[#parts + 1] = '<aside class="backlinks"><h2 id="referenced-from">Referenced from</h2><ul class="pills">' .. table.concat(bl) .. "</ul></aside>"
  end

  local prev, nxt = order[r.idx - 1], order[r.idx + 1]
  parts[#parts + 1] = string.format('<nav class="pager" aria-label="Page navigation">%s%s</nav>',
    prev and string.format('<a class="prev" href="%s.html"><span>Previous</span>%s</a>', prev.id, esc(prev.title)) or "<span></span>",
    nxt and string.format('<a class="next" href="%s.html"><span>Next</span>%s</a>', nxt.id, esc(nxt.title)) or "<span></span>")

  return layout(p, p.title .. " · " .. SITE_TITLE, table.concat(parts, "\n"), p.id)
end

local function render_index()
  local sections = {}
  for _, section in ipairs(SECTION_ORDER) do
    local cards = {}
    for _, p in ipairs(order) do
      if p.section == section then
        cards[#cards + 1] = string.format(
          '<a class="card" href="%s.html"><span class="tag tag-%s">%s</span><strong>%s</strong><span>%s</span></a>',
          p.id, p.kind, KIND_LABEL[p.kind], esc(p.title), esc(p.summary or ""))
      end
    end
    sections[#sections + 1] = string.format('<section class="toc-section"><h2 id="%s">%s</h2><div class="cards">%s</div></section>',
      slug(section), esc(section), table.concat(cards))
  end
  local content = table.concat({
    '<div class="cover">',
    '<img class="banner" src="banner.svg" width="192" height="72" alt="Pixel-art dusk over the Serra do Mar: a tank wagon climbs the funicular toward the Castelinho while fog rises from the valley.">',
    '<p class="kicker">A Call of Cthulhu 7th Edition scenario · Paranapiacaba, Brazil · May–July 1974</p>',
    '<h1 class="cover-title">The Mist over<br>the Funicular</h1>',
    '<p class="cover-lede">In 1974 the government begins closing a century-old mountain railway to save money. '
      .. 'Nobody told it what the railway was really carrying.</p>',
    '<div class="cover-actions"><a class="btn" href="synopsis.html">Open the grimoire</a>'
      .. '<a class="btn btn-ghost" href="scenario-flow.html">See the scenario flow</a></div>',
    '<p class="legend"><span class="tag tag-history">History</span> documented and cited · '
      .. '<span class="tag tag-fiction">Fiction</span> invented for play · '
      .. '<span class="tag tag-mixed">History + Fiction</span> fiction built on fact</p>',
    '</div>',
    table.concat(sections),
  }, "\n")
  return layout(nil, SITE_TITLE .. " — a Call of Cthulhu grimoire", content, "index")
end

---------------------------------------------------------------------------
-- Build
---------------------------------------------------------------------------
local rendered = {}
for i, p in ipairs(order) do rendered[i] = render_page(p, i) end
local index_html = render_index()

for _, s in ipairs(sources) do
  if not source_used[s.id] then fail("source '%s' is listed but never cited", s.id) end
end

if #errors > 0 then
  io.stderr:write("\nBuild failed — " .. #errors .. " problem(s):\n")
  for _, e in ipairs(errors) do io.stderr:write("  • " .. e .. "\n") end
  os.exit(1)
end

local reach_count = 0
for _ in pairs(reachable) do reach_count = reach_count + 1 end
print(string.format("✓ %d pages, %d sources, %d timeline entries", #order + 1, #sources, #timeline))
print(string.format("✓ scenario graph: %d/%d scenes reachable, %d endings, no dead ends", reach_count, #flow.nodes, ending_count))
print(string.format("✓ %d investigator sheets match CoC 7e derived-stat rules", #investigators))
print(string.format("✓ mist contact track: %d tiers cover 0–%d with no gaps", #contact.tiers, contact.max))

if CHECK_ONLY then return end

os.execute("mkdir -p " .. OUT)
local function write(name, s)
  local f = assert(io.open(OUT .. "/" .. name, "w")); f:write(s); f:close()
end
for _, r in ipairs(rendered) do write(r.page.id .. ".html", finish_page(r)) end
write("index.html", index_html)
local css = assert(io.open("assets/style.css")):read("a")
write("style.css", css)
write(".nojekyll", "")
write("banner.svg", dofile("tools/banner.lua").svg())
print("✓ wrote site to " .. OUT .. "/")
