-- compatibility wrapper
fx_version 'adamant'
game 'gta5'

description 'Lenzh Chop Shop'
author 'Lenzh'
version 'v2'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/*',

	'config.lua',
	'server/*',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*',

	'config.lua',
	'client/*',
}
