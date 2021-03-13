--[[
    Paper
    捺印される台紙
    
    func:
        setStatus(status(string))
        捺印済み(imorinted)か否か(plain)を設定する
            status(string)
            変更するステータス

        getPenalty()
        ペナルティがあったフレームのみ 1 と返す

        getStatus()
        ペナルティがあったフレームのみスコアを返す

        setImprintStatus(index(number))
        捺印があった台紙を監視する
            index(number)
            捺印されたフレームにカーソルが合っていた台紙のインデックス
            （通常は 0 ）
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
