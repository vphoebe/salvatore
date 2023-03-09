import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shot').extends(gfx.sprite)
class('Counter').extends(gfx.sprite)
class('EndMsg').extends(gfx.sprite)
class('ShipIndicator').extends(gfx.sprite)

local size = 20
local r = size / 2

function Shot:init(x, y, index)
  Shot.super.init(self)
  self.index = index
  self.filled = true
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
  if self.index > remaining and self.filled then
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
  self.filled = false
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

function Counter:init()
  Counter.super.init(self)
  self.shotsTaken = -1 -- allow update to draw initial 0
  self:setCenter(0,0)
  self:moveTo(32, 8)
  self:add()
end

function Counter:update()
  if 24 - gameState.remaining ~= self.shotsTaken then
    self.shotsTaken = 24 - gameState.remaining
    local counterImage = gfx.image.new(32, 32)
    gfx.pushContext(counterImage)
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawTextAligned("*" .. self.shotsTaken .. "*", 19, 6, kTextAlignment.center)
    gfx.setImageDrawMode(original_draw_mode)
    gfx.popContext()
    self:setImage(counterImage)
  end
end

function EndMsg:init(won)
  EndMsg.super.init(self)
  local text = "Loser! Press B to try again..."
  if won then
    text = "Winner! Press B to play again!"
    local sound = pd.sound.sampleplayer.new("sound/winner.wav")
    sound:play()
  else
    local sound = pd.sound.sampleplayer.new("sound/loser.wav")
    sound:play()
  end
  self:setCenter(0,0)
  self:moveTo(340, 125)
  local textImage = gfx.image.new(64, 200)
  gfx.pushContext(textImage)
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawTextInRect(text, 0, 0, 56, 120)
    gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(textImage)
  self:add()
end

function EndMsg:update()
  if pd.buttonJustPressed(pd.kButtonB) then
    -- reset game logic
    for k,v in pairs(gfx.sprite.getAllSprites()) do
      v:remove()
    end
    gameState = Game()
  end
end

function ShipIndicator:init(x, y, length)
  ShipIndicator.super.init(self)
  self.length = length
  self.sunk = false
  self:moveTo(x, y)
  self:setCenter(0,0)
  local shipImage = gfx.image.new(32, 32)
  gfx.pushContext(shipImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.drawRect(0, 0, 32, 32)
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText(self.length, 12, 8)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(shipImage)
  self:add()
end

function ShipIndicator:fillIn()
  local shipImage = gfx.image.new(32, 32)
  gfx.pushContext(shipImage)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillRect(0, 0, 32, 32)
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
  gfx.drawText(self.length, 12, 8)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(shipImage)
end
