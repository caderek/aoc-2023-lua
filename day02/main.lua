io.input("./day02/input.txt")

-- PARSING

local function parseLine(line)
  local game = {
    id = tonumber(line:match("%d+")),
    draws = {},
  }

  local chunks = line:gmatch("[%d%l ,]+")

  for chunk in chunks do
    local draw = {}
    local items = chunk:gmatch("%d+ %w+")

    for item in items do
      local num = tonumber(item:match("%d+"))
      local color = item:match("%l+")
      local group = { num = num, color = color }
      table.insert(draw, group)
    end

    if #draw > 0 then
      table.insert(game.draws, draw)
    end
  end

  return game
end

local games = {}

for line in io.lines() do
  table.insert(games, parseLine(line))
end

-- PART 1

local bagContent = {
  red = 12,
  green = 13,
  blue = 14,
}

local solution1 = 0

local function checkGame(game)
  for _, draw in ipairs(game.draws) do
    for _, group in ipairs(draw) do
      if group.num > bagContent[group.color] then
        return false
      end
    end
  end

  return true
end

for _, game in ipairs(games) do
  local isPossible = checkGame(game)

  if isPossible then
    solution1 = solution1 + game.id
  end
end

print("Part 1:", solution1)

-- PART 2

local solution2 = 0

local function getPower(game)
  local max = {
    red = 0,
    green = 0,
    blue = 0,
  }

  for _, draw in ipairs(game.draws) do
    for _, group in ipairs(draw) do
      if group.num > max[group.color] then
        max[group.color] = group.num
      end
    end
  end

  return max.red * max.green * max.blue
end

for _, game in ipairs(games) do
  solution2 = solution2 + getPower(game)
end

print("Part 2:", solution2)
