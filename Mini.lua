require "Rope"
Mini = {}
Mini.__index = Mini

function Mini.new(sW, sH)
	local self = setmetatable({}, Mini)
	self.sW = sW
	self.sH = sH
	self.p = {x = sW/2, y = sH-sH/5}
	self.s = {}
	self.sTimeStamp = 0
	self.e = {}
	self.eTimeStamp = 0
	self.go = false
	self.r = Rope.new(0, sH-50, 30)
	return self
end

function Mini.draw(self)
	love.graphics.polygon("fill",
						  self.p.x, self.p.y, 
						  self.p.x+5, self.p.y+3,
						  self.p.x, self.p.y-30,
						  self.p.x-5, self.p.y+3)

	for i=1, #self.s do 
		love.graphics.circle("fill", self.s[i].x, self.s[i].y, 2)
	end

	for i=1, #self.e do 
		love.graphics.circle("fill", self.e[i].x, self.e[i].y, 10)
	end

	self.r:draw()

end


function Mini.update(self, dt)
	self.p.x = love.mouse.getX()
	self.p.y = love.mouse.getY()

	if love.mouse.isDown(1) then
		if love.timer.getTime() - self.sTimeStamp > 0.5 and #self.s < 10 then
			table.insert(self.s, {x=self.p.x, y=self.p.y})
		end
	end

	for i=1, #self.s do 
		if self.s[i] ~= nil then
			self.s[i].y = self.s[i].y - 10
			if self.s[i].y < 0 then
				table.remove(self.s, i)
			end
		end
	end


	if love.timer.getTime() - self.eTimeStamp > 0.5 then
		self.eTimeStamp = love.timer.getTime()
		table.insert(self.e, {x=love.math.random(0, sW), y=love.math.random(0, 100), vx=love.math.random(5, 20), vy=love.math.random(20, 100)})
	end

	for i=1, #self.e do 
		if self.e[i] ~= nil then
			if dist(self.p.x, self.p.y, self.e[i].x, self.e[i].y) < 25 then
				self.go = true
			end
			self.e[i].x = self.e[i].x + self.e[i].vx
			if self.e[i].x > self.sW then
				self.e[i].x = 0
				self.e[i].y = self.e[i].y + self.e[i].vy
			end
		end
	end

	for i=1, #self.s do 
		for j=1, #self.e do 
			if self.e[j] ~= nil and self.s[i] ~= nil then
				if dist(self.s[i].x, self.s[i].y, self.e[j].x, self.e[j].y) < 10 then
					table.remove(self.s, i)
					table.remove(self.e, j)
				end
			end
		end
	end
end


function dist(x1, y1, x2, y2)
	d = math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
	if d < 1 then
		d = 1
	end
	return d
end