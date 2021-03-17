local sandbox = {}

sandbox.name = 'sandbox'

function sandbox:init()
end

function sandbox:enter()
    player = Player(100, 500)
    groundTest = Ground(0, 580, 800, 80)
    goalTest = Goal(700, 500)

    square = Square(400, 200)
    triangle1 = Triangle(500, 200, 0)
    triangle2 = Triangle(600, 200, math.pi / 3)

    player:addNewObject(1, 'square', 100 + 50, 500 - 50)
end

function sandbox:update(dt)
end

function sandbox:draw()
end

function sandbox:leave()
    player:delete()
    groundTest:delete()
    goalTest:delete()

    square:delete()
    triangle1:delete()
    triangle2:delete()
end

return sandbox
