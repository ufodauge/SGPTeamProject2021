PlayerCreationGUI = Class('PlayerCreationGUI')

PlayerCreationGUI.catchedItem = 'empty'
PlayerCreationGUI.image = {}
PlayerCreationGUI.image.background = love.graphics.newImage('resource/background.png')
PlayerCreationGUI.image.table = love.graphics.newImage('resource/flame_3.png')
PlayerCreationGUI.image.selectedTable = love.graphics.newImage('resource/selectedTable.png')
PlayerCreationGUI.image.circle = love.graphics.newImage('resource/circle.png')
PlayerCreationGUI.image.triangle = love.graphics.newImage('resource/triangle.png')
PlayerCreationGUI.image.square = love.graphics.newImage('resource/square.png')
PlayerCreationGUI.image.playerCore = love.graphics.newImage('resource/player.png')
PlayerCreationGUI.image.reset = love.graphics.newImage('resource/reset.png')
PlayerCreationGUI.image.delete = love.graphics.newImage('resource/delete.png')
PlayerCreationGUI.image.complete = love.graphics.newImage('resource/complete.png')
PlayerCreationGUI.image.colormatBlack = love.graphics.newImage('resource/colormat_black.png')

-- プレイヤー作成を完了する処理
local function completePlayerCreation()
    State.pop()
    --print('complete')
end

-- プレイヤー作成を破棄する処理
local function deletePlayerCreation()
    State.pop()
    --print('delete')
end

--プレイヤー作成をリセットする処理
local function resetPlayerCreation()
    PlayerCreationGUI.animationFlameTimer = 0

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        if PlayerCreationGUI.creationTable[i].type == 'circle' then
            PlayerCreationGUI.creationTable[i].type = 'empty'
            PlayerCreationGUI.circleBox:addBlock(1)
        elseif PlayerCreationGUI.creationTable[i].type == 'triangle' then
            PlayerCreationGUI.creationTable[i].type = 'empty'
            PlayerCreationGUI.triangleBox:addBlock(1)
        elseif PlayerCreationGUI.creationTable[i].type == 'square' then
            PlayerCreationGUI.creationTable[i].type = 'empty'
            PlayerCreationGUI.squareBox:addBlock(1)
        end
    end
end

