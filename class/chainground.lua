local ChainGround = Instance:extend('ChainGround')

function ChainGround:init(verticies, loop)
    ChainGround.super:init(self)

    self.physics = world:newChainCollider(verticies, loop)
    self.physics:setType('static')
end

function ChainGround:update(dt)
end

function ChainGround:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function ChainGround:delete()
    self.physics:destroy()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return ChainGround
