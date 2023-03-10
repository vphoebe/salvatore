import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shot').extends(gfx.sprite)
class('Counter').extends(gfx.sprite)
class('EndMsg').extends(gfx.sprite)
class('ShipIndicator').extends(gfx.sprite)
class('ScreenShake').extends(gfx.sprite)

local size = 22
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
  local xOffset = 25
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
  self.font = gfx.font.new('images/font/Asheville-Sans-12-Bold-Oblique')
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
    gfx.setFont(self.font)
    gfx.drawTextAligned(self.shotsTaken, 19, 6, kTextAlignment.center)
    gfx.setImageDrawMode(original_draw_mode)
    gfx.popContext()
    self:setImage(counterImage)
  end
end

function EndMsg:init(won)
  EndMsg.super.init(self)
  self.font = gfx.font.new('images/font/Asheville-Sans-12-Bold-Oblique')
  local text = "Loser! Press Ⓑ to try again..."
  if won then
    text = "Win!! Press Ⓑ to play again!"
    local sound = pd.sound.sampleplayer.new("sound/winner.wav")
    sound:play()
  else
    local sound = pd.sound.sampleplayer.new("sound/loser.wav")
    sound:play()
  end
  self:setCenter(0,0)
  self:moveTo(332, 125)
  local textImage = gfx.image.new(64, 120)
  gfx.pushContext(textImage)
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.setFont(self.font)
    gfx.drawTextInRect(text, 0, 0, 64, 120)
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

function ShipIndicator:init(y, length)
  ShipIndicator.super.init(self)
  self.x = 348
  self.length = length
  self.sunk = false
  self.font = gfx.font.new('images/font/Asheville-Sans-12-Bold-Oblique')
  self:moveTo(self.x, y)
  self:setCenter(0,0)
  local shipImage = gfx.image.new(32, 32)
  gfx.pushContext(shipImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.setLineWidth(2)
    gfx.setStrokeLocation(gfx.kStrokeInside)
    gfx.drawRoundRect(0, 0, 32, 32, 8)
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.setFont(self.font)
    gfx.drawTextAligned(self.length, 16, 8, kTextAlignment.center)
    gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(shipImage)
  self:add()
end

function ShipIndicator:fillIn()
  local shipImage = gfx.image.new(32, 32)
  gfx.pushContext(shipImage)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRoundRect(0, 0, 32, 32, 8)
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
    gfx.setFont(self.font)
    gfx.drawText(self.length, 12, 8)
    gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(shipImage)
end

function ScreenShake:init()
  self.shakeAmount = 0
  self:add()
end

function ScreenShake:setShakeAmount(amount)
  self.shakeAmount = amount
end

function ScreenShake:update()
  if self.shakeAmount > 0 then
    local shakeAngle = math.random()*math.pi*2
    local shakeX = math.floor(math.cos(shakeAngle))*self.shakeAmount
    local shakeY = math.floor(math.sin(shakeAngle))*self.shakeAmount
    self.shakeAmount -= 1
    pd.display.setOffset(shakeX, shakeY)
  else
    pd.display.setOffset(0, 0)
  end
end
