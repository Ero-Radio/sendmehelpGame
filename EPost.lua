EPost = {}
EPost.__index = EPost

function EPost.new(initX, initY, size, orientation)
	local self = setmetatable({}, EPost)
	self.x = initX
	self.y = initY
	self.size = size
	self.orientation = orientation
	return self
end

function EPost.update(self, dt)
end

function EPost.draw(self)
	love.graphics.polygon("line", self.x - self.size/5, self.y, self.x + self.size/5, self.y, self.x, self.y+self.size*self.orientation)
end

function EPost.getTopPosition(self)
	r = {}
	r.x = self.x
	r.y = self.y + self.size * self.orientation
	return r
end