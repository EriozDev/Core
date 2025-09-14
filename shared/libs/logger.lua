Logger = Class:extend()

function Logger:debug(...)
    return print('(^2debug^0) ', ...)
end

function Logger:info(...)
    return print('(^5info^0) ', ...)
end

function Logger:warn(...)
    return print('(^3warn^0) ', ...)
end

return Logger;
