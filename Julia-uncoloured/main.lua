-- - Tried to get backward iteration working but no avail
-- - Fixed a tiny graphics glitch that made (0,0) an oval

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
	moveX = 0
	moveY = 0
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("Real seed, hit <> to change:         " .. cRe,0,20)
		love.graphics.print("Imaginary seed, hit [] to change:  "..cIm,0,40)
		love.graphics.print("Displacement, hit 'w/s/a/d' to change:  "..moveX.." ,"..moveY,0,60)
		love.graphics.print("Zoom level, hit 'q/e' to change:  "..zoom,0,80)
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
	if key == "," then	if cRe >-0.6 then cRe=cRe-0.05 end	end
	if key == "." then	if cRe <0.6  then cRe=cRe+0.05 end	end
	if key == "[" then	if cIm >-0.6 then cIm=cIm-0.05 end	end
	if key == "]" then	if cIm <0.6  then cIm=cIm+0.05 end	end
	if key == "w" then moveY = moveY + 0.05 end
	if key == "s" then moveY = moveY - 0.05 end
	if key == "a" then moveX = moveX - 0.05 end
	if key == "d" then moveX = moveX + 0.05 end
	if key == "q" then zoom = zoom + 1 end
	if key == "e" and zoom > 1 then zoom = zoom - 1 end
end

function juliafilled()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - moveX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 - y/(winH/4) - moveY)/zoom	-- convert screen coordinates into actual coordinates
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

	if radius <= 4 then return 1 end
end