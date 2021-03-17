local BlackBox = Instance:extend('BlackBox')

function BlackBox:init()
    BlackBox.super:init(self)
end

function BlackBox:update(dt)
end

function BlackBox:draw()
    love.graphics.setColor(0.1, 0.1, 0.1, 0.7)
    love.graphics.rectangle('fill', 0, 0, SYS_WIDTH, SYS_HEIGHT)
end

function BlackBox:delete()
    self.super.delete(self)
end

return BlackBox
