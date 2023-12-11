require("utils.pretty-print")
local util = require("utils.util")

local raw = util.readInput()

-- PARSING

local input = {
  points = {},
  shiftedX = {},
  shiftedY = {},
}

for y, line in ipairs(util.split(raw, "\n")) do
  for x, point in ipairs(util.split(line)) do
    if point == "#" then
      table.insert(input.points, { x, y })
      input.shiftedX[x] = x
      input.shiftedY[y] = y
    end
  end
end

-- COMMON

local function shiftIndicies(mapping, expansionSize)
  local additional = 0
  local nums = util.sort(util.keys(mapping))

  for i, num in ipairs(nums) do
    local prev = nums[i - 1] or nums[1] - 1
    local diff = nums[i] - prev

    if diff > 1 then
      additional = additional + (diff - 1) * expansionSize - 1
    end

    mapping[num] = num + additional
  end
end

local function getSumOfDistances()
  local sum = 0
  local used = {}

  for i, a in ipairs(input.points) do
    for j, b in ipairs(input.points) do
      local label = table.concat(util.sort({ i, j }), ":")

      if i ~= j and not used[label] then
        local x1, y1 = unpack(a)
        local x2, y2 = unpack(b)

        local distance = math.abs(input.shiftedX[x1] - input.shiftedX[x2])
          + math.abs(input.shiftedY[y1] - input.shiftedY[y2])

        sum = sum + distance
        used[label] = true
      end
    end
  end

  return sum
end

-- PART 1

shiftIndicies(input.shiftedX, 2)
shiftIndicies(input.shiftedY, 2)
local solution1 = getSumOfDistances()

print("Part 1:", solution1)

-- PART 2

shiftIndicies(input.shiftedX, 1e6)
shiftIndicies(input.shiftedY, 1e6)
local solution2 = getSumOfDistances()

print("Part 2:", solution2)
