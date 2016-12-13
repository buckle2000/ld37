Aseprite = require "aseprite"
Key = require "key"

with {}
  .enter = =>
    @bg = Aseprite.Animation "background"
    @button = Aseprite.Animation "buttons"
    @wait_inputs = {C.LEFT,C.RIGHT,C.UP,C.DOWN,'r'}

  .draw = =>
    @bg\draw!
    lg.push!
    lg.translate (640-48)/2, 480
    @button\draw!
    lg.pop!
    
  .update = (dt) =>
    @bg\update dt
    
  .keypressed = (key) =>
    if Key.virtual(key) == @wait_inputs[1]
      table.remove @wait_inputs, 1
      U.play_sound "select"
      if #@wait_inputs == 0
        U.goto_state "play"
      else
        @button\step!

-- TODO music!!!
