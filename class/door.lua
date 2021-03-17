local Door = Class('Door')

function Door:init(x, y, w, h)

    self.x, self.y = x, y
    self.width, self.height = w, h

    self.physics = world:newRectangleCollider(x, y, w, h)
    self.physics:setType('static')
    self.physics:setCollisionClass('Door_Locked')
end

function Door:update(dt)
end

function Door:draw()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end

function Door:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function Door:delete()
    self.physics:destroy()
    self = nil
end

return Door
