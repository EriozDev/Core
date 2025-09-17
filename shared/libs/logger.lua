Logger = Class:extend()

local pendingLogs = {}

local function flushLogs()
    for _, log in ipairs(pendingLogs) do
        print(log)
    end
    pendingLogs = {}
end

function Logger:debug(...)
    local msg = '(^2debug^0) ' .. table.concat({...}, " ")
    if CORE_STARTED then
        print(msg)
    else
        table.insert(pendingLogs, msg)
    end
end

function Logger:info(...)
    local msg = '(^5info^0) ' .. table.concat({...}, " ")
    if CORE_STARTED then
        print(msg)
    else
        table.insert(pendingLogs, msg)
    end
end

function Logger:warn(...)
    local msg = '(^3warn^0) ' .. table.concat({...}, " ")
    print(msg)
end

CreateThread(function()
    while not CORE_STARTED do Wait(100) end
    flushLogs()
end)

return Logger
