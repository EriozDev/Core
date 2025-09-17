Core = {}

CORE_STARTED = false

local IS_SERVER = IsDuplicityVersion();

function Core.SetCoreState(state)
    if type(state) ~= 'boolean' then return false; end
    if (IS_SERVER) then
        CORE_STARTED = state;
        TriggerClientEvent('updateCoreState', -1, state)
    end
end

if (not IS_SERVER) then
    RegisterNetEvent('updateCoreState', function(state) CORE_STARTED = state; end)
end

local Callbacks = {}
local pendingCallbacks = {}
local callbackId = 0

if (IS_SERVER) then
    function RegisterServerCallback(name, fn)
        Callbacks[name] = fn
    end

    RegisterNetEvent('triggerServerCallback')
    AddEventHandler('triggerServerCallback', function(name, cbId, ...)
        local src = source
        local args = {...}
        if Callbacks[name] then
            local result = Callbacks[name](src, table.unpack(args))
            TriggerClientEvent('serverCallback', src, cbId, result)
        else
            TriggerClientEvent('serverCallback', src, cbId, nil)
        end
    end)
else
    function TriggerServerCallback(name, fn, ...)
        callbackId = callbackId + 1
        pendingCallbacks[callbackId] = fn
        TriggerServerEvent('triggerServerCallback', name, callbackId, ...)
    end

    RegisterNetEvent('serverCallback')
    AddEventHandler('serverCallback', function(cbId, result)
        if pendingCallbacks[cbId] then
            pendingCallbacks[cbId](result)
            pendingCallbacks[cbId] = nil
        end
    end)
end
