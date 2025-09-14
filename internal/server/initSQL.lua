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
