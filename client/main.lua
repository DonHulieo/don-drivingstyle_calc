local DrivingStyles = GetDrivingStyles()
local Selected = {}

-------------------------------- FUNCTIONS --------------------------------

---@param tbl table
---@param value any
---@return boolean, number
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

lib.locale()

local function setupStyleOptions()
  local options = {
  {
    label = '0',
    defaultIndex = 1,
    icon = 'car'
  }, {
    label = locale('reset'),
    close = true,
    defaultIndex = 2,
    icon = 'rotate-right',
    args = Selected
  }, {
    label = locale('calculate'),
    close = true,
    defaultIndex = 3,
    icon = 'calculator',
    args = Selected
  }}
  for i = 1, #DrivingStyles - 1 do
    local index = #options + 1
    options[index] = {
      label = locale('df_'..((i < 10 and '0'..i) or i)..'_name'),
      defaultIndex = index,
      description = locale('df_'..((i < 10 and '0'..i) or i)..'_des'),
      checked = false
    }
  end
  return options
end

lib.registerMenu(
  {
    id = 'drivingstyle_calc',
    title = locale('title'),
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
          label = locale('df_'..((i < 10 and '0'..i) or i)..'_name'),
          description = locale('df_'..((i < 10 and '0'..i) or i)..'_des'),
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
        label = locale('df_'..((i < 10 and '0'..i) or i)..'_name'),
        description = locale('df_'..((i < 10 and '0'..i) or i)..'_des'),
        checked = false
      }, Selected[i] + 3)
    end
    if selected == 3 then
      local bits = CalculateBits(Selected)
      if lib.alertDialog({
        header = locale('header'),
        content = locale('content', tostring(bits), tostring(To32Bit(bits)), tostring(ToHex(bits))),
        centered = true,
        cancel = true,
        size = 'md',
        labels = {cancel = locale('discard'), confirm = locale('copy')}
      }) == 'confirm' then
        lib.setClipboard(tostring(bits))
      end
    else
      Wait(0)
      lib.showMenu('drivingstyle_calc')
    end
  end
end)

-------------------------------- NET EVENTS --------------------------------

RegisterNetEvent('don-ds_calc:client:ShowMenu', function() Selected = {}; lib.showMenu('drivingstyle_calc') end)
