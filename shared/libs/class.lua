Class = {}
Class.__index = Class

function Class:new()
    local self = setmetatable({}, Class)
    self._attr_index = 0
    return self
end

function Class:addAttr(value)
    self._attr_index = self._attr_index + 1
    local attr_name = "attr" .. self._attr_index
    self[attr_name] = value
    return attr_name
end

function Class:printAttrs()
    for k, v in pairs(self) do
        if k ~= "_attr_index" then
            print(k, v)
        end
    end
end

function Class:extend()
    local cls = {}
    cls.__index = cls
    setmetatable(cls, {__index = self})
    function cls:new(...)
        local instance = Class.new(self)
        if cls.init then
            Logger:debug('Class initialized !', json.encode(self))
            cls.init(instance, ...)
        end
        return instance
    end
    return cls
end
