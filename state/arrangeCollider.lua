local arrangeCollider = {}

arrangeCollider.name = 'arrangeCollider'

function arrangeCollider:init()
end

function arrangeCollider:enter(from, infoTable)
    self.from = from

    blackbox = BlackBox()

    mouseManager = MouseManager()
    playerCreationGUI = PlayerCreationGUI()
end

function arrangeCollider:update(dt)
end

function arrangeCollider:draw()
end

function arrangeCollider:leave()
    blackbox:delete()
    playerCreationGUI:delete()
    mouseManager:delete()
end

return arrangeCollider
