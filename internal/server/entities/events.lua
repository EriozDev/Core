AddEventHandler('entityCreating', function(entity)
    local owner = NetworkGetEntityOwner(entity)
    if not owner or not entity then return end

    if GetEntityType(entity) == 1 and not IsPedAPlayer(entity) then
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)
    local model = GetEntityModel(entity)

    local ent = Entities.New(netId, owner, model)
    Logger:debug(
        'Nouvelle entité trackée',
        'NetID:', ent:GetNetId(),
        'Owner:', ent:GetOwner(),
        'Model:', ent:GetModel()
    )
end)

AddEventHandler('entityRemoved', function(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if netId and Entities.Get(netId) then
        Entities.Remove(netId)
        Logger:debug('Entité supprimée -> NetID:', netId)
    end
end)
