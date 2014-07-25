--[[
<<Program 5: Sierpinski Triangle>>

	Use Geometric Iteration to create self-similar fractals
]]

help = true

function love.load()
	winW = 700
	winH = 700
	success = love.window.setMode(winW, winH)
	love.window.setTitle("Orbit Diagram")
	
	canvas = love.graphics.newCanvas(winW, winH)
	love.graphics.setCanvas(canvas)
		canvas:clear()
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setCanvas()
	
	mX = 0
	mY = 0
	cX = 0
	cY = 0
	dX = 0
	dY = 0
	zoom = 1
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("'z' to create Sierpinski Triangle",0,20)
		love.graphics.print("'x' to create Square Fractal",0,40)
		love.graphics.print("'c' to create Right Triangle",0,60)
		love.graphics.print("'v' to create uhhhh, inverse Sier",0,80)
	end
end

function love.mousepressed(x, y, b)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then sier() end
	if key == "x" then square() end
	if key == "c" then right() end
	if key == "v" then trip() end
end

function sier()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	local x=0
	local y=0
	local d = 700-700*math.sqrt(3)/2
	for i = 1, 1000000 do 
		r = math.random(0,2)
		if (r==0) then  x,y = (350+x)/2,(d+y)/2 end
		if (r==1) then  x,y = (700+x)/2,(700+y)/2 end
		if (r==2) then  x,y = x/2,(700+y)/2 end
		if i > 1000 then love.graphics.point(x,y) end
	end
	love.graphics.setCanvas()
end

function square()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	local x=0
	local y=0
	for i = 1, 1000000 do 
		r = math.random(0,4)
		if (r==0) then  x,y = x*2/3,y*2/3 end
		if (r==1) then  x,y = (2*700+x)/3,y*2/3 end
		if (r==2) then  x,y = (2*700+x)/3,(2*700+y)/3 end
		if (r==3) then  x,y = x*2/3,(2*700+y)/3 end
		if (r==4) then  x,y = (2*350+x)/3,(2*350+y)/3 end
		if i > 1000 then love.graphics.point(x,y) end
	end
	love.graphics.setCanvas()
end

function right()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	local x=0
	local y=0
	for i = 1, 1000000 do 
		r = math.random(0,2)
		x = x/2 + r*(r-1) * 175
		y = y/2 + r*(3-r) * 175
		if i > 1000 then love.graphics.point(x,y) end
	end
	love.graphics.setCanvas()
end

function trip()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	local x=0
	local y=0
	local d = 700-700*math.sqrt(3)/2
	for i = 1, 1000000 do 
		r = math.random(0,2)
		if (r==0) then  x,y = (350+x)/2,-y/2 end
		if (r==1) then  x,y = (700+x)/2,(700+y)/2 end
		if (r==2) then  x,y = x/2,(700+y)/2 end
		if i > 1000 then love.graphics.point(x,y) end
	end
	love.graphics.setCanvas()
end