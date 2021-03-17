local Ground = Class('Ground')

function Ground:init(x, y, w, h)

    self.x, self.y = x, y
    self.width, self.height = w, h

    self.physics = world:newRectangleCollider(x, y, w, h)
    self.physics:setType('static')
    self.physics:setCollisionClass('Ground')
end

function Ground:update(dt)
end

function Ground:draw()
    love.graphics.setColor(0.4, 0.4, 0.4, 1)

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ground:delete()
    self.physics:destroy()
    self = nil
end

return Ground
