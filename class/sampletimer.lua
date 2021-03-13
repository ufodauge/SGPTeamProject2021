local SampleTimer = Instance:extend('SampleTimer')

function SampleTimer:init()
    SampleTimer.super:init(self)

    self.time = 0
    self.started = false

    self.text = {
        mm = ('%02d'):format(math.floor(self.time / 60)),
        ss = ('%02d'):format(math.floor(self.time)),
        ml = ('%02d'):format(math.floor(self.time - math.floor(self.time)) * 100)
    }

    self.keyManager = KeyManager()
    self.keyManager:register(
        {
            {
                key = 'z',
                func = function()
                    self.started = not self.started
                end,
                rep = false,
                act = 'pressed'
            },
            {
                key = 'x',
                func = function()
                    self.time = 0
                end,
                rep = true,
                act = 'pressed'
            }
        }
    )
end

function SampleTimer:update(dt)
    self.keyManager:update(dt)

    self.text = {
        mm = ('%02d'):format(math.floor(self.time / 60)),
        ss = ('%02d'):format(math.floor(self.time) % 60),
        ml = ('%02d'):format(math.floor((self.time - math.floor(self.time)) * 100))
    }

    if self.started then
        self.time = self.time + dt
    end
end

function SampleTimer:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('TIME: ' .. self:getText(), 200, 200)
end

function SampleTimer:getText()
    return self.text.mm .. ':' .. self.text.ss .. '.' .. self.text.ml
end

function SampleTimer:toggle()
    self.started = not self.started
end

function SampleTimer:delete()
    self.super:delete(self)
end

return SampleTimer
