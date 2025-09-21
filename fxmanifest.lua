fx_version 'cerulean'
game 'gta5'

author 'Erioz'
description 'Core'
version '1.0'

shared_scripts {
    'enums/__erz.lua',
    'enums/natives.lua',
    'shared/functions.lua',
    'shared/config.lua',
    'shared/libs/class.lua',
    'shared/libs/thread.lua',
    'shared/libs/logger.lua',
    'modules/events/triggers.lua',
    'modules/events/eventsManager.lua',
    'shared/libs/resources.lua'
}

client_scripts {
    'internal/client/ped.lua',
    'internal/client/client.lua',
    'internal/client/LocalPlayer.lua',
    'modules/admin/client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'internal/server/db.lua',
    'internal/server/initSQL.lua',
    'internal/server/inventory.lua',
    'internal/server/players.lua',
    'internal/server/playerMain.lua',
    'internal/server/entities/object.lua',
    'internal/server/entities/events.lua',
    'modules/admin/server/main.lua',
}