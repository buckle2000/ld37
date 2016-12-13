Cell = require "obj.cell"
Drawable = require "obj.drawable"


class Fish extends Drawable
  CS = C.CELL_SIZE
  CSH = CS/2
  quad_left  = lg.newQuad 0,     0,     CSH.x, CS.y,  CS.x, CS.y
  quad_right = lg.newQuad CSH.x, 0,     CSH.x, CS.y,  CS.x, CS.y
  quad_up    = lg.newQuad 0,     0,     CS.x,  CSH.y, CS.x, CS.y
  quad_down  = lg.newQuad 0,     CSH.y, CS.x,  CSH.y, CS.x, CS.y

  new: (cell, x, y) =>
    assert cell.fish~='^', "Cannot draw player!"
    super x, y, 0, {255,255,255,255}
    @cell = cell
    @layout = cell.layout
    @fish = Cell.fishes[cell.fish]
    @fish_active = Cell.fishes[cell.fish_active]


  draw_helper = (fish, sx, sy, ox, oy) ->
    lg.draw fish.o, 0,0,0,sx,sy,ox,oy
  draw_internal: =>
    switch @layout
      when 0
        draw_helper @fish, 1, 1, CSH.x, CSH.y
      when C.LEFT
        draw_helper @fish, 0.5, 1, 0, CSH.y
        draw_helper @fish_active, 0.5, 1, CS.x, CSH.y
      when C.RIGHT
        draw_helper @fish, 0.5, 1, CS.x, CSH.y
        draw_helper @fish_active, 0.5, 1, 0, CSH.y
      when C.UP
        draw_helper @fish, 1, 0.5, CSH.x, 0
        draw_helper @fish_active, 1, 0.5, CSH.x, CS.y
      when C.DOWN
        draw_helper @fish, 1, 0.5, CSH.x, CS.y
        draw_helper @fish_active, 1, 0.5, CSH.x, 0


  -- img_zipper_h = U.load_image "zipper_h"
  -- img_zipper_v = U.load_image "zipper_v"
  -- draw_internal2: =>
  --   if @layout == 0
  --     lg.draw @fish.o, 0,0,0,1,1, CSH.x, CSH.y
  --   else
  --     if @layout <= C.RIGHT
  --       if @layout == C.LEFT
  --         lg.draw @fish.v,        quad_right, 0,0,0,1,1, 0, CSH.y
  --         lg.draw @fish_active.v, quad_left,  0,0,0,1,1, CSH.x, CSH.y
  --       else
  --         lg.draw @fish.v,        quad_left,  0,0,0,1,1, CSH.x, CSH.y
  --         lg.draw @fish_active.v, quad_right, 0,0,0,1,1, 0, CSH.y
  --       -- if @fish~=@fish_active
  --       -- lg.draw img_zipper_h, 0,0,0,1,1, CSH.x, CSH.y
  --     else
  --       if @layout == C.UP   
  --         lg.draw @fish.h,        quad_down,  0,0,0,1,1, CSH.x, 0
  --         lg.draw @fish_active.h, quad_up,    0,0,0,1,1, CSH.x, CSH.y
  --       else
  --         lg.draw @fish.h,        quad_up,    0,0,0,1,1, CSH.x, CSH.y
  --         lg.draw @fish_active.h, quad_down,  0,0,0,1,1, CSH.x, 0
  --       -- lg.draw img_zipper_v, 0,0,0,1,1, CSH.x, CSH.y
  --   nil