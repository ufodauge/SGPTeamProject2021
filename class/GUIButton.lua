-- MouseManager = require 'class.mouseManager'
-- mouseManager = MouseManager()

local GUIButton = Class('GUIButton')

function GUIButton:init()

    --ボタンの画像拡大率
    self.buttonRate = {}
    self.buttonRate.x = 0.6
    self.buttonRate.y = 0.6

    --ボタンに表示するテキスト
    self.image = {}
    self.image.UI = PlayerCreationGUI.image.reset

    --テキストの大きさ
    self.textSize = 1.5

    self.x = 400
    self.y = 300

    self.width = 120 * self.buttonRate.x
    self.height = 120 * self.buttonRate.y

    self.state = 'neutral'

    self.buttonFunction = nil
    --ボタン上の画像の誤差修正変数
    self.imageOffset = {}
    self.imageOffset.x = 0
    self.imageOffset.neutral = -5
    self.imageOffset.pushY = 2
    self.imageOffset.rate = 1
end

function GUIButton:setButtonFunction(func)
    self.buttonFunction = func
end

function GUIButton:update(dt)
    if mouseManager.isReleased and self:isTouched() then
        self:callButtonFunction()
    end
end

function GUIButton:callButtonFunction()
    self.buttonFunction()
end

function GUIButton:draw()
    self:drawButton()
end

function GUIButton:drawButton()
    love.graphics.setColor(1,1,1,1)
    if self:isTouched() then
        love.graphics.draw(BlockBox.image.pushButton,self.x, self.y,0,self.buttonRate.x,self.buttonRate.y)
        --love.graphics.setColor(0,0,0,1)
        -- love.graphics.print(self.text, BlockBox.font.pixel12B, self.x + self.width/4 + self.imageOffset.x, self.y + self.height/4 + self.imageOffset.neutral + self.imageOffset.pushY,
        -- 0, self.textSize, self.textSize)
        love.graphics.draw(self.image.UI, self.x + self.width/4 + self.imageOffset.x, self.y + self.height/4 + self.imageOffset.neutral + self.imageOffset.pushY, 0, self.imageOffset.rate, self.imageOffset.rate)
    else
        love.graphics.draw(BlockBox.image.neutralButton,self.x, self.y,0,self.buttonRate.x,self.buttonRate.y)
        --love.graphics.setColor(0,0,0,1)
        -- love.graphics.print(self.text, BlockBox.font.pixel12B, self.x + self.width/4 + self.imageOffset.x, self.y + self.height/4 + self.imageOffset.neutral,
        -- 0, self.textSize, self.textSize)
        love.graphics.draw(self.image.UI, self.x + self.width/4 + self.imageOffset.x, self.y + self.height/4 + self.imageOffset.neutral, 0, self.imageOffset.rate, self.imageOffset.rate)
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