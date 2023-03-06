import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function drawShipValue(i, j, value) -- grid coordinates
  local x = (i - 1) * gridSize + gridXOffset
  local y = (j - 1) * gridSize + gridYOffset
  local debugSprite = gfx.sprite.new()
  debugSprite:setSize(gridSize, gridSize)
  function debugSprite:draw()
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.drawText(value, 10, 6)
    gfx.setImageDrawMode(original_draw_mode)
  end

  debugSprite:setCenter(0, 0)
  debugSprite:moveTo(x, y)
  debugSprite:add()
end

local function fits(x, y, length, orientation, board)
  if orientation == 0 then
    for j = 1, length do
      if (x > 8) or (y + j > 8) then
        return false
      elseif (board[x][y + j] ~= 0) then
        return false
      end
    end
    return true
  else
    for i = 1, length do
      if (y > 8) or (x + i > 8) then
        return false
      elseif (board[x + i][y] ~= 0) then
        return false
      end
    end
    return true
  end
end

local function placeShip(length, board)
  local x, y, orientation
  repeat
    orientation = math.floor((math.random() * 1000) % 2)
    x = math.ceil(math.random() * 8)
    y = math.ceil(math.random() * 8)
  until fits(x, y, length, orientation, board)

  if orientation == 0 then
    for j = 1, length do
      board[x][y + j] = length
    end
  else
    for i = 1, length do
      board[x + i][y] = length
    end
  end
end

class('Board').extends()

function Board:init()
  Board.super.init(self)
  self.board = {}
  -- fill in 8x8 matrix with 0
  for x = 1, 8 do
    self.board[x] = {}
    for y = 1, 8 do
      self.board[x][y] = 0
    end
  end
  -- place ships
  placeShip(2, self.board)
  placeShip(3, self.board)
  placeShip(4, self.board)
end

function Board:showShips()
  for i = 1, #self.board do
    for j = 1, #self.board[i] do
      if self.board[i][j] ~= 0 then
        drawShipValue(i, j, self.board[i][j])
      end
    end
  end
end