function PlayerCreationGUI:init()
    PlayerCreationGUI.buttonsBoard = ButtonsBoard()

    PlayerCreationGUI.circleBox = BlockBox()
    PlayerCreationGUI.circleBox.x = 475
    PlayerCreationGUI.circleBox.y = 140
    PlayerCreationGUI.circleBox:setBlockImage('circle')

    PlayerCreationGUI.triangleBox = BlockBox()
    PlayerCreationGUI.triangleBox.x = 475
    PlayerCreationGUI.triangleBox.y = 250
    PlayerCreationGUI.triangleBox:setBlockImage('triangle')

    PlayerCreationGUI.squareBox = BlockBox()
    PlayerCreationGUI.squareBox.x = 475
    PlayerCreationGUI.squareBox.y = 360
    PlayerCreationGUI.squareBox:setBlockImage('square')

    PlayerCreationGUI.makePlayerButton = GUIButton()
    PlayerCreationGUI.makePlayerButton.x = 675
    PlayerCreationGUI.makePlayerButton.y = 520
    PlayerCreationGUI.makePlayerButton.image.UI = PlayerCreationGUI.image.complete
    PlayerCreationGUI.makePlayerButton:setButtonFunction(completePlayerCreation)

    PlayerCreationGUI.deletePlayerButton = GUIButton()
    PlayerCreationGUI.deletePlayerButton.x = 565
    PlayerCreationGUI.deletePlayerButton.y = 520
    PlayerCreationGUI.deletePlayerButton.image.UI = PlayerCreationGUI.image.delete
    PlayerCreationGUI.deletePlayerButton:setButtonFunction(deletePlayerCreation)

    PlayerCreationGUI.resetPlayerButton = GUIButton()
    PlayerCreationGUI.resetPlayerButton.x = 455
    PlayerCreationGUI.resetPlayerButton.y = 520
    PlayerCreationGUI.resetPlayerButton.image.UI = PlayerCreationGUI.image.reset
    PlayerCreationGUI.resetPlayerButton.imageOffset.rate = 1.2
    PlayerCreationGUI.resetPlayerButton.imageOffset.x = -2
    PlayerCreationGUI.resetPlayerButton.imageOffset.neutral = -8
    PlayerCreationGUI.resetPlayerButton:setButtonFunction(resetPlayerCreation)
    
    -- ブロックの基準ピクセル数
    PlayerCreationGUI.standardBlockPixel = 80
    -- 実際のブロックのピクセル数
    PlayerCreationGUI.realBlockPixel = 40
    -- ブロックの画像拡大率
    PlayerCreationGUI.blockImageRate = PlayerCreationGUI.standardBlockPixel / PlayerCreationGUI.realBlockPixel
    -- テーブルの基準ピクセル数
    PlayerCreationGUI.standardTablePixel = 80
    -- 実際のテーブルのピクセル数
    PlayerCreationGUI.realTablePixel = 120
    -- テーブルの画像拡大率
    PlayerCreationGUI.tableImageRate = PlayerCreationGUI.standardTablePixel / PlayerCreationGUI.realTablePixel

    -- プレイヤーを配置できるテーブルのサイズ
    PlayerCreationGUI.max_tableSize_x = 4
    PlayerCreationGUI.max_tableSize_y = 3

    -- テーブル幅
    PlayerCreationGUI.tableWidth = PlayerCreationGUI.standardTablePixel
    PlayerCreationGUI.tableHeight = PlayerCreationGUI.standardTablePixel

    -- テーブルの原点座標
    PlayerCreationGUI.table_x = (400 - PlayerCreationGUI.tableWidth * PlayerCreationGUI.max_tableSize_x) / 2 - PlayerCreationGUI.tableWidth
    PlayerCreationGUI.table_y = (600 - PlayerCreationGUI.tableHeight * PlayerCreationGUI.max_tableSize_y) / 2 - PlayerCreationGUI.tableHeight

    -- マウスの状態
    PlayerCreationGUI.state = 'neutral'

    --シーン遷移してくるときのアニメーションが行われるフレーム
    PlayerCreationGUI.animationFlameTime = 48
    --タイマー
    PlayerCreationGUI.animationFlameTimer = 0


    -- for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
    --     print(i..'x: '..PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * math.floor((i-1) % PlayerCreationGUI.max_tableSize_y)
    -- ..'y: '..PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * math.floor((i-1) / PlayerCreationGUI.max_tableSize_x))
    -- end

    PlayerCreationGUI.creationTable = {{x = 0, y = 0, type = 'empty'}}
    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        PlayerCreationGUI.creationTable[i] = PlayerCreationGUI.creationTable[i] or {}
        PlayerCreationGUI.creationTable[i].x = ((i - 1) % PlayerCreationGUI.max_tableSize_x) + 1
        PlayerCreationGUI.creationTable[i].y = (math.floor((i - 1) / PlayerCreationGUI.max_tableSize_x)) + 1
        PlayerCreationGUI.creationTable[i].type = 'empty'
    end

    PlayerCreationGUI.creationTable[PlayerCreationGUI.max_tableSize_x * (PlayerCreationGUI.max_tableSize_y - 1) +
        math.floor(PlayerCreationGUI.max_tableSize_x / 2)].type = 'playerCore'
end

function PlayerCreationGUI:enter()
end

function PlayerCreationGUI:setBlock(infoTable)
    PlayerCreationGUI.circleBox:addBlock(infoTable.circle)
    PlayerCreationGUI.squareBox:addBlock(infoTable.square)
end

