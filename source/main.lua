import "CoreLibs/graphics"
import "grid"
import "board"

local pd <const> = playdate
local gfx <const> = pd.graphics

function resetGame()
  gfx.setBackgroundColor(gfx.kColorBlack)
  gfx.clear()
  math.randomseed(pd.getSecondsSinceEpoch())
  drawGrid()
  initBoard()
end

resetGame()

function pd.update()
  gfx.sprite.update()
end
