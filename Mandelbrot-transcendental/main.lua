--[[
<<Program 4a: Transcendental Functions>>

Consider the non-polynomial functions
 Q(z) = c * e^z
 R(z) = c * sin(z)
 S(z) = c * cos(z)
 
Using Julia-transcendental speeds up the process, showing that Mandelbrot sets can be built from Julia sets with relative ease.
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
		love.graphics.print("Zoom level: "..zoom,0,20)
		love.graphics.print("Displacement: "..dX..","..dY,0,40)
		love.graphics.print("'z/x/c' to create Mandelbrot set (exp/sin/cos)",0,60)
		love.graphics.print("Mouse: "..mX..", "..mY,550,00)
		love.graphics.printf("c value: "..cX.." + "..cY.."i",550,20,50,"left")
	end
end

function love.update(dt)
	mX = love.mouse.getX()
	mY = love.mouse.getY()
	cX = ((mX-winW/2-dX)*2/350)/zoom
	cY = ((winH/2+dY-mY)*2/350)/zoom
	if love.keyboard.isDown("up") then dY = dY + 0.05 end
	if love.keyboard.isDown("down") then dY = dY - 0.05 end
	if love.keyboard.isDown("left") then dX = dX + 0.05 end
	if love.keyboard.isDown("right") then dX = dX - 0.05 end
end

function love.mousepressed(x, y, b)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if (b=='wu') then zoom = zoom + 1 end
	if (b=='wd') then zoom = zoom - 1 end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then mbrot("exp") end
	if key == "x" then mbrot("sin") end
	if key == "c" then mbrot("cos") end
end

function mbrot(t)
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 1, winW do 
		for y = 1, winH do
			cRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			cIm = (2 + dY - y/(winH/4))/zoom	-- convert screen coordinates into actual coordinates
			if t=="exp" and escapee(cRe,cIm) == 1 then love.graphics.point(x,y) end
			if t=="sin" and escapes(cRe,cIm) == 1 then love.graphics.point(x,y) end
			if t=="cos" and escapec(cRe,cIm) == 1 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

-- Checks to see if Q(x) = c*e^x escapes the orbit or tends to infinity
function escapee(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 25 do
		eRe = math.exp(oldRe)*math.cos(oldIm)
		eIm = math.exp(oldRe)*math.sin(oldIm)
		newRe = cRe*eRe - cIm*eIm
		newIm = cRe*eIm + cIm*eRe
		if newRe > 200 then return 0 end
		oldRe = newRe
		oldIm = newIm
	end
	return 1
end

-- Checks to see if Q(x) = c*sin(x) escapes the orbit or tends to infinity
function escapes(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 25 do
		sRe = math.sin(oldRe)*(math.exp(oldIm)+math.exp(-oldIm))/2
		sIm = math.cos(oldRe)*(math.exp(oldIm)-math.exp(-oldIm))/2
		newRe = cRe*sRe - cIm*sIm
		newIm = cRe*sIm + cIm*sRe
		if math.abs(newIm) > 50 then return 0 end
		oldRe = newRe
		oldIm = newIm
	end
	return 1
end

-- Checks to see if Q(x) = c*cos(x) escapes the orbit or tends to infinity
function escapec(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 25 do
		sRe = math.cos(oldRe)*(math.exp(oldIm)+math.exp(-oldIm))/2
		sIm = math.sin(oldRe)*(math.exp(oldIm)-math.exp(-oldIm))/2
		
		newRe = cRe*sRe - cIm*sIm
		newIm = cRe*sIm + cIm*sRe
		if math.abs(newIm) > 50 then return 0 end
		oldRe = newRe
		oldIm = newIm
	end
	return 1
end