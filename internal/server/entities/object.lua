Entities = {}
Entities.__index = Entities

local registry = {}

function Entities.New(netId, owner, model)
    local self = setmetatable({}, Entities)

    self.netId = netId
    self.owner = owner
    self.model = model
    self.timestamp = os.time()
    self.firstOwner = owner

    registry[netId] = self
    return self
end

function Entities.Get(netId)
    return registry[netId]
end

function Entities.Remove(netId)
    registry[netId] = nil
end

function Entities.All()
    return registry
end

function Entities:GetAge()
    return os.time() - self.timestamp
end

function Entities:GetModel()
    return self.model
end

function Entities:GetOwner()
    return self.owner
end

function Entities:GetFirstOwner()
    return self.firstOwner
end

function Entities:GetNetId()
    return self.netId
end

if Config.DevMod then
    function Entities:Debug()
        Logger:debug(string.format(
            "[Entity %s] Model: %s | Owner: %s | FirstOwner: %s | CreatedAt: %s | Age: %ss",
            self.netId,
            self.model,
            self.owner,
            self.firstOwner,
            os.date("%Y-%m-%d %H:%M:%S", self.timestamp),
            self:GetAge()
        ))
    end
end
