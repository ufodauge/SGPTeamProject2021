-- MouseManager = require 'class.mouseManager'
-- mouseManager = MouseManager()

local GUIBlock = Instance:extend('GUIBlock')

function GUIBlock:init()
    self.super:init(self)

    self.x = 200
    self.y = 200
    self.radius = 20

    self.isTouch = false
    self.isClicked = false
    self.isCatched = false
    self.isReleased = false
end

function GUIBlock:update(dt)
    if self.isCatched and love.mouse.isDown(1) then
        self.isCatched = false
        self.isReleased = true
    elseif self.isReleased and not love.mouse.isDown(1) then
        self.isReleased = false
        self:delete()
    elseif self:isTouched() and MouseManager.clickedTimer == 1 and
     not self.isClicked and not self.isCatched and not self.isReleased then
        self.isClicked = true
    elseif self:isTouched() and not love.mouse.isDown(1) and self.isClicked and not self.isReleased then
        self.isClicked = false
        self.isCatched = true
    elseif self.isCatched then
        self.x = MouseManager.x - 5
        self.y = MouseManager.y - 5
    end
end

function GUIBlock:draw()
    --GUIBlock.mouseCoord = MouseManager:getMouseCoord()
    --print('X: ' .. GUIBlock.mouseCoord[1] .. 'Y: ' .. GUIBlock.mouseCoord[2])

    --print('X: ' .. MouseManager.x .. 'Y: ' .. MouseManager.y)

    if self.isClicked then
        love.graphics.print('GUI is Clicked!', 100, 525)
    end
    
    if self:isTouched() then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    
    love.graphics.circle("fill", self.x, self.y, self.radius)

end

function GUIBlock:isTouched()
    return math.pow(MouseManager.x - self.x, 2) + math.pow(MouseManager.y - self.y, 2) <= math.pow(self.radius, 2)
end

function GUIBlock:isClicked()
end

function GUIBlock:delete()
    print('delete!')
    self.super:delete(self)
end

return GUIBlock