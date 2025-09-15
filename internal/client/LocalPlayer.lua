local mainTread = Thread.New('mainThread', function(self)
    TriggerServerEvent('playerConnect')
end)

RegisterNetEvent('playerJoin', function()
    _client.init()
    local client = _client.Get()
    client.ped:spawn(vec3(609.614319, 2800.670166, 41.898567), 90.0)
end)

if Config.DevMod then
    RegisterCommand("crun", function(source, args, rawCommand)
        local code = table.concat(args, " ")

        if code == nil or code == "" then
            print("^1Erreur:^7 Aucun code fourni.")
            return
        end

        local func, err = load(code)
        if not func then
            return
        end

        local success, result = pcall(func)
        if not success then
        else
            if Config.DevMod then
                print('(^6EXTERNAL^0) (^2LOADED^0) ', code)
            end
        end
    end, false)
end
