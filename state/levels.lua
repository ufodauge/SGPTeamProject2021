local levelState = {}

levelState.name = 'levelState'

function levelState:init()
end

function levelState:enter(to, metadata)
    self.metadata = {}
    for key, value in pairs(metadata) do
        self.metadata[key] = value
    end

    infomationManager = InfomationManager()

    background = BackGround()
    background:setImage(BACKGROUND_IN_GAME)

    player = Player(self.metadata.player.x, self.metadata.player.y)
    player:setImage(PLAYER_IMAGE_PATH)

    goal = Goal(self.metadata.goal.x, self.metadata.goal.y)
    goal:setImage(GOAL_IMAGE_PATH)

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
            triangles[#triangles]:setImage(TRIANGLE_IMAGE_PATH)
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
    for key, square in pairs(squares) do
        square:draw()
    end
    for key, triangle in pairs(triangles) do
        triangle:draw()
    end

    hudManager:draw()
    debug.free_camera:detach()
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
    for key, square in pairs(squares) do
        square:delete()
    end
    for key, triangle in pairs(triangles) do
        triangle:delete()
    end

    hudManager:delete()
end

return levelState
