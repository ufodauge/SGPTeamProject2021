--[[
    Background
    背景を表示する
    
    func:
        setImage(image(Drawable))
        表示する画像を設定する
            image(Drawable)
            イメージデータ
]]
local DummyClass = Instance:extend('DummyClass')

function DummyClass:init()
    DummyClass.super:init(self)
end

function DummyClass:update(dt)
end

function DummyClass:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function DummyClass:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return DummyClass
