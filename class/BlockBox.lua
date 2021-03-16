local BlockBox = Instance:extend('BlockBox')

blockTypeList = {}
blockTypeList['empty'] = 'empty'
blockTypeList['circle'] = 'circle'

function BlockBox:init()
    self.super:init(self)

    self.x = 400
    self.y = 300

    self.width = 30
    self.height = 30

    self.state = 'neutral'

    self.blocktype = blockTypeList['circle']
end

function BlockBox:enter()
end

function BlockBox:update(dt)
   if self.state == 'clicked' and not love.mouse.isDown(1) and self:isTouched() then
    self.state = 'neutral'
    self:getBlock()
   elseif self.state == 'neutral' and love.mouse.isDown(1) and self:isTouched() then
    self.state = 'clicked'
   end

end

function BlockBox:draw()
    self:drawBox()
end

function BlockBox:drawBox()
    
    if self:isTouched() then
        love.graphics.setColor(0, 0.7, 0, 0.5)
    else
        love.graphics.setColor(1, 0.7, 0, 1)
    end
    
    love.graphics.line(
        self.x - self.width, self.y - self.height,
        self.x + self.width, self.y - self.height,
        self.x + self.width, self.y + self.height,
        self.x - self.width, self.y + self.height,
        self.x - self.width, self.y - self.height
    )
    love.graphics.circle("line", self.x, self.y, self.width)
end

function BlockBox:isTouched()
    return  (self.x - self.width) <= MouseManager.x and
            (self.x + self.width) >= MouseManager.x and
            (self.y - self.height) <= MouseManager.y and
            (self.y + self.height) >= MouseManager.y 
end

function BlockBox:isClicked()
    return self:isTouched() and MouseManager.clickedTimer == 1
end

function BlockBox:getBlock()
    PlayerCreationGUI.catchedItem = self.blocktype
end

function BlockBox:delete()
    self.super:delete(self)
end

return BlockBox
