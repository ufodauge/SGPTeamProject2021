local BackGround = Class('BackGround')

function BackGround:init()
    self.image = nil
end

function BackGround:update(dt)
end

function BackGround:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function BackGround:draw()
    if self.image then
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.draw(self.image, 0, 0)
    end
end

function BackGround:delete()

end

return BackGround
