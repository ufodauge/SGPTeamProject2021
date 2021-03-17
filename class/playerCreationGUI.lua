PlayerCreationGUI = Class('PlayerCreationGUI')

PlayerCreationGUI.catchedItem = 'empty'
PlayerCreationGUI.image = {}
PlayerCreationGUI.image.background = love.graphics.newImage('resource/GUIBackground.png')
PlayerCreationGUI.image.table = love.graphics.newImage('resource/flame.png')
PlayerCreationGUI.image.selectedTable = love.graphics.newImage('resource/selectedTable.png')
PlayerCreationGUI.image.circle = love.graphics.newImage('resource/circle40.png')
PlayerCreationGUI.image.triangle = love.graphics.newImage('resource/triangle40.png')
PlayerCreationGUI.image.square = love.graphics.newImage('resource/square40.png')
PlayerCreationGUI.image.playerCore = love.graphics.newImage('resource/protagonist_take1.png')

function PlayerCreationGUI:init()
    

    PlayerCreationGUI.buttonsBoard = ButtonsBoard()

    PlayerCreationGUI.circleBox = BlockBox();
    PlayerCreationGUI.circleBox.x = 475
    PlayerCreationGUI.circleBox.y = 140
    PlayerCreationGUI.circleBox:setBlockImage('circle')
    PlayerCreationGUI.circleBox:addBlock(3)
    --PlayerCreationGUI.circleBox:setPriority(3)

    PlayerCreationGUI.triangleBox = BlockBox();
    PlayerCreationGUI.triangleBox.x = 475
    PlayerCreationGUI.triangleBox.y = 250
    PlayerCreationGUI.triangleBox:setBlockImage('triangle')
    PlayerCreationGUI.triangleBox:addBlock(3)

    PlayerCreationGUI.squareBox = BlockBox();
    PlayerCreationGUI.squareBox.x = 475
    PlayerCreationGUI.squareBox.y = 360
    PlayerCreationGUI.squareBox:setBlockImage('square')
    PlayerCreationGUI.squareBox:addBlock(3)
    

    --テーブルおよびブロックの画像拡大率
    PlayerCreationGUI.imageRate = 2
    
    --プレイヤーを配置できるテーブルのサイズ
    PlayerCreationGUI.max_tableSize_x = 4
    PlayerCreationGUI.max_tableSize_y = 3

    --テーブル幅
    PlayerCreationGUI.tableWidth = 40 * PlayerCreationGUI.imageRate
    PlayerCreationGUI.tableHeight = 40 * PlayerCreationGUI.imageRate

    --テーブルの原点座標
    PlayerCreationGUI.table_x = (400 - PlayerCreationGUI.tableWidth * PlayerCreationGUI.max_tableSize_x) / 2 - PlayerCreationGUI.tableWidth
    PlayerCreationGUI.table_y = (600 - PlayerCreationGUI.tableHeight * PlayerCreationGUI.max_tableSize_y) / 2 - PlayerCreationGUI.tableHeight

    -- テーブル幅
    self.tableWidth = 50
    self.tableHeight = 50

    
    -- マウスの状態
    self.state = 'neutral'

    for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
        print(i .. 'x: ' .. self.table_x + self.tableWidth * math.floor((i - 1) % self.max_tableSize_y) .. 'y: ' .. self.table_y + self.tableHeight *
                  math.floor((i - 1) / self.max_tableSize_x))
    end

    self.creationTable = {{x = 0, y = 0, type = 'empty'}}
    for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
        self.creationTable[i] = self.creationTable[i] or {}
        self.creationTable[i].x = ((i - 1) % self.max_tableSize_x) + 1
        self.creationTable[i].y = (math.floor((i - 1) / self.max_tableSize_x)) + 1
        self.creationTable[i].type = 'empty'
    end

    self.creationTable[self.max_tableSize_x * (self.max_tableSize_y - 1) + math.floor(self.max_tableSize_x / 2)].type = 'playerCore'
end

function playerCreationGUI:update(dt)
    if mouseManager.isReleased then
        self:ReleaseMouse()
    end
    PlayerCreationGUI.circleBox:update(dt)
    playerCreationGUI.triangleBox:update(dt)
    playerCreationGUI.squareBox:update(dt)
end

