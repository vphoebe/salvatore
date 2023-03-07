import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shot').extends(gfx.sprite)
class('Counter').extends(gfx.sprite)
class('EndMsg').extends(gfx.sprite)
class('Ship').extends(gfx.sprite)

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
  gfx.drawTextAligned("*" .. 24 - gameState.remaining .. "*", 19, 6, kTextAlignment.center)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()
  self:setImage(counterImage)
end

function EndMsg:init(won)
  EndMsg.super.init(self)
  local text = "Loser! Press B to try again..."
  if won then
    text = "Winner! Press B to play again!"
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

function Ship:init(x, y, length)
  Ship.super.init(self)
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

function Ship:fillIn()
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

function Ship:update()
  if not self.sunk then
    local shotsTaken = gameState.board.shotsTaken
    local hits = 0
    for k,v in pairs(shotsTaken) do
      local value = v.value
      if value == self.length then
        hits += 1
      end
    end
    if hits == self.length then
      self:fillIn()
      self.sunk = true
      gameState.sunk += 1
    end
  end
end
