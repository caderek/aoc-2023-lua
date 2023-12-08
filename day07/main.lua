require("utils.pretty-print")
local util = require("utils.util")

io.input("./day07/input.txt")

-- PARSING

local input = {}

for line in io.lines() do
  local rawHand, rawBid = unpack(util.split(line, " "))

  table.insert(input, {
    hand = util.split(rawHand),
    bid = tonumber(rawBid),
  })
end

-- SHARED

local cardValues = {
  ["A"] = 14,
  ["K"] = 13,
  ["Q"] = 12,
  ["J"] = 11,
  ["T"] = 10,
  ["9"] = 9,
  ["8"] = 8,
  ["7"] = 7,
  ["6"] = 6,
  ["5"] = 5,
  ["4"] = 4,
  ["3"] = 3,
  ["2"] = 2,
}

local function getHandStrength(hand)
  local counts = {}

  for _, card in ipairs(hand) do
    counts[card] = (counts[card] or 0) + 1
  end

  local type = util.values(counts)
  table.sort(type)
  local typeStr = table.concat(type, "")

  if typeStr:match("5") then
    return 6
  end

  if typeStr:match("4") then
    return 5
  end

  if typeStr:match("23") then
    return 4
  end

  if typeStr:match("3") then
    return 3
  end

  if typeStr:match("22") then
    return 2
  end

  if typeStr:match("2") then
    return 1
  end

  return 0
end

local function getCardsStrength(hand)
  return util.reduce(hand, function(sum, card, i)
    return sum + (cardValues[card] * math.pow(10, -2 * (i - 1)))
  end, 0)
end

-- PART 1

local solution1 = 0

table.sort(input, function(a, b)
  local strengthA = getHandStrength(a.hand)
  local strengthB = getHandStrength(b.hand)

  if strengthA == strengthB then
    strengthA = getCardsStrength(a.hand)
    strengthB = getCardsStrength(b.hand)
  end

  return strengthA < strengthB
end)

for i, item in ipairs(input) do
  solution1 = solution1 + (i * item.bid)
end

print("Part 1:", solution1)

-- PART 2

local function getJokerHandStrength(hand)
  local handWithoutJokers = util.filter(hand, function(card)
    return card ~= "J"
  end)

  local jokersCount = 5 - #handWithoutJokers
  local baseStrengt = getHandStrength(handWithoutJokers)

  if jokersCount == 0 then
    return baseStrengt
  end

  if baseStrengt == 5 then
    return 6
  end

  if baseStrengt == 3 and jokersCount == 1 then
    return 5
  end

  if baseStrengt == 3 and jokersCount == 2 then
    return 6
  end

  if baseStrengt == 2 then
    return 4
  end

  if baseStrengt == 1 and jokersCount == 1 then
    return 3
  end

  if baseStrengt == 1 and jokersCount == 2 then
    return 5
  end

  if baseStrengt == 1 and jokersCount == 3 then
    return 6
  end

  if baseStrengt == 0 and jokersCount == 1 then
    return 1
  end

  if baseStrengt == 0 and jokersCount == 2 then
    return 3
  end

  if baseStrengt == 0 and jokersCount == 3 then
    return 5
  end

  return 6
end

cardValues["J"] = 1

local solution2 = 0

table.sort(input, function(a, b)
  local strengthA = getJokerHandStrength(a.hand)
  local strengthB = getJokerHandStrength(b.hand)

  if strengthA == strengthB then
    strengthA = getCardsStrength(a.hand)
    strengthB = getCardsStrength(b.hand)
  end

  return strengthA < strengthB
end)

for i, item in ipairs(input) do
  solution2 = solution2 + (i * item.bid)
end

print("Part 2:", solution2)
