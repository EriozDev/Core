CreateThread(function()
    Core.SetCoreState(true)
    Logger:info('Core Started!')
    Logger:info('Creators: ', table.unpack(Config.Credit))
end)

RegisterNetEvent('playerConnect', function()
    local source = source;
    player.new(source)
    TriggerClientEvent('playerJoin', source)
    Logger:info('Player Joined ', GetPlayerName(source), source)
end)

local database = DB:new('Core')

RegisterServerCallback('getSavedPosition', function(src)
    local license = GetPlayerIdentifierByType(src, 'license')
    local result = database:select('users_character', 'license = ?', { license })

    if result[1] and result[1].position then
        local posData = json.decode(result[1].position)
        return posData
    end

    return { x = 609.614319, y = 2800.670166, z = 41.898567, heading = 90.0 }
end)

AddEventHandler('playerDropped', function(_REASON)
    local source = source;
    local player = player.Get(source);
    if (not player) then
        return false;
    end

    player:save()
    player:destroy()
end)

local function GetPlayerIdentifiersData(src)
    local identifiers = {
        license = "N/A",
        steam = "N/A",
        fivem = "N/A",
        discord = "N/A",
        xbox = "N/A",
        live = "N/A",
        ip = GetPlayerEndpoint(src) or "N/A",
        hwids = {}
    }

    for _, id in pairs(GetPlayerIdentifiers(src)) do
        if id:find("license:") then
            identifiers.license = id
        elseif id:find("steam:") then
            identifiers.steam = id
        elseif id:find("fivem:") then
            identifiers.fivem = id
        elseif id:find("discord:") then
            identifiers.discord = id
        elseif id:find("xbl:") then
            identifiers.xbox = id
        elseif id:find("live:") then
            identifiers.live = id
        end
    end

    local tokens = {}
    for i = 0, GetNumPlayerTokens(src) - 1 do
        table.insert(tokens, GetPlayerToken(src, i))
    end
    identifiers.hwids = tokens

    return identifiers
end

local database = DB:new("Core")

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiersData(src)
    deferrals.defer()
    deferrals.update("Vérification de vos informations...")

    local result = database:select("users", "license = ?", { identifiers.license })

    local data = {
        name = name,
        steam = identifiers.steam,
        fivem = identifiers.fivem,
        discord = identifiers.discord,
        xbox = identifiers.xbox,
        live = identifiers.live,
        ip = identifiers.ip,
        hwids = json.encode(identifiers.hwids)
    }

    if result and result[1] then
        database:update("users", data, "license = ?", { identifiers.license })
    else
        data.license = identifiers.license
        database:insert("users", data)
    end

    deferrals.done()
end)

RegisterCommand('playerlist', function(src, args)
    local players = player.GetPlayers()
    for _, p in pairs(players) do
        print(p.name)
    end
end)

AddEventHandler('onResourceStop', function(_RESOURCE)
    if _RESOURCE == 'Core' then
        local players = player.GetPlayers()
        for _, p in pairs(players) do
            p:save()
        end
    end
end)


