fx_version 'cerulean'
game 'gta5'

shared_script {
  "@ox_lib/init.lua",
  'config.lua'
}

client_scripts {
  'client.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server.lua'
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
}

dependency 'voip'

lua54 'yes'
