Drawable = require "obj.drawable"
Aseprite = require "aseprite"

class Player extends Drawable
  new: (x, y) =>
    super x, y
    @anim = Aseprite.Animation "player"
    @anim\set_tag "default"

  update: (dt) =>
    @anim\update dt

  draw_internal: =>
    lg.translate (-C.CELL_SIZE/2)\unpack!
    @anim\draw!

return Player
