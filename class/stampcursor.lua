--[[
    StamoCursor
    ハンコのカーソル
    
    func:
        setPapersSize(column(number), row(number))
        台紙の縦横の配置を設定する
            column(number)
            列数
            row(number)
            行数

        getStatus()
        捺印した場所のインデックスを返す
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
