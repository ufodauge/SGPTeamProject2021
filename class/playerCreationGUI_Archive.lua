PlayerCreationGUI = Class('PlayerCreationGUI')

PlayerCreationGUI.catchedItem = 'empty'
PlayerCreationGUI.image = {}
PlayerCreationGUI.image.background = love.graphics.newImage('resource/GUIBackground.png')
PlayerCreationGUI.image.table = love.graphics.newImage('resource/flame.png')
-- PlayerCreationGUI.image.selectedTable = love.graphics.newImage('resource/selectedTable.png')
PlayerCreationGUI.image.circle = love.graphics.newImage('resource/circle40.png')
PlayerCreationGUI.image.triangle = love.graphics.newImage('resource/triangle40.png')
PlayerCreationGUI.image.square = love.graphics.newImage('resource/square40.png')
PlayerCreationGUI.image.playerCore = love.graphics.newImage('resource/protagonist_take1.png')

function PlayerCreationGUI:init()

    self.buttonsBoard = ButtonsBoard()

    self.circleBox = BlockBox();
    self.circleBox.x = 475
    self.circleBox.y = 140
    self.circleBox:setBlockImage('circle')
    self.circleBox:addBlock(3)
    -- self.circleBox:setPriority(3)

    self.triangleBox = BlockBox();
    self.triangleBox.x = 475
    self.triangleBox.y = 250
    self.triangleBox:setBlockImage('triangle')
    self.triangleBox:addBlock(3)

    self.squareBox = BlockBox();
    self.squareBox.x = 475
    self.squareBox.y = 360
    self.squareBox:setBlockImage('square')
    self.squareBox:addBlock(3)

    -- テーブルおよびブロックの画像拡大率
    self.imageRate = 2

    -- プレイヤーを配置できるテーブルのサイズ
    self.max_tableSize_x = 4
    self.max_tableSize_y = 3

    -- テーブル幅
    self.tableWidth = 40 * self.imageRate
    self.tableHeight = 40 * self.imageRate

    -- テーブルの原点座標
    self.table_x = (400 - self.tableWidth * self.max_tableSize_x) / 2 - self.tableWidth
    self.table_y = (600 - self.tableHeight * self.max_tableSize_y) / 2 - self.tableHeight

    -- テーブル幅
    self.tableWidth = 50
    self.tableHeight = 50

    -- for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
    --     print(i..'x: '..PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * math.floor((i-1) % PlayerCreationGUI.max_tableSize_y)
    -- ..'y: '..PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * math.floor((i-1) / PlayerCreationGUI.max_tableSize_x))
    -- end

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

function PlayerCreationGUI:update(dt)

    if mouseManager.isReleased then
        self:ReleaseMouse()
    end
    self.circleBox:update(dt)
    self.triangleBox:update(dt)
    self.squareBox:update(dt)
end

function PlayerCreationGUI:ReleaseMouse() -- マウスを離したときの関数

    if PlayerCreationGUI.catchedItem == 'empty' then -- 自分が何も持っていないとき
        for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
            if self:isTouchedTable(i) and self.creationTable[i].type ~= 'empty' and self.creationTable[i].type ~= 'playerCore' then
                self:swapMouseandTable(i)
                break
            end
        end
    elseif PlayerCreationGUI.catchedItem ~= 'empty' then -- 自分がブロックを持っているとき
        local deleteBlock = true
        local blockType = PlayerCreationGUI.catchedItem
        for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
            if self:isTouchedTable(i) and self.creationTable[i].type == 'empty' then
                self:setItemInTable(i)
                deleteBlock = false
                break
            elseif self:isTouchedTable(i) and self.creationTable[i].type ~= 'empty' and self.creationTable[i].type ~= 'playerCore' then
                self:swapMouseandTable(i)
                deleteBlock = false
                break
            elseif self:isTouchedTable(i) and self.creationTable[i].type == 'playerCore' then
                deleteBlock = false
                break
            end

        end
        if deleteBlock then
            PlayerCreationGUI.catchedItem = 'empty'
            if blockType == 'circle' then
                self.circleBox:addBlock(1)
            elseif blockType == 'triangle' then
                self.triangleBox:addBlock(1)
            elseif blockType == 'square' then
                self.squareBox:addBlock(1)
            end
        end
    end
