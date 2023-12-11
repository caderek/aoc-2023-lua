local math = {}

function math.gcd(m, n)
  while n ~= 0 do
    local q = m
    m = n
    n = q % n
  end

  return m
end

function math.lcm(m, n)
  return (m ~= 0 and n ~= 0) and m * n / math.gcd(m, n) or 0
end

function math.sum(list)
  local result = 0

  for _, item in ipairs(list) do
    result = result + item
  end

  return result
end

function math.average(list)
  return math.sum(list) / #list
end

return math
