local Respawn = Class('Respawn')

function Respawn:init(x, y, w, h)

    self.x, self.y = x, y
    self.width, self.height = w, h

    self.physics = world:newRectangleCollider(x, y, w, h)
    self.physics:setType('static')
    self.physics:setCollisionClass('Respawn')
end

function Respawn:update(dt)
    if self.physics:enter('Player') then
        States.Levels:transitionLevel(States.Levels:getCurrentLevelIndex())
    end
end

function Respawn:draw()
    love.graphics.setColor(0.4, 0.4, 0.4, 1)

    local x, y = self.physics:getPosition()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Respawn:delete()
    self.physics:destroy()
    self = nil
end

return Respawn
