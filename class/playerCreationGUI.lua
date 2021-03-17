local playerCreationGUI = Instance:extend('PlayerCreationGUI')

playerCreationGUI.catchedItem = 'empty'

function playerCreationGUI:init()
    self.super:init(self)

    self.circleBox = BlockBox();
    self.circleBox.x = 500
    self.circleBox.y = 300
    print('call')

    -- プレイヤーを配置できるテーブルのサイズ
    self.max_tableSize_x = 4
    self.max_tableSize_y = 3

    -- テーブル原点座標
    self.table_x = 50
    self.table_y = 50

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
end

function playerCreationGUI:ReleaseMouse() -- マウスを離したときの関数

    if self.catchedItem == 'empty' then -- 自分が何も持っていないとき
        for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
            if self:isTouchedTable(i) and self.creationTable[i].type == 'circle' then
                self:swapMouseandTable(i)
                break
            end
        end
    elseif self.catchedItem == 'circle' then -- 自分がブロックを持っているとき
        local deleteBlock = true
        for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
            if self:isTouchedTable(i) and self.creationTable[i].type == 'empty' then
                self:setItemInTable(i)
                deleteBlock = false
                break
            elseif self:isTouchedTable(i) and (self.creationTable[i].type == 'playerCore' or self.creationTable[i].type == 'circle') then
                deleteBlock = false
                break
            end
        end
        if deleteBlock then
            self.catchedItem = 'empty'
        end
    end
end

function playerCreationGUI:draw()
    self:drawTable()
    self:drawMouseItem()

end

function playerCreationGUI:drawTable()
    self:drawBlock()

    for i = 1, self.max_tableSize_x + 1, 1 do
        love.graphics.line(self.table_x + self.tableWidth * (i - 1) + self.table_x / 2, self.table_y + self.table_y / 2,
                           self.table_x + self.tableWidth * (i - 1) + self.table_x / 2,
                           self.table_y + self.tableHeight * self.max_tableSize_y + self.table_y / 2)
    end
    for i = 1, self.max_tableSize_y + 1, 1 do
        love.graphics.line(self.table_x + self.table_x / 2, self.table_y + self.tableHeight * (i - 1) + self.table_y / 2,
                           self.table_x + self.tableWidth * self.max_tableSize_x + self.table_x / 2,
                           self.table_y + self.tableHeight * (i - 1) + self.table_y / 2)
    end
end

function playerCreationGUI:drawBlock()

    for i = 1, self.max_tableSize_x * self.max_tableSize_y, 1 do
        if self.creationTable[i].type == 'circle' then
            love.graphics.setColor(0, 0, 1, 1)
        elseif self.creationTable[i].type == 'playerCore' then
            love.graphics.setColor(1, 0, 0, 1)
        elseif self:isTouchedTable(i) then
            love.graphics.setColor(1, 1, 1, 0.7)
        else
            love.graphics.setColor(1, 1, 1, 0.3)
        end
        love.graphics.circle('fill', self.table_x + self.tableWidth * self.creationTable[i].x, self.table_y + self.tableHeight * self.creationTable[i].y,
                             self.tableWidth / 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function playerCreationGUI:drawMouseItem()
    love.graphics.setColor(0, 0, 0.5, 1)
    if self.catchedItem == 'circle' then
        love.graphics.circle('fill', mouseManager.x, mouseManager.y, self.tableWidth / 3)
    end
end

function playerCreationGUI:isTouchedTable(i)
    return (self.table_x + self.tableWidth * self.creationTable[i].x - self.tableWidth / 2) < mouseManager.x and
               (self.table_x + self.tableWidth * self.creationTable[i].x + self.tableWidth / 2) > mouseManager.x and
               (self.table_y + self.tableHeight * self.creationTable[i].y - self.tableHeight / 2) < mouseManager.y and
               (self.table_y + self.tableHeight * self.creationTable[i].y + self.tableHeight / 2) > mouseManager.y
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

function playerCreationGUI:delete()
    self.circleBox:delete()
    self.super.delete(self)
end

return playerCreationGUI
