fx_version 'cerulean'
game 'gta5'

author 'Erioz'
description 'Core'
version '1.0'

shared_scripts {
    'shared/config.lua',
    'shared/libs/class.lua',
    'shared/libs/thread.lua',
    'shared/libs/logger.lua',
    'modules/events/triggers.lua'
}

client_scripts {
    'internal/client/ped.lua',
    'internal/client/client.lua',
    'internal/client/LocalPlayer.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'internal/server/db.lua',
    'internal/server/initSQL.lua',
    'internal/server/playerMain.lua',
    'internal/server/entities/object.lua',
    'internal/server/entities/events.lua',
}