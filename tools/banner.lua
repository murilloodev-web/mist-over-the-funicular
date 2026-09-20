-- tools/banner.lua — procedural 16-bit pixel-art banner for the grimoire cover.
--
-- Paints a 192×72 pixel scene into a palette-indexed grid (dusk sky with
-- ordered dithering, clouds, moon, the Serra do Mar, the funicular incline,
-- a tank wagon, the Castelinho and rolling fog), then emits an SVG made of
-- horizontal pixel runs. Deterministic: same seed, same picture.

local M = {}

local W, H = 192, 72

local PAL = {
  "#0d0d18", -- 1 void
  "#15162a", -- 2 night
  "#1f1f3d", -- 3 dusk blue
  "#2e2550", -- 4 violet
  "#4a2a55", -- 5 plum
  "#7a2f45", -- 6 wine
  "#b8433e", -- 7 ember
  "#e27a3f", -- 8 glow
  "#dfe7d9", -- 9 moon
  "#9fa8a6", -- 10 moon shade
  "#262543", -- 11 ridge far
  "#0a0a12", -- 12 ridge near
  "#8e8aae", -- 13 rail / stone
  "#8a86a8", -- 14 fog light
  "#3b3860", -- 15 fog dark
  "#f3b04a", -- 16 lamp
  "#9b6bd6", -- 17 amethyst
  "#2a2f22", -- 18 moss dark
  "#3e4a2c", -- 19 moss
}

-- 4×4 Bayer matrix, values 0..15
local BAYER = {
  { 0, 8, 2, 10 }, { 12, 4, 14, 6 }, { 3, 11, 1, 9 }, { 15, 7, 13, 5 },
}
local function bayer(x, y) return BAYER[y % 4 + 1][x % 4 + 1] / 16 end

-- tiny deterministic PRNG
local seed = 1974
local function rnd() seed = (seed * 1103515245 + 12345) % 2147483648; return seed / 2147483648 end

-- 1-D value noise
local function noise1(n, scale)
  local pts = {}
  local count = math.ceil(n / scale) + 1
  for i = 0, count - 1 do pts[i] = rnd() end
  return function(x)
    local i = math.floor(x / scale); local t = x / scale - i
    t = t * t * (3 - 2 * t)
    return pts[i % count] * (1 - t) + pts[(i + 1) % count] * t
  end
end

