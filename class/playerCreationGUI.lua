PlayerCreationGUI = Instance:extend('PlayerCreationGUI')

PlayerCreationGUI.catchedItem = 'empty'

function PlayerCreationGUI:init()
    PlayerCreationGUI.super:init(self)

    PlayerCreationGUI.circleBox = BlockBox();
    PlayerCreationGUI.circleBox.x = 500
    PlayerCreationGUI.circleBox.y = 300
    print('call')
    
    --プレイヤーを配置できるテーブルのサイズ
    PlayerCreationGUI.max_tableSize_x = 4
    PlayerCreationGUI.max_tableSize_y = 3

    --テーブル原点座標
    PlayerCreationGUI.table_x = 50
    PlayerCreationGUI.table_y = 50

    --テーブル幅
    PlayerCreationGUI.tableWidth = 50
    PlayerCreationGUI.tableHeight = 50

    --マウスの状態
    PlayerCreationGUI.state = 'neutral'

    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        print(i..'x: '..PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * math.floor((i-1) % PlayerCreationGUI.max_tableSize_y)
    ..'y: '..PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * math.floor((i-1) / PlayerCreationGUI.max_tableSize_x))
    end

    PlayerCreationGUI.creationTable = {
        {
            x = 0,
            y = 0,
            type = 'empty'
        }
    }
    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        PlayerCreationGUI.creationTable[i] = PlayerCreationGUI.creationTable[i] or {}
        PlayerCreationGUI.creationTable[i].x = ((i-1) % PlayerCreationGUI.max_tableSize_x) + 1
        PlayerCreationGUI.creationTable[i].y = (math.floor((i-1) / PlayerCreationGUI.max_tableSize_x)) + 1
        PlayerCreationGUI.creationTable[i].type = 'empty'
    end

    PlayerCreationGUI.creationTable[
        PlayerCreationGUI.max_tableSize_x * (PlayerCreationGUI.max_tableSize_y - 1) + math.floor(PlayerCreationGUI.max_tableSize_x/2)
        ].type = 'playerCore'
end

function PlayerCreationGUI:enter()
end

function PlayerCreationGUI:update(dt)
    if MouseManager.isReleased then
        PlayerCreationGUI:ReleaseMouse()
    end
end

function PlayerCreationGUI:ReleaseMouse() -- マウスを離したときの関数

    if PlayerCreationGUI.catchedItem == 'empty' then --自分が何も持っていないとき
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type == 'circle' then
                PlayerCreationGUI:swapMouseandTable(i)
                break
            end
        end
    elseif PlayerCreationGUI.catchedItem == 'circle' then --自分がブロックを持っているとき
        local deleteBlock = true
        for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
            if PlayerCreationGUI:isTouchedTable(i) and PlayerCreationGUI.creationTable[i].type == 'empty' then
                PlayerCreationGUI:setItemInTable(i)
                deleteBlock = false
                break
            elseif PlayerCreationGUI:isTouchedTable(i) and (PlayerCreationGUI.creationTable[i].type == 'playerCore' or PlayerCreationGUI.creationTable[i].type == 'circle') then
                deleteBlock = false
                break
            end
        end
        if deleteBlock then
            PlayerCreationGUI.catchedItem = 'empty'
        end
    end
end

function PlayerCreationGUI:draw()
    PlayerCreationGUI:drawTable()
    PlayerCreationGUI:drawMouseItem()
    
end

function PlayerCreationGUI:drawTable()
    PlayerCreationGUI:drawBlock()

    for i = 1, PlayerCreationGUI.max_tableSize_x + 1, 1 do
        love.graphics.line(
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * (i - 1) + PlayerCreationGUI.table_x/2, PlayerCreationGUI.table_y + PlayerCreationGUI.table_y/2,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * (i - 1) + PlayerCreationGUI.table_x/2, PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.max_tableSize_y + PlayerCreationGUI.table_y/2
        )
    end
    for i = 1, PlayerCreationGUI.max_tableSize_y + 1, 1 do
        love.graphics.line(
            PlayerCreationGUI.table_x + PlayerCreationGUI.table_x/2, PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * (i - 1) + PlayerCreationGUI.table_y/2,
            PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.max_tableSize_x + PlayerCreationGUI.table_x/2, PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * (i - 1) + PlayerCreationGUI.table_y/2
        )
    end
end

function PlayerCreationGUI:drawBlock()
    
    for i = 1, PlayerCreationGUI.max_tableSize_x * PlayerCreationGUI.max_tableSize_y, 1 do
        if PlayerCreationGUI.creationTable[i].type == 'circle' then
            love.graphics.setColor(0, 0, 1, 1)
        elseif PlayerCreationGUI.creationTable[i].type == 'playerCore' then
            love.graphics.setColor(1, 0, 0, 1)
        elseif PlayerCreationGUI:isTouchedTable(i) then
            love.graphics.setColor(1, 1, 1, 0.7)
        else
            love.graphics.setColor(1, 1, 1, 0.3)
        end
        love.graphics.circle("fill", PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x,
        PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y, PlayerCreationGUI.tableWidth/2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayerCreationGUI:drawMouseItem()
    love.graphics.setColor(0, 0, 0.5, 1)
    if PlayerCreationGUI.catchedItem == 'circle' then
        love.graphics.circle("fill", MouseManager.x, MouseManager.y, PlayerCreationGUI.tableWidth/3)
    end
end

function PlayerCreationGUI:isTouchedTable(i)
    return  (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x - PlayerCreationGUI.tableWidth/2) < MouseManager.x and
            (PlayerCreationGUI.table_x + PlayerCreationGUI.tableWidth * PlayerCreationGUI.creationTable[i].x + PlayerCreationGUI.tableWidth/2) > MouseManager.x and
            (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y - PlayerCreationGUI.tableHeight/2) < MouseManager.y and
            (PlayerCreationGUI.table_y + PlayerCreationGUI.tableHeight * PlayerCreationGUI.creationTable[i].y + PlayerCreationGUI.tableHeight/2) > MouseManager.y 
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

function PlayerCreationGUI:delete()
    playerCreationGUI.circleBox:delete()
    self.super:delete(self)
end

return PlayerCreationGUI