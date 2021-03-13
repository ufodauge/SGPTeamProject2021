local Player = Instance:extend('Player')

local sigmoid = function(x, a, b)
    return 1 / (1 + math.exp(a * (-x) + b))
end

local signum = function(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

function Player:init(x, y)
    Player.super:init(self)

    self.physics = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.physics:setType('kinematic')

    self.moveCount = 0

    self.keys = KeyManager()
    self.keys:register({
        {
            key = 'z',
            func = function()
            end,
            rep = false,
            act = 'pressed'
        }, {
            key = 'right',
            func = function()
                self.moveCount = self.moveCount >= 0 and self.moveCount + 2 or 0
            end,
            rep = true,
            act = 'pressed'
        }, {
            key = 'left',
            func = function()
                self.moveCount = self.moveCount <= 0 and self.moveCount - 2 or 0
            end,
            rep = true,
            act = 'pressed'
        }
    })
end

function Player:update(dt)
    self.keys:update(dt)
    self:move()
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:move()
    self.moveCount = self.moveCount and self.moveCount - signum(self.moveCount) or 0

    local vx, vy = self.physics:getLinearVelocity()
    vx = signum(self.moveCount) * sigmoid(math.abs(self.moveCount), 0.2, 5) * PLAYER_BASE_SPEED
    self.physics:setLinearVelocity(vx, vy)

    debug:setDebugInfo('player vx: ' .. vx)
end

function Player:delete()
    self.super:delete(self) -- selfを明示的に書いてあげる必要あり
end

return Player
