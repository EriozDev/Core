__erz = {}

function __erz.eachValue(tbl)
    local i = 0
    local n = #tbl
    return function()
        i = i + 1
        if i <= n then
            return tbl[i]
        end
    end
end

if (IS_SERVER) then
    local function raw()
        return function(tbl, name)
            tbl.__erz = name or "instance"
            return setmetatable(tbl, {
                __tostring = function(t)
                    return "__erz: " .. t.__erz
                end
            })
        end
    end

    __x {
        __internal = raw()
    }

    function __x.create(name)
        return __x.__internal({}, name)
    end
end
