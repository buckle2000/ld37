local state = {}

function state:init()  -- first time called

end

function state:enter(previous) -- runs every time the state is entered

end

function state.draw()

end

function state.update(dt)
	Timer.update(dt)
end

function state.keypressed(key)
	Signal.emit("keypressed", key)
end

function state.keyreleased(key)
	Signal.emit("keyreleased", key)
end

return state
