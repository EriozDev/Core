Thread = Class:extend()
local threadList = {}
local UID = 0

function Thread.New(uid, fn, options)
    local self = setmetatable({}, { __index = Thread })

    if uid then
        self.threadId = uid
    else
        UID = UID + 1
        self.threadId = UID
    end

    self.fn = fn
    self.state = false
    threadList[self.threadId] = self

    self.loop = options and options.loop or false
    self.interval = options and options.interval or 0
    self.condition = options and options.condition or (function() return true end)

    self:start()

    return self
end

function Thread.Get(id)
    return threadList[id]
end

function Thread:start()
    if self.state then return end
    self.state = true

    Logger:debug('Thread Started !', self.threadId)

    CreateThread(function()
        if self.loop then
            while self.state and self.condition() do
                self.fn(self)
                if self.interval > 0 then
                    Wait(self.interval)
                else
                    Wait(0)
                end
            end
        else
            self.fn(self)
        end
    end)
end

function Thread:stop()
    if not self.state then return end
    self.state = false
    Logger:debug('Thread Stopped !', self.threadId)
end

function Thread.GetThreadList()
    return threadList
end
