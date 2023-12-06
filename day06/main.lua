require("utils.pretty-print")
-- io.input("./day06/example.txt")
io.input("./day06/input.txt")

-- HELPERS

local function toList(iterator)
  local list = {}

  for item in iterator do
    table.insert(list, item)
  end

  return list
end

local function map(list, transformation)
  local result = {}

  for index, item in ipairs(list) do
    table.insert(result, transformation(item, index))
  end

  return result
end

local function toDecimal(x)
  return tonumber(x, 10)
end

-- PARSING

local input = {}

for line in io.lines() do
  table.insert(input, map(toList(line:gmatch("%d+")), toDecimal))
end

-- PART 1

local solution1 = 1

for i = 1, #input[1] do
  local time = input[1][i]
  local record = input[2][i]

  local good = 0

  for t = 1, time - 1 do
    if (time - t) * t > record then
      good = good + 1
    end
  end

  solution1 = solution1 * good
end

print("Part 1:", solution1)

-- PART 2

input = { { 58819676 }, { 434104122191218 } }

local solution2 = 1

for i = 1, #input[1] do
  local time = input[1][i]
  local record = input[2][i]

  local good = 0

  for t = 1, time - 1 do
    if (time - t) * t > record then
      good = good + 1
    end
  end

  solution2 = solution2 * good
end

print("Part 2:", solution2)
