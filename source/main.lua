import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/object"
import "grid"
import "board"
import "cursor"
import "hud"

local pd <const> = playdate
local gfx <const> = pd.graphics

pd.display.setRefreshRate(20)

class('Game').extends()

function Game:init()
  gfx.setBackgroundColor(gfx.kColorBlack)
  gfx.clear()
  math.randomseed(pd.getSecondsSinceEpoch())
  drawGrid()
  self.ships = {
    ShipIndicator(356, 8, 2),
    ShipIndicator(356, 44, 3),
    ShipIndicator(356, 80, 4)
  }
  self.sunk = 0
  self.ended = false
  self.board = Board()
  self.remaining = 24
  self.cursor = Cursor(4, 5)
  self.cursor:add()
  drawShots(self.remaining)
end

function Game:calcSunk()
  for key, ship in pairs(self.ships) do
    local sunk = ship.sunk
    local length = ship.length
    if not sunk then
      local shotsTaken = gameState.board.shotsTaken
      local hits = 0
      for k,v in pairs(shotsTaken) do
        local value = v.value
        if value == length then
          hits += 1
        end
      end
      if hits == length then
        ship:fillIn()
        ship.sunk = true
        self.sunk += 1
        local sound = pd.sound.sampleplayer.new("sound/sunk")
        sound:play()
      end
    end
  end
end

gameState = Game()

function pd.update()
  gfx.sprite.update()
  if (not gameState.ended) then
    gameState:calcSunk()
    if gameState.remaining == 0 or gameState.sunk == 3 then
      -- handle game end state
      gameState.ended = true
      gameState.cursor:remove()
      if (gameState.sunk == 3) then
        EndMsg(true)
      else
        gameState.board:showShips()
        EndMsg(false)
      end
    end
  end
end
