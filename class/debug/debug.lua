---------------------------------------
-- Debug
-- Q で表示および非表示を切り替え
---------------------------------------

-- リファクタリングをしろ

FrameCount = require 'class.debug.frame_count'
FreeCamera = require 'class.debug.camera'

local Debug = Class('Debug')

local framecount_x, framecount_y = 800, 5
local free_camera_x, free_camera_y = 800, 25

-- local functions
-- 影付きでテキスト出力
local function print_with_shadow(text, x, y)
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.print(text, x + 1, y + 1)
    love.graphics.print(text, x - 1, y + 1)
    love.graphics.print(text, x + 1, y - 1)
    love.graphics.print(text, x - 1, y - 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x, y)
end

-- returns current directory
local function getCurrentDirectory(this)
    local directory = this.list

    for i, name in ipairs(this.path) do
        if type(name) == type(1) then
            return directory
        end

        for j, dir in ipairs(directory) do
            if dir.name == name then
                directory = dir.contents
                break
            end
        end
    end
end

-- カーソルの移動
local function cursor_move(this, up_down)
    local dir = getCurrentDirectory(this)

    -- カーソルの上への移動
    if up_down == 'up' and this.path[#this.path] > 1 then
        this.path[#this.path] = this.path[#this.path] - 1
    end

    if up_down == 'down' and this.path[#this.path] < #dir then
        this.path[#this.path] = this.path[#this.path] + 1
    end
end

-- メニュー遷移処理
local function move_path(this, command)
    -- returns current path
    local dir = getCurrentDirectory(this)

    -- 現在指している場所がフォルダなら移動　末尾なら戻る
    if command == '..' then
        table.remove(this.path)
        table.remove(this.path)
        table.insert(this.path, 1)
    elseif dir[this.path[#this.path]].attribute == 'dir' then
        table.insert(this.path, dir[this.path[#this.path]].name)
        table.remove(this.path, #this.path - 1)
        table.insert(this.path, 1)
    end

    print('move_path:')
    for i, v in ipairs(this.path) do
        print(i, v)
    end
end

-- Debug functions
function Debug:init(valid)
    --
    -- if valid then
    --     State.registerEvents()
    --     State.switch(DebugState)
    -- end

    self.frame_count = FrameCount()
    self.free_camera = FreeCamera()

    -- インスタンス変数
    -- x, y:        座標
    -- valid:       デバッグメニューを有効化するか否か
    -- active:      スクリーン表示させるか否か
    -- list:        選択肢のリスト
    -- frame_count: フレームカウント
    -- index:       選択中のインデックス
    self.x, self.y = 20, 10
    self.valid = valid
    self.active = false

    self.list = {
        {
            attribute = 'dir',
            name = 'root',
            contents = {
                {
                    attribute = 'dir',
                    name = 'toggle',
                    contents = {
                        {
                            attribute = 'file',
                            name = 'frame_count',
                            contents = function()
                                self.toggle.frame_count = not self.toggle.frame_count
                            end
                        },
                        {
                            attribute = 'file',
                            name = 'free_camera',
                            contents = function()
                                -- self.toggle.free_camera = not self.toggle.free_camera
                                self.free_camera:toggle()
                            end
                        },
                        {
                            attribute = 'file',
                            name = 'return',
                            contents = function()
                                move_path(self, '..')
                            end
                        }
                    }
                },
                {
                    attribute = 'dir',
                    name = 'framecount',
                    contents = {
                        {
                            attribute = 'file',
                            name = 'reset',
                            contents = function()
                                self.frame_count:reset()
                            end
                        },
                        {
                            attribute = 'file',
                            name = 'stop',
                            contents = function()
                                self.frame_count:stop()
                            end
                        },
                        {
                            attribute = 'file',
                            name = 'start',
                            contents = function()
                                self.frame_count:start()
                            end
                        },
                        {
                            attribute = 'file',
                            name = 'return',
                            contents = function()
                                move_path(self, '..')
                            end
                        }
                    }
                },
                {
                    attribute = 'dir',
                    name = 'state',
                    contents = {}
                },
                {
                    attribute = 'file',
                    name = 'quit',
                    contents = function()
                        love.event.quit()
                    end
                },
                {
                    attribute = 'file',
                    name = 'return',
                    contents = function()
                        self:deactivate()
                    end
                }
            }
        }
    }

    for i, content in ipairs(self.list[1].contents) do
        if content.name == 'state' then
            for j, state in pairs(States) do
                table.insert(
                    content.contents,
                    {
                        attribute = 'file',
                        name = state.name,
                        contents = function()
                            -- if State.current() ~= state then
                            -- else
                            -- end
                            State.switch(state)
                        end
                    }
                )
            end
            table.insert(
                content.contents,
                {
                    attribute = 'file',
                    name = 'return',
                    contents = function()
                        move_path(self, '..')
                    end
                }
            )
        end
    end

    self.toggle = {
        frame_count = true
    }

    self.path = {
        'root',
        1
    }

    self.keys = KeyManager()
    self.keys:register(
        {
            {
                key = 'pageup',
                func = function()
                    -- 非表示の際は更新しない
                    if not self:is_active() then
                        return
                    end

                    -- 上方向への移動
                    cursor_move(self, 'up')
                end,
                rep = false,
                act = 'pressed'
            },
            {
                key = 'pagedown',
                func = function()
                    -- 非表示の際は更新しない
                    if not self:is_active() then
                        return
                    end

                    -- 下方向への移動
                    cursor_move(self, 'down')
                end,
                rep = false,
                act = 'pressed'
            },
            {
                key = 'end',
                func = function()
                    -- 非表示の際は更新しない
                    if not self:is_active() then
                        return
                    end

                    -- returns current dir
                    local dir = getCurrentDirectory(self)

                    -- 決定時の具体的な処理
                    if dir[self.path[#self.path]].attribute == 'file' then
                        dir[self.path[#self.path]].contents()
                    elseif dir[self.path[#self.path]].attribute == 'dir' then
                        move_path(self, self.path[#self.path])
                    end
                end,
                rep = false,
                act = 'pressed'
            },
            {
                key = 'home',
                func = function()
                    if self:is_active() then
                        self:deactivate()
                    else
                        self:activate()
                    end
                end,
                rep = false,
                act = 'pressed'
            }
        }
    )
end

function Debug:update(dt)
    -- デバッグメニューが無効ならば更新しない
    if not self:is_valid() then
        return
    end

    self.free_camera:update(dt)

    -- フレーム総数の更新
    self.frame_count:update(dt)

    self.keys:update(dt)
end

function Debug:draw()
    -- デバッグメニューが無効ならば描画しない
    if not self:is_valid() then
        return
    end

    love.graphics.setFont(Data.Font.debug)

    -- 現在のフレーム数を表示する
    if self.toggle.frame_count then
        print_with_shadow('frame: ' .. tostring(self.frame_count:getFrame()), framecount_x, framecount_y)
    end

    if self.free_camera:getActive() then
        local x, y = self.free_camera:getPosition()
        print_with_shadow('free camera: (' .. x .. ', ' .. y .. ')', free_camera_x, free_camera_y)
    end

    -- デバッグメニューを表示する
    if self:is_active() then
        -- returns current path
        local dir = getCurrentDirectory(self)

        -- 選択肢の表示
        for i, content in ipairs(dir) do
            print_with_shadow(content.name, self.x, self.y + Data.Font.size.debug * (i - 1))

            if self.path[#self.path] == i then
                print_with_shadow('>', self.x - 10, self.y + Data.Font.size.debug * (i - 1))
            end
        end
    end
end

-- デバッグメニューの有効・無効状態の取得
function Debug:is_valid()
    return self.valid
end

-- デバッグメニューの表示
function Debug:activate()
    self.active = true
end

-- デバッグメニューの非表示
function Debug:deactivate()
    self.active = false
end

-- デバッグメニューの表示状態を取得
function Debug:is_active()
    return self.active
end

return Debug
