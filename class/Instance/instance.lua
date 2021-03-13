InstanceCamera = require 'class.Instance.camera'

local Instance = Class('Instance')

Instance._list = {}
setmetatable(Instance._list, {__mode = 'k'})

function Instance:init(obj)
    -- マネージャーへの登録
    table.insert(Instance._list, obj)

    -- 優先度の指定
    self.priority = 5

    -- カメラ
    self.camera = InstanceCamera()
end

function Instance:update(dt)
    -- 親クラスでなければ処理しない
    -- if not self:subclassOf(Instance) then
    --     return
    -- end

    for i, obj in pairs(Instance._list) do
        if obj.update then
            obj:update(dt)
        end

        -- リストから除外　じゃあな
        -- えっなにこれきたねえ
        if not obj.instanceOf then
            table.remove(Instance._list, i)
        end
    end
end

function Instance:draw()
    -- 親クラスでなければ処理しない
    -- if not self:subclassOf(Instance) then
    --     return
    -- end

    love.graphics.setColor(1, 1, 1, 1)
    for i, obj in pairs(Instance._list) do
        -- オブジェクトが無ければ処理しない
        if not obj.draw then
            break
        end

        obj.camera:attach()

        obj:draw()

        obj.camera:detach()
    end
end

local function sort(a, b)
    return a.priority > b.priority
end

function Instance:setPriority(priority)
    self.priority = priority

    table.sort(Instance._list, sort)

    -- print('------------------------------')
    -- print('priorities:')
    -- for i, v in pairs(Instance._list) do
    --     print(i, v.priority, v)
    -- end
    -- print('------------------------------')
end

function Instance:setPosition(x, y)
    self.x, self.y = x, y
end

function Instance:setSize(w, h)
    self.width, self.height = w, h
end

function Instance:delete()
    setmetatable(self, {__mode = 'k'})
    self = nil
end

return Instance
