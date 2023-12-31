require("utils.pretty-print")
local util = require("utils.util")

local raw = util.readInput()

-- PARSING

local grid = {}

for _, line in ipairs(util.split(raw, "\n")) do
  table.insert(grid, util.split(line))
end

-- CREATING A GRAPH

local dirs = {
  ["F"] = { { dx = 1, dy = 0 }, { dx = 0, dy = 1 } },
  ["L"] = { { dx = 1, dy = 0 }, { dx = 0, dy = -1 } },
  ["J"] = { { dx = -1, dy = 0 }, { dx = 0, dy = -1 } },
  ["7"] = { { dx = -1, dy = 0 }, { dx = 0, dy = 1 } },
  ["|"] = { { dx = 0, dy = 1 }, { dx = 0, dy = -1 } },
  ["-"] = { { dx = 1, dy = 0 }, { dx = -1, dy = 0 } },
}

local function pointToLabel(x, y)
  return x .. ":" .. y
end

local function labelToPint(label)
  return unpack(util.map(util.split(label, ":"), util.toDecimal))
end

local function getNeighbors(shape, x, y)
  local neighbors = {}

  for _, dir in ipairs(dirs[shape]) do
    table.insert(neighbors, pointToLabel(x + dir.dx, y + dir.dy))
  end

  return neighbors
end

local graph = {}
local start

for y, row in ipairs(grid) do
  for x, shape in ipairs(row) do
    if shape ~= "." and shape ~= "S" then
      graph[pointToLabel(x, y)] = getNeighbors(shape, x, y)
    elseif shape == "S" then
      start = pointToLabel(x, y)
      graph[start] = {}
    end
  end
end

-- find and add statring point edges

local function isStart(edge)
  return edge == start
end

for node, edges in pairs(graph) do
  if util.some(edges, isStart) then
    table.insert(graph[start], node)
  end
end

-- PART 1

local prev = graph[start][1]
local current = start
local loop = { start }

repeat
  local edges = graph[current]
  local next

  next = util.find(edges, function(item)
    return item ~= prev
  end)

  prev = current
  current = next
  table.insert(loop, next)
until current == start

local solution1 = math.floor(#loop / 2)

print("Part 1:", solution1)

-- PART 2

local function isInPoly(poly, x, y)
  local isInside = false
  local j = #poly

  for i = 1, #poly do
    local xi = poly[i].x
    local xj = poly[j].x
    local yi = poly[i].y
    local yj = poly[j].y

    if (yi > y) ~= (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi then
      isInside = not isInside
    end

    j = i
  end

  return isInside
end

local function isVertex(x, y)
  return grid[y][x]:match("[LJ7FS]")
end

local poly = util.reduce(loop, function(acc, node)
  local x, y = labelToPint(node)

  if isVertex(x, y) then
    table.insert(acc, { x = x, y = y })
  end

  return acc
end, {})

local loopPoints = util.toSet(loop)
local solution2 = 0

for y = 1, #grid do
  for x = 1, #grid[1] do
    if not loopPoints[pointToLabel(x, y)] and isInPoly(poly, x, y) then
      solution2 = solution2 + 1
    end
  end
end

print("Part 2:", solution2)
