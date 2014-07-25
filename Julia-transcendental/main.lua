--[[
<<Program 3b: Transcendental Functions>>

Consider the non-polynomial functions
 Q(z) = c * e^z
 R(z) = c * sin(z)
 S(z) = c * cos(z)

This is an exercise that we can take the basic Julia approach and apply it to any formula, by checking if the orbit escapes.
Boundary scanning is also possible, but backwards iteration is generally impossible do to needing to solve f(x) - w0 = 0
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
	cRe = 1 -- real seed
	cIm = 0 -- imaginary seed
	zoom = 1
	dX = 0
	dY = 0
	r=5
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("Real seed, hit <> to change:       " .. cRe,0,20)
		love.graphics.print("Imaginary seed, hit [] to change:  "..cIm,0,40)
		love.graphics.print("Zoom level (middle mouse button): "..zoom,0,60)
		love.graphics.print("Displacement (cursor keys): "..dX..","..dY,0,80)
		love.graphics.print("'z' creates a exp Julia Set",0,100)
		love.graphics.print("Has additional setting; maxIterations (a/s): "..r,20,120)
		love.graphics.print("'x' creates a sine Julia Set",0,140)
		love.graphics.print("'c' creates a cosine Julia Set",0,160)
		love.graphics.print("Please give a few seconds to calculate image",0,200)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then juliaexp() end
	if key == "x" then juliasin() end
	if key == "c" then juliacos() end
	if key == "a" then r=r-1 end
	if key == "s" then r=r+1 end
end

function love.update(dt)
	if love.keyboard.isDown("up") then dY = dY + 0.05 end
	if love.keyboard.isDown("down") then dY = dY - 0.05 end
	if love.keyboard.isDown("left") then dX = dX + 0.05 end
	if love.keyboard.isDown("right") then dX = dX - 0.05 end
	if love.keyboard.isDown(",") then cRe=cRe-0.01 end
	if love.keyboard.isDown(".") then cRe=cRe+0.01 end
	if love.keyboard.isDown("[") then cIm=cIm-0.01 end
	if love.keyboard.isDown("]") then cIm=cIm+0.01 end
end

function love.mousepressed(x, y, b)
	if (b=='wu') then zoom = zoom + 1 end
	if (b=='wd') then zoom = zoom - 1 end
end

function juliaexp()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			oldRe = (-4 + x/(700/8) - dX)/zoom
			oldIm = (4 + dY - y/(700/8))/zoom
			for n = 1, r do
				--[[e^z = e^(x + iy) = e^x * cos(y) + i * e^x * sin(y)
									   \Real value/       \Imag value/
					
					Q(z) = c * e^z
					Both being complex, makes (a + bi)(c + di)
				]]

				eRe = math.exp(oldRe)*math.cos(oldIm)
				eIm = math.exp(oldRe)*math.sin(oldIm)
				newRe = cRe*eRe - cIm*eIm
				newIm = cRe*eIm + cIm*eRe
				if newRe > 200 then break end
				oldRe = newRe
				oldIm = newIm
			end
			if newRe <= 200 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

function juliasin()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			oldRe = (-4 + x/(700/8) - dX)/zoom
			oldIm = (4 + dY - y/(700/8))/zoom
			for n = 1, 25 do
				--[[
					sin(x + iy) = sin(x)*cosh(y) + i * cos(x) * sinh(y)
								  \Real   value/      \Imaginary value/
					where :: cosh(x) = [e^y + e^-y] / 2
				 			 sinh(x) = [e^y - e^-y] / 2
					
					S(z) = c * sin(z)
					Both being complex, makes (a + bi)(c + di)
				]]
				sRe = math.sin(oldRe)*(math.exp(oldIm)+math.exp(-oldIm))/2
				sIm = math.cos(oldRe)*(math.exp(oldIm)-math.exp(-oldIm))/2
				
				newRe = cRe*sRe - cIm*sIm
				newIm = cRe*sIm + cIm*sRe
				if math.abs(newIm) > 50 then break end
				oldRe = newRe
				oldIm = newIm
			end
			if math.abs(newIm) <=50 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

function juliacos()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			oldRe = (-4 + x/(700/8) - dX)/zoom
			oldIm = (4 + dY - y/(700/8))/zoom
			for n = 1, 25 do
				--[[
					cos(x + iy) = cos(x)*cosh(y) + i * sin(x) * sinh(y)
								  \Real   value/      \Imaginary value/
					where :: cosh(x) = [e^y + e^-y] / 2
				 			 sinh(x) = [e^y - e^-y] / 2
					
					R(z) = c * sin(z)
					Both being complex, makes (a + bi)(c + di)
				]]
				sRe = math.cos(oldRe)*(math.exp(oldIm)+math.exp(-oldIm))/2
				sIm = math.sin(oldRe)*(math.exp(oldIm)-math.exp(-oldIm))/2
				
				newRe = cRe*sRe - cIm*sIm
				newIm = cRe*sIm + cIm*sRe
				if math.abs(newIm) > 50 then break end
				oldRe = newRe
				oldIm = newIm
			end
			if math.abs(newIm) <=50 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end