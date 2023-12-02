io.input("./day01/input.txt")

local lines = {}

for line in io.lines() do
  table.insert(lines, line)
end

-- PART 1
local solution1 = 0

for _, line in ipairs(lines) do
  local nums = {}

  for num in string.gmatch(line, "%d") do
    table.insert(nums, num)
  end

  solution1 = solution1 + (nums[1] .. nums[#nums])
end

-- PART 2

local solution2 = 0

local numNames = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }

for _, line in ipairs(lines) do
  local nums = ""

  for i = 1, #line do
    local temp = line:sub(i)
    local first = temp:sub(1, 1)

    if first:match("%d") then
      nums = nums .. first
    else
      for digit, name in ipairs(numNames) do
        if temp:sub(1, #name):match(name) then
          nums = nums .. digit
          break
        end
      end
    end
  end

  solution2 = solution2 + (nums:sub(1, 1) .. nums:sub(#nums, #nums))
end

print("Part 1:", solution1)
print("Part 2:", solution2)
