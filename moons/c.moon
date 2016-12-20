with {}
  .PATH_IMAGE = "assets/image/"
  .DEFAULT_STATE = if DEBUG then "play" else "welcome"
  -- MAP_SIZE: Vec 10, 10 -- custom map size
  .CELL_SIZE = Vec 64, 64
  -- CELL_SIZE_HALF: Vec 16,16
  .LEFT  = 1
  .RIGHT = 2
  .UP    = 3
  .DOWN  = 4
  .DIR2VEC = {
    Vec -1, 0
    Vec 1, 0
    Vec 0, -1
    Vec 0, 1
  }
  .WHITE = {149,223,255}
  .BLUE = {43,191,255}
  .DARKBLUE = {0,155,255}
