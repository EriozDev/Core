if (Config.DevMod) then
    local debugMode = true
    local lastEntity = nil

    local function DrawCross3D(x, y, z, size, r, g, b, a)
        DrawLine(x - size, y, z, x + size, y, z, r, g, b, a)
        DrawLine(x, y - size, z, x, y + size, z, r, g, b, a)
        DrawLine(x, y, z - size, x, y, z + size, r, g, b, a)
    end

    local function DrawEntityDebugInfo(entity)
        if not entity or entity == 0 then return end
        if not DoesEntityExist(entity) then return end

        local etype = GetEntityType(entity)
        if etype == 0 then return end

        local model = GetEntityModel(entity)
        if not model or model == 0 then return end

        local coords = GetEntityCoords(entity)
        local min, max = GetModelDimensions(model)
        local size = vector3(max.x - min.x, max.y - min.y, max.z - min.z)

        DrawCross3D(coords.x, coords.y, coords.z, 0.5, 255, 0, 0, 200)

        SetTextColour(200, 200, 200, 180)
        SetTextScale(0.3, 0.3)
        SetTextFont(0)

        SetDrawOrigin(coords.x, coords.y, coords.z + size.z / 2 + 0.5, 0)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(string.format(
            "Type: %s\nHash: %s\nDim: %.2f, %.2f, %.2f",
            etype, model, size.x, size.y, size.z
        ))
        EndTextCommandDisplayText(0.0, 0.0)
        ClearDrawOrigin()

        SetEntityAlpha(entity, 120, false)
    end

    local function RaycastFromCamera(distance)
        local camRot = GetGameplayCamRot(2)
        local camCoord = GetGameplayCamCoord()

        local direction = vec3(
            -math.sin(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
            math.cos(math.rad(camRot.z)) * math.abs(math.cos(math.rad(camRot.x))),
            math.sin(math.rad(camRot.x))
        )

        local destination = camCoord + (direction * distance)

        local rayHandle = StartShapeTestRay(
            camCoord.x, camCoord.y, camCoord.z,
            destination.x, destination.y, destination.z,
            -1,
            PlayerPedId(),
            0
        )

        local _, hit, endCoords, _, entityHit = GetShapeTestResult(rayHandle)
        if hit == 1 and entityHit ~= 0 and DoesEntityExist(entityHit) then
            return entityHit, endCoords
        end
        return nil, endCoords
    end

    CreateThread(function()
        while true do
            Wait(0)
            if debugMode then
                local entity, coords = RaycastFromCamera(25.0)

                if lastEntity and (entity ~= lastEntity) then
                    if DoesEntityExist(lastEntity) then
                        ResetEntityAlpha(lastEntity)
                    end
                    lastEntity = nil
                end

                if entity and DoesEntityExist(entity) then
                    DrawEntityDebugInfo(entity)
                    lastEntity = entity
                end
            elseif lastEntity then
                if DoesEntityExist(lastEntity) then
                    ResetEntityAlpha(lastEntity)
                end
                lastEntity = nil
            end
        end
    end)
end
