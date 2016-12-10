export GS      = require("hump.gamestate")
export Signal  = require("hump.signal")
export Timer   = require("hump.timer")
export Vec     = require("hump.vector")
export lg      = love.graphics
export U       = require("utils")
table.seal _G
-- no global variable declaration afterward!!!

default_state = "play"

love.load = (arg) ->
  math.randomseed os.time!

  -- if first argument is given (must be STATE name)
  --   change to that state
  -- else
  --   change to the default states
  unless love.filesystem.isFused!
    arg = {unpack arg, 2}
  GS.registerEvents!
  first_state = default_state if #arg == 0 else arg[1]
  GS.switch require("states.#{first_state}")
  