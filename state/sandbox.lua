local sandbox = {}

sandbox.name = 'sandbox'

function sandbox:init()
    world:addCollisionClass('Player')
    world:addCollisionClass('Collectable')
end

function sandbox:enter()
    player = Player(100, 500)
    groundTest = Ground(0, 580, 800, 80)

    square = Square(400, 200)
end

function sandbox:update(dt)
end

function sandbox:draw()
end

function sandbox:leave()
    player:delete()
    groundTest:delete()
    square:delete()
end

return sandbox
