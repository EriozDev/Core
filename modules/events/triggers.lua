local v1 = IsDuplicityVersion()
local v2 = {}
local function v3(l)
    local c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local t = ''
    math.randomseed(os.time() + math.random(1000))
    for i = 1, (l or 6) do
        local r = math.random(1, #c)
        t = t .. c:sub(r,r)
    end
    return t
end

local v4 = {
    ["gameEventTriggered"]=true, ["onClientResourceStart"]=true, ["onClientResourceStop"]=true,
    ["onResourceStart"]=true, ["onResourceStarting"]=true, ["onResourceStop"]=true,
    ["playerConnecting"]=true, ["playerDropped"]=true, ["populationPedCreating"]=true,
    ["rconCommand"]=true, ["entityCreated"]=true, ["entityCreating"]=true, ["entityRemoved"]=true,
    ["onResourceListRefresh"]=true, ["onServerResourceStart"]=true, ["onServerResourceStop"]=true,
    ["playerEnteredScope"]=true, ["playerJoining"]=true, ["onPlayerJoining"]=true,
    ["playerLeftScope"]=true, ["ptFxEvent"]=true, ["removeAllWeaponsEvent"]=true,
    ["startProjectileEvent"]=true, ["weaponDamageEvent"]=true, ["CEventName"]=true,
    ["entityDamaged"]=true, ["mumbleConnected"]=true, ["mumbleDisconnected"]=true,
    ["__cfx_nui:exit"]=true, ["__cfx_internal:commandFallback"]=true,
    ["giveWeaponEvent"]=true, ["RemoveWeaponEvent"]=true, ["explosionEvent"]=true,
    ["onPlayerDropped"]=true, ["fireEvent"]=true, ["vehicleComponentControlEvent"]=true,
    ["playerConnect"]=true
}

if v1 then
    local _RNE, _AEH = RegisterNetEvent, AddEventHandler

    RegisterNetEvent = function(e,f)
        if v4[e] or e:find('__cfx') then return _RNE(e,f) end
        if not v2[e] then
            local h = string.format('core:%s', GetHashKey(e))
            local tk = v3(6)
            v2[e] = {c=h, t=tk}
            Logger:debug('Event secure:', e, 'Token:', tk, 'Crypted:', h)
            return _RNE(h, function(...)
                local s = source
                local ent = v2[e]
                if not ent or not ent.t then
                    Logger:warn('Token invalide pour', e, 'src:', s)
                    DropPlayer(s,"Trigger détecté : token invalide [Anti-Trigger]")
                    return
                end

                ent.t = v3(6)
                Logger:debug('New token generated for event:', e, 'Token:', ent.t)

                f(s, ...)
            end)
        end
        Logger:debug('Event already secure:', e)
    end

    AddEventHandler = function(e,f)
        if v2[e] then
            return _AEH(v2[e].c,f)
        end
        return _AEH(e,f)
    end

    CreateThread(function()
        while true do
            Wait(5000)
            TriggerClientEvent('core:2398273973', -1, v2)
        end
    end)

else
    local v5 = {}
    local _TSE = TriggerServerEvent

    TriggerServerEvent = function(e,...)
        local t = v5[e]
        if t then
            Logger:debug('TriggerServer: ', t.c)
            return _TSE(t.c, t.t, ...)
        else
            return _TSE(e,...)
        end
    end

    RegisterNetEvent('core:2398273973')
    AddEventHandler('core:2398273973', function(t) v5=t end)
end
