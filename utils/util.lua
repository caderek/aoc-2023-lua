local math = require("utils.math")

local util = {
  math = math,
}

function util.readFile(path)
  local file = io.open(path, "rb")

  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  return content
end

function util.readInput(inputFile)
  inputFile = inputFile or "input.txt"

  local dir = util.split(debug.getinfo(2).short_src, "/")[1]
  local path = dir .. "/" .. inputFile

  return util.readFile(path)
end

function util.split(str, delimiter)
  local chunks = {}
  local temp = ""

  if not delimiter or delimiter == "" then
    return util.toList(str:gmatch("."))
  end

  for i = 1, #str do
    temp = temp .. str:sub(i, i)
    local last = temp:sub(#temp - #delimiter + 1)

    if last == delimiter then
      table.insert(chunks, temp:sub(1, #temp - #delimiter))
      temp = ""
    end
  end

  if temp ~= "" then
    table.insert(chunks, temp)
  end

  return chunks
end

function util.slice(list, from, to)
  local sliced = {}

  for _, val in ipairs({ unpack(list, from, to) }) do
    table.insert(sliced, val)
  end

  return sliced
end

function util.reverse(list)
  local reversed = {}

  for i = 1, #list do
    reversed[i] = list[#list - i + 1]
  end

  return reversed
end

function util.toList(iterator)
  local list = {}

  for item in iterator do
    table.insert(list, item)
  end

  return list
end

function util.values(tab)
  local list = {}

  for _, v in pairs(tab) do
    table.insert(list, v)
  end

  return list
end

function util.keys(tab)
  local list = {}

  for k in pairs(tab) do
    table.insert(list, k)
  end

  return list
end

function util.toSet(iterator)
  local set = {}

  for item in iterator do
    set[item] = true
  end

  return set
end

function util.chunk(list, chunkSize)
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

function util.map(list, transformation)
  local result = {}

  for index, item in ipairs(list) do
    table.insert(result, transformation(item, index))
  end

  return result
end

function util.filter(list, predicate)
  local result = {}

  for index, item in ipairs(list) do
    if predicate(item, index) then
      table.insert(result, item)
    end
  end

  return result
end

function util.reduce(list, reducer, initial)
  local start = 1

  if initial == nil then
    initial = list[1]
    start = 2
  end

  local result = initial

  for i = start, #list do
    result = reducer(result, list[i], i)
  end

  return result
end

function util.every(list, predicate)
  for index, item in ipairs(list) do
    if not predicate(item, index) then
      return false
    end
  end

  return true
end

function util.toDecimal(x)
  return tonumber(x, 10)
end

return util
