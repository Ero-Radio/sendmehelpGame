Pulsar = {}
Pulsar.__index = Pulsar

function Pulsar.new(initX, initY, lookingAt)
	local self = setmetatable({}, Pulsar)
	self.x = initX
	self.y = initY
	self.lookingAt = lookingAt
	self.phase = 0
	self.lastTime = love.timer.getTime()
	self.mouseY = nil
	return self
end

function Pulsar.update(self, dt)

	if self:Drag() then
		self.lookingAt = self.lookingAt + (self.mouseY - love.mouse.getY())/1000
	end

	if love.keyboard.isDown("right") then
		self.lookingAt = self.lookingAt + 0.1
	end

	if love.timer.getTime() - self.lastTime > 0.2 then
		if self.phase == 0 then
			self.phase = 1
		else
			self.phase = 0
		end
		self.lastTime = love.timer.getTime()
	end
end

function Pulsar.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setLineWidth(3)
	if self.phase == 0 then
		love.graphics.arc("line", "open", self.x, self.y, 50, self.lookingAt-1, self.lookingAt+1, 10)
		love.graphics.arc("line", "open", self.x, self.y, 30, self.lookingAt-1, self.lookingAt+1, 10)
		love.graphics.arc("line", "open", self.x, self.y, 10, self.lookingAt-1, self.lookingAt+1, 10)
	else
		love.graphics.arc("line", "open", self.x, self.y, 60, self.lookingAt-1, self.lookingAt+1, 10)
		love.graphics.arc("line", "open", self.x, self.y, 40, self.lookingAt-1, self.lookingAt+1, 10)
		love.graphics.arc("line", "open", self.x, self.y, 20, self.lookingAt-1, self.lookingAt+1, 10)
	end

	love.graphics.line(self.x, self.y, self:xEnd(), self:yEnd())
end

function Pulsar.MouseTouching(self)
	mX = love.mouse.getX()
	mY = love.mouse.getY()
	if math.sqrt(math.pow(self.x-mX, 2) + math.pow(self.y-mY, 2)) < 60 then
		print("Wololo")
		return true
	else
		return false
	end
end

function Pulsar.Drag(self)
	if love.mouse.isDown(1) and self:MouseTouching() then
		if self.mouseY == nil then
			self.mouseY = love.mouse.getY()
		end
		return true
	else
		self.mouseY = nil
		return false
	end

end

function Pulsar.xEnd(self)
	return self.x+150*math.cos(self.lookingAt)
end
function Pulsar.yEnd(self)
	return self.y+150*math.sin(self.lookingAt)
end