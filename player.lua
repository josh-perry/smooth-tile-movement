local player = {
	position = { x = 5, y = 5 },
	size = { w = 0, h = 0 },
	velocity = { x = 0, y = 0 },
	speed = 0,
	move_intention = nil,
	last_move = nil,
	destination = nil,
	moving_direction = nil,
	level = nil
}

function player:initialize(position, level)
	self.position = position
	self.level = level

	self.size = { w = level.tile_width, h = level.tile_height }
	self.speed = self.size.w
end

function player:update(dt)
	if not self.level then
		return
	end

	self.move_intention = nil

	if love.keyboard.isDown("a") then
		self.move_intention = "left"
	elseif love.keyboard.isDown("d") then
		self.move_intention = "right"
	elseif love.keyboard.isDown("s") then
		self.move_intention = "down"
	elseif love.keyboard.isDown("w") then
		self.move_intention = "up"
	end

	local moving = self:is_moving()
	local reached_destination = self:reached_destination()

	if reached_destination then
		self.moving_direction = nil
		self:stop_moving()
	end

	if not moving and self.move_intention then
		self.moving_direction = self.move_intention
		self:move(self.move_intention)
	end

	self:update_position(dt)
end

function player:update_position(dt)
	self.position.x = self.position.x + ((self.velocity.x * self.speed) * dt)
	self.position.y = self.position.y + ((self.velocity.y * self.speed) * dt)
end

function player:reached_destination()
	if not self.destination then
		return false
	end

	local px = self.position.x * self.level.tile_width
	local py = self.position.y * self.level.tile_height

	local dx = self.destination.x * self.level.tile_width
	local dy = self.destination.y * self.level.tile_height

	if self.moving_direction == "up" then
		if py <= dy then return true end
	end

	if self.moving_direction == "down" then
		if py >= dy then return true end
	end

	if self.moving_direction == "left" then
		if px <= dx then return true end
	end

	if self.moving_direction == "right" then
		if px >= dx then return true end
	end

	return false
end

function player:move(direction)
	self.destination = { x = self.position.x, y = self.position.y }
	self.velocity = { x = 0, y = 0 }
	self.moving = true

	if direction == "up" then
		self.destination.y = self.position.y - 1
		self.velocity.y = -1
	elseif direction == "down" then
		self.destination.y = self.position.y + 1
		self.velocity.y = 1
	elseif direction == "left" then
		self.destination.x = self.position.x - 1
		self.velocity.x = -1
	elseif direction == "right" then
		self.destination.x = self.position.x + 1
		self.velocity.x = 1
	else
		self.moving = false
	end

	if self:check_destination_solid() then
		self.destination = nil
		self.velocity = { x = 0, y = 0 }
		self.moving = false
	end
end

function player:check_destination_solid()
	return self.level.tiles[self.destination.x][self.destination.y]
end

function player:is_moving()
	return self.destination ~= nil
end

function player:draw()
	love.graphics.setColor(255, 100, 100)

	local x = (self.position.x - 1) * self.level.tile_width
	local y = (self.position.y - 1) * self.level.tile_height

	love.graphics.rectangle("fill", x, y, self.size.w, self.size.h)
end

function player:stop_moving()
	self:snap_position(self.destination.x, self.destination.y)
	self.destination = nil
	self.velocity = {x = 0, y = 0}
end

function player:snap_position(x, y)
	self.position = {x = x, y = y}
end

return player