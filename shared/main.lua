local DrivingStyles = LoadResourceFile(GetCurrentResourceName(), 'data/drivingStyleFlagValues.json')
DrivingStyles = DrivingStyles and json.decode(DrivingStyles) or {}

if not DrivingStyles then
  print('Failed to load driving style flag values.')
  return
end

---@return table DrivingStyles
function GetDrivingStyles()
  return DrivingStyles
end

---@param style string
---@return number
function GetStyleIndex(style)
  local index = 0
  for i = 1, #DrivingStyles do
    if DrivingStyles[i].name:lower() == style:lower() then
      index = i
      break
    end
  end
  return index
end

---@param index number
---@param getDesc boolean
---@return string name, string|boolean description
function GetDrivingStyleName(index, getDesc)
  local name, description = 'Unknown', false
  for i = 1, #DrivingStyles do
    if i == index then
      local data = DrivingStyles[i]
      name, description = data.name, getDesc and data.description
    end
  end
  return name, description
end

---@param bits table Array of bits, e.g. {1, 3, 5, 6} = 2^0 + 2^2 + 2^4 + 2^5 = 1 + 4 + 16 + 32 = 53
---@return number
function CalculateBits(bits)
  if not bits or type(bits[1]) ~= 'number' then return 0 end
  local number = 0
  for i = 1, #bits do
    number = number | 2 ^ (bits[i] - 1)
  end
  return number
end

---@param number number
---@return number bits
function To32Bit(number)
  local bits
  for i = 31, 0, -1 do
    local bit = number >> i & 1
    bits = not bits and bit or bits .. bit
  end
  return bits
end

---@param number number
---@return string hex
function ToHex(number)
  local hex = ''
  for i = 7, 0, -1 do
    local nibble = number >> i * 4 & 0xF
    hex = hex .. string.format('%X', nibble)
  end
  return hex
end
