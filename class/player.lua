local Player = Class('Player')

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

    self.physics = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.physics:setType('dynamic')
    self.physics:setCollisionClass('Player')
    self.physics:setFriction(0)

    self.additionalPhysics = {}
    self.additionalJoints = {}
    self.additionalObjectInfo = {}

    self.moveCount = 0
    self.isMoving = false
    self.stayOnGround = true
    self.rotatable = true
    self.image = nil
    self.jump_cooltime = 0

    self.keys = KeyManager()
    self.keys:register({
        {
            key = 'w',
            func = function()
                self:jump()
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
            key = 's',
            func = function()
                self.rotatable = not self.rotatable
            end,
            rep = false,
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

    self:manageEnteringCollidersInfo()

    if self.rotatable then
        self.physics:setAngle(0)
    end

    self.jump_cooltime = self.jump_cooltime > 0 and self.jump_cooltime - 1 or 0

    if self:isPlayerEnteringGoal() then
        self:removePlayer()
        States.Levels:transitionLevel(States.Levels:getCurrentLevelIndex() + 1)
    end
end

function Player:draw()
    love.graphics.setColor(0.1, 0.1, 0.1, 1)

    if self.image then
        local x, y = self.physics:getPosition()
        local r = self.physics:getAngle()

        love.graphics.draw(self.image, x, y, r, 1, 1, PLAYER_WIDTH / 2, PLAYER_HEIGHT / 2)
    end

    for key, physics in pairs(self.additionalPhysics) do
        if self.imageSquare then
            local x, y = physics:getPosition()
            local r = physics:getAngle()

            love.graphics.draw(self.imageSquare, x, y, r, 1, 1, SQUARE_WIDTH / 2, SQUARE_HEIGHT / 2)
        end
    end
end

function Player:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.image:setFilter('nearest', 'nearest')
end

function Player:jump()
    if self:isStandingOnGround() and self.jump_cooltime <= 0 then
        self.jump_cooltime = PLAYER_JUMP_COOLTIME
        self.physics:applyLinearImpulse(0, -1000)
    end
end

function Player:isStandingOnGround()
    return self.stayOnGround
end

function Player:manageEnteringCollidersInfo()
    self.physics:enter('Ground')
    self.stayOnGround = self.physics:stay('Ground')
    self.physics:exit('Ground')
    -- debug:setDebugInfo('self.stayOnGround' .. tostring(self.stayOnGround))
end

function Player:move()
    local flag = self.isMoving and 1 or 5
    self.moveCount = self.moveCount and self.moveCount - flag * signum(self.moveCount) or 0
    self.moveCount = self.moveCount >= 50 and 50 or self.moveCount
    self.moveCount = self.moveCount <= -50 and -50 or self.moveCount

    local vx, vy = self.physics:getLinearVelocity()
    vx = signum(self.moveCount) * sigmoid(math.abs(self.moveCount), 0.2, 5) * PLAYER_BASE_SPEED
    self.physics:setLinearVelocity(vx * 0.994, vy)

end

function Player:addNewObject(id, type, x, y)
    if type == 'square' then
        self.additionalObjectInfo[id] = {type = type}

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
    self = nil
end

return Player
