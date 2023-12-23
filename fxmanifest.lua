fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'A FiveM VehicleAI Driving Style Calculator'
version '0.0.1'
url ''

shared_scripts {'@ox_lib/init.lua', 'shared/config.lua', 'shared/main.lua'}

client_script 'client/main.lua'

file 'data/drivingStyleFlagValues.json'

ox_libs {'alert', 'clipboard', 'menu'}

lua54 'yes'
