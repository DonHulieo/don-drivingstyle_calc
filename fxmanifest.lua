fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'An In-Game Driving Style Flag Calculator'
version '0.0.1'
lua54 'yes'

shared_scripts {'@ox_lib/init.lua', 'shared/config.lua', 'shared/main.lua'}

client_script 'client/main.lua'

file 'data/drivingStyleFlagValues.json'

ox_libs {'alert', 'clipboard', 'menu'}
