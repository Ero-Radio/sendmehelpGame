BaseO = {}
BaseO.__index = BaseO

function BaseO.new(initX, initY, pinned)
	local self = setmetatable({}, BaseO)
	self.x = initX
	self.y = initY
	self.pinned = pinned
	return self
end

function BaseO.update(self, dt)
	if self.pinned == true then
	 return
	end

	if self:Drag() then
		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
	elseif self.y < 500 then
		self.y = self.y + 2
	end
end

function BaseO.draw(self)
	if self:MouseTouching() then
		love.graphics.setColor(125, 125, 125, 255)
	else
		love.graphics.setColor(255, 125, 125, 255)
	end
	love.graphics.circle("fill", self.x, self.y, 10)
end

function BaseO.MouseTouching(self)
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if mouseX > self.x -10 and mouseX < self.x + 10 and
		mouseY > self.y -10 and mouseY < self.y + 10
	then
		return true
	else 
		return false
	end
end

function BaseO.Drag(self)
	if self:MouseTouching() and love.mouse.isDown(1) then
		return true
	else 
		return false
	end
end