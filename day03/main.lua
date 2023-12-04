io.input("./day03/input.txt")

local lines = {}

for line in io.lines() do
  table.insert(lines, line)
end

-- PARSING GRID

local grid = {}

for _, line in ipairs(lines) do
  local row = {}

  for char in line:gmatch(".") do
    table.insert(row, char)
  end

  table.insert(grid, row)
end

-- PARSING PART NUMBERS

local numbers = {}

for _, line in ipairs(lines) do
  local first = 0
  local last = 0
  local num = ""
  local row = {}

  while true do
    first, last = line:find("%d+", first + #num + 1)

    if not first then
      table.insert(numbers, row)
      break
    end

    num = line:sub(first, last)
    table.insert(row, { num = tonumber(num), from = first, to = last })
  end
end

-- HELPERS

local coords = {
  { 0, -1 },
  { 1, -1 },
  { 1, 0 },
  { 1, 1 },
  { 0, 1 },
  { -1, 1 },
  { -1, 0 },
  { -1, -1 },
}

local function getCell(grid, x, y)
  -- return nil if outside the grid
  if (y > #grid or y < 1) and (x > #grid[1] or x < 1) then
    return nil
  end

  return grid[y][x]
end

local function getDigitNeigbors(grid, x, y)
  local neighbors = {}

  for _, move in ipairs(coords) do
    local xx = x + move[1]
    local yy = y + move[2]
    local neighbor = getCell(grid, xx, yy)

    if neighbor ~= "." and neighbor:match("%d") then
      table.insert(neighbors, { digit = neighbor, x = xx, y = yy })
    end
  end

  return neighbors
end

local function dedupe(list)
  local hash = {}
  local result = {}

  for _, item in ipairs(list) do
    if not hash[item] then
      hash[item] = true
      table.insert(result, item)
    end
  end

  return result
end

-- PART 1

local solution1 = 0

for y, row in ipairs(grid) do
  for x, char in ipairs(row) do
    if char:match("[^%w.]") then
      local neighbors = getDigitNeigbors(grid, x, y)

      for _, neighbor in ipairs(neighbors) do
        for _, entry in ipairs(numbers[neighbor.y]) do
          if neighbor.x >= entry.from and neighbor.x <= entry.to and not entry.done then
            solution1 = solution1 + entry.num
            entry.done = true
          end
        end
      end
    end
  end
end

print("Part 1:", solution1)

-- PART 2

local solution2 = 0

for y, row in ipairs(grid) do
  for x, char in ipairs(row) do
    if char:match("*") then
      local neighbors = getDigitNeigbors(grid, x, y)

      local nums = {}

      for _, neighbor in ipairs(neighbors) do
        for _, entry in ipairs(numbers[neighbor.y]) do
          if neighbor.x >= entry.from and neighbor.x <= entry.to then
            table.insert(nums, entry.num)
          end
        end
      end

      local unique = dedupe(nums)

      if #unique == 2 then
        solution2 = solution2 + unique[1] * unique[2]
      end
    end
  end
end

print("Part 2:", solution2)
