local AnimationManager = Class('AnimationManager')

function AnimationManager:init()
end

function AnimationManager:setTilesets(tilesets)
    self.width = tilesets.tilewidth
    self.height = tilesets.tileheight
    self.imagewidth = tilesets.imagewidth
    self.imageheight = tilesets.imageheight
    self.columns = tilesets.columns
    self.tilecount = tilesets.tilecount
    self.image = love.graphics.newImage(tilesets.image)

    self.quads = {}

    for y, tiles in ipairs(tilesets.tiles) do
        self.quads[y] = {}
        self.quads[y].animationmax = 0
        self.quads.id = tiles.id
        for x, tile in ipairs(tiles.animation) do
            self.quads[y][x] = {}
            self.quads[y][x].quad = love.graphics.newQuad((x - 1) * tilesets.tilewidth, (y - 1) * tilesets.tilewidth, tilesets.tilewidth, tilesets.tileheight, self.image:getDimensions())
            self.quads[y][x].duration = tile.duration
            self.quads[y].animationmax = self.quads[y].animationmax + 1
        end
    end

    self.ms = 0
    self.type = 1
    self.animationid = 1
end

function AnimationManager:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.quads[self.type][self.animationid].quad, x, y)
end

function AnimationManager:setTile(id)
    self.type = id
end

function AnimationManager:update(dt)
    self.ms = self.ms + dt * 1000
    if self.ms >= self.quads[self.type][self.animationid].duration then
        self.ms = self.ms - self.quads[self.type][self.animationid].duration
        self.animationid = self.animationid < self.quads[self.type].animationmax and self.animationid + 1 or 1
    end
end

return AnimationManager
