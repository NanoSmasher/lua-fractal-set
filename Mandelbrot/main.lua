--[[
<<Program 4: Mandelbrot Set>>

Consider the function Q(x) = x^n + c

Julia sets give boundaries for a specific value of c. A Mandelbrot set serves as a "dictionary" of Julia Sets, displaying the c values in which the basin boundary is visible (there are at least a few black points / orbits / connected Julia).

Note that, instead of needing to calculate EVERY x0, note that all polynomials of f(x) = x^n + c have one critical point at x=0
This point will determine whether the Julia set is connected or it has been turned into fractal dust
Therefore, we only need to check x=0 for orbit escaping.
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
		love.graphics.print("'z/x/c/v' to create Mandelbrot set (degree 2/3/4/5)",0,60)
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
	if key == "z" then mbrot(2) end
	if key == "x" then mbrot(3) end
	if key == "c" then mbrot(4) end
	if key == "v" then mbrot(5) end
end

function mbrot(n)
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 1, winW do 
		for y = 1, winH do
			local cRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			local cIm = (2 + dY - y/(winH/4))/zoom	-- convert screen coordinates into actual coordinates
			if n==2 and escape2(cRe,cIm) == 1 then love.graphics.point(x,y) end
			if n==3 and escape3(cRe,cIm) == 1 then love.graphics.point(x,y) end
			if n==4 and escape4(cRe,cIm) == 1 then love.graphics.point(x,y) end
			if n==5 and escape5(cRe,cIm) == 1 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

-- Checks to see if Q(x) = x^2 + c escapes the orbit or tends to infinity
function escape2(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 50 do
		newRe = oldRe * oldRe - oldIm * oldIm + cRe	-- Square real values and add cRe
		newIm = 2 * oldRe * oldIm + cIm				-- Square imaginary values and add cIm

		radius = newRe * newRe + newIm * newIm
		if  radius > 4 then return 0 end 			-- quicker to invoke [|z|^2 > 4] than [|z| > 2]
		oldRe = newRe
		oldIm = newIm
	end
	return 1
end

-- Checks to see if Q(x) = x^3 + c escapes the orbit or tends to infinity
function escape3(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 50 do
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

-- Checks to see if Q(x) = x^4 + c escapes the orbit or tends to infinity
function escape4(cRe,cIm)
	local oldRe = cRe
	local oldIm = cIm
	local radius = 0
	for i = 0, 50 do
		newRe = oldRe*oldRe*oldRe*oldRe - 6*oldRe*oldRe*oldIm*oldIm + oldIm*oldIm*oldIm*oldIm + cRe
		newIm = 4*(oldRe*oldRe*oldRe*oldIm - oldRe*oldIm*oldIm*oldIm) + cIm
		radius = newRe * newRe + newIm * newIm
		if  radius > 4 then return 0 end
		oldRe = newRe
		oldIm = newIm
	end
	return 1
end

-- Checks to see if Q(x) = x^5 + c escapes the orbit or tends to infinity
function escape5(cRe,cIm)
	local a = cRe
	local b = cIm
	local radius = 0
	for i = 0, 50 do
		newRe = a*a*a*a*a - 10*a*a*a*b*b + 5*a*b*b*b*b + cRe
		newIm = 5*a*a*a*a*b - 10*a*a*b*b*b + b*b*b*b*b + cIm
		radius = newRe * newRe + newIm * newIm
		if  radius > 4 then return 0 end
		a = newRe
		b = newIm
	end
	return 1
end