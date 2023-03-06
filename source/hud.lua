import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = pd.graphics

local scoreSprite

function createShotDisplay()
  scoreSprite = gfx.sprite.new()
  score = gameState.remaining
  updateShotDisplay()
  scoreSprite:setCenter(0, 0)
  scoreSprite:moveTo(4, 4)
  scoreSprite:add()
end

function updateShotDisplay()
  local scoreText = "Shots: " .. gameState.remaining
  local textWidth, textHeight = gfx.getTextSize(scoreText)
  local scoreImage = gfx.image.new(textWidth, textHeight)
  gfx.pushContext(scoreImage)
  gfx.drawText(scoreText, 0, 0)
  gfx.popContext()
  scoreSprite:setImage(scoreImage)
end
