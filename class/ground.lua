local Ground = Instance:extend('Ground')

function Ground:init(x, y, w, h)
    Ground.super:init(self)

    self.physics = world:newRectangleCollider(x, y, w, h)
    self.physics:setType('static')
end

function Ground:update(dt)
end

function Ground:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Ground:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return Ground
