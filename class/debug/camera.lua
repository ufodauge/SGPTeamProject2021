-- フリーカメラ
local FreeCamera = Class('FreeCamera')

local move_distance = 5
local keyconfig_set = {
    wasd = {{key = 'w'}, {key = 's'}, {key = 'd'}, {key = 'a'}},
    direction_key = {{key = 'up'}, {key = 'down'}, {key = 'right'}, {key = 'left'}},
    numpad = {{key = 'kp8'}, {key = 'kp2'}, {key = 'kp6'}, {key = 'kp4'}}
}

-- 初期化処理
function FreeCamera:init()
    self.camera = Camera.new()
    self.keys = KeyManager()

    self.actions = {
        {
            func = function()
                self.camera:move(0, -move_distance)
            end,
            rep = true
        },
        {
            func = function()
                self.camera:move(0, move_distance)
            end,
            rep = true
        },
        {
            func = function()
                self.camera:move(move_distance, 0)
            end,
            rep = true
        },
        {
            func = function()
                self.camera:move(-move_distance, 0)
            end,
            rep = true
        }
    }

    for index, value in ipairs(self.actions) do
        local registerAction = lume.merge(value, keyconfig_set.wasd[index])
        self.keys:register({registerAction})
    end

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

function FreeCamera:changeConfig(type)
    self.keys = KeyManager()
    for index, value in ipairs(self.actions) do
        local registerAction = lume.merge(value, keyconfig_set[type][index])
        self.keys:register({registerAction})
    end
end

return FreeCamera
