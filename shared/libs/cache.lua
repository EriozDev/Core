Cache = {};

local IS_SERVER = IsDuplicityVersion();

if (IS_SERVER) then
    local onlyIndex = {};

    local __instance = {
        __index = Cache,
    }

    function Cache.new()
        local self = setmetatable({}, __instance);

        self.mainInt = {}
        self.secondInt = {}

        onlyIndex['cache'] = self
        return self;
    end

    function Cache.getServerCache()
        return onlyIndex['cache']
    end

    function Cache:set(k, v, pattern)
        if type(pattern) ~= 'number' then return false end
        if pattern == 1 then
            self.mainInt[k] = v
        elseif pattern == 2 then
            self.secondInt[k] = v
        end
    end

    function Cache:get(k)
        if self.mainInt[k] ~= nil then
            return self.mainInt[k]
        end

        if self.secondInt[k] ~= nil then
            return self.secondInt[k]
        end
    end

    function Cache:getInt(k)
        if self.mainInt[k] ~= nil then
            return 1
        end

        if self.secondInt[k] ~= nil then
            return 2
        end
    end

    function Cache:getGlobalMainCache()
        return self.mainInt
    end

    function Cache:getGlobalSecondCache()
        return self.secondInt
    end

    function Cache:resetMainCache()
        self.mainInt = {}
    end

    function Cache:resetSecondCache()
        self.secondInt = {}
    end
end

--TODO: sync to clients