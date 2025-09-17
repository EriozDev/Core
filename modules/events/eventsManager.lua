eventsManager = Class:extend()

local IS_SERVER = IsDuplicityVersion()
local listeners = {}

local __instance = {
    __index = eventsManager
}

function eventsManager.GetMetaTable()
    local self = {}
    self.events = {}
    setmetatable(self, __instance)
    return self
end

local function addEventListeners(event)
    if (listeners[event]) then return end
    listeners[event] = true
end

local function removeEventListerners(event)
    if (not listeners[event]) then return false end
    listeners[event] = nil
end

function eventsManager:RegisterEvent(eventName, eventFunction)
    addEventListeners(eventName)
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, eventFunction)
    if (IS_SERVER) then
        TriggerClientEvent("syncListeners", -1, listeners)
    else
        TriggerServerEvent("syncListeners", listeners)
    end
end

function eventsManager:removeEvent(eventName)
    if listeners[eventName] then
        listeners[eventName] = nil
        Logger:debug('Event has been removed from listerners!', eventName)
    end

    if (IS_SERVER) then
        TriggerClientEvent("syncListeners", -1, listeners)
    else
        TriggerServerEvent("syncListeners", listeners)
    end
end

if (IS_SERVER) then
    RegisterNetEvent("syncListeners")
    AddEventHandler("syncListeners", function(clientListeners)
        TriggerClientEvent("core:syncListeners", source, listeners)
    end)

    function eventsManager:toClient(eventName, target, ...)
        Logger:debug("TriggerClientEvent", eventName, "target:", target, "payload:", ...)
        TriggerClientEvent(eventName, target, ...)
    end
else
    RegisterNetEvent("syncListeners")
    AddEventHandler("syncListeners", function(serverListeners)
        listeners = serverListeners
        Logger:debug("Listeners synced from server", json.encode(listeners))
    end)

    function eventsManager:toServer(eventName, ...)
        Logger:debug("TriggerServerEvent", eventName, "payload:", ...)
        TriggerServerEvent(eventName, ...)
    end
end
