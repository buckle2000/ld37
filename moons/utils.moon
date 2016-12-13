math.round = (n) ->
  math.floor n + 0.5

math.in_range = (n, min, max) ->
  if n < min
    min
  elseif n > max
    max
  else
    n

Vec.one = Vec 1,1

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

table.contains = (t, v) ->
  for vv in *t
    return true if vv==v
  false

-- table.eq = (t1, t2) ->
--   if #t1==#t2
--     p
--   else
--     false


utils = {}
with utils
  .type = (value) -> -- class aware type
    base_type = type value
    if base_type == "table"
      cls = value.__class
      return cls if cls
    base_type
    
  -- set color to white
  .white = ->
    lg.setColor 255,255,255
  
  -- set color temporarily to `color` and run `func`
  .with_color = (color, func) ->
    pr,pg,pb,pa = lg.getColor!
    lg.setColor color
    func!
    lg.setColor pr,pg,pb,pa

  .new_debug_image = (width, height, fill_color={255, 255, 255}, text) ->
    assert width, "Please give width to create a debug image"
    assert height, "Please give height to create a debug image"
    local image_data
    with canvas = lg.newCanvas width, height
      canvas\renderTo ->
        utils.with_color fill_color, ->
          lg.rectangle 'fill', 0,0, width, height
        if text
          lg.print text
      image_data = canvas\newImageData!
    lg.newImage image_data

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

  -- .key_as_analog = (left,right,up,down) ->
  --   dx, dy = 0, 0
  --   if love.keyboard.isDown left  then dx -= 1
  --   if love.keyboard.isDown right then dx += 1
  --   if love.keyboard.isDown up    then dy -= 1
  --   if love.keyboard.isDown down  then dy += 1
  --   dx, dy

  image_cache = {}
  .load_image = (name) ->
    local img
    unless img = image_cache[name]
      img = lg.newImage("assets/image/#{name}.png")
      image_cache[name] = img
    img


  .load_level = (name) ->
    level = love.filesystem.load "assets/level/#{name}.lua"
    level = level!
    assert #level == level.height, "Level #{name} has invalid height"
    array2d = require "array2d"
    level_2d = array2d Vec(level.width, level.height)
    for y=1,level.height
      row = level[y]
      assert type(row) == "string", "Level #{name} row must be a string"
      assert row\len! == level.width, "Level #{name} has row '#{row}' with invalid length"
      for x=1,level.width
        level_2d[x][y] = row\sub x,x
    level_2d.id = level.id or name
    if cond = level.win_condition
      level_2d.win_condition = cond
    else
      error "Level #{name} has no win condition"
    level_2d

  .dir_is = (dir) -> type(dir)=='number' and 1<=dir and dir<=4
  .dir_2vec = (dir) -> C.DIR2VEC[dir]
  .dir_reverse = (dir) -> if dir<=2 then 3-dir else 7-dir

  .play_sound = (sound_name) ->
     source = love.audio.newSource "assets/sound/#{sound_name}.wav", 'static'
     source\play!

  .goto_state = (next_name, ...) ->
    GS.switch (require "states.transition"), (require "states.#{next_name}"), ...
