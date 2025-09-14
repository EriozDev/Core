---@class DB
DB = {}
DB.__index = DB

---@param name string
function DB:new(name)
    local self = setmetatable({}, DB)
    self.name = name or "default"
    return self
end

---@param tableName string
---@param columns table
function DB:createTable(tableName, columns)
    local query = ("CREATE TABLE IF NOT EXISTS `%s` (id INT AUTO_INCREMENT PRIMARY KEY, "):format(tableName)

    local defs = {}
    for _, col in ipairs(columns) do
        table.insert(defs, ("`%s` %s"):format(col.col, col.type))
    end

    query = query .. table.concat(defs, ", ") .. ")"
    Logger:info('DB - Table create: ', tableName)
    MySQL.query.await(query)
end

---@param tableName string
---@param data table
function DB:insert(tableName, data)
    local cols, vals, placeholders = {}, {}, {}

    for col, val in pairs(data) do
        table.insert(cols, "`" .. col .. "`")
        table.insert(vals, val)
        table.insert(placeholders, "?")
    end

    local query = ("INSERT INTO `%s` (%s) VALUES (%s)"):format(
        tableName,
        table.concat(cols, ", "),
        table.concat(placeholders, ", ")
    )

    Logger:info('DB - Query insert: ', tableName)
    MySQL.insert.await(query, vals)
end

---@param tableName string
---@param data table
---@param where string
---@param params table
function DB:update(tableName, data, where, params)
    local sets, vals = {}, {}

    for col, val in pairs(data) do
        table.insert(sets, ("`%s` = ?"):format(col))
        table.insert(vals, val)
    end

    local query = ("UPDATE `%s` SET %s WHERE %s"):format(tableName, table.concat(sets, ", "), where)

    for _, v in ipairs(params or {}) do
        table.insert(vals, v)
    end

    Logger:info('DB - Query update: ', tableName)
    MySQL.update.await(query, vals)
end

---@param tableName string
---@param where string|nil
---@param params table|nil
---@return table
function DB:select(tableName, where, params)
    local query = ("SELECT * FROM `%s`"):format(tableName)
    if where then
        query = query .. " WHERE " .. where
    end

    Logger:info('DB - Query select: ', tableName)
    return MySQL.query.await(query, params or {})
end
