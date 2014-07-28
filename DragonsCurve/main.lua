--[[ 
<<Program 6: Dragon Curve>>

Take one line and choose [A] or [B]

[A] "curl" it to the right. meaning:

--- expands to R \/ L

[B] "curl" it to the left. meaning:

--- expands to R /\ L

The endpoints are the same, we are just adding a midpoint that is shared between both lines.
The expansion makes the daughter 1/sqrt(2) the size of their parent, and the two lines are perpendicular.

Now recursively; all right dragons curl right [A] and all left dragons curl left [B]. Keep doing it until we tell you to stop.
]]
help = true

function love.load()
	winW = 700
	winH = 700
	success = love.window.setMode(winW, winH)
	love.window.setTitle("Dragon curve")
	
	canvas = love.graphics.newCanvas(winW, winH)
	love.graphics.setCanvas(canvas)
		canvas:clear()
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setCanvas()

	oline = {{500,350,200,350,'r'}} -- The "original" line. for this program it'll be constant.
	dline = oline
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas)
	love.graphics.setColor(255,0,0)
	if help then
		love.graphics.print("Hit 'space' to toggle help module",0,0)
		love.graphics.print("'z' to add one iteration to the dragon curve",0,20)
		love.graphics.print("'x' to undo the last iteration",0,40)
		love.graphics.print("Current number of lines: "..#dline,0,80)
			love.graphics.print("Be careful! A large number of lines (131072) takes long time to calculate!: ",20,100)
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then drawcurve() end
	if key == "x" then drawcurve("reverse") end
	if key == "left" then ox = ox - 10 end
	if key == "right" then ox = ox + 10 end
	if key == "up" then oy = oy - 10 end
	if key == "down" then oy = oy + 10 end
end

function drawcurve(x)
	if not x then dline = dragoncurve(dline)
	else dline = back(dline) end

	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	for i = 1, #dline do love.graphics.line(dline[i][1],dline[i][2],dline[i][3],dline[i][4]) end

	love.graphics.setCanvas()
end

function back(dline)
	local fline = {}
	local dir = 'r'
	if #dline < 2 then return oline end
	for i = 1, #dline-1, 2 do --go by twos since we know every two daughter lines comes from one parent line
		table.insert(fline, {dline[i][1],dline[i][2],dline[i+1][3],dline[i+1][4],dir}) -- removing the midpoint
		dir = dir == 'r' and 'l' or 'r' -- change right to left and left to right
	end
	return fline
end

function dragoncurve(dline)
	local fline = {}
	for i, v in ipairs(dline) do
		if v[5] == 'r' then rcurve(v,fline) -- v[1] to v[4] are the line coordinates, v[5] is the type of curve
		else lcurve(v,fline)
		end
	end
	return fline
end

-- We assume the line to be perfectly in a cardinal direction (N,NE,E,SE,S,SW,W,NW)
-- Hence we can simplify everything to x or x+cut.
-- If we had to assume any line, we would need to include vectors and messy math.
function rcurve(line,out)
	local cut = length(line)/2 -- Half of the length of the line
	local dir = dir(line) -- Direction of the line. 0-7; clockwise from the top
	if dir == 0 then
		table.insert(out, {line[1],line[2],line[1]+cut,line[4]+cut,'r'})
		table.insert(out, {line[1]+cut,line[4]+cut,line[3],line[4],'l'})
	elseif dir == 1 then
		table.insert(out, {line[1],line[2],line[3],line[2],'r'})
		table.insert(out, {line[3],line[2],line[3],line[4],'l'})
	elseif dir == 2 then
		table.insert(out, {line[1],line[2],line[1]+cut,line[4]+cut,'r'})
		table.insert(out, {line[1]+cut,line[4]+cut,line[3],line[4],'l'})
	elseif dir == 3 then
		table.insert(out, {line[1],line[2],line[1],line[4],'r'})
		table.insert(out, {line[1],line[4],line[3],line[4],'l'})
	elseif dir == 4 then
		table.insert(out, {line[1],line[2],line[1]-cut,line[2]+cut,'r'})
		table.insert(out, {line[1]-cut,line[2]+cut,line[3],line[4],'l'})
	elseif dir == 5 then
		table.insert(out, {line[1],line[2],line[3],line[2],'r'})
		table.insert(out, {line[3],line[2],line[3],line[4],'l'})
	elseif dir == 6 then
		table.insert(out, {line[1],line[2],line[1]-cut,line[2]-cut,'r'})
		table.insert(out, {line[1]-cut,line[2]-cut,line[3],line[4],'l'})
	elseif dir == 7 then
		table.insert(out, {line[1],line[2],line[1],line[4],'r'})
		table.insert(out, {line[1],line[4],line[3],line[4],'l'})
	end
	-- The multiple condition statements may look messy, but if you inspect it the code is simply repetitive.
end

-- same as rcurve, except it has been curved in the other direction.
function lcurve(line,out)
	local cut = length(line)/2
	local dir = dir(line)
	if dir == 0 then
		table.insert(out, {line[1],line[2],line[1]-cut,line[4]+cut,'r'})
		table.insert(out, {line[1]-cut,line[4]+cut,line[3],line[4],'l'})
	elseif dir == 1 then
		table.insert(out, {line[1],line[2],line[1],line[4],'r'})
		table.insert(out, {line[1],line[4],line[3],line[4],'l'})
	elseif dir == 2 then
		table.insert(out, {line[1],line[2],line[1]+cut,line[4]-cut,'r'})
		table.insert(out, {line[1]+cut,line[4]-cut,line[3],line[4],'l'})
	elseif dir == 3 then
		table.insert(out, {line[1],line[2],line[3],line[2],'r'})
		table.insert(out, {line[3],line[2],line[3],line[4],'l'})
	elseif dir == 4 then
		table.insert(out, {line[1],line[2],line[1]+cut,line[2]+cut,'r'})
		table.insert(out, {line[1]+cut,line[2]+cut,line[3],line[4],'l'})
	elseif dir == 5 then
		table.insert(out, {line[1],line[2],line[1],line[4],'r'})
		table.insert(out, {line[1],line[4],line[3],line[4],'l'})
	elseif dir == 6 then
		table.insert(out, {line[1],line[2],line[1]-cut,line[2]+cut,'r'})
		table.insert(out, {line[1]-cut,line[2]+cut,line[3],line[4],'l'})
	elseif dir == 7 then
		table.insert(out, {line[1],line[2],line[3],line[2],'r'})
		table.insert(out, {line[3],line[2],line[3],line[4],'l'})
	end
end

-- length of line. Duh.
function length(l) return math.sqrt(math.abs(l[1]-l[3])*math.abs(l[1]-l[3])+math.abs(l[2]-l[4])*math.abs(l[2]-l[4])) end

function dir(line)
	--It goes clockwise with 0 at the top. Remember the coordinate system has 'y' going down instead of up.
	if line[3] == line[1] and line[4] <  line[2] then return 0 end
	if line[3] >  line[1] and line[4] <  line[2] then return 1 end
	if line[3] >  line[1] and line[4] == line[2] then return 2 end
	if line[3] >  line[1] and line[4] >  line[2] then return 3 end
	if line[3] == line[1] and line[4] >  line[2] then return 4 end
	if line[3] <  line[1] and line[4] >  line[2] then return 5 end
	if line[3] <  line[1] and line[4] == line[2] then return 6 end
	if line[3] <  line[1] and line[4] <  line[2] then return 7 end
end