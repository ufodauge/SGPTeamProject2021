local ButtonsBoard = Instance:extend('ButtonsBoard')

ButtonsBoard.image = {}
ButtonsBoard.image.buttonsBoard = love.graphics.newImage('resource//ButtonsFlame.png')

function ButtonsBoard:init()
    self.super:init(self)
    -- self:setPriority(2)

    self.x = 450
    self.y = 100
end

function ButtonsBoard:update(dt)
end

function ButtonsBoard:draw()
    love.graphics.draw(ButtonsBoard.image.buttonsBoard, self.x, self.y)
end

function ButtonsBoard:delete()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return ButtonsBoard
