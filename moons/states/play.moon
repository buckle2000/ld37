Tank = require "obj.tank"
Key = require "key"

with {}
	-- .init = => nil

	.reset = (force) =>
		if tutorial_name = @level.tutorial
			@tutorial = require "tutorial.#{tutorial_name}"
			@tutorial\init @
		@timer = Timer.new!
		@signal = Signal.new!
		@tank = Tank @, @level
		if force
			U.play_sound "reset"
			@timer\script (wait) ->
				@signal\emit "task_inc"
				@color[2] = 0
				@color[3] = 0
				@timer\tween 0.2, @color, {[2]:255,[3]:255}
				wait 0.2
				@signal\emit "task_dec"
		
	.enter = (previous, level_name=3) => -- runs every time the state is entered
		if level_name == 5
			GS.switch require("states.end")
			return
		assert level_name, "Please specify a level"
		print "Entering level #{level_name}..."
		@level_name = level_name
		@level = U.load_level(level_name)
		@canvas = lg.newCanvas!
		@color = {255,255,255,255}
		\reset!
		@tank_offset = (Vec(lg.getDimensions!) - @tank.grid.size\permul(C.CELL_SIZE)) / 2

	.draw = =>
		@canvas\renderTo ->
			lg.clear C.BLUE
			lg.push!
			lg.translate @tank_offset\unpack!
			@tank\draw!
			lg.pop!
		U.with_color @color, ->
			lg.draw @canvas
		-- @signal\emit "draw"

	.update = (dt) =>
		@timer\update dt
		-- @signal\emit "update", dt

	.keypressed = (key) =>
		if key=='r'
			@level = U.load_level(@level_name)
			\reset true
		else
			@signal\emit "keypressed", Key.virtual(key)

	.keyreleased = (key) =>
		@signal\emit "keyreleased", Key.virtual(key)

-- TODO music!!!
