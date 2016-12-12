Cell = require "obj.cell"

img_zipper = U.load_image "zipper"

class Fish
  CS = C.CELL_SIZE
  CSH = CS/2
  quad_left  = lg.newQuad 0,     0,     CSH.x, CS.y,  CS.x, CS.y
  quad_right = lg.newQuad CSH.x, 0,     CSH.x, CS.y,  CS.x, CS.y
  quad_up    = lg.newQuad 0,     0,     CS.x,  CSH.y, CS.x, CS.y
  quad_down  = lg.newQuad 0,     CSH.y, CS.x,  CSH.y, CS.x, CS.y

  new: (cell, x, y) =>
    @cell = cell
    @layout = cell.layout
    @fish = Cell.fishes[cell.fish]
    @fish_active = Cell.fishes[cell.fish_active]
    @x = x
    @y = y
    @r = 0
    @alpha = 1

  draw: =>
    lg.push!
    lg.translate @x, @y
    lg.rotate @r
    if @alpha == 1
      @draw_internal!
    else
      U.with_color {255,255,@alpha*256}, @\draw_internal
    lg.pop!

  draw_internal: =>
    if @layout == 0
      lg.draw @fish.o, 0,0,0,1,1, CSH.x, CSH.y
    else
      switch @layout
        when C.LEFT
          lg.draw @fish.v,        quad_right, 0,0,0,1,1, 0, CSH.y
          lg.draw @fish_active.v, quad_left,  0,0,0,1,1, CSH.x, CSH.y
        when C.RIGHT
          lg.draw @fish.v,        quad_left,  0,0,0,1,1, CSH.x, CSH.y
          lg.draw @fish_active.v, quad_right, 0,0,0,1,1, 0, CSH.y
        when C.UP   
          lg.draw @fish.h,        quad_down,  0,0,0,1,1, CSH.x, 0
          lg.draw @fish_active.h, quad_up,    0,0,0,1,1, CSH.x, CSH.y
        when C.DOWN 
          lg.draw @fish.h,        quad_up,    0,0,0,1,1, CSH.x, CSH.y
          lg.draw @fish_active.h, quad_down,  0,0,0,1,1, CSH.x, 0
      lg.draw img_zipper, 0,0,0,1,1, CSH.x, CSH.y
    nil