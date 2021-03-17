local arrangeCollider = {}

arrangeCollider.name = 'arrangeCollider'

function arrangeCollider:init()
end

function arrangeCollider:enter()

    -- sampleTimer = SampleTimer()
    -- sampleTimer:toggle()
    mouseManager = MouseManager()
    playerCreationGUI = PlayerCreationGUI()
    -- mGGUIBlock =  GUIBlock()
    -- blockBox = BlockBox()

end

function arrangeCollider:update(dt)
end

function arrangeCollider:draw()
end

function arrangeCollider:leave()

    -- sampleTimer:delete()
    playerCreationGUI:delete()
    mouseManager:delete()
    -- mGUIBlock:delete()
    -- blockBox:delete()
end

return arrangeCollider
