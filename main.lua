-- debug
lovebird = require 'lovebird'
lume = require 'lume'

-- data
Data = {}
Data.Font = require 'data.font'
Data.Background = require 'data.background'

-- library
Class = require '30log.30log'
Camera = require 'hump.camera'
State = require 'hump.gamestate'
Const = require 'const.const'
Windfield = require 'windfield'

-- defines
require 'data.defines'

-- state
States = {}
States.Dummy = require 'state.dummy'
States.Sandbox = require 'state.sandbox'
States.Menu = require 'state.menu'
States.Levels = require 'state.level'

-- Debug
Debug = require 'class.debug.debug'

-- class
Instance = require 'class.Instance.instance'
KeyManager = require 'class.keyManager'
JoystickManager = require 'class.joystickManager'
AnimationManager = require 'class.animationManager'
InfomationManager = require 'class.infomationManager'

Player = require 'class.player'
Ground = require 'class.ground'
Goal = require 'class.goal'
Square = require 'class.square'

function love.load()
    -- デバッグモードの有効化の際は true を渡すこと
    debug = Debug(true)

    world = Windfield.newWorld(0, 0, true)
    world:setGravity(0, 512)

    State.registerEvents()
    State.switch(States.Sandbox)
end

function love.update(dt)
    -- debug
    lovebird.update()
    debug:update(dt)
    -- debug

    Instance:update(dt)
    world:update(dt)
end

function love.draw()
    -- debug
    debug.free_camera:attach()
    Instance:draw()
    debug.free_camera:detach()

    -- debug
    debug:draw()
    world:draw(128)
    -- debug
end