function PlayerCreationGUI:update(dt)

    if mouseManager.isReleased then
        PlayerCreationGUI:ReleaseMouse()
    end
    PlayerCreationGUI.circleBox:update(dt)
    PlayerCreationGUI.triangleBox:update(dt)
    PlayerCreationGUI.squareBox:update(dt)
    PlayerCreationGUI.makePlayerButton:update(dt)
    PlayerCreationGUI.deletePlayerButton:update(dt)
    PlayerCreationGUI.resetPlayerButton:update(dt)

end

function PlayerCreationGUI:ReleaseMouse() -- マウスを離したときの関数

    if PlayerCreationGUI.catchedItem == 'empty' then -- 自分が何も持っていないとき
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type ~= 'empty' and PlayerCreationGUI.creationTable[i].type ~=
                'playerCore' then
                PlayerCreationGUI:swapMouseandTable(i)
                break
            end
        end
    elseif PlayerCreationGUI.catchedItem ~= 'empty' then -- 自分がブロックを持っているとき
        local deleteBlock = true
        local blockType = PlayerCreationGUI.catchedItem
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type == 'empty' then
                PlayerCreationGUI:setItemInTable(i)
                deleteBlock = false
                break
            elseif PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type ~= 'empty' and PlayerCreationGUI.creationTable[i].type ~=
                'playerCore' then
                PlayerCreationGUI:swapMouseandTable(i)
                deleteBlock = false
                break
            elseif PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type == 'playerCore' then
                deleteBlock = false
                break
            end

        end
        if deleteBlock then
            PlayerCreationGUI.catchedItem = 'empty'
            if blockType == 'circle' then
                PlayerCreationGUI.circleBox:addBlock(1)
            elseif blockType == 'triangle' then
                PlayerCreationGUI.triangleBox:addBlock(1)
            elseif blockType == 'square' then
                PlayerCreationGUI.squareBox:addBlock(1)
            end
        end
    end
end

function PlayerCreationGUI:draw()

    love.graphics.draw(PlayerCreationGUI.image.background, 0, 0)

    PlayerCreationGUI.buttonsBoard:draw()
    PlayerCreationGUI.circleBox:draw()
    PlayerCreationGUI.triangleBox:draw()
    PlayerCreationGUI.squareBox:draw()
    PlayerCreationGUI.makePlayerButton:draw()
    PlayerCreationGUI.deletePlayerButton:draw()
    PlayerCreationGUI.resetPlayerButton:draw()

    PlayerCreationGUI:drawTable()
    PlayerCreationGUI:drawBlock()

    PlayerCreationGUI:drawMouseItem()
    PlayerCreationGUI:inSceneAnimation()

    
    if PlayerCreationGUI.animationFlameTimer < PlayerCreationGUI.animationFlameTime then
        PlayerCreationGUI.animationFlameTimer = PlayerCreationGUI.animationFlameTimer + 1
        PlayerCreationGUI:inSceneAnimation()
    end
end

function PlayerCreationGUI:inSceneAnimation()
    -- love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 0,PlayerCreationGUI.animationFlameTimer*20,0,0.2,1)
    -- love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 160,PlayerCreationGUI.animationFlameTimer*(-20),0,0.2,1)
    -- love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 320,PlayerCreationGUI.animationFlameTimer*20,0,0.2,1)
    -- love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 480,PlayerCreationGUI.animationFlameTimer*(-20),0,0.2,1)
    -- love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 640,PlayerCreationGUI.animationFlameTimer*20,0,0.2,1)
    love.graphics.draw(PlayerCreationGUI.image.colormatBlack, 
    PlayerCreationGUI:calX_inSceneAnimation(PlayerCreationGUI:calRate_inSceneAnimation()),
    PlayerCreationGUI:calY_inSceneAnimation(PlayerCreationGUI:calRate_inSceneAnimation()),
    0,
    PlayerCreationGUI:calRate_inSceneAnimation(),
    PlayerCreationGUI:calRate_inSceneAnimation())
