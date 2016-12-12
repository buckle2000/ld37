class Drawable
  new: (pos, image) =>
    if pos == nil
      pos = vec!
    @pos = pos
    @image = love.graphics.newImage image
  draw: =>
    love.graphics.draw @image, @pos.x, @pos.y

return Drawable