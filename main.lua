local player = require("player")

local level = {
	tile_width = 16,
	tile_height = 16,
	tiles_x = 0,
	tiles_y = 0,
	tiles = {}
}

function love.load()
	level.tiles_x = math.floor(love.graphics:getWidth() / level.tile_width)
	level.tiles_y = math.floor(love.graphics:getHeight() / level.tile_height)

	for x = 1, level.tiles_x do
		level.tiles[x] = {}

		for y = 1, level.tiles_y do
			if x == 1 or x == level.tiles_x or y == 1 or y == level.tiles_y then
				level.tiles[x][y] = true
			end
		end
	end

	local position = {x = 5, y = 5}
	player:initialize(position, level)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)

	for x = 1, level.tiles_x do
		for y = 1, level.tiles_y do
			if level.tiles[x][y] == true then
				local tile_x = (x - 1) * level.tile_width
				local tile_y = (y - 1) * level.tile_height

				love.graphics.rectangle("fill", tile_x, tile_y, level.tile_width, level.tile_height)
			end
		end
	end

	player:draw()
end

function love.update(dt)
	player:update(dt)
end