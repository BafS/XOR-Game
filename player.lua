
Player = {}
Player.__index = Player

function Player.new(name, options)
	local self = {}
	setmetatable(self, Player)
	self.name = name
	self.color = options.color
	self.x = 300
	if options.x then
		self.x = options.x
	end
	self.xx = self.x
	self.y = 450
	if options.y then
		self.y = options.y
	end
	self.yy = self.y
	self.speed = 110
	self.angle = 10
	self.radius = 4
	return self
end

function Player:collision()
	local projX1 = math.floor(self.x + math.cos(self.angle + math.pi / 3) * (self.radius + 0))
	local projX2 = math.floor(self.x + math.cos(self.angle - math.pi / 3) * (self.radius + 0))
	local projY1 = math.floor(self.y + math.sin(self.angle + math.pi / 3) * (self.radius + 0))
	local projY2 = math.floor(self.y + math.sin(self.angle - math.pi / 3) * (self.radius + 0))

	if projX1 < 0 or projX2 < 0 or projY1 < 0 or projY2 < 0 then
		return true
	end

	-- TODO
	if projX1 >= window.width or projX2 >= window.width or projY1 >= window.height or projY2 >= window.height then
		return true
	end

	local data1 = canvas:newImageData(projX1, projY1, 1, 1)
	local data2 = canvas:newImageData(projX2, projY2, 1, 1)

	local sumAlpha = 0
	local r, g, b, a1 = data1:getPixel(0, 0)
	local r, g, b, a2 = data2:getPixel(0, 0)

	sumAlpha = a1 + a2


	-- TMP
	-- love.graphics.setCanvas(canvas)
		-- love.graphics.setColor(20, 10, 10)
		-- love.graphics.rectangle('fill', 40, 420, 140, 140)
		-- love.graphics.setColor(220, 200, 200)

		-- love.graphics.rectangle('fill', projX - 0, projY - 0, 1, 1)
		-- love.graphics.rectangle('fill', projX1 - 0, projY1 - 0, 1, 1)
		-- love.graphics.rectangle('fill', projX2 - 0, projY2 - 0, 1, 1)

		-- love.graphics.rectangle('fill', self.x - 1, self.y - 1, 2, 2)
		-- love.graphics.setColor(220, 188, 156)
		-- img = love.graphics.newImage(data1)
		-- img:setFilter("nearest", "nearest", 0)
		-- love.graphics.draw(img, 40, 420, 0, 14, 14)
	-- love.graphics.setCanvas()


	if sumAlpha > 200 and self.speed > 0 then
		print("COLLISION " ..sumAlpha)
		print(self.x.." "..self.y)
		print(a1..", "..a2)
		-- print(a1..", "..a2..", "..a3..", "..a4)

		return true
	end
end

function Player:move(dt)

	self.xx = self.x
	self.yy = self.y

	self.x = self.x + self.speed * dt * math.cos(self.angle)
	self.y = self.y + self.speed * dt * math.sin(self.angle)

end

function Player:restart()

	self.x = 400
	self.y = 400

	self.speed = 110

	print "[restart]"
	print(r)

	love.graphics.setCanvas(canvas)
		love.graphics.clear()
	love.graphics.setCanvas()

end