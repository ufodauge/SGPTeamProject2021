local Trianlge = Class('Trianlge')

-- x, y ともに　中心座標
function Trianlge:init(x, y, rad)
    local radius = TRIANGLE_EDGE_LENGTH - TRIANGLE_EDGE_LENGTH / (2 * math.sqrt(3))
    self.vertices = {}

    for i = 1, 3 do
        self.vertices[i * 2 - 1] = radius * math.cos(rad + math.pi * (i - 1) * 2 / 3) + x
        self.vertices[i * 2] = radius * math.sin(rad + math.pi * (i - 1) * 2 / 3) + y
    end

    self.physics = world:newChainCollider(self.vertices, true)
    self.physics:setType('dynamic')
    self.physics:setCollisionClass('Collectable')
end

function Trianlge:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
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

    if self.image then
        local x, y = self.physics:getPosition()
        local r = self.physics:getAngle()

        love.graphics.draw(self.image, x, y, r, 1, 1, TRIANGLE_WIDTH / 2, TRIANGLE_HEIGHT / 2)
    end

    local x, y = self.physics:getPosition()
    love.graphics.polygon('fill', self.vertices)
end

function Trianlge:delete()
    self.physics:destroy()
    self = nil
end

return Trianlge
