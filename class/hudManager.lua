local HudManager = Class('HudManager')

function HudManager:init()

    self.huds = {}
    self.isDebugDrawEnabled = false
end

function HudManager:update(dt)
    self:manageMouseInfo()

    for name, hud in pairs(self.huds) do
        hud:update(dt)
    end
end

function HudManager:draw()
    love.graphics.setColor(1, 1, 1, 1)

    for name, hud in pairs(self.huds) do
        hud:draw()
        if self.isDebugDrawEnabled then
            hud:debugDraw()
        end
    end
end

function HudManager:setDebugDrawEnabled(bool)
    self.isDebugDrawEnabled = bool
end

function HudManager:manageMouseInfo()
    for name, hud in pairs(self.huds) do
        local x, y, w, h = hud:getHudBox()
        local mx, my = love.mouse.getPosition()
        if mx >= x and mx <= x + w and my >= y and my <= y + h then
            hud:setOnMouseMode(true)
        else
            hud:setOnMouseMode(false)
        end
    end
end

function HudManager:setMouseClickFunction(name, func)
    self.huds[name]:setMouseClickFunction(func)
end

function HudManager:add(name, instance)
    self.huds[name] = instance
end

function HudManager:setImage(name, imagePath)
    assert(self.huds[name], 'There\'s any huds named {1}.', {name})

    local image = love.graphics.newImage(imagePath)
    image:setFilter('nearest', 'nearest')

    self.huds[name]:setImage(image)
end

function HudManager:delete()
    for name, hud in pairs(self.huds) do
        hud:delete()
    end
    self = nil
end

return HudManager
