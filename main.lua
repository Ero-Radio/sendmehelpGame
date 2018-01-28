require "BaseO"
require "Rope"
require "Antena"
require "EPost"
require "Pulse"
function love.load()
	love.window.setTitle("Send me help")
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
	levels[2][3] = Antena.new(400, 300, math.pi/4)
	levels[2][4] = Antena.new(300, 600, math.pi)
	-- levels[2][3] = Rope.new(5, 100, 100)


	pulse = Pulse.new(levels[level])
	 
end

function love.draw()
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

function love.update(dt)
	for i=1,#levels[level] do
		levels[level][i]:update(dt)
	end

	pulse:update(dt)

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