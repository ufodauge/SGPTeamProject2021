local Hud = Instance:extend('Hud')

function Hud:init(x, y, width, height)
    Hud.super:init(self)

    self.x, self.y = x, y
    self.width, self.height = width, height

    self.image = nil
    self.functions = {
        onMouseClick = function()

        end
    }
end

function Hud:update(dt)
end

function Hud:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if self.onMouse and love.mouse.isDown(MOUSE_BUTTON_LEFT) then
        self.functions.onMouseClick()
    end

    if self.image then
        -- ガムなくなった　買わなきゃ
        love.graphics.draw(self.image, self.x, self.y)
    end
end

function Hud:debugDraw()
    if self.onMouse then
        love.graphics.setColor(0.0, 0.6, 0.0, 0.6)
    else
        love.graphics.setColor(0.2, 0.2, 0.2, 0.2)
    end
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function Hud:setMouseClickFunction(func)
    self.functions.onMouseClick = func
end

function Hud:getHudBox()
    return self.x, self.y, self.width, self.height
end

function Hud:setOnMouseMode(bool)
    self.onMouse = bool
end

function Hud:setImage(image)
    assert(image:typeOf('Image'), 'incorrect object type.')

    self.image = image
end

function Hud:delete()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return Hud
