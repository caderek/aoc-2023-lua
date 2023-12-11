require("utils.pretty-print")
local util = require("utils.util")

-- PARSING

-- local input = util.readInput()
local input = util.readInput("example.txt")
local parts = util.split(input, "\n\n")

local data = {
  seeds = util.map(util.toList(util.slice(parts, 1, 1)[1]:gmatch("%d+")), util.toDecimal),
  maps = {},
}

for _, part in ipairs(util.slice(parts, 2, #parts)) do
  local rows = util.map(util.toList(part:gmatch("%d+")), util.toDecimal)
  table.insert(data.maps, util.chunk(rows, 3))
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

local solution1 = math.min(unpack(finalDestinations))

print("Part 1:", solution1)

-- PART 2

local function sortRanges(ranges)
  table.sort(ranges, function(a, b)
    return a[1] < b[1]
  end)

  return ranges
end

local function getStartRanges(seeds)
  return sortRanges(util.map(util.chunk(seeds, 2), function(item)
    return { item[1], item[1] + item[2] - 1 }
  end))
end

local function getFullRanges(baseRanges)
  -- sortRanges(baseRanges)

  local allRanges = {}

  local allLimits = util.flat(baseRanges)

  table.insert(allRanges, { -math.huge, math.min(unpack(allLimits)) - 1 })

  for _, range in ipairs(baseRanges) do
    local lastUnused = allRanges[#allRanges][2] + 1
    local currentStart = range[1]

    if lastUnused < currentStart then
      table.insert(allRanges, { lastUnused, currentStart - 1 })
    end

    table.insert(allRanges, { currentStart, range[2] })
  end

  table.insert(allRanges, { math.max(unpack(allLimits)) + 1, math.huge })

  return allRanges
end

local function getMappingRanges(mappingData)
  local baseRanges = { {}, {} }

  for _, mapping in ipairs(mappingData) do
    local destination, source, length = unpack(mapping)
    local sourceRange = { source, source + length - 1 }
    local destinationRange = { destination, destination + length - 1 }

    table.insert(baseRanges[1], sourceRange)
    table.insert(baseRanges[2], destinationRange)
  end

  local fullRanges = {}

  for _, ranges in ipairs(baseRanges) do
    table.insert(fullRanges, getFullRanges(ranges))
  end

  return fullRanges
end

local function getAllRanges()
  local ranges = { getStartRanges(data.seeds) }

  for _, mappingData in ipairs(data.maps) do
    local stageRanges = getMappingRanges(mappingData)

    for _, item in ipairs(stageRanges) do
      table.insert(ranges, item)
    end
  end

  return ranges
end

local function foldRanges()
  local ranges = getAllRanges()

  local current = ranges[1]
  print(current)

  for _, item in ipairs(util.slice(ranges, 2, #ranges)) do
    print(item)
  end

  --temp
  return { { 1 } }
end

local solution2 = foldRanges()[1][1]

print("Part 2:", solution2)
