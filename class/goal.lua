local Goal = Instance:extend('Goal')

function Goal:init(x, y)
    Goal.super:init(self)

    self.physics = world:newRectangleCollider(x, y, GOAL_WIDTH, GOAL_HEIGHT)
    self.physics:setType('static')
    self.physics:setCollisionClass('Goal')
end

function Goal:update(dt)

end

function Goal:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Goal:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return Goal
