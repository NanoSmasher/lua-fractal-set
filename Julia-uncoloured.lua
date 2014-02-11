--
--
-- Make sure to rename this file to main.lua,
-- and throw it in a random folder before use
--              *sigh*, the problems with love
--
--

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
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit space' to toggle help module",0,0)
		love.graphics.print("Real seed, hit <> to change:         " .. cRe,0,25)
		love.graphics.print("Imaginary seed, hit [] to change:  "..cIm,0,40)
		love.graphics.print("'f' to create Julia set",0,55)
		love.graphics.print("'b' creates Julia w/backwards iteration",0,70)
		love.graphics.print("Please give a few seconds to calculate image",0,90)
	end
	love.graphics.setColor(255,255,255)
end

function love.keypressed(key)
	if key == " " then help = not help end
	if key == "f" then juliafilled() end
	if key == "," then	if cRe >-0.6 then cRe=cRe-0.05 end	end
	if key == "." then	if cRe <0.6 then cRe=cRe+0.05 end	end
	if key == "[" then	if cIm >-0.6 then cIm=cIm-0.05 end	end
	if key == "]" then	if cIm <0.6 then cIm=cIm+0.05 end	end
end

function juliafilled()
	love.graphics.setCanvas(canvas)
	        canvas:clear()
	        love.graphics.setColor(255,255,255)
	        love.graphics.rectangle('fill', 0, 0, winW, winH)
	        love.graphics.setColor(0,0,0)
	        for x = 0,  winW do 
		for y = 0, winH do
			--calculate the initial real and imaginary part of z
			newRe = 1.5 * (x - winW / 2) / (0.5 * zoom * winW) + moveX
			newIm = (y - winH / 2) / (0.5 * zoom * winH) + moveY
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
			if radius <= 4  then
				love.graphics.point(x,y)
			end
		end
	        end
	        
	love.graphics.setCanvas()
	 end
