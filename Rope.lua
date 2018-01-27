Rope = {}
Rope.__index = Rope

require "BaseO"

function Rope.new(size, startX, startY)
	local self = setmetatable({}, Rope)
	self.Nodes = {}
	self.size = size
		self.Nodes[1] = BaseO.new(startX, startY, true)
	for i=2, size do
		t = BaseO.new(startX+10*i, startY+10*i, false)
		self.Nodes[i] = t
	end
	return self
end

function Rope.draw(self)

	for i=1, self.size do
		self.Nodes[i]:draw()
	end

	for i=1, self.size-1 do
		love.graphics.line(self.Nodes[i].x, self.Nodes[i].y,self.Nodes[i+1].x, self.Nodes[i+1].y)
	end
end

function Rope.update(self)
	for i=1, self.size do
		self.Nodes[i]:update()
	end

	for i=1, self.size-1 do
		if self.Nodes[i+1].y < 500 then
			self.Nodes[i+1].x = self.Nodes[i+1].x + (self.Nodes[i].x - self.Nodes[i+1].x)/100
		end
	end 
end