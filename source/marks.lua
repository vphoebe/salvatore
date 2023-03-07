import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function getAbsoluteCoordsFromGridPos(gridPos)
  local i, j = table.unpack(gridPos)
  local x = (i - 1) * gridSize + gridXOffset
  local y = (j - 1) * gridSize + gridYOffset
  return { x, y }
end

class('Mark').extends(gfx.sprite)

function Mark:init(i, j, result)
  Mark.super.init(self)
  self.result = result
  self:setCenter(0, 0)
  self:setSize(gridSize, gridSize)
  local absoluteCoords = getAbsoluteCoordsFromGridPos({ i, j })
  local x, y = table.unpack(absoluteCoords)
  self:moveTo(x, y)
  self:add()
end

function Mark:draw()
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("*" .. self.result .. "*", 10, 6)
  gfx.setImageDrawMode(original_draw_mode)
end
