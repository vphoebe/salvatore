import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

gridSize = 28
gridXOffset = 100
gridYOffset = 8

class('GridSquare').extends(gfx.sprite)
class('GridBorder').extends(gfx.sprite)

function GridSquare:init(x, y)
  GridSquare.super.init(self)
  self:setCenter(0, 0)
  self:moveTo(x, y)
  local sqImage = gfx.image.new(gridSize, gridSize)
  gfx.pushContext(sqImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.setLineWidth(1)
  gfx.setStrokeLocation(gfx.kStrokeInside)
  gfx.drawRect(0, 0, gridSize, gridSize)
  gfx.popContext()
  self:setImage(sqImage)
  self:add()
end

function GridBorder:init()
  GridBorder.super.init(self)
  self:setCenter(0,0)
  self:moveTo(gridXOffset - 1, gridYOffset - 1)
  local size = gridSize * 8 + 2
  local gridBorder = gfx.image.new(size, size)
  gfx.pushContext(gridBorder)
    gfx.setColor(gfx.kColorWhite)
    gfx.drawRect(0, 0, size, size)
  gfx.popContext()
  self:setImage(gridBorder)
  self:add()
end

function drawGrid()
  -- draw 1px border to make it even
  GridBorder()
  local xOffset = gridXOffset
  for i=1, 8 do
    local yOffset = gridYOffset
    for j=1, 8 do
      GridSquare(xOffset, yOffset)
      yOffset += gridSize
    end
    xOffset += gridSize
  end
end
