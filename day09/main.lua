require("utils.pretty-print")
local util = require("utils.util")

local raw = util.readInput()

-- PARSING

local input = {}

do
  for _, line in ipairs(util.split(raw, "\n")) do
    table.insert(input, util.map(util.toList(line:gmatch("[-]*%d+")), util.toDecimal))
  end
end

-- COMMON

local function isZero(x)
  return x == 0
end

local function extrapolate(nums, backwards)
  local sign = backwards and -1 or 1
  local index = backwards and 1 or #nums

  if util.every(nums, isZero) then
    return 0
  end

  local next = {}

  for i = 1, #nums - 1 do
    next[i] = nums[i + 1] - nums[i]
  end

  return nums[index] + extrapolate(next, backwards) * sign
end

-- PART 1

do
  local solution1 = 0

  for _, nums in ipairs(input) do
    solution1 = solution1 + extrapolate(nums)
  end

  print("Part 1:", solution1)
end

-- PART 2

do
  local solution2 = 0

  for _, nums in ipairs(input) do
    solution2 = solution2 + extrapolate(nums, true)
  end

  print("Part 2:", solution2)
end
