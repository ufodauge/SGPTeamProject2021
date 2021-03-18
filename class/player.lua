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
    self.image = nil
    self.imageInteriorSquare = nil
    self.imageInteriorTriangle = nil
    self.imageInteriorCircle = nil
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
                -- self.rotatable = not self.rotatable
                self.physics:setFixedRotation(not self.physics:isFixedRotation())
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

    -- self:setInteriorsTarget(self.physics:getPosition())
    self:correctInteriorsAngle()

    self:manageEnteringCollidersInfo()

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

    for index, physics in ipairs(self.additionalPhysics) do
        if self.imageInteriorSquare and self.additionalObjectInfo[index].type == 'square' then
            local x, y = physics:getPosition()
            local r = physics:getAngle()

            love.graphics.draw(self.imageInteriorSquare, x, y, r, 1, 1, SQUARE_WIDTH / 2, SQUARE_HEIGHT / 2)
        elseif self.imageInteriorTriangle and self.additionalObjectInfo[index].type == 'triangle' then
            local x, y = physics:getPosition()
            local r = physics:getAngle()

            love.graphics.draw(self.imageInteriorTriangle, x, y, r, 1, 1, SQUARE_WIDTH / 2, SQUARE_HEIGHT / 2)

        elseif self.imageInteriorCircle and self.additionalObjectInfo[index].type == 'circle' then
            local x, y = physics:getPosition()
            local r = physics:getAngle()

            love.graphics.draw(self.imageInteriorCircle, x, y, r, 1, 1, SQUARE_WIDTH / 2, SQUARE_HEIGHT / 2)
        end
    end
end

function Player:setImage(imagePath, type)
    if type == 'square' then
        self.imageInteriorSquare = love.graphics.newImage(imagePath)
        self.imageInteriorSquare:setFilter('nearest', 'nearest')
    elseif type == 'triangle' then
        self.imageInteriorTriangle = love.graphics.newImage(imagePath)
        self.imageInteriorTriangle:setFilter('nearest', 'nearest')
    elseif type == 'circle' then
        self.imageInteriorCircle = love.graphics.newImage(imagePath)
        self.imageInteriorCircle:setFilter('nearest', 'nearest')
    else
        self.image = love.graphics.newImage(imagePath)
        self.image:setFilter('nearest', 'nearest')
    end
end

function Player:jump()
    if self:isStandingOnGround() and self.jump_cooltime <= 0 then
        self.jump_cooltime = PLAYER_JUMP_COOLTIME
        self.physics:setLinearVelocity(0, -300)
        for id, physics in pairs(self.additionalPhysics) do
            self.additionalPhysics[id]:setLinearVelocity(0, -300)
        end
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
        self.additionalObjectInfo[id] = {type = type, relativeX = x, relativeY = y}

        self.additionalPhysics[id] = world:newRectangleCollider(x, y, SQUARE_WIDTH, SQUARE_HEIGHT)
        self.additionalPhysics[id]:setType('dynamic')
        self.additionalPhysics[id]:setCollisionClass('Player')
        self.additionalPhysics[id]:setFriction(0)

        print('physics added: ' .. tostring(id) .. '(' .. tostring(self.additionalPhysics[id]:getX()) .. ', ' .. tostring(self.additionalPhysics[id]:getY()) ..
                  ')')

        self.additionalJoints[id] = world:addJoint('WeldJoint', self.physics, self.additionalPhysics[id], x + SQUARE_WIDTH / 2, y + SQUARE_HEIGHT / 2, true)

        print('joint added: ' .. tostring(id) .. '(' .. tostring(self.additionalJoints[id]) .. ')')
    end
end

function Player:setRelativePositions(id, x, y)
    self.additionalObjectInfo[id].relativeX = x
    self.additionalObjectInfo[id].relativeY = y
end

function Player:setInteriorsTarget(playerX, playerY)
    for id, joint in pairs(self.additionalJoints) do
        self.additionalJoints[id]:setTarget(playerX + PLAYER_WIDTH / 2 + self.additionalObjectInfo[id].relativeX,
                                            playerY + PLAYER_HEIGHT / 2 + self.additionalObjectInfo[id].relativeY)
    end
end

function Player:correctInteriorsAngle()
    for id, physics in pairs(self.additionalPhysics) do
        self.additionalPhysics[id]:setAngle(self.physics:getAngle())
    end
end

function Player:removeArrangedObjectsAll()
    for index, joint in ipairs(self.additionalJoints) do
        print('joint removed: ' .. tostring(index) .. '(' .. tostring(joint) .. ')')
        joint:destroy()
    end
    for index, physics in ipairs(self.additionalPhysics) do
        print('physics removed: ' .. tostring(index) .. '(' .. tostring(physics) .. ')')
        physics:destroy()
    end

    self.additionalJoints = {}
    self.additionalPhysics = {}
    self.additionalObjectInfo = {}
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
