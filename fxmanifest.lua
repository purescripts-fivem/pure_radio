fx_version 'cerulean'

description 'pure_radio'
author 'purescripts.net'
version '1.0.0'

lua54 'yes'

game 'gta5'

ui_page 'web/build/index.html'

client_scripts {
  '@qbx_core/modules/playerdata.lua', -- ENABLE IF USING QBOX
  'client/**/*',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua', -- for oxmysql
  'server/**/*',
}

shared_scripts {
  '@ox_lib/init.lua', -- for oxlib
  'shared_functions.lua',
  'locales/locale.lua',
  'locales/translations/*.lua',
  'config/*.lua'
}

files {
	'web/build/index.html',
	'web/build/**/*',
}