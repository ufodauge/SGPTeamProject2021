-- debug
lovebird = require 'lovebird'

-- utility
lume = require 'lume'

-- data
Data = {}
Data.Font = require 'data.font'
Data.Background = require 'data.background'
-- Data.Image = require 'data.image'
Data.LevelsMetaData = require 'data.levelsMetaData'

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
States.Levels = require 'state.levels'
States.ArrangeCollider = require 'state.arrangeCollider'

-- Debug
Debug = require 'class.debug.debug'

-- class
Instance = require 'class.Instance.instance'
KeyManager = require 'class.keyManager'
JoystickManager = require 'class.joystickManager'
AnimationManager = require 'class.animationManager'
InfomationManager = require 'class.infomationManager'

Text = require 'class.text'

Player = require 'class.player'
Ground = require 'class.ground'
ChainGround = require 'class.chainground'
Goal = require 'class.goal'
Square = require 'class.square'
Triangle = require 'class.triangle'

-- SampleTimer = require 'class.sampletimer'
MouseManager = require 'class.mouseManager'
PlayerCreationGUI = require 'class.playerCreationGUI'
GUIBlock = require 'class.GUIBlock'
BlockBox = require 'class.BlockBox'

function love.load()
    -- デバッグモードの有効化の際は true を渡すこと
    debug = Debug(true)
    debug:changeFreeCameraConfig('direction_key')

    world = Windfield.newWorld(0, 0, true)
    world:setGravity(0, 512)

    world:addCollisionClass('Player')
    world:addCollisionClass('Collectable')
    world:addCollisionClass('Removed', {ignores = {'Removed'}})
    world:addCollisionClass('Goal')
    world:addCollisionClass('Ground')

    State.registerEvents()
    State.switch(States.ArrangeCollider)
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
    world:draw(128)
    debug.free_camera:detach()

    -- debug
    debug:draw()
    -- debug
end