function M.render()
  local g = {}
  for y = 0, H - 1 do g[y] = {} end
  local function put(x, y, c) if x >= 0 and x < W and y >= 0 and y < H then g[y][x] = c end end

  -- sky: gradient bands, dithered between neighbours
  local bands = { 2, 3, 4, 5, 6, 7 }
  for y = 0, H - 1 do
    local t = (y / (H * 0.62)) * (#bands - 1)
    local i = math.min(#bands - 1, math.floor(t))
    local f = math.min(1, t - i)
    for x = 0, W - 1 do
      put(x, y, (f > bayer(x, y)) and bands[math.min(#bands, i + 2)] or bands[i + 1])
    end
  end

  -- clouds: stretched noise streaks with warm under-lighting
  local cn = { noise1(W, 18), noise1(W, 9) }
  for _, row in ipairs({ { y = 9, h = 5 }, { y = 20, h = 4 }, { y = 30, h = 3 } }) do
    for x = 0, W - 1 do
      local v = cn[1](x) * 0.7 + cn[2](x) * 0.3
      local thick = math.floor((v - 0.45) * row.h * 4)
      if thick >= 1 then
        local base = row.y + math.floor(cn[2](x + 40) * 2)
        for k = 0, thick do put(x, base - k, row.y > 18 and 5 or 4) end
        put(x, base + 1, row.y > 18 and 8 or 6)
        if bayer(x, base) < 0.5 then put(x, base - thick - 1, 3) end
      end
    end
  end

  -- moon with left-side shading
  local mx, my, mr = 38, 14, 9
  for y = my - mr, my + mr do
    for x = mx - mr, mx + mr do
      local d = (x - mx) ^ 2 + (y - my) ^ 2
      if d <= mr * mr then put(x, y, (x > mx + 3 and bayer(x, y) < 0.6) and 10 or 9) end
    end
  end

  -- distant sea line on the left (Paranapiacaba: "where one sees the sea")
  for x = 0, 70 do
    put(x, 44, 6)
    if bayer(x, 44) < 0.25 then put(x, 44, 8) end
    put(x, 45, 2)
  end

  -- far ridge of the Serra do Mar
  local rn = noise1(W, 22)
  for x = 0, W - 1 do
    local top = math.floor(38 + rn(x) * 10 - (x / W) * 12)
    for y = top, H - 1 do put(x, y, 11) end
    if bayer(x, top) < 0.5 then put(x, top, 4) end
  end

  -- near slope: the incline climbs from bottom-left to the crest
  local function slope(x) return math.floor(70 - x * 0.33) end
  local crest = 132
  for x = 0, W - 1 do
    local top = x <= crest and slope(x) or slope(crest) + math.floor((x - crest) * 0.12)
    for y = top, H - 1 do put(x, y, 12) end
    -- moss speckles along the edge
    if bayer(x, top) < 0.4 then put(x, top, 18) end
    if bayer(x, top + 1) < 0.2 then put(x, top + 1, 19) end
  end

  -- rails and sleepers on the incline
  for x = 6, crest - 4 do
    local y = slope(x) - 1
    put(x, y, 13)
    if x % 3 == 0 then put(x, y - 1, 13); put(x, y + 1, 15) end
  end

  -- the tank wagon, mid-climb, with an amethyst glint
  local wx = 70
  local wy = slope(wx) - 6
  for y = wy, wy + 3 do for x = wx, wx + 9 do put(x, y, 13) end end
  for x = wx + 1, wx + 8 do put(x, wy - 1, 15) end
  put(wx + 2, wy + 4, 1); put(wx + 7, wy + 4, 1)
  put(wx + 4, wy + 1, 17); put(wx + 5, wy + 1, 17)
  -- cable up to the crest
  for x = wx + 10, crest - 2 do put(x, slope(x) - 3, 5) end

  -- atlantic forest silhouettes along the ridge
  for i = 1, 16 do
    local tx = crest - 6 + math.floor(rnd() * (W - crest + 6)); if rnd() < 0.3 then tx = math.floor(rnd() * 40) end
    local base = tx <= crest and slope(tx) or slope(crest) + math.floor((tx - crest) * 0.12)
    local r = 2 + math.floor(rnd() * 3)
    for y = -r, r do for x = -r, r do
      if x * x + y * y <= r * r then put(tx + x, base - r + y, 12) end
    end end
  end

  -- the Castelinho on the crest: walls, pitched roof, chimneys, lit windows
  local cx, cy = crest + 4, slope(crest)
  for y = cy - 9, cy - 1 do for x = cx, cx + 16 do put(x, y, 1) end end
  for k = 0, 5 do for x = cx - 1 + k, cx + 17 - k do put(x, cy - 10 - k, 1) end end
  for y = cy - 18, cy - 12 do put(cx + 3, y, 1); put(cx + 4, y, 1) end
  for y = cy - 17, cy - 12 do put(cx + 13, y, 1) end
  for _, wxy in ipairs({ { 3, 6 }, { 7, 6 }, { 12, 6 }, { 7, 3 } }) do
    put(cx + wxy[1], cy - wxy[2], 16); put(cx + wxy[1] + 1, cy - wxy[2], 16)
  end
  put(cx + 8, cy - 13, 17) -- a violet light in the attic

  -- fog: dithered bands that thicken towards the valley
  local drift = { noise1(W, 20), noise1(W, 11) }
  for y = 50, H - 1 do
    local density = ((y - 50) / (H - 50)) ^ 1.1
    local band = math.floor(y / 3)
    for x = 0, W - 1 do
      local d = density * (0.35 + drift[band % 2 + 1](x + band * 17) * 0.9)
      local b = bayer(x, y)
      if d > 0.72 + b * 0.2 then put(x, y, 14)
      elseif d > 0.38 + b * 0.35 then put(x, y, 15) end
    end
  end

  return g
end

function M.svg()
  local g = M.render()
  local by_color = {}
  for y = 0, H - 1 do
    local x = 0
    while x < W do
      local c = g[y][x]
      local x2 = x
      while x2 + 1 < W and g[y][x2 + 1] == c do x2 = x2 + 1 end
      by_color[c] = by_color[c] or {}
      table.insert(by_color[c], string.format("M%d %dh%dv1h-%dz", x, y, x2 - x + 1, x2 - x + 1))
      x = x2 + 1
    end
  end
  local paths = {}
  for c = 1, #PAL do
    if by_color[c] then
      paths[#paths + 1] = string.format('<path fill="%s" d="%s"/>', PAL[c], table.concat(by_color[c]))
    end
  end
  return string.format(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 %d %d" shape-rendering="crispEdges" role="img" '
    .. 'aria-label="Pixel-art dusk over the Serra do Mar: a tank wagon climbs the funicular toward the Castelinho as fog rises from the valley">%s</svg>',
    W, H, table.concat(paths))
end

return M
