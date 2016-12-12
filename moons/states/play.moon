Tank = require "obj.tank"
Key = require "key"

image_map =
	-- [false]: U.new_debug_image GRID_SIZE, GRID_SIZE, {219,194,237}, 'empty'
	[false]: U.load_image 'fish_globe'
	Player:  U.new_debug_image C.CELL_SIZE.x, C.CELL_SIZE.y, {255,0,0}, 'Player'

with {}
	.init = => nil

	.reset = =>
		if tutorial_name = @level.tutorial
			@tutorial = require "tutorial.#{tutorial_name}"
			@tutorial\init @
		@timer = Timer.new!
		@signal = Signal.new!
		@tank = Tank @, @level
		
	.enter = (previous, level_name=2) => -- runs every time the state is entered
		assert level_name, "Please specify a level"
		print "Entering level #{level_name}..."
		@level_name = level_name
		@level = U.load_level(level_name)
		\reset!

	.draw = =>
		@tank\draw!

	.update = (dt) =>
		@tutorial\update dt if @tutorial
		@timer\update dt

	.keypressed = (key) =>
		if key=='r'
			@level = U.load_level(@level_name)
			\reset!
		else
			@signal\emit "keypressed", Key.virtual(key)

	.keyreleased = (key) =>
		@signal\emit "keyreleased", Key.virtual(key)
