fx_version 'cerulean'
game 'gta5'
author 'AnishBplayz #4854'
description 'Paycheck System to replace QBCore Paycheck system, saves in database'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'	
}

lua54 'yes'