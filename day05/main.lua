require("utils.pretty-print")
local util = require("utils.util")

-- PARSING

local input = util.readInput()
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
  return util.sort(ranges, function(a, b)
    return a[1] < b[1]
  end)
end

local function getStartRanges(seeds)
  return sortRanges(util.map(util.chunk(seeds, 2), function(item)
    return { item[1], item[1] + item[2] - 1 }
  end))
end

local function getRangeShifts(maps)
  local pipeline = {}

  for _, mappingData in ipairs(maps) do
    local shifts = {}

    for _, mapping in ipairs(mappingData) do
      local destination, source, length = unpack(mapping)
      local shift = destination - source
      local transformation = { source, source + length - 1, shift }
      table.insert(shifts, transformation)
    end

    table.insert(pipeline, sortRanges(shifts))
  end

  return pipeline
end

local function getOverlap(range, transformation)
  local fromA, toA = unpack(range)
  local fromB, toB, shift = unpack(transformation)
  local startDiff = fromA - fromB
  local finishDiff = toA - toB

  local overlapStart = math.max(fromB + startDiff, fromB)
  local overlapEnd = math.min(toB + finishDiff, toB)

  if overlapStart > overlapEnd then
    return nil
  end

  return {
    range = { overlapStart + shift, overlapEnd + shift },
    used = { overlapStart, overlapEnd },
  }
end

local function getUnused(range, used)
  used = sortRanges(used)

  local unused = {}
  local x = range[1]

  for _, item in ipairs(used) do
    local len = item[1] - x

    if len > 0 then
      table.insert(unused, { x, x + len - 1 })
    end

    x = item[2] + 1
  end

  if x < range[2] then
    table.insert(unused, { x, range[2] })
  end

  return unused
end

local function foldOnce(rangeShifts, ranges)
  local done = {}

  for _, range in ipairs(ranges) do
    local used = {}

    for _, transformation in ipairs(rangeShifts) do
      local overlap = getOverlap(range, transformation)

      if overlap then
        table.insert(done, overlap.range)
        table.insert(used, overlap.used)
      end
    end

    for _, unused in ipairs(getUnused(range, used)) do
      table.insert(done, unused)
    end
  end

  return done
end

local function foldRanges()
  local pipeline = getRangeShifts(data.maps)
  local ranges = getStartRanges(data.seeds)

  for _, rangeShifts in ipairs(pipeline) do
    ranges = foldOnce(rangeShifts, ranges)
  end

  local sorted = sortRanges(ranges)

  return sorted
end

local solution2 = foldRanges()[1][1]

print("Part 2:", solution2)
