io.input("./day04/input.txt")

local lines = {}

for line in io.lines() do
  table.insert(lines, line)
end

-- PARSING

local something = {}

for _, line in ipairs(lines) do
  table.insert(something, nil)
end

-- HELPERS

-- PART 1

local solution1 = 0

print("Part 1:", solution1)

-- PART 2

local solution2 = 0

print("Part 2:", solution2)
