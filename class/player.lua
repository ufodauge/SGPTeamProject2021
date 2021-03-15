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
    self.physics:setType('dynamic')
    self.physics:setCollisionClass('Player')
    self.physics:setFixedRotation(true)

    self.additionalPhysics = {}
    self.additionalJoints = {}

    self.moveCount = 0
    self.isMoving = false

    self.keys = KeyManager()
    self.keys:register({
        {
            key = 'z',
            func = function()
            end,
            rep = false,
            act = 'pressed'
        },
        {
            key = 'd',
            func = function()
                self.moveCount = self.moveCount >= 0 and self.moveCount + 3 or 0
                self.isMoving = true
            end,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'a',
            func = function()
                self.moveCount = self.moveCount <= 0 and self.moveCount - 3 or 0
                self.isMoving = true
            end,
            rep = true,
            act = 'pressed'
        }
    })

    self.keys:setPreProcess(function()
        self.isMoving = false
    end)
end

function Player:update(dt)
    self.keys:update(dt)
    self:move()

    if self:isPlayerEnteringGoal() then
        self:removePlayer()
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:move()
    local flag = self.isMoving and 1 or 5
    self.moveCount = self.moveCount and self.moveCount - flag * signum(self.moveCount) or 0
    self.moveCount = self.moveCount >= 50 and 50 or self.moveCount
    self.moveCount = self.moveCount <= -50 and -50 or self.moveCount

    local vx, vy = self.physics:getLinearVelocity()
    vx = signum(self.moveCount) * sigmoid(math.abs(self.moveCount), 0.2, 5) * PLAYER_BASE_SPEED
    self.physics:setLinearVelocity(vx, vy)

    debug:setDebugInfo('player vx: ' .. vx)
    debug:setDebugInfo('player isMoving: ' .. tostring(self.isMoving))
end

function Player:addNewObject(id, type, x, y)
    if type == 'square' then
        self.additionalPhysics[id] = world:newRectangleCollider(x, y, SQUARE_WIDTH, SQUARE_HEIGHT)
        self.additionalPhysics[id]:setType('dynamic')
        self.additionalPhysics[id]:setCollisionClass('Player')

        print('physics added: ' .. tostring(id) .. '(' .. tostring(self.additionalPhysics[id]) .. ')')

        local x0, y0 = self.physics:getPosition()
        self.additionalJoints[id] = world:addJoint('WeldJoint', self.physics, self.additionalPhysics[id], x, y, false)

        print('joint added: ' .. tostring(id) .. '(' .. tostring(self.additionalJoints[id]) .. ')')
    end
end

function Player:removeArrangedObjectsAll()
    for key, joint in pairs(self.additionalJoints) do
        print('joint removed: ' .. tostring(key) .. '(' .. joint .. ')')
        joint:destroy()
    end
    for key, physics in pairs(self.additionalPhysics) do
        print('physics removed: ' .. tostring(key) .. '(' .. physics .. ')')
        physics:destroy()
    end
end

function Player:isPlayerEnteringGoal()
    if self.physics:enter('Goal') then
        return true
    end

    for key, physics in pairs(self.additionalPhysics) do
        if physics:enter('Goal') then
            return true
        end
    end

    return false
end

function Player:removePlayer()
    self.physics:setPosition(1000, 1000)
    self.physics:setType('static')
    self.physics:setCollisionClass('Removed')

    for key, physics in pairs(self.additionalPhysics) do
        physics:setPosition(1000, 1000)
        physics:setType('static')
        physics:setCollisionClass('Removed')
    end
end

function Player:delete()
    self.physics:destroy()
    for key, physics in pairs(self.additionalPhysics) do
        physics:destroy()
    end

    self.super.delete(self) -- selfを明示的に書いてあげる必要あり
end

return Player
