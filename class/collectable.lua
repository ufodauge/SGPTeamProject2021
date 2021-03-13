local Collectable = Instance:extend('Collectable')

function Collectable:init()
    Collectable.super:init(self)

    self.physics = world:newRectangleCollider()
    self.physics:setType('static')
end

function Collectable:update(dt)
end

function Collectable:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Collectable:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return Collectable
