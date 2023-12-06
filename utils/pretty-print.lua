local inspect = require("./utils.inspect")
local rawPrint = print

local styles = {
  default = "\27[0m",
  black = "\27[30m",
  red = "\27[31m",
  green = "\27[32m",
  yellow = "\27[33m",
  blue = "\27[34m",
  magenta = "\27[35m",
  cyan = "\27[36m",
  white = "\27[37m",
  blackLight = "\27[90m",
  redLight = "\27[91m",
  greenLight = "\27[92m",
  yellowLight = "\27[93m",
  blueLight = "\27[94m",
  magentaLight = "\27[95m",
  cyanLight = "\27[96m",
  whiteLight = "\27[97m",
  bold = "\27[1m",
  underline = "\27[4m",
  noUnderline = "\27[24m",
  reverse = "\27[7m",
  noReverse = "\27[27m",
}

local function formatNumber(val)
  return styles.yellow .. tostring(val) .. styles.default
end

local function formatString(val, quoteStrings)
  if not quoteStrings then
    return val
  end

  return styles.cyan .. '"' .. val .. '"' .. styles.default
end

local function formatBoolean(val)
  return styles.magenta .. tostring(val) .. styles.default
end

local function formatFunction(val)
  return styles.blue .. "[" .. tostring(val) .. "]" .. styles.default
end

local function isNumericTable(table)
  local i = 0

  for _ in pairs(table) do
    i = i + 1
    if table[i] == nil then
      return false
    end
  end

  return true
end

local function formatKey(val, formatFn)
  if type(val) == "string" and val:match("^[_%l%u][_%w]*$") then
    return val
  end

  return "[" .. formatFn(val, true) .. "]"
end

local function formatNumericTable(table, formatFn)
  if #table == 0 then
    return "{}"
  end

  local output = "{ "

  for i, val in ipairs(table) do
    output = output .. formatFn(val, true)

    if i ~= #table then
      output = output .. ", "
    end
  end
  --
  output = output .. " }"

  return output
end

local function formatGenericTable(tab, formatFn)
  local items = {}

  for key, val in pairs(tab) do
    local item = formatKey(key, formatFn) .. " = " .. formatFn(val, true)

    table.insert(items, item)
  end

  if #items == 0 then
    return "{}"
  end

  local output = "{ "

  for i, val in ipairs(items) do
    output = output .. val

    if i ~= #items then
      output = output .. ", "
    end
  end

  output = output .. " }"

  return output
end

local function formatTable(table, formatFn)
  if isNumericTable(table) then
    return formatNumericTable(table, formatFn)
  end

  return formatGenericTable(table, formatFn)
end

local function formatValue(val, quoteStrings)
  if type(val) == "number" then
    return formatNumber(val)
  end

  if type(val) == "string" then
    return formatString(val, quoteStrings)
  end

  if type(val) == "boolean" then
    return formatBoolean(val)
  end

  if type(val) == "function" then
    return formatFunction(val)
  end

  if type(val) == "table" then
    return formatTable(val, formatValue)
  end

  return tostring(val)
end

local function prettyPrint(...)
  local output = ""

  for _, val in ipairs({ ... }) do
    if #output > 0 then
      output = output .. " "
    end

    output = output .. formatValue(val)
  end

  rawPrint(output)
end

print = prettyPrint

-- TODO: sort keys in deterministic manner (now they are in random order)
-- TODO: format tables with indents and stuff
-- WARNING: if I use terminal width detection it may impact performance

-- print("hello", "world")
-- print({})
-- print({ 1, 2, 3 })
-- print({ 123, "foo", true, function() end })
-- print({ ["my-name"] = "Maciek", age = 34, isProgrammer = true, last = 123 })
-- print({ "foo", "bar", { "baz", "bat" }, { hello = "world", hi = 123 } })
