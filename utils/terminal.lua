local function command_exists(cmd)
  local h = io.popen("which " .. cmd)

  if h ~= nil then
    local result = h:read("*all")
    h:close()
    return not (result == "")
  end

  return false
end

local function getTerminalWidth()
  local width = 64
  local realWidth = nil

  if os.getenv("COLUMNS") then
    -- User defined
    realWidth = tonumber(os.getenv("COLUMNS"))

    print("a")
  elseif command_exists("stty") then
    print("b")
    local handle = io.popen("stty size") -- Result is like: "42 80" (height width)

    if handle ~= nil then
      local content = handle:read("*all")
      realWidth = tonumber(string.match(content, "%d+%s(%d+)"))
      handle:close()
    end
  elseif command_exists("tput") then
    local handle = io.popen("tput cols")

    if handle ~= nil then
      realWidth = tonumber(handle:read("*all"))
      handle:close()
    end
  end

  if realWidth ~= nil then
    width = realWidth
  end

  return width
end

print("Columns:", getTerminalWidth())
