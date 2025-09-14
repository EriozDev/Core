local mainTread = Thread.New('mainThread', function(self)
    eventsManager.TriggerServer('playerConnect')
end)

eventsManager.RegisterEventOnNet('playerJoin', function()
    _client.init()
    local client = _client.Get()
    client.ped:spawn(vec3(609.614319, 2800.670166, 41.898567), 90.0)
end)
