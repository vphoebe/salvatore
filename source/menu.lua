import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Menu').extends(gfx.sprite)

function Menu:init()
  gfx.setBackgroundColor(gfx.kColorBlack)
  Menu.super.init(self)
  self:setCenter(0, 0)
  self.font = gfx.font.new('images/font/Asheville-Sans-12-Bold-Oblique')
  local menuImage = gfx.image.new(400, 240)
  local logoImage = gfx.image.new("images/logo")

  gfx.pushContext(menuImage)
  gfx.setFont(self.font)
  local original_draw_mode = gfx.getImageDrawMode()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  logoImage:draw(56, 20)
  gfx.drawTextAligned("Press Ⓐ to START", 200, 210, kTextAlignment.center)
  gfx.drawTextInRect(
    "Take 24 shots at an 8-by-8 grid to sink all three ships.", 32, 80,
    336, 100)
  gfx.drawTextAligned("Move: ✛", 200, 140, kTextAlignment.center)
  gfx.drawTextAligned("Shoot: Ⓐ", 200, 165, kTextAlignment.center)
  gfx.setImageDrawMode(original_draw_mode)
  gfx.popContext()

  self:setImage(menuImage)
  self:add()
end

function Menu:update()
  if pd.buttonJustPressed(pd.kButtonA) then
    -- reset game logic
    for k, v in pairs(gfx.sprite.getAllSprites()) do
      v:remove()
    end
    gameState = Game()
  end
end
