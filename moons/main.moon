--- Utilities ---
export GS      = require "hump.gamestate"
export Vec     = require "hump.vector"
export Signal  = require "hump.signal"
export Timer   = require "hump.timer"
export lg      = love.graphics
export U       = require "utils"
--- Constants ---
export C       = require "c"
table.seal _G -- no global variable declaration afterward!!!

love.load = (arg) ->
  math.randomseed os.time!
  lg.setDefaultFilter 'linear', 'nearest'

  do
    -- if first argument is given (must be a state name)
    --   change to that state
    -- else
    --   change to `default_state`
    unless love.filesystem.isFused!
      arg = {unpack arg, 2}
    GS.registerEvents!
    love.draw = ->
      lg.push!
      lg.scale 2,2
      GS.draw!
      lg.pop!
      -- TODO Post draw scaling
    first_state = C.DEFAULT_STATE if #arg == 0 else arg[1]
    GS.switch require("states.play"), unpack(arg, 2)


-- TODO global timer and signal?

-- love.update = (dt) ->
--   Timer.update(dt)

-- Signal.emit(...)