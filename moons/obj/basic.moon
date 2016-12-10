-- @class Base of any object in the game
class Basic
  new: (grid, pos) =>
    @to grid, pos
  -- @function to_where; return a list of possible position, preferable first
  to_where: => {}
  -- @function to; goto a new pos
  to: (grid, pos) =>
    @pos = pos
    @grid = grid
    grid[pos.x][pos.y] = @