function playerCreationGUI:ReleaseMouse() -- マウスを離したときの関数


    if PlayerCreationGUI.catchedItem == 'empty' then --自分が何も持っていないとき
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type ~= 'empty' and PlayerCreationGUI.creationTable[i].type ~= 'playerCore' then
                PlayerCreationGUI:swapMouseandTable(i)
                break
            end
        end
    elseif PlayerCreationGUI.catchedItem ~= 'empty'then --自分がブロックを持っているとき
        local deleteBlock = true
        local blockType = PlayerCreationGUI.catchedItem
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type == 'empty' then
                PlayerCreationGUI:setItemInTable(i)
                deleteBlock = false
                break
            elseif PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type ~= 'empty' and PlayerCreationGUI.creationTable[i].type ~= 'playerCore' then
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
            self.catchedItem = 'empty'
        end
    end
end

function PlayerCreationGUI:draw()

    love.graphics.draw(PlayerCreationGUI.image.background,0,0)

    PlayerCreationGUI.buttonsBoard:draw()
    PlayerCreationGUI.circleBox:draw()
    playerCreationGUI.triangleBox:draw()
    playerCreationGUI.squareBox:draw()
    
    PlayerCreationGUI:drawTable()
    PlayerCreationGUI:drawBlock()

    PlayerCreationGUI:drawMouseItem()
    
    --love.graphics.draw(PlayerCreationGUI.image.circle,0,0)
    
end

function PlayerCreationGUI:drawTable()

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        love.graphics.draw(PlayerCreationGUI.image.table,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
    end
end

function PlayerCreationGUI:drawBlock()
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        if PlayerCreationGUI.creationTable[i].type == 'circle' then
            love.graphics.draw(PlayerCreationGUI.image.circle,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
        elseif PlayerCreationGUI.creationTable[i].type == 'triangle' then
            love.graphics.draw(PlayerCreationGUI.image.triangle,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
        elseif PlayerCreationGUI.creationTable[i].type == 'square' then
            love.graphics.draw(PlayerCreationGUI.image.square,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
        elseif PlayerCreationGUI.creationTable[i].type == 'playerCore' then
            love.graphics.draw(PlayerCreationGUI.image.playerCore,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
        elseif PlayerCreationGUI:isTouchedTable(i) then
            love.graphics.draw(PlayerCreationGUI.image.selectedTable,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
            PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y,
            0,PlayerCreationGUI.imageRate,PlayerCreationGUI.imageRate
            )
        end
    end
end

function PlayerCreationGUI:drawMouseItem()
    if PlayerCreationGUI.catchedItem == 'circle' then
        love.graphics.draw(PlayerCreationGUI.image.circle, MouseManager.x - 15, MouseManager.y - 15,
            0, PlayerCreationGUI.imageRate/2, PlayerCreationGUI.imageRate/2
            )
    elseif PlayerCreationGUI.catchedItem == 'triangle' then
            love.graphics.draw(PlayerCreationGUI.image.triangle, MouseManager.x - 15, MouseManager.y - 15,
            0, PlayerCreationGUI.imageRate/2, PlayerCreationGUI.imageRate/2
            )
    elseif PlayerCreationGUI.catchedItem == 'square' then
        love.graphics.draw(PlayerCreationGUI.image.square, MouseManager.x - 15, MouseManager.y - 15,
        0, PlayerCreationGUI.imageRate/2, PlayerCreationGUI.imageRate/2
        )
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:isTouchedTable(i)
    return  (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x) < MouseManager.x and
            (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x + PlayerCreationGUI.tableWidth) > MouseManager.x and
            (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y) < MouseManager.y and
            (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y + PlayerCreationGUI.tableHeight) > MouseManager.y 

-- function playerCreationGUI:isTouchedTable(i)
--     return (self.table_x + self.tableWidth * self.creationTable[i].x - self.tableWidth / 2) < mouseManager.x and
--                (self.table_x + self.tableWidth * self.creationTable[i].x + self.tableWidth / 2) > mouseManager.x and
--                (self.table_y + self.tableHeight * self.creationTable[i].y - self.tableHeight / 2) < mouseManager.y and
--                (self.table_y + self.tableHeight * self.creationTable[i].y + self.tableHeight / 2) > mouseManager.y
-- >>>>>>> devAgdf
end

function playerCreationGUI:setItemInTable(i)
    self.creationTable[i].type = self.catchedItem
    self.catchedItem = 'empty'
end

function playerCreationGUI:swapMouseandTable(i)
    local tmp = self.creationTable[i].type
    self.creationTable[i].type = self.catchedItem
    self.catchedItem = tmp
end

function PlayerCreationGUI:delete()
    playerCreationGUI.circleBox:delete()
    self = nil

end

return playerCreationGUI
