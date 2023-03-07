import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "grid"
import "board"
import "cursor"
import "hud"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Game').extends()

function Game:init()
  gfx.setBackgroundColor(gfx.kColorBlack)
  gfx.clear()
  math.randomseed(pd.getSecondsSinceEpoch())
  drawGrid()
  self.sunk = 0
  self.ended = false
  self.board = Board()
  self.remaining = 24
  self.cursor = Cursor(4, 5)
  self.cursor:add()
  drawShots(self.remaining)
end

gameState = Game()

function pd.update()
  gfx.sprite.update()
  if gameState.sunk == 3 and not gameState.ended then
    -- handle win
    gameState.ended = true
    gameState.cursor:remove()
    EndMsg(true)
  elseif (gameState.remaining == 0) and not gameState.ended then
    -- handle game end state
    gameState.ended = true
    gameState.cursor:remove()
    gameState.board:showShips()
    EndMsg(false)
  end
end
