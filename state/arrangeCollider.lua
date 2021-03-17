local arrangeCollider = {}

arrangeCollider.name = 'arrangeCollider'

function arrangeCollider:init()
end

function arrangeCollider:enter(from, infoTable)
    self.from = from

    mouseManager = MouseManager()
    playerCreationGUI = PlayerCreationGUI()

end

function arrangeCollider:update(dt)
end

function arrangeCollider:draw()
    -- self.from:draw()
end

function arrangeCollider:leave()
    playerCreationGUI:delete()
    mouseManager:delete()
end

return arrangeCollider
