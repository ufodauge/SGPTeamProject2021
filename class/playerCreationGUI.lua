PlayerCreationGUI = Class('PlayerCreationGUI')

PlayerCreationGUI.catchedItem = 'empty'
PlayerCreationGUI.image = {}
PlayerCreationGUI.image.background = love.graphics.newImage('resource//GUIBackground.png')
PlayerCreationGUI.image.table = love.graphics.newImage('resource//flame.png')
PlayerCreationGUI.image.selectedTable = love.graphics.newImage('resource//selectedTable.png')
PlayerCreationGUI.image.circle = love.graphics.newImage('resource//circle.png')
PlayerCreationGUI.image.triangle = love.graphics.newImage('resource//triangle.png')
PlayerCreationGUI.image.square = love.graphics.newImage('resource//square.png')
PlayerCreationGUI.image.playerCore = love.graphics.newImage('resource//player.png')

-- プレイヤー作成を完了する処理
local function completePlayerCreation()
    State.pop(PlayerCreationGUI:getArrangedTable())
    print('complete')
end

-- プレイヤー作成を破棄する処理
local function deletePlayerCreation()
    State.pop({})
    print('delete')
end

-- プレイヤー作成をリセットする処理
local function resetPlayerCreation()
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
    PlayerCreationGUI.makePlayerButton.text = 'MAKE'
    PlayerCreationGUI.makePlayerButton:setButtonFunction(completePlayerCreation)

    PlayerCreationGUI.deletePlayerButton = GUIButton()
    PlayerCreationGUI.deletePlayerButton.x = 565
    PlayerCreationGUI.deletePlayerButton.y = 520
    PlayerCreationGUI.deletePlayerButton.text = 'DEL'
    PlayerCreationGUI.deletePlayerButton.textOffset.x = 4
    PlayerCreationGUI.deletePlayerButton:setButtonFunction(deletePlayerCreation)

    PlayerCreationGUI.resetPlayerButton = GUIButton()
    PlayerCreationGUI.resetPlayerButton.x = 455
    PlayerCreationGUI.resetPlayerButton.y = 520
    PlayerCreationGUI.resetPlayerButton.text = 'RESET'
    PlayerCreationGUI.resetPlayerButton.textOffset.x = -3
    PlayerCreationGUI.resetPlayerButton:setButtonFunction(resetPlayerCreation)

    -- テーブルおよびブロックの画像拡大率
    PlayerCreationGUI.imageRate = 2

    -- プレイヤーを配置できるテーブルのサイズ
    PlayerCreationGUI.max_tableSize_x = 4
    PlayerCreationGUI.max_tableSize_y = 3

    -- テーブル幅
    PlayerCreationGUI.tableWidth = 40 * PlayerCreationGUI.imageRate
    PlayerCreationGUI.tableHeight = 40 * PlayerCreationGUI.imageRate

    -- テーブルの原点座標
    PlayerCreationGUI.table_x = (400 - PlayerCreationGUI.tableWidth * PlayerCreationGUI.max_tableSize_x) / 2 - PlayerCreationGUI.tableWidth
    PlayerCreationGUI.table_y = (600 - PlayerCreationGUI.tableHeight * PlayerCreationGUI.max_tableSize_y) / 2 - PlayerCreationGUI.tableHeight

    -- マウスの状態
    PlayerCreationGUI.state = 'neutral'

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

    -- love.graphics.draw(PlayerCreationGUI.image.circle,0,0)

end

function PlayerCreationGUI:drawTable()

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        love.graphics.draw(PlayerCreationGUI.image.table, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                           PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                           PlayerCreationGUI.imageRate)
    end
end

function PlayerCreationGUI:drawBlock()
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        if PlayerCreationGUI.creationTable[i].type == 'circle' then
            love.graphics.draw(PlayerCreationGUI.image.circle, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                               PlayerCreationGUI.imageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'triangle' then
            love.graphics.draw(PlayerCreationGUI.image.triangle,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                               PlayerCreationGUI.imageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'square' then
            love.graphics.draw(PlayerCreationGUI.image.square, PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                               PlayerCreationGUI.imageRate)
        elseif PlayerCreationGUI.creationTable[i].type == 'playerCore' then
            love.graphics.draw(PlayerCreationGUI.image.playerCore,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                               PlayerCreationGUI.imageRate)
        elseif PlayerCreationGUI:isTouchedTable(i) then
            love.graphics.draw(PlayerCreationGUI.image.selectedTable,
                               PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
                               PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, 0, PlayerCreationGUI.imageRate,
                               PlayerCreationGUI.imageRate)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:drawMouseItem()
    love.graphics.setColor(1, 1, 1, 1)
    if PlayerCreationGUI.catchedItem == 'circle' then
        love.graphics.draw(PlayerCreationGUI.image.circle, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.imageRate / 2,
                           PlayerCreationGUI.imageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'triangle' then
        love.graphics.draw(PlayerCreationGUI.image.triangle, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.imageRate / 2,
                           PlayerCreationGUI.imageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'square' then
        love.graphics.draw(PlayerCreationGUI.image.square, mouseManager.x - 15, mouseManager.y - 15, 0, PlayerCreationGUI.imageRate / 2,
                           PlayerCreationGUI.imageRate / 2)
    end
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

function PlayerCreationGUI:getArrangedTable()
    local arrangedTable = {}

    for index, tbl in ipairs(PlayerCreationGUI.creationTable) do
        if tbl.type ~= 'empty' and tbl.type ~= 'playerCore' then
            table.insert(arrangedTable, {type = tbl.type, x = tbl.x, y = tbl.y})
        end
    end

    return arrangedTable
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
