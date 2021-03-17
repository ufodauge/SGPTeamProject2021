-- MouseManager = require 'class.mouseManager'
-- mouseManager = MouseManager()

local GUIButton = Class('GUIButton')

function GUIButton:init()

    --ボタンの画像拡大率
    self.buttonRate = {}
    self.buttonRate.x = 0.6
    self.buttonRate.y = 0.6

    --ボタンに表示するテキスト
    self.text = 'hello'

    --テキストの大きさ
    self.textSize = 1.5

    self.x = 400
    self.y = 300

    self.width = 120 * self.buttonRate.x
    self.height = 120 * self.buttonRate.y

    self.state = 'neutral'
end

function GUIButton:update(dt)
    if mouseManager.isReleased then
        self:ReleaseMouse()
    end
end

function GUIButton:ReleaseMouse()
    if self:isTouched() and self.blockNumber >= 1 then
        clickMotion()
    end 
end

function GUIButton:draw()
    self:drawButton()
end

function GUIButton:drawButton()
    love.graphics.setColor(1,1,1,1)
    if self:isTouched() then
        love.graphics.draw(BlockBox.image.pushButton,self.x, self.y,0,self.buttonRate.x,self.buttonRate.y)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(self.text, BlockBox.font.pixel12B, self.x + self.width/4, self.y + self.height/4 - 3,
        0, self.textSize, self.textSize)
    else
        love.graphics.draw(BlockBox.image.neutralButton,self.x, self.y,0,self.buttonRate.x,self.buttonRate.y)
        love.graphics.setColor(0,0,0,1)
        love.graphics.print(self.text, BlockBox.font.pixel12B, self.x + self.width/4, self.y + self.height/4 - 5,
        0, self.textSize, self.textSize)
    end
    love.graphics.setColor(1,1,1,1)
end

function GUIButton:isTouched()
    return  (self.x) <= mouseManager.x and
            (self.x + self.width) >= mouseManager.x and
            (self.y) <= mouseManager.y and
            (self.y + self.height) >= mouseManager.y 
end

function GUIButton:isClicked()
    return self:isTouched() and mouseManager.clickedTimer == 1
end

function GUIButton:delete()
    self = nil
end

return GUIButton