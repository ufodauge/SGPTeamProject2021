-- フリーカメラ
local FreeCamera = Class('FreeCamera')

local move_distance = 5

-- 初期化処理
function FreeCamera:init()
    self.camera = Camera.new()
    self.keys = KeyManager()

    -- self.keys:register(
    --     'w',
    --     function()
    --         self.camera:move(0, -move_distance)
    --     end,
    --     true,
    --     'pressed'
    -- )
    -- self.keys:register(
    --     's',
    --     function()
    --         self.camera:move(0, move_distance)
    --     end,
    --     true
    -- )
    -- self.keys:register(
    --     'd',
    --     function()
    --         self.camera:move(move_distance, 0)
    --     end,
    --     true
    -- )
    -- self.keys:register(
    --     'a',
    --     function()
    --         self.camera:move(-move_distance, 0)
    --     end,
    --     true
    -- )
    self.keys:register(
        {
            {
                key = 'w',
                func = function()
                    self.camera:move(0, -move_distance)
                end,
                rep = true,
                act = 'pressed'
            },
            {
                key = 's',
                func = function()
                    self.camera:move(0, move_distance)
                end,
                rep = true
            },
            {
                key = 'd',
                func = function()
                    self.camera:move(move_distance, 0)
                end,
                rep = true
            },
            {
                key = 'a',
                func = function()
                    self.camera:move(-move_distance, 0)
                end,
                rep = true
            }
        }
    )

    self.active = false
end

function FreeCamera:update(dt)
    if self.active then
        self.keys:update(dt)
    end
end

function FreeCamera:getActive()
    return self.active
end

function FreeCamera:getPosition()
    return self.camera.x, self.camera.y
end

function FreeCamera:attach()
    self.camera:attach()
end

function FreeCamera:detach()
    self.camera:detach()
end

function FreeCamera:toggle()
    self.active = not self.active
end

return FreeCamera
