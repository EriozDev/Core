local database = DB:new("Core")

CreateThread(function()
    database:createTable("users_character", {
        {col = "license", type = "VARCHAR(100) NOT NULL UNIQUE"},
        {col = "name", type = "VARCHAR(64) DEFAULT 'Unknown'"},
        {col = "group_name", type = "VARCHAR(50) DEFAULT 'user'"},
        {col = "job", type = "VARCHAR(50) DEFAULT 'unemployed'"},
        {col = "job_grade", type = "INT DEFAULT 0"},
        {col = "job2", type = "VARCHAR(50) DEFAULT 'unemployed2'"},
        {col = "job_grade2", type = "INT DEFAULT 0"},
        {col = "inventory", type = "LONGTEXT"},
        {col = "position", type = "JSON"},
        {col = "created_at", type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP"},
        {col = "updated_at", type = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"}
    })
end)
