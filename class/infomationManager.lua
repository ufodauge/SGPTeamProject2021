local InfomationManager = Instance:extend('InfomationManager')

InfomationManager.super:init(InfomationManager)

InfomationManager.collectablesName = {'square', 'circle'}

InfomationManager.countCollectables = {square = 0, circle = 0}
InfomationManager.groundsNearbyPlayer = {}
InfomationManager.arrangedObjectsInfo = {{id = 0, x = 0, y = 0, type = ''}}
--[[
    InfomationManager.arrangedObjectsInfo = {
        [1] = {x = 0, y = 0, type = ''}
    }
]]

-- function InfomationManager:init()
--     InfomationManager.super:init(self)
-- end

function InfomationManager:addCollectable(type)
    for index, value in ipairs(InfomationManager.collectablesName) do
        if type == value then
            InfomationManager.countCollectables[type] = InfomationManager.countCollectables[type] + 1
            return
        end
    end
    error('incorrect type is called in InfomationManager:addCollectable')
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
