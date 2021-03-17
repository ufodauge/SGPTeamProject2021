local mouseManager = Instance:extend('MouseManager')

function mouseManager:init()
    self.super:init(self)

    -- 現在の座標
    self.tx, self.ty = love.mouse.getPosition()
    self.x = self.tx
    self.y = self.ty

    self.isReleased = false -- 離された瞬間
    self.clickedTimer = 0
    self.clicked_x = -1000
    self.clicked_y = -1000
end

function mouseManager:update(dt)

    self.tx, self.ty = love.mouse.getPosition()
    self.x = self.tx
    self.y = self.ty

    if not love.mouse.isDown(1) and self.clickedTimer ~= 0 then -- 離された瞬間
        self.clickedTimer = 0
        self.isReleased = true
    elseif not love.mouse.isDown(1) then -- 離されているあいだ
        self.isReleased = false
    elseif love.mouse.isDown(1) and self.clickedTimer ~= 0 then -- 押された瞬間
        self.clickedTimer = 1
        self.clicked_x = self.x
        self.clicked_y = self.y
    elseif love.mouse.isDown(1) then -- 押されている間
        self.clickedTimer = self.clickedTimer + 1
    end

end

function mouseManager:draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.print('nowX : ' .. MouseManager.x .. ', nowY : ' .. MouseManager.y, 500, 100)
    -- print(self.clickedTimer)
    -- if MouseManager.clickedTimer ~= 0 then
    --     love.graphics.print('Mouse is Clicked!', 500, 125)
    --     love.graphics.print('clickedX : ' .. MouseManager.clicked_x .. ', clicedY : ' .. MouseManager.clicked_y, 500, 150)
    -- end
    -- if MouseManager.isReleased then
    --     love.graphics.print('Mouse is released!', 500, 175)
    -- end
end

function mouseManager:delete()
    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return mouseManager
