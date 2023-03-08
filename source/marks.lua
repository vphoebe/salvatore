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

function Mark:init(i, j, type)
  -- type = hit, miss, or end
  Mark.super.init(self)
  self.type = type
  self:setCenter(0, 0)
  self:setSize(gridSize, gridSize)
  local absoluteCoords = getAbsoluteCoordsFromGridPos({ i, j })
  local x, y = table.unpack(absoluteCoords)
  self:moveTo(x, y)
  self:add()
  if type ~= "end" then
    self:playSound()
  end
end

function Mark:draw()
  local text = 'O'
  if self.type == "miss" then
    text = 'X'
  end
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("*" .. text .. "*", 10, 6)
  gfx.setImageDrawMode(original_draw_mode)
end

function Mark:playSound()
  if self.type == "hit" then
    local sound = pd.sound.sampleplayer.new("sound/hit.wav")
    sound:setVolume(0.8)
    sound:play(1)
  elseif self.type == "miss" then
    local sound = pd.sound.sampleplayer.new("sound/miss.wav")
    sound:play(1)
  end
end
