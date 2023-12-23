-------------------------------- FUNCTIONS --------------------------------

---@param resource string Resource name
local function initScript(resource)
  if resource ~= GetCurrentResourceName() then return end
  lib.versionCheck('donhulieo/'..resource)
  lib.locale()
  lib.addCommand(Config.Command, {help = locale('help'), restricted = Config.UserLevel}, function(src)
    TriggerClientEvent('don-ds_calc:client:ShowMenu', src)
  end)
end

-------------------------------- HANDLERS --------------------------------

AddEventHandler('onResourceStart', initScript)
