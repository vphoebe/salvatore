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
  local image = gfx.image.new("images/hit")
  if type == 'end' then
    image = gfx.image.new("images/end")
  end
  if type == 'miss' then
    image = gfx.image.new("images/miss")
  end
  self:setImage(image)
  local absoluteCoords = getAbsoluteCoordsFromGridPos({ i, j })
  local x, y = table.unpack(absoluteCoords)
  self:moveTo(x, y)
  self:add()
  if type ~= "end" then
    self:playSound()
    gameState.remaining -= 1
  end
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
