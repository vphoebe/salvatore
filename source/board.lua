board = {}

function fits(x, y, length, orientation)
  if orientation == 0 then
    for j = 1, length do
      if (x > 8) or (y + j > 8) then
        return false
      elseif (board[x][y + j] ~= 0) then
        return false
      end
    end
    return true
  else
    for i = 1, length do
      if (y > 8) or (x + i > 8) then
        return false
      elseif (board[x + i][y] ~= 0) then
        return false
      end
    end
    return true
  end
end

function placeShip(length)
  local x, y, orientation
  repeat
    orientation = math.floor((math.random() * 1000) % 2)
    x = math.ceil(math.random() * 8)
    y = math.ceil(math.random() * 8)
  until fits(x, y, length, orientation)

  if orientation == 0 then
    for j = 1, length do
      board[x][y + j] = length
    end
  else
    for i = 1, length do
      board[x + i][y] = length
    end
  end
end

function initBoard()
  -- fill in 8x8 matrix with 0
  for x = 1, 8 do
    board[x] = {}
    for y = 1, 8 do
      board[x][y] = 0
    end
  end
  -- place ships
  placeShip(2)
  placeShip(3)
  placeShip(4)
end
