Pulse = {}
Pulse.__index = Pulse

function Pulse.new(objects)
	local self = setmetatable({}, Pulse)
	self.x = 200
	self.y = 200
	self.step = 1
	self.stepInside = 0
	self.lastTime = love.timer.getTime()
	self.vx = 0
	self.vy = 0
	self.objects_list = objects
	self.receiverCheck = {false, false}

	return self
end

function Pulse.draw(self)
	love.graphics.setColor(255, 255, 255, 255)
	if self.step > #self.objects_list then
		--self.step = 1
		love.graphics.setColor(0, 255, 0, 255)
		return
	end
	love.graphics.circle("fill", self.x, self.y, 9)
end

function Pulse.update(self, dt)
	-- No final dos objetos ativos volta para o primeiro
	if self.step > #self.objects_list then
		--self.step = 1
		return
	end

	if getmetatable(self.objects_list[self.step]) == Rope then

		self:RopeUpdate(self.objects_list[self.step].Nodes, dt)
	
	elseif getmetatable(self.objects_list[self.step]) == Antena then
		self:AntenaUpdate(self.objects_list[self.step], self.objects_list[self.step+1], dt)
	end

	if self.x < 0 or self.x > love.graphics.getWidth() or self.y<0 or self.y > love.graphics.getHeight() then
		self:resetSteps()
	end

	self.x = self.x+self.vx
	self.y = self.y+self.vy
end

function Pulse.RopeUpdate(self, ropeNodes, dt)
	-- Aqui ele ainda não entrou no fio
	if dist(self.x, self.y, ropeNodes[1].x, ropeNodes[1].y) < 15  and
	   self.stepInside == 0 then
	   self.x = ropeNodes[1].x
	   self.y = ropeNodes[1].y
	   self.stepInside = 1
	-- Aqui já entrou no fio
	elseif self.stepInside > 0 then
		-- Estou no ultimo no e cheguei
		if self.stepInside == #ropeNodes and
			dist(self.x, self.y, ropeNodes[self.stepInside].x, ropeNodes[self.stepInside].y) <10 then
			--Existe proximos objetos
			if self.step < #self.objects_list then
				-- estou tocando no proximo
				if dist(self.x, self.y, self.objects_list[self.step+1].x, self.objects_list[self.step+1].y) < 15 then
					self.step = self.step+1
					self.stepInside = 0
				-- não estou tocando no proximo
				else
					self:resetSteps()
				end
			-- sou o ultimo
			else
				self.step = self.step+1
			end
		elseif dist(self.x, self.y, ropeNodes[self.stepInside].x, ropeNodes[self.stepInside].y) <10 or self.stepInside == 1 then
			p1 = ropeNodes[self.stepInside]:pos()
			p2 = ropeNodes[self.stepInside+1]:pos()
			self.vx = (p2.x - p1.x)/dist(p1.x, p1.y, p2.x, p2.y) * 10
			self.vy = (p2.y - p1.y)/dist(p1.x, p1.y, p2.x, p2.y) * 10
			self.stepInside = self.stepInside + 1
		end
	-- Passou longe do fio
	else
		self:resetSteps()
	end

end


function Pulse.OldRopeUpdate(self, ropeNodes, dt)
	if self.stepInside >= #ropeNodes then
		if dist(self.x, self.y, ropeNodes[self.stepInside].x, ropeNodes[self.stepInside].y) <10 then
			if self.step+1<=#self.objects_list then
				if dist(self.x, self.y, self.objects_list[self.step+1].x, self.objects_list[self.step+1].y) <10 then
					self.step = self.step + 1
				end
			end
			self.stepInside = 0
		end
		return
	end

	if self.stepInside == 0 then
		self.x = ropeNodes[self.stepInside+1].x
		self.y = ropeNodes[self.stepInside+1].y
		self.stepInside = 1
	end

	if dist(self.x, self.y, ropeNodes[self.stepInside].x, ropeNodes[self.stepInside].y) <10 or self.stepInside == 1 then
		p1 = ropeNodes[self.stepInside]:pos()
		p2 = ropeNodes[self.stepInside+1]:pos()
		self.vx = (p2.x - p1.x)/dist(p1.x, p1.y, p2.x, p2.y) * 10
		self.vy = (p2.y - p1.y)/dist(p1.x, p1.y, p2.x, p2.y) * 10
		self.stepInside = self.stepInside + 1
	end

end


function Pulse.AntenaUpdate(self, transmitter, receiver, dt)

	--só deixa o sinal proseguir pela antena caso ele chegue proximo ao transmissor
	if dist(self.x, self.y, transmitter.x, transmitter.y) < 15 then
		self.vx = math.cos(transmitter.lookingAt)*10
		self.vy = math.sin(transmitter.lookingAt)*10
		--self.step = self.step + 1
	else
		if dist(self.x, self.y, receiver:xEnd(), receiver:yEnd()) < 15 then
			self.receiverCheck[1] = true
		end

		if dist(self.x, self.y, receiver.x, receiver.y) < 15 then 
			if self.receiverCheck[1] then
				self.receiverCheck[2] = true
			end
		end
	end

	if self.receiverCheck[1] and self.receiverCheck[2] then
		self.step = self.step + 2
		self.receiverCheck = {false, false}
	end


end

-- Reseta os passos depois de utlizar o mouse
-- vide love.mousereleased
function Pulse.resetSteps(self)
	self.stepInside = 0
	self.step = 1
	self.receiverCheck = {false, false}
	self.x = self.objects_list[1].x
	self.y = self.objects_list[1].y
end


function dist(x1, y1, x2, y2)
	d = math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
	if d < 1 then
		d = 1
	end
	return d
end