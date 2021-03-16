MouseManager = Instance:extend('MouseManager')

function MouseManager:init()
    MouseManager.super:init(self)

    --現在の座標
    MouseManager.tx, MouseManager.ty = love.mouse.getPosition()
    MouseManager.x = MouseManager.tx
    MouseManager.y = MouseManager.ty

    MouseManager.isReleased = false --離された瞬間
    MouseManager.clickedTimer = 0
    MouseManager.clicked_x = -1000
    MouseManager.clicked_y = -1000
end

function MouseManager:update(dt)
    
    MouseManager.tx, MouseManager.ty = love.mouse.getPosition()
    MouseManager.x = MouseManager.tx
    MouseManager.y = MouseManager.ty

    if not love.mouse.isDown(1) and MouseManager.clickedTimer ~= 0 then --離された瞬間
        MouseManager.clickedTimer = 0
        MouseManager.isReleased = true
    elseif not love.mouse.isDown(1) then --離されているあいだ
        MouseManager.isReleased = false
    elseif love.mouse.isDown(1) and MouseManager.clickedTimer ~= 0 then --押された瞬間
        MouseManager.clickedTimer = 1
        MouseManager.clicked_x = MouseManager.x
        MouseManager.clicked_y = MouseManager.y
    elseif love.mouse.isDown(1) then --押されている間
        MouseManager.clickedTimer = MouseManager.clickedTimer + 1
    end

end

function MouseManager:draw()
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.print('nowX : ' .. MouseManager.x .. ', nowY : ' .. MouseManager.y, 500, 100)
    --print(self.clickedTimer)
    -- if MouseManager.clickedTimer ~= 0 then
    --     love.graphics.print('Mouse is Clicked!', 500, 125)
    --     love.graphics.print('clickedX : ' .. MouseManager.clicked_x .. ', clicedY : ' .. MouseManager.clicked_y, 500, 150)
    -- end
    -- if MouseManager.isReleased then
    --     love.graphics.print('Mouse is released!', 500, 175)
    -- end
end

function MouseManager:delete()
    MouseManager.super:delete(MouseManager) -- selfを明示的に書いてあげる必要あり
end

return MouseManager