_ped = {}

local __instance = {
    __index = _ped;
};

function _ped.init()
    local self = {};

    self.playerId = PlayerId()
    self.playerPed = PlayerPedId()
    self.coords = GetEntityCoords(self.playerPed)
    self.heading = GetEntityHeading(self.playerPed)

    setmetatable(self, __instance);
    return self;
end

function _ped:setCoords(x, y, z)
    self.coords = vec3(x, y, z)
    SetEntityCoords(self.playerPed, self.coords)
end

function _ped:setHeading(h)
    self.heading = h
    SetEntityHeading(self.playerPed, self.heading)
end

function _ped:getCoords()
    self.coords = GetEntityCoords(self.playerPed)
    return self.coords
end

function _ped:getHeading()
    self.heading = GetEntityHeading(self.playerPed)
    return self.heading
end

function _ped:setModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    SetPlayerModel(PlayerId(), model)
end

function _ped:spawn(coords, heading)
    Wait(0)
    ShutdownLoadingScreen()
    ResetPausedRenderphases()
    ShutdownLoadingScreenNui()

    local model = "mp_m_freemode_01"
    --self:setModel(model)
    Wait(100)
    local ped = PlayerPedId()
    self.ped = ped
    Logger:debug('LocalPlayer:ped', self.ped)
    --SetPedComponentVariation(ped, 1, 0, 0, 2)

    while not HasPedHeadBlendFinished(PlayerPedId()) or not DoesEntityExist(PlayerPedId()) do
        Wait(0)
    end

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading or 0.0, true, false)

    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
    SetPlayerInvincible(PlayerId(), false)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading or 0.0)
end

function _ped:setClothes(componentId, drawableId, textureId, paletteId)
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end
    SetPedComponentVariation(self.ped, componentId, drawableId, textureId, paletteId or 0)
    return true
end

function _ped:getClothes(componentId)
    if not self.ped or not DoesEntityExist(self.ped) then
        return nil
    end
    local drawable = GetPedDrawableVariation(self.ped, componentId)
    local texture = GetPedTextureVariation(self.ped, componentId)
    local palette = GetPedPaletteVariation(self.ped, componentId)
    return {drawable = drawable, texture = texture, palette = palette}
end

function _ped:saveOutfit()
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end
    local outfit = {}
    for i = 0, 11 do
        outfit[i] = self:getClothes(i)
    end
    self.__var["outfit"] = outfit
    return outfit
end

function _ped:loadOutfit(outfit)
    outfit = outfit or self.__var["outfit"]
    if not outfit then return false end
    for compId, data in pairs(outfit) do
        if data then
            self:setClothes(compId, data.drawable, data.texture, data.palette)
        end
    end
    return true
end

function _ped:applyOutfit(outfit)
    if not outfit then return false end
    for compId, data in pairs(outfit) do
        if data then
            self:setClothes(compId, data.drawable or 0, data.texture or 0, data.palette or 0)
        end
    end
    return true
end

function _ped:setFreezeState(v)
    if type(v) ~= 'boolean' then
        return false;
    end
    self.IsFreeze = v
    FreezeEntityPosition(self.ped, self.IsFreeze)
end

function _ped:setVisible(state, selfVisible)
    if not self.ped or not DoesEntityExist(self.ped) then
        return false
    end

    if state then
        SetEntityVisible(self.ped, true, false)
        SetLocalPlayerVisibleLocally(self.ped, true)
    else
        SetEntityVisible(self.ped, false, false)

        if selfVisible then
            SetLocalPlayerVisibleLocally(self.ped, true)
        else
            SetLocalPlayerVisibleLocally(self.ped, false)
        end
    end

    return true
end


return _ped
