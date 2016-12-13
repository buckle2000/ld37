class Drawable
  new: (x=0, y=0, r=0, color) =>
    @x = x
    @y = y
    @r = r
    @color = color

  add_image: (image) =>
    @image = image
    
  draw: =>
    lg.push!
    lg.translate @x, @y
    lg.rotate @r
    if @color
      U.with_color @color, @\draw_internal
    else
      @draw_internal!
    lg.pop!

  draw_internal: =>
    lg.draw @image

return Drawable