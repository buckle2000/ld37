Array2d = require "array2d"
Cell    = require "obj.cell"
Fish    = require "obj.fish"
Player  = require "obj.player"

--- The water tank
--    Events:
--      cell_move  <vec>, <num_dir>, <dest>
--      cell_zip   <vec>, <num_dir>, <dest>
--      cell_unzip <vec>, <num_dir>, <dest>
--      cell_stuck <vec>, <num_dir>
--      player_move  <vec>, <num_dir>, <dest>
--      player_stuck <vec>, <num_dir>
--      task_idle
--      task_busy
class Tank
  new: (gs, level) =>
    @gs = gs
    @register_callbacks!

    --- Tank state (number)
    -- =0 idle
    -- >0 busy
    @task_num = 0

    --- The grid
    -- something like {{<cell>,<cell>,false},{<cell>,<cell>,false},{<cell>,<cell>,false}}
    has_player = false
    @grid = level\clone (x, y, fish_type) ->
      switch fish_type
        when ' '
          false
        when '^'
          assert not has_player, "Level #{level.id} has >1 players"
          @player_pos = Vec x, y
          has_player = true
          Cell.new 0, fish_type
        else -- whatever except air
          Cell.new 0, fish_type
    assert has_player, "Level #{level.id} has no player"

    @refresh_cells!
    -- TODO use a better approach to represent @player


  register_callbacks: =>
    sig = @gs.signal
    tmr = @gs.timer
    sig\register "keypressed", @\keypressed
    sig\register "player_move", ->
      @task_inc!
      tmr\after 0.1, ->
        @step!
        @task_dec!
    sig\register "player_stuck", (pos, dir using nil) ->
      dirvec = U.dir_2vec(dir)\permul(C.CELL_SIZE) * 0.15
      @task_inc!
      player = @g_pool\get(pos)
      x, y = player.x, player.y
      tmr\tween 0.05, player, {x:dirvec.x+x, y:dirvec.y+y}
      tmr\after 0.05, ->
        tmr\tween 0.05, player, {:x, :y}
      tmr\after 0.1, ->
        @task_dec!
    sig\register "task_inc", @\task_inc
    sig\register "task_dec", @\task_dec
    sig\register "task_idle", @\refresh_cells
    sig\register "cell_move", (origin, dir, dest) ->
      @task_inc!
      x, y = @screen_coords dest\unpack!
      fish = @g_pool\get origin
      @g_pool\set origin, nil
      table.insert @g_out, fish
      tmr\tween 0.2, fish, {:x,:y}, 'in-out-quad'
      tmr\after 0.2, @\task_dec
    sig\register "cell_zip", (origin, dir, dest) ->
      @task_inc!
      x, y = @screen_coords dest\unpack!
      fish_active = @g_pool\get origin
      fish = @g_pool\get dest
      table.insert @g_out, fish
      table.insert @g_out, fish_active
      @g_pool\set origin, nil
      @g_pool\set dest, nil
      tmr\tween 0.2, fish_active, {:x,:y}, 'in-out-quad'
      tmr\after 0.2, @\task_dec
    sig\register "cell_zip", -> U.play_sound("zip")
    sig\register "cell_unzip", -> U.play_sound("unzip")
    sig\register "cell_unzip", (origin, dir, dest) ->
      @task_inc!
      x, y = @screen_coords origin\unpack!
      dstx, dsty = @screen_coords dest\unpack!
      fish = Fish @grid\get(origin), x, y
      fish_active = Fish @grid\get(dest), x, y
      @g_pool\set origin, nil
      table.insert @g_out, fish
      table.insert @g_out, fish_active
      tmr\tween 0.2, fish_active, {x:dstx,y:dsty}, 'in-out-quad'
      tmr\after 0.2, @\task_dec
    sig\register "player_move", (_,_,dest) ->
      if @gs.level.win_condition dest\unpack!
        tmr\after 0.2, @\refresh_cells
        tmr\script (wait) ->
          @task_inc!
          @game_x = 2
          wait 0.1
          U.play_sound "win"
          wait 4.3
          U.goto_state "play", @gs.level_name+1


    -- sig\register "player_move", -> U.play_sound("move")


  -- reference-count Tasking
  task_idle: => @task_num == 0
  task_inc: =>
    @gs.signal\emit "task_busy" if @task_idle!
    @task_num += 1
  task_dec: =>
    @task_num -= 1
    assert @task_num>=0, "Negative task_num???"
    @gs.signal\emit "task_idle" if @task_idle!


  keypressed: (key) =>
    is_dir = U.dir_is key
    if @task_idle!
      if is_dir
        dirvec = U.dir_2vec key
        if @cell_move @player_pos, key
          -- moved
          -- TODO play animation here
          dest = @player_pos + dirvec
          @gs.signal\emit "player_move", @player_pos, key, dest
          @player_pos = dest
        else
          -- stand still
          -- TODO play another animation
          @gs.signal\emit "player_stuck", @player_pos, key

        -- switch key
        --   when C.LEFT
        --     nil
        --   when C.RIGHT
        --     nil
        --   when C.UP
        --     nil

  -- Move a cell
  cell_move: (origin, direction using nil) =>
    can_move = @cell_move_h origin, direction
    if can_move
      true
    else
      @cell_move_h origin, direction, 2
    --   dirvec = U.dir_2vec direction
    --   o2 = origin + dirvec
    --   if cell = @grid\get o2
    --     dest = origin + dirvec
    --     if dest_cell = @grid\get dest
    -- return false

  cell_move_h: (origin, direction, dozip=0 using nil) =>
    cell = @grid\get origin
    assert cell, "There is no cell at #{origin}"
    dest = origin + U.dir_2vec direction
    if Vec.one <= dest and dest <= @grid.size and -- inside the map
              Cell.movable_cell cell -- fish movable
      if dest_cell = @grid\get dest
        -- one fish at dest
        if dozip>0
          if new_cell = Cell.zip dest_cell, cell, direction
              -- zipable
            @grid\set origin, false
            @grid\set dest, new_cell
            @gs.signal\emit "cell_zip", origin, direction, dest
            return true
        -- else
        --   return false
        if @cell_move_h dest, direction, dozip-1
          -- move a bunch of fish
          @grid\set origin, false
          @grid\set dest, cell
          @gs.signal\emit "cell_move", origin, direction, dest
          return true
        else
          @gs.signal\emit "cell_stuck", origin, direction
          return false
      else
        -- there is no fish at dest, simple move there
        @grid\set origin, false
        @grid\set dest, cell
        @gs.signal\emit "cell_move", origin, direction, dest
        return true
    else
      @gs.signal\emit "cell_stuck", origin, direction
      return false


  step: =>
    -- unzip all possible cells
    @grid\foreach (x, y, cell) ->
      if cell and cell.layout~=0
        origin = Vec x, y
        pop_dirvec = U.dir_2vec cell.layout
        dest = origin+pop_dirvec
        unless @grid\get dest -- can unzip
          cell_staion, cell_active = Cell.unzip @grid\get origin
          @grid\set origin, cell_staion
          @grid\set dest, cell_active
          @gs.signal\emit "cell_unzip", Vec(x,y), pop_dir, dest

    -- refresh graphics
    -- TODO find a better way
    -- @refresh_cells!

  screen_coords: (cell_x, cell_y) =>
    (cell_x-0.5)*C.CELL_SIZE.x, (cell_y-0.5)*C.CELL_SIZE.y

  draw: (using nil) =>
    w, h = (@grid.size\permul C.CELL_SIZE)\unpack!
    U.with_color C.DARKBLUE, ->
      lg.setLineWidth 10
      lg.line 0,0,0,h,w,h,w,0
    @grid\foreach (x, y, cell using nil) ->
      local color
      if @gs.level.win_condition x, y
        color = C.WHITE
      else
        color = C.BLUE
      x, y = @screen_coords x-0.5, y-0.5
      U.with_color color, ->
        lg.rectangle 'fill', x, y, C.CELL_SIZE\unpack!
    @draw_cells!

  refresh_cells: =>
    @g_out = {}
    @g_pool = @grid\clone (x, y, cell) ->
      if cell
        if cell.fish == '^'
          with player = Player @screen_coords(x, y)
            @gs.signal\register "update", player\update
        else
          Fish cell, @screen_coords(x, y)
      else
        nil

  draw_cells: =>
    for fish in *@g_out
      fish\draw!
    @g_pool\foreach (x, y, fish) ->
      if fish -- if not air
        fish\draw!

