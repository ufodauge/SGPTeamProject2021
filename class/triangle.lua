local Trianlge = Instance:extend('Trianlge')

-- x, y ともに　中心座標
function Trianlge:init(x, y, rad)
    Trianlge.super:init(self)
    local radius = TRIANGLE_EDGE_LENGTH - TRIANGLE_EDGE_LENGTH / (2 * math.sqrt(3))
    local vertices = {}

    for i = 1, 3 do
        vertices[i * 2 - 1] = radius * math.cos(rad + math.pi * (i - 1) * 2 / 3) + x
        vertices[i * 2] = radius * math.sin(rad + math.pi * (i - 1) * 2 / 3) + y
    end

    self.physics = world:newChainCollider(vertices, true)
    self.physics:setType('dynamic')
    self.physics:setCollisionClass('Collectable')
end

function Trianlge:update(dt)
    if self.physics:enter('Player') then
        self.physics:setPosition(800, 1000)
        self.physics:setType('static')
        self.physics:setCollisionClass('Removed')
        infomationManager:addCollectable('square')
    end
end

function Trianlge:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Trianlge:delete()
    self.physics:destroy()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return Trianlge
