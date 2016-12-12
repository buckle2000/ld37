class Array2d
  new: (size, default_val) =>
    @size = size
    for x=1,size.x
      if default_val==nil
        @[x] = {}
      else
        @[x] = [default_val for y=1,size.y]

  get: (pos) => @[pos.x][pos.y]
  set: (pos, val) => @[pos.x][pos.y] = val

  clone: (map_func) =>
    with new_a2d = Array2d @size
      for x=1,@size.x
        for y=1,@size.y
          if map_func
            new_a2d[x][y] = map_func x, y, @[x][y]
          else
            new_a2d[x][y] = @[x][y]

  random_pos: =>
    Vec (math.random 1, @size.x),(math.random 1, @size.y)

  foreach: (func) =>
    for x=1,@size.x
      for y=1,@size.y
        func x, y, @[x][y]
