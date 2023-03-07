import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shot').extends(gfx.sprite)

local size = 20

function Shot:init(x, y)
  Shot.super.init(self)
  self:moveTo(x, y)
  local r = size / 2
  local shotImage = gfx.image.new(size, size)
  gfx.pushContext(shotImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawCircleAtPoint(r, r, r)
  gfx.popContext()
  self:setImage(shotImage)
  self:add()
end

function drawShots()
  local shotOffsetSize = size + 2
  local xOffset = 24
  for i=1, 3 do
    local yOffset = 42
    for j=1, 8 do
      Shot(xOffset, yOffset)
      yOffset += shotOffsetSize
    end
    xOffset += shotOffsetSize
  end
end
