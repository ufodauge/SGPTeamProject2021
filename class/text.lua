local Text = Instance:extend('Text')

function Text:init(x, y, string, font, type)
    Text.super:init(self)

    self.x = x
    self.y = y

    self.type = type or TEXT_PRINT_TYPE_CENTER
    self.font = font or FONT_REGULAR

    assert(lume.find(TEXT_PRINT_TYPES_LIST, self.type), 'Invalid print type is called: ' .. tostring(self.type))
    assert(lume.find(FONTS_LIST, self.font), 'Invalid font is called: ' .. tostring(self.font))

    assert(#string > 0, 'string is not defined in Text.')

    self.text = love.graphics.newText(self.font, string)
    self.width, self.height = self.text:getDimensions()
end

function Text:update(dt)
end

function Text:draw()
    love.graphics.setColor(1, 1, 1, 1)
    self:printText()
end

function Text:setPrintType(type)
    assert(lume.find(TEXT_PRINT_TYPES_LIST, type), 'Invalid print type is called: ' .. tostring(type))
    self.type = type
end

function Text:setFont(font)
    assert(lume.find(FONTS_LIST, font), 'Invalid font is called: ' .. tostring(font))
    self.font = font
end

function Text:printText()
    if self.type == TEXT_PRINT_TYPE_CENTER then
        love.graphics.draw(self.text, self.x - self.width / 2, self.y - self.height / 2)
    end
    if self.type == TEXT_PRINT_TYPE_UPPER_LEFT then
        love.graphics.draw(self.text, self.x, self.y)
    end
end

function Text:delete()
    self.text:release()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return Text
