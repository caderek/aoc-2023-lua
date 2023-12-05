io.input("./day04/input.txt")

-- HELPERS

local function split(str, delimiter)
  local chunks = {}

  for chunk in str:gmatch("([^" .. delimiter .. "]+)") do
    table.insert(chunks, chunk)
  end

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

local function toSet(iterator)
  local set = {}

  for item in iterator do
    set[item] = true
  end

  return set
end

-- PARSING

local scratchcards = {}

for line in io.lines() do
  local chunks = split(line, "|")
  local leftNums = toList(chunks[1]:gmatch("%d+"))
  local rightNums = toSet(chunks[2]:gmatch("%d+"))

  table.insert(scratchcards, {
    numbersYouHave = slice(leftNums, 2, #leftNums),
    winningNumbers = rightNums,
    copies = 1,
  })
end

-- PART 1

local solution1 = 0

for _, scratchcard in ipairs(scratchcards) do
  local score = 0

  for _, num in ipairs(scratchcard.numbersYouHave) do
    if scratchcard.winningNumbers[num] then
      if score == 0 then
        score = 1
      else
        score = score * 2
      end
    end
  end

  solution1 = solution1 + score
end

print("Part 1:", solution1)

-- PART 2

local solution2 = 0

for i, scratchcard in ipairs(scratchcards) do
  local matches = 0

  for _, num in ipairs(scratchcard.numbersYouHave) do
    if scratchcard.winningNumbers[num] then
      matches = matches + 1
    end
  end

  for j = i + 1, i + matches do
    scratchcards[j].copies = scratchcards[j].copies + scratchcard.copies
  end

  solution2 = solution2 + scratchcard.copies
end

print("Part 2:", solution2)
