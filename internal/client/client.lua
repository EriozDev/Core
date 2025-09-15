_client = {};

local index = {};

local __instance = {
    __index = _client;
};

function _client.init()
    local self = {};

    self.__var = {}
    self.sessionToken = math.random(1, 9999)
    self.ped = _ped.init()

    index[GetPlayerServerId(PlayerId())] = self
    setmetatable(self, __instance)
    return self;
end

function _client.Get()
    return index[GetPlayerServerId(PlayerId())];
end