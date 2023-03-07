import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "grid"
import "marks"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function getAbsoluteCoordsFromGridPos(gridPos)
  local i, j = table.unpack(gridPos)
  local x = (i - 1) * gridSize + gridXOffset
  local y = (j - 1) * gridSize + gridYOffset
  return { x - 8, y - 8 }
end

class('Cursor').extends(gfx.sprite)

function Cursor:init(i, j)
  Cursor.super.init(self)
  self.gridI = i
  self.gridJ = j
  self:setCenter(0, 0)
  local absoluteCoords = getAbsoluteCoordsFromGridPos({ self.gridI, self.gridJ })
  local x, y = table.unpack(absoluteCoords)
  self:moveTo(x, y)
  local size = gridSize + 16
  local r = (size / 2)
  local cursorImage = gfx.image.new(size, size)
  gfx.pushContext(cursorImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.setLineWidth(2)
  gfx.setStrokeLocation(gfx.kStrokeInside)
  gfx.drawCircleAtPoint(r, r, r)
  gfx.setColor(gfx.kColorBlack)
  gfx.setLineWidth(0)
  gfx.fillCircleAtPoint(r, r, r - 2)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillTriangle(size / 2, size / 2, 8, size - 2, size - 8, size - 2)
  gfx.popContext()
  self:setImage(cursorImage)
end

function Cursor:update()
  Cursor.super.update(self)
  if pd.buttonJustPressed(pd.kButtonUp) then
    local newJPos = self.gridJ - 1
    if ((newJPos <= 8) and (newJPos > 0)) then
      self:moveBy(0, -gridSize)
      self.gridJ = newJPos
    end
  end
  if pd.buttonJustPressed(pd.kButtonRight) then
    local newIPos = self.gridI + 1
    if ((newIPos <= 8) and (newIPos > 0)) then
      self:moveBy(gridSize, 0)
      self.gridI = newIPos
    end
  end
  if pd.buttonJustPressed(pd.kButtonDown) then
    local newJPos = self.gridJ + 1
    if ((newJPos <= 8) and (newJPos > 0)) then
      self:moveBy(0, gridSize)
      self.gridJ = newJPos
    end
  end
  if pd.buttonJustPressed(pd.kButtonLeft) then
    local newIPos = self.gridI - 1
    if ((newIPos <= 8) and (newIPos > 0)) then
      self:moveBy(-gridSize, 0)
      self.gridI = newIPos
    end
  end
  if pd.buttonJustPressed(pd.kButtonA) then
    gameState.shots[gameState.remaining]:unfill()
    gameState.remaining -= 1
    if gameState.board.board[self.gridI][self.gridJ] ~= 0 then
      -- hit
      Mark(self.gridI, self.gridJ, 'O')
    else
      -- miss
      Mark(self.gridI, self.gridJ, 'X')
    end
  end
end
