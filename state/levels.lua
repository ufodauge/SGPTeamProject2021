local levelState = {}

levelState.name = 'levelState'

function levelState:init()
end

function levelState:enter(to, metadata)
    self.metadata = {}
    for key, value in pairs(metadata) do
        self.metadata[key] = value
    end

    self.arrangedTable = {}

    infomationManager = InfomationManager()

    background = BackGround()
    background:setImage(BACKGROUND_IN_GAME)

    player = Player(self.metadata.player.x, self.metadata.player.y)
    player:setImage(PLAYER_IMAGE_PATH)
    player:setImage(SQUARE_IMAGE_PATH, 'square')
    player:setImage(TRIANGLE_IMAGE_PATH, 'triangle')
    player:setImage(CIRCLE_IMAGE_PATH, 'circle')

    goal = Goal(self.metadata.goal.x, self.metadata.goal.y)
    goal:setImage(GOAL_IMAGE_PATH)

    door = Door(self.metadata.doors[1].x, self.metadata.doors[1].y, self.metadata.doors[1].w, self.metadata.doors[1].h)
    switch = Switch(self.metadata.switches[1].x, self.metadata.switches[1].y, self.metadata.doors[1].w, self.metadata.doors[1].h)

    grounds = {}
    for index, groundData in ipairs(self.metadata.grounds) do
        grounds[index] = Ground(groundData.x, groundData.y, groundData.w, groundData.h, groundData.rot)
    end

    respawns = {}
    for index, respawnData in ipairs(self.metadata.respawns) do
        respawns[index] = Respawn(respawnData.x, respawnData.y, respawnData.w, respawnData.h, respawnData.rot)
    end

    squares = {}
    triangles = {}

    for index, collectablesData in ipairs(self.metadata.collectables) do
        if collectablesData.type == 'square' then
            table.insert(squares, Square(collectablesData.x, collectablesData.y, collectablesData.rot))
            squares[#squares]:setImage(SQUARE_IMAGE_PATH)
        elseif collectablesData.type == 'triangle' then
            table.insert(triangles, Triangle(collectablesData.x, collectablesData.y, collectablesData.rot))
            -- triangles[#triangles]:setImage(TRIANGLE_IMAGE_PATH)
        end
    end

    hudManager = HudManager()
    hudManager:setDebugDrawEnabled(true)

    hudManager:add(HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_TAG,
                   Hud(HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_X, HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_Y, HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_WIDTH,
                       HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_HEIGHT))
    hudManager:setImage(HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_TAG, HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_IMAGE_PATH)
    hudManager:setMouseClickFunction(HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_TAG, function()
        State.push(States.ArrangeCollider, infomationManager:getCollectablesInfo())
    end)
end

function levelState:update(dt)
    background:update(dt)

    player:update(dt)

    goal:update(dt)

    for key, ground in pairs(grounds) do
        ground:update(dt)
    end

    for key, respawn in pairs(respawns) do
        respawn:update(dt)
    end

    door:update(dt)
    switch:update(dt)

    for key, square in pairs(squares) do
        square:update(dt)
    end
    for key, triangle in pairs(triangles) do
        triangle:update(dt)
    end

    hudManager:update(dt)
end

function levelState:draw()
    debug.free_camera:attach()
    background:draw()

    player:draw()
    goal:draw()

    for key, ground in pairs(grounds) do
        ground:draw()
    end

    for key, respawn in pairs(respawns) do
        respawn:draw()
    end

    door:draw()
    switch:draw()

    for key, square in pairs(squares) do
        square:draw()
    end
    for key, triangle in pairs(triangles) do
        triangle:draw()
    end

    hudManager:draw()
    debug.free_camera:detach()

    debug:draw()
end

function levelState:getCurrentLevelIndex()
    return self.metadata.level
end

-- シーン遷移
function levelState:transitionLevel(level)
    for index, metadata in ipairs(Data.LevelsMetaData) do
        if metadata.level == level then
            State.switch(States.Levels, metadata)
            return
        end
    end
    error(lume.format('There\'s any levels to go to: levelState:transitionLevel({1})', {level}))
end

function levelState:leave()
    player:delete()
    goal:delete()

    for key, ground in pairs(grounds) do
        ground:delete()
    end
    for key, respawn in pairs(respawns) do
        respawn:delete()
    end

    door:delete()
    switch:delete()

    for key, square in pairs(squares) do
        square:delete()
    end
    for key, triangle in pairs(triangles) do
        triangle:delete()
    end

    hudManager:delete()
end

function levelState:resume(from, arrangedTable)
    player:removeArrangedObjectsAll()

    self.arrangedTable = arrangedTable

    for index, tbl in ipairs(arrangedTable) do
        local x, y = 0, 0

        print(tbl.x, SQUARE_WIDTH, player.physics:getX())

        x = (tbl.x - 2) * SQUARE_WIDTH - SQUARE_WIDTH / 2
        y = (tbl.y - 3) * SQUARE_HEIGHT - SQUARE_HEIGHT / 2

        player:addNewObject(index, tbl.type, x + player.physics:getX(), y + player.physics:getY())
        player:setRelativePositions(index, x, y)
    end
end

return levelState
