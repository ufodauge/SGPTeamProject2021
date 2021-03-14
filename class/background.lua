local BackGround = Instance:extend('BackGround')

function BackGround:init()
    BackGround.super:init(self)
end

function BackGround:update(dt)
end

function BackGround:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function BackGround:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return BackGround
