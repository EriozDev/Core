Resources = Class:extend();
ResourcesList = {};

local eventsManager = eventsManager.GetMetaTable()

local IS_SERVER = IsDuplicityVersion();

local __instance = {
    __index = Resources;
};

function Resources.New(name)
    local self = {};

    self.name = name;
    self.author = 'author';
    self.version = '1.0.0';
    self.state = 'stopped'
    self.__var = {}

    setmetatable(self, __instance)
    ResourcesList[name] = self
    Logger:debug('Module has been register!', name)
    return self;
end

function Resources.Get(name)
    assert(type(name), 'Resource.Name need a string!')

    local module = ResourcesList[name]
    if (not module) then
        Logger:warn('Module not found, ', name)
        return false;
    end

    return module;
end

function Resources.GetList()
    local modules = {};

    for k, v in pairs(ResourcesList) do
        modules[k] = v
    end

    return modules;
end

function Resources.Register(name)
    assert(type(name), 'Resource.Name need a string!')

    if ResourcesList[name] then
        Logger:warn('Resource already exist, ', name)
        return false;
    end

    local module = Resources.New(name)

    return module;
end

function Resources:start()
    if (self.state == 'started') then return end

    CreateThread(function()
        while self.state == 'stopped' do
            Wait(0)
        end

        Logger:debug('Resource ', self.name, 'has been started!')
        self.state = 'started';
    end)
    return self;
end

function Resources:stop()
    if (self.state == 'stopped') then return end

    CreateThread(function()
        while self.state == 'started' do
            Wait(0)
        end

        Logger:debug('Resource ', self.name, 'has been stopped!')
        self.state = 'stopped';
    end)
    return self;
end

function Resources:set(k, v)
    self.__var[k] = v
end

function Resources:get(k)
    return self.__var[k]
end

function Resources:CFG(table)
    if (not table) then
        return self.__var['CFG'];
    end

    self:set('CFG', table)
end

if (IS_SERVER) then
    function Resources:toClient(eventName, target, ...)
        eventsManager:toClient(eventName, target, ...)
    end
end

function Resources:toServer(eventName, ...)
    eventsManager:toServer(eventName, ...)
end

function Resources:Thread(fn)
    if (not fn) then
        Logger:warn('Resources.Thread need fn!')
        return false;
    end

    Citizen.CreateThread(fn)
end

if (Config.DevMod) then
    function Resources:debug()
        Logger:debug(json.encode(self))
    end
end
