local Square = Class('Square')

function Square:init(x, y)

    self.physics = world:newRectangleCollider(x, y, SQUARE_WIDTH, SQUARE_HEIGHT)
    self.physics:setType('dynamic')
    self.physics:setCollisionClass('Collectable')
end

function Square:update(dt)
    if self.physics:enter('Player') then
        self.physics:setPosition(800, 1000)
        self.physics:setType('static')
        self.physics:setCollisionClass('Removed')
        infomationManager:addCollectable('square')
    end
end

function Square:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function Square:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.image then
        local x, y = self.physics:getPosition()
        local r = self.physics:getAngle()

        love.graphics.draw(self.image, x, y, r, 1, 1, SQUARE_WIDTH / 2, SQUARE_HEIGHT / 2)
    end
end

function Square:delete()
    self.physics:destroy()
    self = nil
end

return Square
