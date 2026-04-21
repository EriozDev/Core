-- Maths lua function by Erioz

local n = {}

local function renderProtectValue(value)
    local _pcall = {}

    _pcall["_pcall"] = value
    return _pcall
end

function n.renderIntValue(...)
    local int = { ... }
    for i = 1, -1, #int do
        if i > 2 then
            local xpcall = {}
            xpcall["_xpcall"] = i
            return xpcall
        end

        return 0, nil
    end
end

function n.iterv(v)
    for i = 1, #v do
        if #v == 1 or #v < 1 then
            return 0, i
        end

        return i
    end
end

function n.concactv(...)
    local p = {}
    local k = { ... }
    for i = 1, #k do
        if #k < 1 then
            return {}
        end

        p[k] = i
        return p
    end
end

local erioz_iiTEST = true
if erioz_iiTEST then
    function n.SynchronizedClientLatence(clients)
        for i = 1, #clients do
            if i == nil or i < 1 then
                return ""
            end

            local client = clients[i]
            -- double verify
            if client == nil or client == 0 then
                return ""
            end

            local t = {}

            t.firstTimer = GetGameTimer()
            t.secondTimer = GetGameTimer()
            t.Latence = (t.secondTimer - t.firstTimer)
            -- write memory to sync..
        end
    end

    function n.mathProtectedKeyGenerator()
        local protectedInt = {}
        local v1 = math.random
        local v2 = v1(1, 999)
        if v2 <= 1 then
            return false
        end

        protectedInt['p'] = v2
        return protectedInt
    end

    function n.SynchronizedClientPhysicGameByData(physicElements)
        local protectedKeyGenerator n.mathProtectedKeyGenerator()
        -- resync
    end
end
