with {}
  .DEFAULT_STATE = "play"
  -- MAP_SIZE: Vec 10, 10 -- custom map size
  .CELL_SIZE = Vec 32,32
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
