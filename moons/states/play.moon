Array2d = require "array2d"
Player = require "obj.player"

MAP_SIZE = 10
GRID_SIZE = 64

MOVEMENT_KEYS = {"left","right","up","down"}
MOVEMENT_KEYS[v] = k for k,v in ipairs MOVEMENT_KEYS

image_map =
	-- [false]: U.new_debug_image GRID_SIZE, GRID_SIZE, {219,194,237}, 'empty'
	[false]: U.load_image 'fish_globe'
	Player:  U.new_debug_image GRID_SIZE, GRID_SIZE, {255,0,0}, 'Player'

with {}

	.new_grid = =>
		Array2d @map_size, false  -- false means "empty"

	.init = =>
		@map_size = Vec MAP_SIZE, MAP_SIZE
		@next_grid = @new_grid!
		@grid = @new_grid!
		@player = Player @grid, @grid\random_pos!
		@step!
		@step!

	.enter = (previous) => -- runs every time the state is entered

	.step = (player_dir=Vec!) =>
		assert @grid
		assert @next_grid
		w = @map_size.x
		h = @map_size.y

		inter_grid = @grid\clone!

		object_list = {}  -- all objects
		for x=1,w
			for y=1,h
				-- inter_grid[x][y] = @grid[x][y]
				if object = @grid[x][y]
					table.insert object_list, object


		--- player move
		player_dest = @player.pos + player_dir
		-- limit inside map
		-- TODO don't move down
		with player_dest
			.x = math.in_range .x, 1, w
			.y = math.in_range .y, 1, h

		if @grid\get player_dest  -- something at 'dest'
			nil
			-- TODO push
		else  -- nothing at 'dest'
			@player\to @next_grid, player_dest

		--- fish move
		for x=1,w
			for y=1,h
				object = @grid[x][y]
				-- TODO

		@grid = @next_grid
		@next_grid = @new_grid!

	.draw = =>
		w = @map_size.x
		h = @map_size.y
		for x=1,w
			for y=1,h
				object = @grid[x][y]
				local object_name
				if object
					object_name = object.__class.__name
				else
					object_name = object
				xx, yy = (x-1)*GRID_SIZE, (y-1)*GRID_SIZE
				love.graphics.draw image_map[object_name], xx, yy
				love.graphics.line xx, yy, xx, yy+GRID_SIZE
				love.graphics.line xx, yy, xx+GRID_SIZE, yy

	.update = (dt) =>
		Timer.update(dt)

	.keypressed = (key) =>
		if player_dir = MOVEMENT_KEYS[key]
			player_dir_vec = U.key_to_vec[player_dir]
			@step player_dir_vec

			-- step
		-- GUI might need this
		Signal.emit("keypressed", key)

	.keyreleased = (key) =>
		-- Signal.emit("keyreleased", key)
