local Square = Instance:extend('Square')

function Square:init(x, y)
    Square.super:init(self)

    self.physics = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
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

function Square:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Square:delete()
    self.physics:destroy()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return Square
