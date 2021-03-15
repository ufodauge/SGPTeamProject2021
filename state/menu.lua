local menu = {}

menu.name = 'menu'

function menu:init()
end

function menu:enter()
    texts = {}
    texts.title = Text(400, 200, 'UNTITLED', FONT_TITLE)
    texts.pressStart = Text(400, 400, 'PRESS START', FONT_REGULAR)
end

function menu:update(dt)
end

function menu:draw()
end

function menu:leave()
    for key, text in pairs(texts) do
        text:delete()
    end
end

return menu
