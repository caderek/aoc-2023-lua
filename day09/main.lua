require("utils.pretty-print")
local util = require("utils.util")

local raw = util.readInput()

-- PARSING

local input = {}

for _, line in ipairs(util.split(raw, "\n")) do
  table.insert(input, util.map(util.toList(line:gmatch("[-]*%d+")), util.toDecimal))
end

-- PART 1 & 2

local function isZero(x)
  return x == 0
end

local function extrapolate(nums)
  if util.every(nums, isZero) then
    return 0
  end

  local next = {}

  for i = 1, #nums - 1 do
    next[i] = nums[i + 1] - nums[i]
  end

  return nums[#nums] + extrapolate(next)
end

local solution1 = 0
local solution2 = 0

for _, nums in ipairs(input) do
  solution1 = solution1 + extrapolate(nums)
  solution2 = solution2 + extrapolate(util.reverse(nums))
end

print("Part 1:", solution1)
print("Part 2:", solution2)
