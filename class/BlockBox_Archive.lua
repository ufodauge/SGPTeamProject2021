local BlockBox = Class('BlockBox')

BlockTypeList = {}
BlockTypeList['empty'] = 'empty'
BlockTypeList['circle'] = 'circle'
BlockTypeList['triangle'] = 'triangle'
BlockTypeList['square'] = 'square'

BlockBox.font = {}
BlockBox.font.pixel10R = love.graphics.newFont('resource/PixelMplus10-Regular.ttf')
BlockBox.font.pixel12B = love.graphics.newFont('resource/PixelMplus12-Bold.ttf')

BlockBox.image = {}
BlockBox.image.neutralButton = love.graphics.newImage('resource/GUIButton.png')
BlockBox.image.pushButton = love.graphics.newImage('resource/GUIButton_push.png')

function BlockBox:init()
    -- ボタンの画像拡大率
    self.buttonRate = {}
    self.buttonRate.x = 2
    self.buttonRate.y = 0.7

    self.x = 400
    self.y = 300

    self.width = 120 * self.buttonRate.x
    self.height = 120 * self.buttonRate.y

    self.state = 'neutral'

    self.blocktype = BlockTypeList['circle']
    self.image.shape = PlayerCreationGUI.image.circle

    self.blockNumber = 0
end

function BlockBox:addBlock(num) -- ブロックを増やす
    self.blockNumber = self.blockNumber + num
end

function BlockBox:subBlock(num) -- ブロックを減らす
    self.blockNumber = self.blockNumber - num
end

function BlockBox:setBlockImage(blockType)

    self.blocktype = BlockTypeList[blockType]

    if blockType == 'circle' then
        self.image.shape = PlayerCreationGUI.image.circle
    elseif blockType == 'triangle' then
        self.image.shape = PlayerCreationGUI.image.triangle
    elseif blockType == 'square' then
        self.image.shape = PlayerCreationGUI.image.square
    end
end

function BlockBox:enter()
end

function BlockBox:update(dt)
    --    if self.state == 'clicked' and not love.mouse.isDown(1) and self:isTouched() then
    --     self.state = 'neutral'
    --     self:getBlock()
    --    elseif self.state == 'neutral' and love.mouse.isDown(1) and self:isTouched() then
    --     self.state = 'clicked'
    --    end
    if mouseManager.isReleased then
        self:ReleaseMouse()
    end

end

function BlockBox:ReleaseMouse()
    if self:isTouched() and self.blockNumber >= 1 then
        self:getBlock()
    end
end

function BlockBox:draw()
    self:drawBox()
end

function BlockBox:drawBox()

    if self:isTouched() then
        love.graphics.draw(BlockBox.image.pushButton, self.x, self.y, 0, self.buttonRate.x, self.buttonRate.y)
        love.graphics.draw(self.image.shape, self.x + self.width / 5, self.y + self.height / 4 - 5)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print('x', BlockBox.font.pixel12B, self.x + self.width / 2, self.y + self.height / 4 - 3, 0, 2, 2)
        love.graphics.print(self.blockNumber, BlockBox.font.pixel12B, self.x + self.width / 1.4, self.y + self.height / 4 - 1, 0, 2, 2)
    else
        love.graphics.draw(BlockBox.image.neutralButton, self.x, self.y, 0, self.buttonRate.x, self.buttonRate.y)
        love.graphics.draw(self.image.shape, self.x + self.width / 5, self.y + self.height / 4 - 7)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print('x', BlockBox.font.pixel12B, self.x + self.width / 2, self.y + self.height / 4 - 5, 0, 2, 2)
        love.graphics.print(self.blockNumber, BlockBox.font.pixel12B, self.x + self.width / 1.4, self.y + self.height / 4 - 3, 0, 2, 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function BlockBox:isTouched()
    return (self.x) <= mouseManager.x and (self.x + self.width) >= mouseManager.x and (self.y) <= mouseManager.y and (self.y + self.height) >= mouseManager.y
end

function BlockBox:isClicked()
    return self:isTouched() and mouseManager.clickedTimer == 1
end

function BlockBox:getBlock()
    if PlayerCreationGUI.catchedItem == 'empty' then
        PlayerCreationGUI.catchedItem = self.blocktype
        self:subBlock(1)
    end
end

function BlockBox:delete()
    self = nil
end

return BlockBox
