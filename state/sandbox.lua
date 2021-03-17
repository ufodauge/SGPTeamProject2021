local sandbox = {}

sandbox.name = 'sandbox'

function sandbox:init()
end

function sandbox:enter()
    -- sampleTimer = SampleTimer()
    -- sampleTimer:toggle()
    playerCreationGUI = PlayerCreationGUI()
    mouseManager = MouseManager()
    -- mGGUIBlock =  GUIBlock()
    -- blockBox = BlockBox()

end

function sandbox:update(dt)
    playerCreationGUI:update(dt)
end

function sandbox:draw()
    playerCreationGUI:draw()
end

function sandbox:leave()

    -- sampleTimer:delete()
    playerCreationGUI:delete()
    mouseManager:delete()
    -- mGUIBlock:delete()
    -- blockBox:delete()
end

return sandbox
