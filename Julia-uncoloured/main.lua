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
	 
	 --Julia Setup
	newRe = 0
	newIm = 0
	oldRe = 0
	oldIm = 0
	cRe = 0.3 --seed c0
	cIm = -0.4 --seed c1
	zoom = 1
	moveX = 0
	moveY = 0
	maxIter = 256
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
		love.graphics.print("'f' to create filled in Julia Set",0,100)
		love.graphics.print("'b' creates backwards iteration Julia Set",0,120)
		love.graphics.print("Please give a few seconds to calculate image",0,140)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "f" then juliafilled() end
	if key == "b" then juliaback() end
	if key == "," then	if cRe >-0.6 then cRe=cRe-0.05 end	end
	if key == "." then	if cRe <0.6  then cRe=cRe+0.05 end	end
	if key == "[" then	if cIm >-0.6 then cIm=cIm-0.05 end	end
	if key == "]" then	if cIm <0.6  then cIm=cIm+0.05 end	end
	if key == "w" then moveY = moveX + 0.05 end
	if key == "s" then moveY = moveX - 0.05 end
	if key == "a" then moveX = moveX - 0.05 end
	if key == "d" then moveX = moveX + 0.05 end
	if key == "q" then zoom = zoom + 5 end
	if key == "e" and zoom > 1 then zoom = zoom - 5 end
end

function juliafilled()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			--calculate the initial real and imaginary part of z
			newRe = 1.5 * (x - winW / 2) / (0.5 * zoom * winW) + moveX
			newIm = 1.5 * (y - winH / 2) / (0.5 * zoom * winH) + moveY
			radius = 0
			for i = 0, maxIter do
				oldRe = newRe
				oldIm = newIm
				
				--x2 = (x1)^2 - (y1)^2 + c0
				newRe = oldRe * oldRe - oldIm * oldIm + cRe
				--y2 = 2 (x1)(y1) + c1
				newIm = 2 * oldRe * oldIm + cIm
				
				radius = newRe * newRe + newIm * newIm
				if  radius > 4 then break end
			end
			if radius <= 4  then love.graphics.point(x,y) end

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

	x0 = 1
	y0 = 1

	for i = 0, 10000 do
		w0 = x0 - cRe
		w1 = y0 - cIm
		a = w1/w0 * math.pi / 180
		if w0 == 0 then theta = math.pi/2							end
		if w0 > 0  then theta = math.cos(a)/math.sin(a)				end
		if w0 < 0  then theta = math.cos(a)/math.sin(a) + math.pi	end

		r = math.sqrt(w0*w0 + w1*w1)

		theta = theta/2 + math.random(0,1) * math.pi
		r = math.sqrt(r)
		x0 = r * math.cos(theta)
		y0 = r * math.sin(theta)
		if (i > 50) then
			x = (x0+2) * winW/4
			y = (2-y0) * winH/4
			love.graphics.point(x,y)
		end
	end
	        
	love.graphics.setCanvas()
end
