--[[
    CountdownTimer
    ゲーム開始時からのカウントダウンを実行・表示する
    
    func:
        setTime(time(number))
        計測する時間を設定する

        setPenalty(penalty(number))
        ペナルティの状況を監視する
            penalty(number)
            1 の時にペナルティありと判定

        isOver()
        カウント終了時に true を返す
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
