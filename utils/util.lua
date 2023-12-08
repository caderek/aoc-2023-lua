local util = {}

function util.readFile(path)
  local file = io.open(path, "rb")

  if not file then
    return nil
  end

  local content = file:read("*all")
  file:close()

  return content
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

  table.insert(chunks, temp)

  return chunks
end

function util.slice(list, from, to)
  local sliced = {}

  for _, val in ipairs({ unpack(list, from, to) }) do
    table.insert(sliced, val)
  end

  return sliced
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
  local result = initial

  for index, item in ipairs(list) do
    result = reducer(result, item, index)
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
