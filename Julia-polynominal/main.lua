--[[
<<Program 3a: Polynomial Functions>>

Consider Q(z) = x^n + c,

where any integer n > 2 is used.
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
	cRe = 0.384 -- real seed
	cIm = 0 -- imaginary seed
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
		love.graphics.print("'z/x/c' creates a degree 3,4,5 Julia Set",0,100)
		love.graphics.print("Please give a few seconds to calculate image",0,140)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then julia3() end
	if key == "x" then julia4() end
	if key == "c" then julia5() end
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

function julia3()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 + dY - y/(winH/4))/zoom
			for n = 1, 20 do
				oldRe = newRe
				oldIm = newIm
				--[[
					z^3 + c = z * z * z + c
						= [a+bi][a+bi][a+bi] + c
						= [(a*a-b*b)+(2*a*b)i][a+bi] + c
						= [a*a*a-3*a*b*b] + [3*a*a*b - b*b*b]i + c
				]]

				newRe = oldRe*oldRe*oldRe-3*oldRe*oldIm*oldIm + cRe
				newIm = 3*oldRe*oldRe*oldIm - oldIm*oldIm*oldIm + cIm
				radius = newRe * newRe + newIm * newIm
				if radius > 4 then break end
			end
			if radius <= 4 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

function julia4()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 + dY - y/(winH/4))/zoom
			for n = 1, 20 do
				oldRe = newRe
				oldIm = newIm
				--[[
					z^4 + c = z * z * z * z + c
						= {[a*a*a-3*a*b*b] + [3*a*a*b - b*b*b]i}{a + bi} + c
						= [a*a*a*a -6*a*a*b*b + b*b*b*b] + [4*a*a*a*b-4*a*b*b*b]i + c
				]]--

				newRe = oldRe*oldRe*oldRe*oldRe - 6*oldRe*oldRe*oldIm*oldIm + oldIm*oldIm*oldIm*oldIm + cRe
				newIm = 4*oldRe*oldRe*oldRe*oldIm - 4*oldRe*oldIm*oldIm*oldIm + cIm
				radius = newRe * newRe + newIm * newIm
				if radius > 4 then break end
			end
			if radius <= 4 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end

function julia5()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - dX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 + dY - y/(winH/4))/zoom
			for n = 1, 20 do
				a = newRe
				b = newIm
				--z^5 + c = z * z * z * z ... I think you get it. Just do binomial distribution.
				newRe = a*a*a*a*a - 10*a*a*a*b*b + 5*a*b*b*b*b + cRe
				newIm = 5*a*a*a*a*b - 10*a*a*b*b*b + b*b*b*b*b + cIm
				radius = newRe * newRe + newIm * newIm
				if radius > 4 then break end
			end
			if radius <= 4 then love.graphics.point(x,y) end
		end
	end
	love.graphics.setCanvas()
end