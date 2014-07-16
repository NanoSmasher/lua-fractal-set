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
		love.graphics.print("Please give a few seconds to calculate image",0,120)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then juliafilled_colour() end
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

function juliafilled_colour()
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)
	for x = 0, winW do 
		for y = 0, winH do
			newRe = (-2 + x/(winW/4) - moveX)/zoom	-- convert screen coordinates into actual coordinates
			newIm = (2 - y/(winH/4) - moveY)/zoom	-- convert screen coordinates into actual coordinates
			radius = 0
			for i = 0, 100 do
				oldRe = newRe
				oldIm = newIm
				newRe = oldRe * oldRe - oldIm * oldIm + cRe	-- Square real values and add cRe
				newIm = 2 * oldRe * oldIm + cIm				-- Square imaginary values and add cIm

				radius = newRe * newRe + newIm * newIm
				if  radius > 4 then
					if i < 2 then love.graphics.setColor(100,0,0)
					elseif i < 3 then love.graphics.setColor(100,100,0)
					elseif i < 4 then love.graphics.setColor(150,100,0)
					elseif i < 5 then love.graphics.setColor(150,150,0)
					elseif i < 6 then love.graphics.setColor(255,100,0)
					elseif i < 7 then love.graphics.setColor(255,100,100)
					elseif i < 8 then love.graphics.setColor(255,255,100)
					elseif i < 9 then love.graphics.setColor(255,200,200)
					else love.graphics.setColor(255,255,255)
					end
					break
				end -- quicker to invoke [|z|^2 > 4] than [|z| > 2]
			end
			if radius <= 4  then love.graphics.setColor(0,0,0) end
			love.graphics.point(x,y)
		end
	end

	love.graphics.setCanvas()
end