player = {};
PlayerList = {};

local __instance = {
    __index = player,
}

function player.new(id)
    local self = {};

    self.source = id
    self.name = GetPlayerName(id)
    self.identifier = GetPlayerIdentifierByType(id, 'license')
    self.job = 'unemployed'
    self.jobGrade = 0
    self.job2 = 'unemployed2'
    self.jobGrade2 = 0
    self.group = 'user'
    self.character = {
        inventory = inventory.new(),
    }

    PlayerList[self.source] = self
    Logger:debug('PlayerObject create for', self.name)
    setmetatable(self, __instance)
    return self;
end

function player.Get(id)
    return PlayerList[id];
end

function player.GetPlayers()
    local players = {};

    for k, v in pairs(PlayerList) do
        players[k] = v
    end

    return players;
end

local function encodeTable(t)
    return json.encode(t or {})
end

local function decodeTable(s)
    return s and json.decode(s) or {}
end

local database = DB:new('Core')
function player:save()
    Logger:debug('forceSave', self.name)
    local pos = GetEntityCoords(GetPlayerPed(self.source))
    local posData = { x = pos.x, y = pos.y, z = pos.z, heading = GetEntityHeading(GetPlayerPed(self.source)) }
    local inventoryJSON = encodeTable(self.character.inventory:getInventory())

    local existing = database:select("users_character", "license = ?", {self.identifier})
    if #existing == 0 then
        database:insert("users_character", {
            license = self.identifier,
            name = self.name,
            group = self.group,
            job = self.job,
            job_grade = self.jobGrade,
            job2 = self.job2,
            job_grade2 = self.jobGrade2,
            inventory = inventoryJSON,
            position = encodeTable(posData)
        })
    else
        database:update("users_character", {
            name = self.name,
            group = self.group,
            job = self.job,
            job_grade = self.jobGrade,
            job2 = self.job2,
            job_grade2 = self.jobGrade2,
            inventory = inventoryJSON,
            position = encodeTable(posData)
        }, "license = ?", {self.identifier})
    end

end

function player:destroy()
    table.wipe(self)
end

function player:getSource()
    return self.source;
end

function player:getUserName()
    return self.name;
end

function player:getData()
    return self;
end

function player:setGroup(t)
    self.group = t;
end

function player:getJob()
    return self.job;
end

function player:getJobGrade()
    return self.jobGrade;
end

function player:getJob2()
    return self.job2;
end

function player:getJobGrade2()
    return self.jobGrade2;
end

function player:setJob(job, grade)
    self.job = job
    self.jobGrade = grade
end

function player:setJob2(job, grade)
    self.job2 = job
    self.jobGrade2 = grade
end

function player:getGroup()
    return self.group;
end

CreateThread(function()
    while true do
        Wait(10000) -- optimize update
        for _, playerObject in pairs(player.GetPlayers()) do
            playerObject:save()
            Logger:info("Auto-saved player:", playerObject.name)
        end
    end
end)

return player;
