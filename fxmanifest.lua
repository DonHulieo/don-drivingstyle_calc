fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'A FiveM VehicleAI Driving Style Calculator'
version '1.0.1'
url 'https://github.com/DonHulieo/don-drivingstyle_calc'

shared_scripts {'@ox_lib/init.lua', 'shared/config.lua', 'shared/main.lua'}

server_script 'server/main.lua'

client_script 'client/main.lua'

files {'data/drivingStyleFlagValues.json', 'locales/*.json'}

dependency 'ox_lib'

ox_libs {'alert', 'acl', 'clipboard', 'locale', 'menu', 'version'}

lua54 'yes'
