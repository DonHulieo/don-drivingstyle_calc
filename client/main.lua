local DrivingStyles = GetDrivingStyles()
local Selected = {}

-- TODO: Possibly Make a Locale Folder and Lang files --

local function isValueInTable(tbl, value)
  local index = 0
  local found = false
  for i = 1, #tbl do
    if tbl[i] == value then
      found = true
      index = i
      break
    end
  end
  return found, index
end

local function setupStyleOptions()
  local options = {
  {
    label = '0',
    defaultIndex = 1,
    icon = 'car'
  }, {
    label = 'Reset',
    close = true,
    defaultIndex = 2,
    icon = 'rotate-right',
    args = Selected
  }, {
    label = 'Calculate',
    close = true,
    defaultIndex = 3,
    icon = 'calculator',
    args = Selected
  }}
  for i = 1, #DrivingStyles - 1 do
    local index = #options + 1
    options[index] = {
      label = DrivingStyles[i].name,
      defaultIndex = index,
      description = DrivingStyles[i].description,
      checked = false
    }
  end
  return options
end

lib.registerMenu(
  {
    id = 'drivingstyle_calc',
    title = 'Driving Style Calculator',
    position = 'top-right',
    canClose = true,
    onCheck = function(selected, checked)
      lib.hideMenu(false)
      for i = 1, #DrivingStyles  - 1 do
        local inTable, index = isValueInTable(Selected, i)
        if selected - 3 == i then
          if checked and not inTable then
            Selected[#Selected + 1] = i
            inTable = true
          elseif not checked and inTable then
            table.remove(Selected, index)
            inTable = false
          end
          local bits = Selected and #Selected > 0 and tostring(CalculateBits(Selected)) or '0'
          lib.setMenuOptions('drivingstyle_calc', {label = bits, icon = 'car'}, 1)
        end
        lib.setMenuOptions('drivingstyle_calc', {
          label = DrivingStyles[i].name,
          description = DrivingStyles[i].description,
          checked = inTable
        }, i + 3)
      end
      Wait(0)
      lib.showMenu('drivingstyle_calc')
    end,
    onClose = function()
      Selected = {}
      lib.setMenuOptions('drivingstyle_calc', setupStyleOptions())
    end,
    options = setupStyleOptions()
  }, function(selected)
    if Selected and #Selected > 0 and (selected == 2 or selected == 3) then
      lib.setMenuOptions('drivingstyle_calc', {label = '0', icon = 'car'}, 1)
      for i = 1, #Selected do
        lib.setMenuOptions('drivingstyle_calc', {
          label = DrivingStyles[Selected[i]].name,
          description = DrivingStyles[Selected[i]].description,
          checked = false
        }, Selected[i] + 3)
      end
      if selected == 3 then
        local bits = CalculateBits(Selected)
        if lib.alertDialog({
          header = 'Driving Style Flags',
          content = 'Integer: ' .. bits .. '\n\nBinary: ' .. To32Bit(bits) .. '\n\nHex: 0x' .. ToHex(bits) .. '\n\nCopy to clipboard?',
          centered = true,
          cancel = true,
          size = 'md',
          labels = {cancel = 'Discard', confirm = 'Copy'}
        }) == 'confirm' then
          lib.setClipboard(tostring(bits))
        end
      else
        Wait(0)
        lib.showMenu('drivingstyle_calc')
      end
    end
end)

RegisterCommand('calc', function()
  lib.showMenu('drivingstyle_calc')
end)
