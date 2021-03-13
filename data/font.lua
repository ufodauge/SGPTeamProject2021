local font = {}

font.size = {
    debug = 16,
    title = 64
}

font.debug = love.graphics.newFont('resource/fixedsys-ligatures.ttf', font.size.debug)
font.debug:setFilter('nearest', 'nearest')

font.title = love.graphics.newFont('resource/fixedsys-ligatures.ttf', font.size.title)
font.title:setFilter('nearest', 'nearest')

return font
