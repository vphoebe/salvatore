import "CoreLibs/graphics"

local pd <const> = playdate
local gfx <const> = pd.graphics

local gridSize <const> = 28

local function drawSquare(self, x, y, w, h)
  gfx.setColor(gfx.kColorWhite)
  gfx.setLineWidth(1)
  gfx.setStrokeLocation(gfx.kStrokeInside)
  gfx.drawRect(x, y, w, h)
end

local function newSquare(x, y, fill)
  local w = gridSize
  local h = gridSize
  local sq = gfx.sprite.new()
  sq:setCenter(0, 0)
  sq:moveTo(x, y)
  sq:setSize(w, h)
  sq.draw = drawSquare
  sq:add()
end

local xOffset = 36

function drawGrid()
  for i=1, 8 do
    local yOffset = 8
    for j=1, 8 do
      newSquare(xOffset, yOffset, true)
      yOffset += gridSize
    end
    xOffset += gridSize
  end
end
