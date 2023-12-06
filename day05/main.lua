require("utils.pretty-print")

-- HELPERS

local function readFile(path)
  local file = io.open(path, "rb")

  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  return content
end

local function split(str, delimiter)
  local chunks = {}
  local temp = ""

  for i = 1, #str do
    temp = temp .. str:sub(i, i)
    local last = temp:sub(#temp - #delimiter + 1)

    if last == delimiter then
      table.insert(chunks, temp:sub(1, #temp - #delimiter))
      temp = ""
    end
  end

  table.insert(chunks, temp)

  return chunks
end

local function slice(list, from, to)
  local sliced = {}

  for _, val in ipairs({ table.unpack(list, from, to) }) do
    table.insert(sliced, val)
  end

  return sliced
end

local function toList(iterator)
  local list = {}

  for item in iterator do
    table.insert(list, item)
  end

  return list
end

local function chunk(list, chunkSize)
  local chunks = { {} }

  for _, item in ipairs(list) do
    if #chunks[#chunks] == chunkSize then
      table.insert(chunks, { item })
    else
      table.insert(chunks[#chunks], item)
    end
  end

  return chunks
end

local function map(list, transformation)
  local result = {}

  for index, item in ipairs(list) do
    table.insert(result, transformation(item, index))
  end

  return result
end

local function filter(list, predicate)
  local result = {}

  for index, item in ipairs(list) do
    if predicate(item, index) then
      table.insert(result, item)
    end
  end

  return result
end

local function reduce(list, reducer, initial)
  local result = initial

  for index, item in ipairs(list) do
    result = reducer(result, item, index)
  end

  return result
end

local function toDecimal(x)
  return tonumber(x, 10)
end

-- PARSING

-- local input = readFile("./day05/input.txt")
local input = readFile("./day05/example.txt")
local parts = split(input, "\n\n")

local data = {
  seeds = map(toList(slice(parts, 1, 1)[1]:gmatch("%d+")), toDecimal),
  maps = {},
}

for _, part in ipairs(slice(parts, 2, #parts)) do
  local rows = map(toList(part:gmatch("%d+")), toDecimal)
  table.insert(data.maps, chunk(rows, 3))
end

-- PART 1

local finalDestinations = {}

for _, seed in ipairs(data.seeds) do
  local source = seed

  for _, entries in ipairs(data.maps) do
    local destination = nil

    for _, entry in ipairs(entries) do
      local destinationRangeStart = entry[1]
      local sourceRangeStart = entry[2]
      local sourceRangeEnd = entry[2] + entry[3]

      if source >= sourceRangeStart and source <= sourceRangeEnd then
        destination = destinationRangeStart + source - sourceRangeStart
        break
      end
    end

    if destination ~= nil then
      source = destination
    end
  end

  table.insert(finalDestinations, source)
end

print("Destinations:", finalDestinations)

local solution1 = math.min(table.unpack(finalDestinations))

print("Part 1:", solution1)

-- PART 2

local solution2 = 0

print("Part 2:", solution2)
