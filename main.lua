
function love.load()
	require "BaseO"
	require "Rope"
	require "Pulsar"
	teste = {}
	
	teste[1] = Pulsar.new(200, 200, love.math.random(0, 3)*math.pi/love.math.random(0, 6) )
	teste[2] = Pulsar.new(600, 200, love.math.random(0, 3)*math.pi/love.math.random(0, 6) )

	info = {}
	info.vx = 10
	info.vy = 10
	info.x = teste[1].x
	info.y = teste[1].y
	info.step = 1
	info.check1 = false
	info.check2 = false
	info.lastTime = love.timer.getTime()
	 
end

function love.draw()
	for i=1,#teste do
		teste[i]:draw(dt)
	end
	if info.check1 and info.check2 then
		love.graphics.setColor(255, 2, 2, 255)
	end
	love.graphics.circle("fill", info.x, info.y, 10);
end

function love.update(dt)
	for i=1,#teste do
		teste[i]:update(dt)
	end

	info.vx = math.cos(teste[info.step].lookingAt)*10
	info.vy = math.sin(teste[info.step].lookingAt)*10

	info.x = info.x+info.vx
	info.y = info.y+info.vy

	if(love.timer.getTime() - info.lastTime > 2) then
		info.lastTime = love.timer.getTime()
		info.x = teste[info.step].x
		info.y = teste[info.step].y
		info.check1 = false
		info.check2 = false
	end

	if teste[info.step+1]==nil then
		love.quit()
	end

	if dist(info.x, info.y, teste[info.step+1]:xEnd(), teste[info.step+1]:yEnd()) < 20 then
		info.check1 = true
	end
	
	if dist(info.x, info.y, teste[info.step+1].x, teste[info.step+1].y) < 20 and info.check1 then
		info.check2 = true
	end

	if info.check1 and info.check2 then
		info.step = info.step + 1
	end

end

function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2))
end