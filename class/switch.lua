local Switch = Class('Switch')

function Switch:init(x, y, w, h)
    self.x, self.y = x, y
    self.width, self.height = w, h

    self.physics = world:newRectangleCollider(x, y, w, h)
    self.physics:setType('static')
    self.physics:setCollisionClass('Switch')
end

function Switch:update(dt)
    if self.physics:enter('Player') then
        door:delete()
    end
end

function Goal:draw()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Goal:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function Switch:delete()
    self.physics:destroy()
    self = nil
end

return Switch
