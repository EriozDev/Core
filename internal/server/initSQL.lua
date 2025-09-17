local database = DB:new("ERZ")

CreateThread(function()
    database:createTable("users", {
        {col = "name", type = "VARCHAR(64)"},
        {col = "license", type = "VARCHAR(64) NOT NULL UNIQUE"},
        {col = "steam", type = "VARCHAR(64)"},
        {col = "fivem", type = "VARCHAR(64)"},
        {col = "discord", type = "VARCHAR(64)"},
        {col = "xbox", type = "VARCHAR(64)"},
        {col = "live", type = "VARCHAR(64)"},
        {col = "ip", type = "VARCHAR(64)"},
        {col = "hwids", type = "TEXT"},
        {col = "last_updated", type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"}
    })
end)

CreateThread(function()
    database:createTable("users_character", {
        {col = "license", type = "VARCHAR(64) NOT NULL UNIQUE"},
        {col = "name", type = "VARCHAR(64)"},
        {col = "group", type = "VARCHAR(32) DEFAULT 'user'"},
        {col = "job", type = "VARCHAR(32) DEFAULT 'unemployed'"},
        {col = "job_grade", type = "INT DEFAULT 0"},
        {col = "job2", type = "VARCHAR(32) DEFAULT 'unemployed2'"},
        {col = "job_grade2", type = "INT DEFAULT 0"},
        {col = "inventory", type = "TEXT"},
        {col = "position", type = "TEXT"},
        {col = "last_updated", type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"}
    })
end)



