--[[
<<Program 3: Julia Sets>>

Consider the function Q(x) = x^2 + c

We need to know that for a particular c value, x0 can either tend to infinity or stay in orbit. The Julia set is a real axis - imaginary axis plane [-2,2] in which the black points are orbit staying and white bounds are orbits tending to infinity.

Julia Sets are useful in determining a basin boundary of any function.

]]

help = true

function love.load()
	winW = 700
	winH = 700
	success = love.window.setMode(winW, winH)
	love.window.setTitle("Julia set")
	
	canvas = love.graphics.newCanvas(winW, winH)
	love.graphics.setCanvas(canvas)
		canvas:clear()
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setCanvas()

	newRe = 0
	newIm = 0
	oldRe = 0
	oldIm = 0
	cRe = 0.3 -- real seed
	cIm = -0.4 -- imaginary seed
	zoom = 1
	dX = 0
	dY = 0
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("Real seed, hit <> to change:         " .. cRe,0,20)
		love.graphics.print("Imaginary seed, hit [] to change:  "..cIm,0,40)
		love.graphics.print("Zoom level (middle mouse button): "..zoom,0,60)
		love.graphics.print("Displacement (cursor keys): "..dX..","..dY,0,80)
		love.graphics.print("'z' creates a filled in Julia Set",0,100)
		love.graphics.print("'x' creates a backwards iteration Julia Set",0,120)
		love.graphics.print("'c' creates a boundary scanning Julia Set",0,140)
		love.graphics.print("Please give a few seconds to calculate image",0,160)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then juliafilled() end
	if key == "x" then juliaback() end
	if key == "c" then juliabound() end
end

function love.update(dt)
	if love.keyboard.isDown("up") then dY = dY + 0.05 end
	if love.keyboard.isDown("down") then dY = dY - 0.05 end
	if love.keyboard.isDown("left") then dX = dX + 0.05 end
	if love.keyboard.isDown("right") then dX = dX - 0.05 end
	if love.keyboard.isDown(",") then	if cRe >-0.6 then cRe=cRe-0.01 end	end
	if love.keyboard.isDown(".") then	if cRe <0.6  then cRe=cRe+0.01 end	end
	if love.keyboard.isDown("[") then	if cIm >-0.6 then cIm=cIm-0.01 end	end
	if love.keyboard.isDown("]") then	if cIm <0.6  then cIm=cIm+0.01 end	end
end

function love.mousepressed(x, y, b)
	if (b=='wu') then zoom = zoom + 1 end
	if (b=='wd') then zoom = zoom - 1 end
end

function juliafilled()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 + dY - y/(winH/4))/zoom	-- convert screen coordinates into actual coordinates
			if (escape(newRe,newIm) == 1) then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

function juliaback()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	
	-- start with any arbitrary point w0 = (x0, y0)
	oldRe = 1
	oldIm = 1

	for i = 0, 10000 do
		zR = oldRe - cRe
		zI = oldIm - cIm
		-- Make sure theta is in the right coordinate
		if zR == 0 then theta = math.pi/2				   end
		if zR > 0  then theta = math.atan(zI/zR)		   end
		if zR < 0  then theta = math.pi + math.atan(zI/zR) end
		-- Computation one of the square roots of z: (w - c)
		-- 1. Find distance of point from origin
		r = math.sqrt(zR*zR + zI*zI)
		-- 2. Divide angle by two. Pick an arbitrary root and discard the other
		theta = theta/2 + math.random(0,1) * math.pi
		-- 3. Root the distance
		r = math.sqrt(r)
		-- 4. Replace zR,zI by x0,y0
		oldRe = r * math.cos(theta)
		oldIm = r * math.sin(theta)

		--discard the first few erroneous iterations
		if (i > 50) then
			x = (oldRe+2) * winW/4
			y = (2-oldIm) * winH/4
			love.graphics.point(x,y)
		end
	end
	love.graphics.setCanvas()
end

function juliabound()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			newRe = -2 + x/(winW/4)	-- convert screen coordinates into actual coordinates
			newIm = 2 - y/(winH/4)	-- convert screen coordinates into actual coordinates

			if (escape(newRe,newIm) == 1) then 
				local a = escape(-2 + (x+1)/(winW/4),2 - y/(winH/4)) -- check for escaping is cardinal directions
				local b = escape(-2 + (x-1)/(winW/4),2 - y/(winH/4))
				local c = escape(-2 + x/(winW/4),2 - (y+1)/(winH/4))
				local d = escape(-2 + x/(winW/4),2 - (y-1)/(winH/4))
				if (a+b+c+d > 0 and a+b+c+d < 4) then -- If at least one but not all escape to infinity draw the point
					love.graphics.point(x,y) 
				end
			end
		end
	end

	love.graphics.setCanvas()
end

-- Checks to see if Q(x) = x^2 + c escapes the orbit or tends to infinity
function escape(newRe,newIm)
	local oldRe, oldIm, radius = 0

	for i = 0, 50 do
		oldRe = newRe
		oldIm = newIm
		newRe = oldRe * oldRe - oldIm * oldIm + cRe	-- Square real values and add cRe
		newIm = 2 * oldRe * oldIm + cIm				-- Square imaginary values and add cIm

		radius = newRe * newRe + newIm * newIm
		if  radius > 4 then return 0 end 			-- quicker to invoke [|z|^2 > 4] than [|z| > 2]
	end

	return 1
end