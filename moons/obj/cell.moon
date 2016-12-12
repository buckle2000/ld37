with {}
  -- visual layout
  .layouts = {
    0        -- [] whole
    C.LEFT   -- || stack vertically,   pop to left
    C.RIGHT  -- || stack vertically,   pop to right
    C.UP     -- == stack horizontally, pop to up
    C.DOWN   -- == stack horizontally, pop to down
  }

  -- fish-to-image and fish types
  .fishes = {
    -- ' ': air
    '^': -- player
      o: U.load_image('player')
    '.': -- normal fish
      o: U.load_image('fish_normal')    -- []
      h: U.load_image('fish_normal_h')  -- ==
      v: U.load_image('fish_normal_v')  -- ||
    '#': -- block fish
      o: U.load_image('fish_block')
    'X': -- barrier
      o: U.load_image('barrier')
      -- o: U.new_debug_image C.CELL_SIZE.y, C.CELL_SIZE.y,nil,"barrier"
  }
  .fish_types = {}
  for k,v in pairs(.fishes) -- enumerate fish types
    table.insert .fish_types, k

  -- if a fish can be pushed around?
  .movable = (fish_type) ->
    switch fish_type
      when '.','#','^' true
      else false

  -- if a fish can be compressed?
  .zipable = (fish_type) ->
    switch fish_type
      when '.' true
      else false

  .movable_cell = (cell) ->
    return cell.layout==0 and .movable cell.fish

  -- 
  .new = (layout, fish, fish_active) ->
    assert table.contains(.layouts, layout), "Invalid layout: #{layout}"
    assert table.contains(.fish_types, fish), "Invalid stationary fish: #{fish}"
    unless layout == 0
      assert table.contains(.fish_types, fish_active), "Invalid active fish: #{fish_active}"
    {:layout, :fish, :fish_active}

  .zip = (cell_station, cell_active, push_dir) ->
    unless cell_station.layout==0 and cell_active.layout==0
      return false -- already zipped
    unless .zipable(cell_station.fish) and .zipable(cell_active.fish)
      return false -- cannot be zipped
    assert U.dir_is(push_dir), "Give a DIRECTION as push_dir, not #{push_dir}"
    .new U.dir_reverse(push_dir), cell_station.fish, cell_active.fish

  .unzip = (cell) ->
    assert cell.layout~=0, "This cell #{cell} is not zipped"
    -- if cell.layout==0
    --   return false
    .new(0,cell.fish), .new(0,cell.fish_active), cell.layout
