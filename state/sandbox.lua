local sandbox = {}

sandbox.name = 'sandbox'

function sandbox:init()
end

function sandbox:enter()
    player = Player(100, 500)
    groundTest = Ground(0, 580, 800, 80)
end

function sandbox:update(dt)
end

function sandbox:draw()
end

function sandbox:leave()
    player:delete()
    groundTest:delete()
end

return sandbox
