import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "grid"
import "board"
import "cursor"

local pd <const> = playdate
local gfx <const> = pd.graphics

function initGame()
  gfx.setBackgroundColor(gfx.kColorWhite)
  gfx.clear()
  math.randomseed(pd.getSecondsSinceEpoch())
  drawGrid()
  initBoard()
  local cursorSprite = Cursor(1, 1)
  cursorSprite:add()
end

function drawDebugX(i, j, value) -- grid coordinates
  local x = (i - 1) * gridSize + gridXOffset
  local y = (j - 1) * gridSize + gridYOffset
  local debugSprite = gfx.sprite.new()
  debugSprite:setSize(gridSize, gridSize)
  function debugSprite:draw()
    local original_draw_mode = gfx.getImageDrawMode()
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    gfx.drawText(value, 10, 6)
    gfx.setImageDrawMode(original_draw_mode)
  end

  debugSprite:setCenter(0, 0)
  debugSprite:moveTo(x, y)
  debugSprite:add()
end

function debugBoard()
  for i = 1, #board do
    for j = 1, #board[i] do
      if board[i][j] ~= 0 then
        drawDebugX(i, j, board[i][j])
      end
    end
  end
end

initGame()
debugBoard()

function pd.update()
  gfx.sprite.update()
end
