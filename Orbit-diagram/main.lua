--[[
<<Program 2: Orbit Diagram>>

Consider the function Q(x) = x^2 + c

We need to find real c values where x0 do not tend to infinity. This interval is (-2, 1/4) 
:: This can be found using <<Program 1: Iterator>>

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

	c1 = -2
	c2 = 0.25
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("'f' to create orbit diagram",0,40)
		love.graphics.print("bounds: ["..c1..","..c2.."]",0,20)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "f" then orbitdgm() end
	if key == "q" then c1 = c1 + 0.0625 end
	if key == "w" then c2 = c2 - 0.0625 end
end

function orbitdgm()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for c = c1, c2, ((c2-c1)/1400) do -- The interval to check [c1,c2], in 1400 equally spaced points
		x = 0
		m = (700/(c2-c1))*(c-c1) --between [-2,1/4]
		for i = 0, 200 do
			x = x*x + c -- quadratic f(x) = x^2 + c
			if i > 50 then
				n = 155 * (-c1-x) -- between [0,4]
				love.graphics.point(m,n)
			end
		end
	end
	        
	love.graphics.setCanvas()
end