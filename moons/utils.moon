math.round = (n) ->
  math.floor n + 0.5

table.contains = (t, val) ->
  for i,v in ipairs(t) do
    return true if v == val
  false

--- Seal a table
table.seal = (t) ->
  assert type(t) == "table"
  mt = getmetatable t
  if mt
    assert not mt.__newindex, 'This table already has __newindex metamethod.'
  else
    mt = {}
    setmetatable(t,mt)
  mt.__newindex = (t,k,v) ->
    error 'Try to temper with sealed table index `%s` with value `%s`'\format(k, v)
  t

-- return moon type
-- lua_type = type
-- export type = (value) -> -- class aware type
--   base_type = lua_type value
--   if base_type == "table"
--     cls = value.__class
--     return cls if cls
--   base_type

utils = {}
with utils
  .new_debug_image = (width, height, fill_color) ->
    image_data = love.image.newImageData width, height
    fill_color or= {255, 255, 255}
    for x=0,width-1
      for y=0,height-1
        image_data\setPixel x, y, unpack(fill_color)
    love.graphics.newImage image_data

  -- is point in polygon?
  .pnpoly = (vertices, x, y using nil) ->
    nvert = #vertices/2
    inside, i, j = false, 1, nvert
    while i <= nvert
      vxi, vyi, vyj = vertices[i*2-1], vertices[i*2], vertices[j*2]
      inside = not inside if (vyi > y) ~= (vyj > y) and
        x < (vertices[j*2-1]-vxi) * (y-vyi) / (vyj-vyi) + vxi
      j = i
      i += 1
    inside

  .key_as_analog = (left,right,up,down) ->
    dx, dy = 0, 0
    if love.keyboard.isDown left  then dx -= 1
    if love.keyboard.isDown right then dx += 1
    if love.keyboard.isDown up    then dy -= 1
    if love.keyboard.isDown down  then dy += 1
    dx, dy