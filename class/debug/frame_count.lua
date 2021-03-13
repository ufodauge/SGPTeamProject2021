local FrameCount = Class('FrameCount')

-- 初期化処理
function FrameCount:init()
    self.frame_count = 0
    self.active = true
end

function FrameCount:update(dt)
    if self.active then
        self.frame_count = self.frame_count + 1
    end
end

function FrameCount:stop()
    self.active = false
end

function FrameCount:start()
    self.active = true
end

function FrameCount:getFrame()
    return self.frame_count
end

function FrameCount:reset()
    self.frame_count = 0
end

return FrameCount

-- リリース時の処理の追加！！！！
