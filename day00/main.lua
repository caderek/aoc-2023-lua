require("utils.pretty-print")
local util = require("utils.util")

-- local raw = util.readInput()
local raw = util.readInput("example.txt")

-- PARSING

local input = {}

do
  for _, line in ipairs(util.split(raw, "\n")) do
    table.insert(input, line)
  end
end

print(input)

-- PART 1

do
  local solution1 = 0

  print("Part 1:", solution1)
end

-- PART 2

do
  local solution2 = 0

  print("Part 2:", solution2)
end
