require("utils.pretty-print")
local util = require("utils.util")

local raw = util.readFile("./day08/input.txt")

-- PARSING

local input = { steps = "", network = {} }

do
  local steps, entries = unpack(util.split(raw, "\n\n"))

  input.steps = steps

  for _, line in ipairs(util.split(entries, "\n")) do
    local label, left, right = unpack(util.toList(line:gmatch("%w+")))
    input.network[label] = { L = left, R = right }
  end
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
