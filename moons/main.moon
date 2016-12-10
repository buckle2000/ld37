export GS      = require("lib/hump.gamestate")
export Signal  = require("lib/hump.signal")
export Timer   = require("lib/hump.timer")
export Vec     = require("lib/hump.vector")
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
{a,b,_} = {1,2,3}
1
2