end

function PlayerCreationGUI:draw()

    love.graphics.draw(PlayerCreationGUI.image.background, 0, 0)

    self.buttonsBoard:draw()
    self.circleBox:draw()
    self.triangleBox:draw()
    self.squareBox:draw()

    self:drawTable()
    self:drawBlock()

    self:drawMouseItem()

    -- love.graphics.draw(PlayerCreationGUI.image.circle,0,0)

end

function PlayerCreationGUI:drawTable()

    for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
        love.graphics.draw(PlayerCreationGUI.image.table, self.table_x + self.tableWidth * self.creationTable[i].x,
                           self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate, self.imageRate)
    end
end

function PlayerCreationGUI:drawBlock()
    love.graphics.setColor(1, 1, 1, 1)

    for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
        if self.creationTable[i].type == 'circle' then
            love.graphics.draw(PlayerCreationGUI.image.circle, self.table_x + self.tableWidth * self.creationTable[i].x,
                               self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate, self.imageRate)
        elseif self.creationTable[i].type == 'triangle' then
            love.graphics.draw(PlayerCreationGUI.image.triangle, self.table_x + self.tableWidth * self.creationTable[i].x,
                               self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate, self.imageRate)
        elseif self.creationTable[i].type == 'square' then
            love.graphics.draw(PlayerCreationGUI.image.square, self.table_x + self.tableWidth * self.creationTable[i].x,
                               self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate, self.imageRate)
        elseif self.creationTable[i].type == 'playerCore' then
            love.graphics.draw(PlayerCreationGUI.image.playerCore, self.table_x + self.tableWidth * self.creationTable[i].x,
                               self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate, self.imageRate)
        elseif self:isTouchedTable(i) then
            -- love.graphics.draw(PlayerCreationGUI.image.selectedTable,
            --                    self.table_x + self.tableWidth * self.creationTable[i].x,
            --                    self.table_y + self.tableHeight * self.creationTable[i].y, 0, self.imageRate,
            --                    self.imageRate)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:drawMouseItem()
    if PlayerCreationGUI.catchedItem == 'circle' then
        love.graphics.draw(PlayerCreationGUI.image.circle, mouseManager.x - 15, mouseManager.y - 15, 0, self.imageRate / 2, self.imageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'triangle' then
        love.graphics.draw(PlayerCreationGUI.image.triangle, mouseManager.x - 15, mouseManager.y - 15, 0, self.imageRate / 2, self.imageRate / 2)
    elseif PlayerCreationGUI.catchedItem == 'square' then
        love.graphics.draw(PlayerCreationGUI.image.square, mouseManager.x - 15, mouseManager.y - 15, 0, self.imageRate / 2, self.imageRate / 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:isTouchedTable(i)
    return (self.table_x + self.tableWidth * self.creationTable[i].x) < mouseManager.x and
               (self.table_x + self.tableWidth * self.creationTable[i].x + self.tableWidth) > mouseManager.x and
               (self.table_y + self.tableHeight * self.creationTable[i].y) < mouseManager.y and
               (self.table_y + self.tableHeight * self.creationTable[i].y + self.tableHeight) > mouseManager.y
end

function PlayerCreationGUI:setItemInTable(i)
    self.creationTable[i].type = PlayerCreationGUI.catchedItem
    PlayerCreationGUI.catchedItem = 'empty'
end

function PlayerCreationGUI:swapMouseandTable(i)
    local tmp = self.creationTable[i].type
    self.creationTable[i].type = self.catchedItem
    PlayerCreationGUI.catchedItem = tmp
end

function PlayerCreationGUI:delete()
    self.circleBox:delete()
    self = nil
end

return PlayerCreationGUI
