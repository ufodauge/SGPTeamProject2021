local Goal = Class('Goal')

function Goal:init(x, y)

    self.physics = world:newRectangleCollider(x, y, GOAL_WIDTH, GOAL_HEIGHT)
    self.physics:setType('static')
    self.physics:setCollisionClass('Goal')
end

function Goal:update(dt)

end

function Goal:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.image then
        local x, y = self.physics:getPosition()
        love.graphics.draw(self.image, x - GOAL_WIDTH / 2, y - GOAL_HEIGHT / 2)
    end
end

function Goal:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function Goal:delete()
    self.physics:destroy()
    self = nil
end

return Goal
