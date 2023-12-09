require("utils.pretty-print")
local util = require("utils.util")

io.input("./day08/input.txt")

-- PARSING

local input = {
  steps = "",
  network = {},
}

local lineNumber = 1

for line in io.lines() do
  if lineNumber == 1 then
    input.steps = line
  end

  if lineNumber > 2 then
    local label, left, right = unpack(util.toList(line:gmatch("%w+")))
    input.network[label] = { L = left, R = right }
  end

  lineNumber = lineNumber + 1
end

-- PART 1

do
  local solution1 = 0
  local current = "AAA"

  local moveIndex = 0

  while true do
    local side = input.steps:sub(moveIndex + 1, moveIndex + 1)

    current = input.network[current][side]
    solution1 = solution1 + 1

    if current == "ZZZ" then
      break
    end

    moveIndex = (moveIndex + 1) % #input.steps
  end

  print("Part 1:", solution1)
end

-- PART 2

do
  local current = util.filter(util.keys(input.network), function(label)
    return label:match("A$")
  end)

  local steps = {}
  local moveIndex = 0

  while true do
    for i = 1, #current do
      if not current[i]:match("Z$") then
        local side = input.steps:sub(moveIndex + 1, moveIndex + 1)

        current[i] = input.network[current[i]][side]
        steps[i] = (steps[i] or 0) + 1
      end
    end

    if util.every(current, function(label)
      return label:match("Z$")
    end) then
      break
    end

    moveIndex = (moveIndex + 1) % #input.steps
  end

  local solution2 = util.reduce(steps, util.math.lcm)

  print("Part 2:", solution2)
end
