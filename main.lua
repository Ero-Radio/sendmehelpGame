require "BaseO"
require "Rope"
require "Antena"
require "EPost"
require "Pulse"
require "Mini"
function love.load()
	love.window.setTitle("Send me help")
	font = love.graphics.newFont("04B_30__.TTF", 30)
	love.graphics.setFont(font)
	gameState = 0 -- Menu
	sWidth = love.graphics.getWidth()
	sHeight = love.graphics.getHeight()
	mini = Mini.new(sWidth, sHeight)
	menuAntena = Antena.new(sWidth/2-10, sHeight/2-10, -3*math.pi/4)
	level = 1
	levels = {}
	
	levels[1] = {}
	levels[1][1] = Rope.new(200, 200, 2)
	levels[1][2] = Rope.new(400, 300, 2)
	
	levels[2] = {}
	levels[2][1] = Antena.new(200, 200, 0)
	levels[2][2] = Antena.new(400, 300, 0)
	
	levels[3] = {}
	levels[3][1] = Rope.new(30, sHeight-30, 2)
	levels[3][2] = Antena.new(sWidth/2, sHeight/2, 0)
	levels[3][3] = Antena.new(400, sHeight-40, math.pi)
	
	levels[4] = genLevel(4)
	levels[5] = genLevel(5)
	levels[6] = genLevel(6)
	levels[7] = genLevel(7)
	levels[8] = genLevel(8)
	levels[9] = genLevel(9)
	levels[10] = genLevel(10)
	levels[11] = genLevel(11)
	levels[12] = genLevel(12)
	
	pulse = Pulse.new(levels[level])

end
function love.draw()
	if gameState == 0 then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Send me Help!!!", sWidth/2, sHeight/2-30)
		love.graphics.points(sWidth/2, sHeight/2)
		if mouseOnButton() then
			love.graphics.setColor(255, 0, 0, 255)
		else
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.rectangle("fill", sWidth/2, sHeight/2, -200, 100)
		if mouseOnButton() then
			love.graphics.setColor(255, 255, 255, 255)
		else
			love.graphics.setColor(255, 0, 0, 255)
		end
		love.graphics.print("Start", sWidth/2-160, sHeight/2+40)
		menuAntena:draw()
	elseif gameState == 2 then
		mini:draw()
	else
		if level == 1 then
			love.graphics.print("You have to connect the last", 30, 30)
			love.graphics.print("node from a wire, to the first", 30, 80)
			love.graphics.print("of the next one. Click and Drag", 30, 130)
		elseif level == 2 then
			love.graphics.print("For the antenas, you have to", 30, 30)
			love.graphics.print("align the transmitter, and the", 30, 90)
			love.graphics.print("receiver.", 30, 130)
			love.graphics.setColor(165, 56, 255, 255)
			love.graphics.circle("fill", 200, 200, 60)
			love.graphics.circle("fill", 400, 300, 60)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.print("Click next to them, and your", 30, 400)
			love.graphics.print("y-distance will make them turn", 30, 450)
	
		elseif level == 3 then
			love.graphics.print("Now, is up to you! Good luck!!!", 30, 30)
		end
		if pulse.step > #pulse.objects_list then
			if level+1 <= #levels then
				level = level + 1
				pulse.objects_list = levels[level]
				pulse:resetSteps()
			else
				love.graphics.printf("Boa champs", 300, 300, 300, "center")
			end
		end
		for i=1,#levels[level] do
			levels[level][i]:draw()
		end
		pulse:draw()
	end


end

function love.update(dt)
	if gameState == 0 then
		menuAntena:update(dt)
	elseif gameState == 2 then
		mini:update(dt)
		if mini.go then
			gameState = 0
		end
	else

		for i=1,#levels[level] do
			levels[level][i]:update(dt)
		end

		pulse:update(dt)
	end
end

function love.mousepressed(x, y, button, istouch)
	if mouseOnButton() and gameState == 0 and button == 1 then 
		gameState = 1
	elseif mouseOnButton() and gameState == 0 and button == 2 then
		gameState = 2
		mini.go = false
	elseif gameState == 2 and button == 2 then
		gameState = 0
	end
end

function love.mousereleased(x, y, button, istouch)
	pulse:resetSteps()
end

function love.resize(w, h)
  sWidth = w
  sHeight = h
end

function dist(x1, y1, x2, y2)
	d = math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
	if d < 1 then
		d = 1
	end
	return d
end

function genLevel(levelN)
	r = {}
	elements = 1
	while elements < levelN do
		t = love.math.random(10)
		if t<6 then
			rx = love.math.random(30, love.graphics.getWidth()-200)
			ry = love.math.random(30, love.graphics.getHeight()-30)
			n = love.math.random(2, 5)
			r[#r+1] = Rope.new(rx, ry, n)
		else
			n = love.math.random(3*math.pi)
			rx = love.math.random(30, love.graphics.getWidth()-100)
			ry = love.math.random(30, love.graphics.getHeight()-30)
			r[#r+1] = Antena.new(rx, ry, n)
			rx = love.math.random(30, love.graphics.getWidth()-100)
			ry = love.math.random(30, love.graphics.getHeight()-30)
			n = love.math.random(3*math.pi)
			r[#r+1] = Antena.new(rx, ry, n)
			r[#r+1] = Rope.new(rx, ry, 2)
		end
		elements = elements + 1 
	end
	return r
end

function mouseOnButton()
	x = love.mouse.getX()
	y = love.mouse.getY()
	return x > (sWidth/2)-200 and x < sWidth/2 and
		   y > (sHeight/2) and y < (sHeight/2)+100
		end