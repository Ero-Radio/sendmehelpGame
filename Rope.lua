Rope = {}
Rope.__index = Rope

require "BaseO"
require "Spring"

function Rope.new(startX, startY, size)
	local self = setmetatable({}, Rope)
	self.size = size
	self.newNode = false
	self.Nodes = {}
	self.x = startX
	self.y = startY
	self.Nodes[1] = BaseO.new(startX, startY, true)
	for i = 2, size do
		if i == size then
			self.Nodes[i] = BaseO.new(startX + 30 * i-1, startY, false)
		else
		self.Nodes[i] = BaseO.new(startX + 30 * i-1, startY, false)
		end
	end
	return self
end

function Rope.draw(self)
	for i=1, #self.Nodes do
		self.Nodes[i]:draw()
		if(i<#self.Nodes) then
			love.graphics.line(self.Nodes[i].x, self.Nodes[i].y, self.Nodes[i+1].x, self.Nodes[i+1].y)
		end
	end
end

function Rope.update(self)
	--love.timer.sleep(0.5)
	-- for i=1,self.size-1 do
	-- 	v = self:springSolve(self.Nodes[i], self.Nodes[i+1])
	-- 	if(not self.Nodes[i].pinned) then
	-- 		self.Nodes[i].x = self.Nodes[i].x + v.x
	-- 		self.Nodes[i].y = self.Nodes[i].y + v.y
	-- 	end
	-- 	if(not self.Nodes[i+1].pinned) then
	-- 		self.Nodes[i+1].x = self.Nodes[i+1].x + v.x
	-- 		self.Nodes[i+1].y = self.Nodes[i+1].y + v.y
	-- 	end
	-- end
	for i=1,#self.Nodes do
		self.Nodes[i]:update()
	end

	-- if love.mouse.isDown(2) then
	-- 	if not self.newNode then
	-- 		x = love.mouse.getX()
	-- 		y = love.mouse.getY()
	-- 		self.Nodes[#self.Nodes+1] = BaseO.new(x, y, false)
	-- 	end
	-- 	self.Nodes[#self.Nodes].x = love.mouse.getX()
	-- 	self.Nodes[#self.Nodes].y = love.mouse.getY()
	-- 	self.newNode = true
	-- else
	-- 	self.newNode = false
	-- end
end

-- function Rope.springSolve(self, n1, n2)
-- 	vector = self:springGetVector(n1, n2)

-- 	distance = self:springGetDistance(n1, n2)
-- 	d = 20
-- 	k = 1
-- 	f = {}
-- 	f.x = 0
-- 	f.y = 0

-- 	if distance ~= 0 then
-- 		f.x = -vector.x/distance * (distance - d) * k
-- 		f.y = -vector.y/distance * (distance - d) * k
-- 	end

-- 	g = {}
-- 	g.x = 0
-- 	g.y = 10

-- 	r = {}
-- 	r.x = g.x - f.x
-- 	r.y = g.y - f.y

-- 	return r
-- end

-- function Rope.springGetVector(self, n1, n2)
-- 	r = {}
-- 	r.x = n1.x - n2.x
-- 	r.y = n1.y - n2.y
-- 	return r
-- end

-- function Rope.springGetDistance(self, n1, n2)
-- 	return math.sqrt(math.pow(n1.x-n2.x, 2) + math.pow(n1.y-n2.y, 2))
-- end