fx_version 'cerulean'

game 'gta5'
description 'mmission test'
version '1.0.0'

shared_script 'shared.lua'
server_scripts {
    'server/util.lua',
    'server/server.lua'
}
client_scripts {
    'client/util.lua',
    'client/client.lua'
}