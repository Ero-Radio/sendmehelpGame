require "BaseO"
require "Rope"
require "Antena"
require "EPost"
require "Pulse"
function love.load()
	love.window.setTitle("Send me help")
	font = love.graphics.newFont("04B_30__.TTF", 30)
	love.graphics.setFont(font)
	gameState = 0 -- Menu
	sWidth = love.graphics.getWidth()
	sHeight = love.graphics.getHeight()
	level = 1
	levels = {}
	
	levels[1] = {}

	levels[1][1] = Rope.new(200, 200, 10)
	levels[1][2] = Rope.new(400, 300, 2)

	-- levels[1][3] = EPost.new(5, 100, 100, 1)

	levels[2] = {}


	levels[2][1] = Antena.new(200, 200, 0)
	levels[2][2] = Antena.new(400, 300, 0)
	-- levels[2][3] = Antena.new(400, 300, math.pi/4)
	-- levels[2][4] = Antena.new(300, 600, math.pi)
	-- levels[2][3] = Rope.new(5, 100, 100)


	levels[3] = genLevel(3)
	levels[4] = genLevel(4)
	levels[5] = genLevel(5)



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
	else
		if pulse.step > #pulse.objects_list then
			love.graphics.printf("Cachaça carai", 200, 200, 300, "center")
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
		love.graphics.print(pulse.step, 10, 10)
		love.graphics.print("carai", 10, 20)
		love.graphics.print(pulse.stepInside, 10, 30)
	end


end

function love.update(dt)
	if gameState == 0 then

	else

		for i=1,#levels[level] do
			levels[level][i]:update(dt)
		end

		pulse:update(dt)
	end
end

function love.mousepressed(x, y, button, istouch)
	if mouseOnButton() and gameState == 0 then 
		gameState = 1
	end
end

function love.mousereleased(x, y, button, istouch)
	pulse:resetSteps()
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
	for i=1, levelN do
		t = love.math.random(1, 2)
		rx = love.math.random(30, love.graphics.getWidth()-30)
		ry = love.math.random(30, love.graphics.getHeight()-30)
		--Generate rope
		if t==1 then
			n = love.math.random(2, 5)
			r[i] = Rope.new(rx, ry, n)
		elseif t == 2 then
			n = love.math.random(3*math.pi)
			r[i] = Antena.new(rx, ry, n)
			rx = love.math.random(30, love.graphics.getWidth()-30)
			ry = love.math.random(30, love.graphics.getHeight()-30)
			n = love.math.random(3*math.pi)
			r[i+1] = Antena.new(rx, ry, n)
			r[i+2] = Rope.new(rx, ry, 2)
			i = i + 3
			levelN = levelN + 2
		end
	end
	return r
end

function mouseOnButton()
	x = love.mouse.getX()
	y = love.mouse.getY()
	return x > (sWidth/2)-200 and x < sWidth/2 and
		   y > (sHeight/2) and y < (sHeight/2)+100
		end