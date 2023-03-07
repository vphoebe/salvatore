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
  drawShots()
  self.board = Board()
  self.remaining = 24
  self.cursor = Cursor(4, 5)
  self.cursor:add()
end

gameState = Game()

function pd.update()
  gfx.sprite.update()
end
