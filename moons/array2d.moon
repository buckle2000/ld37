class Array2d
  new: (size, default_val) =>
    -- assert default_val~=nil
    @size = size
    for x=1,size.x
      @[x] = [default_val for y=1,size.y]

  get: (pos) => @[pos.x][pos.y]
  set: (pos, val) => @[pos.x][pos.y] = val

  clone: =>
    with Array2d @size
      for x=1,@size.x
        for y=1,@size.y
          [x][y] = @[x][y]

  random_pos: =>
    Vec (math.random 1, @size.x),(math.random 1, @size.y)
