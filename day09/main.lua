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

-- PART 1

local function isZero(x)
  return x == 0
end

local function extrapolate(nums)
  if util.every(nums, isZero) then
    return nums[#nums]
  end

  local next = {}

  for i = 1, #nums - 1 do
    next[i] = nums[i + 1] - nums[i]
  end

  return nums[#nums] + extrapolate(next)
end

local function extrapolateBackwards(nums)
  if util.every(nums, isZero) then
    return nums[1]
  end

  local next = {}

  for i = 1, #nums - 1 do
    next[i] = nums[i + 1] - nums[i]
  end

  return nums[1] - extrapolateBackwards(next)
end

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
    solution2 = solution2 + extrapolateBackwards(nums)
  end

  print("Part 2:", solution2)
end
