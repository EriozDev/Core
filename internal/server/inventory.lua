inventory = {};

local __instance = {
    __index = inventory,
}

function inventory.new()
    local self = {};

    self.items = {};

    setmetatable(self, __instance)
    return self;
end

function inventory.DoesItemExist(itemName)
    local pattern = false

    for _, items in pairs(Config.Items) do
        if items.name == itemName then
            pattern = true
        else
            pattern = false
        end
    end

    return pattern
end

function inventory:getInventory()
    return self.items;
end

function inventory:addItem(itemName, quantity)
    self.items[itemName] = quantity;
end

function inventory:hasItem(itemName)
    local pattern = false
    for k, v in pairs(self.items) do
        if (k == itemName) then
            pattern = true
        else
            pattern = false
        end
    end

    return pattern
end

function inventory:getItemQuantity(itemName)
    if self:hasItem(itemName) then
        local itemQuantity = self.items[itemName]
        if (itemQuantity) then
            return itemQuantity;
        end
    else
        return 0
    end
end

function inventory:removeItem(itemName, quantity)
    if (quantity) then
        local currentItemQuantity = self:getItemQuantity(itemName)
        local raw = (currentItemQuantity - quantity)
        if raw < 0 then
            self.items[itemName] = nil
        else
            self.items[itemName] = raw
        end
    end
end

function inventory:getWeapons()
    local weaponList = {};
    for _, items in pairs(self.items) do
        if items.type == 'weapon' then
            weaponList[items.name] = true
        end
    end

    return weaponList;
end

return inventory;
