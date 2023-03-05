import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

gridSize = 28
gridXOffset = 120
gridYOffset = 8

class('GridSquare').extends(gfx.sprite)

function GridSquare:init(x, y)
  GridSquare.super.init(self)
  self:setCenter(0, 0)
  self:moveTo(x, y)
  local sqImage = gfx.image.new(gridSize, gridSize)
  gfx.pushContext(sqImage)
  gfx.setColor(gfx.kColorBlack)
  gfx.setLineWidth(1)
  gfx.setStrokeLocation(gfx.kStrokeInside)
  gfx.drawRect(0, 0, gridSize, gridSize)
  gfx.popContext()
  self:setImage(sqImage)
  self:add()
end

local xOffset = gridXOffset

function drawGrid()
  for i=1, 8 do
    local yOffset = gridYOffset
    for j=1, 8 do
      GridSquare(xOffset, yOffset)
      yOffset += gridSize
    end
    xOffset += gridSize
  end
end
