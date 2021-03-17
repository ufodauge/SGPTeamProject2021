local InfomationManager = Instance:extend('InfomationManager')

function InfomationManager:init()
    self.super:init(self)

    self.collectablesName = {'square', 'circle'}

    self.countCollectables = {square = 0, circle = 0}
    self.groundsNearbyPlayer = {}
    self.arrangedObjectsInfo = {{id = 0, x = 0, y = 0, type = ''}}
end

--[[
    InfomationManager.arrangedObjectsInfo = {
        [1] = {x = 0, y = 0, type = ''}
    }
]]

-- function InfomationManager:init()
--     InfomationManager.super:init(self)
-- end

function InfomationManager:addCollectable(type)
    for index, value in ipairs(self.collectablesName) do
        if type == value then
            self.countCollectables[type] = self.countCollectables[type] + 1
            return
        end
    end
    error('incorrect type is called in InfomationManager:addCollectable')
end

function InfomationManager:getCollectablesInfo()
    return self.countCollectables
end

function InfomationManager:getGroundsNearbyPlayer()

end

function InfomationManager:arrangeObjects()
    -- for index, info in ipairs(InfomationManager.arrangedObjectsInfo) do
    --     player:addNewObject(info.id, info.type, info.x, info.y)
    -- end
end

function InfomationManager:update(dt)
end

function InfomationManager:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function InfomationManager:delete()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return InfomationManager
