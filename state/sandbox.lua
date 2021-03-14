local sandbox = {}

sandbox.name = 'sandbox'

function sandbox:init()
    world:addCollisionClass('Player')
    world:addCollisionClass('Collectable')
    world:addCollisionClass('Removed', {ignores = {'Removed'}})
    world:addCollisionClass('Goal')
end

function sandbox:enter()
    player = Player(100, 500)
    groundTest = Ground(0, 580, 800, 80)
    goalTest = Goal(700, 500)

    square = Square(400, 200)

    player:addNewObject(1, 'square', 100 + 50, 500 - 50)
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
