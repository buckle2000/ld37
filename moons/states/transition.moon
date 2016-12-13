with {}
  .enter = (previous, next_, ...) =>
    @prev = previous
    @color = {255,255,255}
    @canvas = lg.newCanvas!
    @timer = Timer.new!
    args = {...}
    @timer\tween 1, @color, {0,0,0}, 'in-quint'
    @timer\after 1.4, ->
      GS.switch next_, unpack(args)

  .draw = =>
    @canvas\renderTo ->
      lg.clear
      @prev\draw!
    U.with_color @color, ->
      lg.draw @canvas
    
  .update = (dt) =>
    @timer\update dt
    @prev\update dt