end

function PlayerCreationGUI:calRate_inSceneAnimation()
    local timer = PlayerCreationGUI.animationFlameTimer
    print(-(1/900) * (timer - 30) * (timer -30) - 1)
    return -(1/120) * timer * timer + 1
end

function PlayerCreationGUI:calX_inSceneAnimation(rate)
    if rate > 0 then
        local size = 800 * rate
        return 400 - (size/2)
    else
        return 0
    end
end

function PlayerCreationGUI:calY_inSceneAnimation(rate)
    if rate > 0 then
        local size = 600 * rate
        return 300 - (size/2)
    else
        return 0
    end
end

function PlayerCreationGUI:drawTable()

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        love.graphics.draw(PlayerCreationGUI.image.table, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                           PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.tableImageRate,
                           PlayerCreationGUI.tableImageRate)
    end
end

function PlayerCreationGUI:drawBlock()
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        if PlayerCreationGUI.creationTable[i].type == 'circle' then
            love.graphics.draw(PlayerCreationGUI.image.circle, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.blockImageRate,
                               PlayerCreationGUI.blockImageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'triangle' then
            love.graphics.draw(PlayerCreationGUI.image.triangle,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.blockImageRate,
                               PlayerCreationGUI.blockImageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'square' then
            love.graphics.draw(PlayerCreationGUI.image.square, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.blockImageRate,
                               PlayerCreationGUI.blockImageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'playerCore' then
            love.graphics.draw(PlayerCreationGUI.image.playerCore,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0,2,2)
        elseif PlayerCreationGUI:isTouchedTable(i) then
            love.graphics.draw(PlayerCreationGUI.image.selectedTable,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.blockImageRate,
                               PlayerCreationGUI.blockImageRate)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:drawMouseItem()
    if PlayerCreationGUI.catchedItem == 'circle' then
        love.graphics.draw(PlayerCreationGUI.image.circle, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.blockImageRate / 2,
                           PlayerCreationGUI.blockImageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'triangle' then
        love.graphics.draw(PlayerCreationGUI.image.triangle, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.blockImageRate / 2,
                           PlayerCreationGUI.blockImageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'square' then
        love.graphics.draw(PlayerCreationGUI.image.square, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.blockImageRate / 2,
                           PlayerCreationGUI.blockImageRate / 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:isTouchedTable(i)
    return (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x) < mouseManager.x and
               (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x + PlayerCreationGUI.tableWidth) > mouseManager.x and
               (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y) < mouseManager.y and
               (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y + PlayerCreationGUI.tableHeight) >
               mouseManager.y
end

function PlayerCreationGUI:setItemInTable(i)
    PlayerCreationGUI.creationTable[i].type = PlayerCreationGUI.catchedItem
    PlayerCreationGUI.catchedItem = 'empty'
end

function PlayerCreationGUI:swapMouseandTable(i)
    local tmp = PlayerCreationGUI.creationTable[i].type
    PlayerCreationGUI.creationTable[i].type = PlayerCreationGUI.catchedItem
    PlayerCreationGUI.catchedItem = tmp
end

function PlayerCreationGUI:tutorial()
    PlayerCreationGUI.circleBox:addBlock(3)
    PlayerCreationGUI.triangleBox:addBlock(3)
    PlayerCreationGUI.squareBox:addBlock(3)
end


function PlayerCreationGUI:delete()
    PlayerCreationGUI.buttonsBoard:delete()
    playerCreationGUI.circleBox:delete()
    playerCreationGUI.triangleBox:delete()
    playerCreationGUI.squareBox:delete()
    PlayerCreationGUI.makePlayerButton:delete()
    PlayerCreationGUI.deletePlayerButton:delete()
    PlayerCreationGUI.resetPlayerButton:delete()
    self = nil
end

return PlayerCreationGUI
