eventsManager = Class:extend()

local listeners = {}

local IS_SERVER = IsDuplicityVersion()
local _RegisterNetEvent = RegisterNetEvent

function eventsManager.RegisterEventOnNet(eventString, eventFn)
    listeners[eventString] = eventFn

    _RegisterNetEvent(eventString)
    AddEventHandler(eventString, eventFn)
    Logger:debug('Event Registered On Net', eventString)
    return true
end

function eventsManager.GetListeners()
    return listeners
end

if IS_SERVER then
    local _TriggerClientEvent = TriggerClientEvent

    function eventsManager.TriggerClient(eventString, target, ...)
        if not eventString then return false end
        _TriggerClientEvent(eventString, target, ...)
        Logger:debug('TriggerClient', eventString, 'to target:', target)
    end
else
    local _TriggerServerEvent = TriggerServerEvent

    function eventsManager.TriggerServer(eventString, ...)
        if not eventString then return false end
        _TriggerServerEvent(eventString, ...)
        Logger:debug('TriggerServer', eventString)
    end
end

return eventsManager
