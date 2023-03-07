import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shot').extends(gfx.sprite)
class('Counter').extends(gfx.sprite)

local size = 20
local r = size / 2

function Shot:init(x, y, index)
  Shot.super.init(self)
  self.index = index
  self:moveTo(x, y)
  local shotImage = gfx.image.new(size, size)
  gfx.pushContext(shotImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleAtPoint(r, r, r)
  gfx.popContext()
  self:setImage(shotImage)
  self:add()
end

function Shot:update()
  local remaining = gameState.remaining
  if self.index > remaining then
    self:unfill()
  end
end

function Shot:unfill()
  local shotImage = gfx.image.new(size, size)
  gfx.pushContext(shotImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(r, r, r)
  gfx.popContext()
  self:setImage(shotImage)
end

function drawShots(remaining)
  Counter(remaining)
  local shotOffsetSize = size + 2
  local xOffset = 30
  local index = 1
  for i=1, 3 do
    local yOffset = 50
    for j=1, 8 do
      Shot(xOffset, yOffset, index)
      index += 1
      yOffset += shotOffsetSize
    end
    xOffset += shotOffsetSize
  end
end

function Counter:init(remaining)
  Counter.super.init(self)
  self:setCenter(0,0)
  self:moveTo(32, 8)
  local counterImage = gfx.image.new(32, 32)
  gfx.pushContext(counterImage)
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("*" .. remaining .. "*", 10, 6)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(counterImage)
  self:add()
end

function Counter:update()
  local counterImage = gfx.image.new(32, 32)
  gfx.pushContext(counterImage)
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("*" .. gameState.remaining .. "*", 10, 6)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(counterImage)
end
