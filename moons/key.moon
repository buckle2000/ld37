with {}
  .virtual = (real_key) ->
    switch real_key
      when 'left', 'a' then C.LEFT
      when 'right','d' then C.RIGHT
      when 'up',   'w' then C.UP
      when 'down', 's' then C.DOWN
      else real_key
