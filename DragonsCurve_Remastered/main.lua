--[[ 
<<Program 6b: Arbitrary starting line>>

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

	oline = {{500,350,200,350,'r'}} -- The "original" line, or the line that you draw on screen
	dline = oline					-- The "drawn" line, or the set of lines that make up the current dragon curve
	cline = oline[1]				-- The "curve" line, or the base line of the current dragon curve
	combine = {}					-- Holds the values of dline if the user decides to draw more curve without erasing
	n=1								-- iteration speed
	warn = false					-- safety
	mx = 0		my = 0				-- Mouse values
end

function love.mousepressed(x, y, b)
	if b=="l" then mx,my = x,y end -- Take the start position of the drag
	if b=="wu" then n = n+1 end
	if b=="wd" and n>1 then n = n-1 end
end	

function love.mousereleased(x, y, b)
	if b=="l" and not (mx==x and my==y) then oline[1] = {mx,my,x,y} end -- If the user did not just click but actually dragged
end

function love.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(canvas, 0, 0)
	love.graphics.setColor(255,0,0)
	if help then
			love.graphics.line(oline[1][1],oline[1][2],oline[1][3],oline[1][4])
		love.graphics.print("Hit 'space' to toggle help module",0,0)
		love.graphics.print("'z' to add one iteration to the current dragon curve",0,20)
		love.graphics.print("'x' to undo the last iteration",0,40)
		love.graphics.print("'c' to erase all curves and start a new dragon curve",0,60)
		love.graphics.print("'v' to keep existing curves and start a new dragon curve",0,80)
		love.graphics.print("Current number of lines: "..#dline+#combine,0,100)
		love.graphics.print("Iterations to perform (handle with extreme care!): "..n,0,120)
			love.graphics.setColor(130,130,130)
			love.graphics.print("Be warned! A large number of lines (> 131072) can take a very long time to draw!: ",20,150)
		love.graphics.print("Length of the current dragon curve line: "..length(cline),400,0)
		love.graphics.print("Angle of the current dragon curve line: "..angle(cline)*180/math.pi,400,20)
			love.graphics.setColor(0,255,0)
			love.graphics.line(cline[1],cline[2],cline[3],cline[4])
	end
	if warn then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill",148,680,420,16)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Safety in line 78 stopped process: Lines drawn exceeds two million",150,680)	
	end
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	if key == " " then help = not help end
	if key == "z" then drawcurve() end
	if key == "x" then drawcurve("reverse") end
	if key == "c" then drawcurve("reset") end
	if key == "v" then drawcurve("layer") end
end

function drawcurve(x)
	-- Safety
	if not x and #dline+#combine+#dline*math.pow(2,n) > 2000000 then warn = true return end
	if x=="reset" and math.pow(2,n) > 2000000					then warn = true return end
	if x=="layer" and #dline+#combine+math.pow(2,n) > 2000000	then warn = true return end
	warn = false

	-- Depending on the argument, decide what to do to dline and combine
	if not x then dline = dragoncurve(dline,n)
	elseif x=="reverse" then dline = back(dline,n)
	elseif x=="reset" 	then combine = {}				dline = dragoncurve(oline,n)		-- combine and dline is dumped
	elseif x=="layer" 	then copy(combine, dline) 		dline = dragoncurve(oline,n) end	-- combine archives dline

	-- get the line it currently draws to
	cline = {dline[1][1],dline[1][2],dline[#dline][3],dline[#dline][4]}
	
	-- reset the canvas to draw again
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill', 0, 0, winW, winH)
	love.graphics.setColor(0,0,0)

	for i = 1, #combine do love.graphics.line(combine[i][1],combine[i][2],combine[i][3],combine[i][4]) end
	for i = 1, #dline do love.graphics.line(dline[i][1],dline[i][2],dline[i][3],dline[i][4]) end

	love.graphics.setCanvas()
end

function back(dline,n)
	if n == 0 or #dline == 1 then return dline end -- end of recursion

	local fline = {}
	local dir = 'r'
	if #dline < 2 then return oline end
	for i = 1, #dline-1, 2 do 				-- go by twos since we know every two daughter lines comes from one parent line
		table.insert(fline, {dline[i][1],dline[i][2],dline[i+1][3],dline[i+1][4],dir})
		dir = dir == 'r' and 'l' or 'r' 	-- change right to left and left to right
	end

	fline = back(fline,n-1) -- next level
	return fline
end

function dragoncurve(dline,n)
	if n==0 then return dline end -- end of recursion

	local fline = {}
	for i, v in ipairs(dline) do
		if v[5] == 'r' then rcurve(v,fline) -- v[1] to v[4] are the line coordinates, v[5] is the type of curve
		else lcurve(v,fline)
		end
	end

	fline = dragoncurve(fline,n-1) -- next level
	return fline
end

function rcurve(line,out)
	local cut = length(line)/2
	if line[1] == line[3] then			-- If the angle is straight up or straight down (It's to safeguard atan)
		if line[2] > line[4] then		-- mirrored coordinate system : so this is pointing straight up
			table.insert(out, {line[1],line[2],line[1]+cut,line[4]+cut,'r'})
			table.insert(out, {line[1]+cut,line[4]+cut,line[3],line[4],'l'})
		else
			table.insert(out, {line[1],line[2],line[1]-cut,line[2]+cut,'r'})
			table.insert(out, {line[1]-cut,line[2]+cut,line[3],line[4],'l'})
		end
		return --Almost forgot!
	end

	-- We now know it isn't 90 degrees, so we can we atan
	local angle = angle(line)
	local re = midpoint(line) -- re is the 'real endpoint' / the midpoint of the bend

	
	if line[2] > line[4]
	then re[1] = re[1] + cut*math.sin(angle)
	else re[1] = re[1] - cut*math.sin(angle)
	end
	if line[3] > line[1]
	then re[2] = re[2] + cut*math.cos(angle)
	else re[2] = re[2] - cut*math.cos(angle)
	end

	table.insert(out, {line[1],line[2],re[1],re[2],'r'})
	table.insert(out, {re[1],re[2],line[3],line[4],'l'})
	return
end

--same as the rcurve; but + and - is swapped. I removed a bit of whitespace/characters just because.
function lcurve(l,out)
	local c=length(l)/2 if l[1]==l[3] then if l[2]>l[4] then
	table.insert(out,{l[1],l[2],l[1]-c,l[4]+c,'r'}) table.insert(out,{l[1]-c,l[4]+c,l[3],l[4],'l'})
	else table.insert(out,{l[1],l[2],l[1]+c,l[2]+c,'r'}) table.insert(out,{l[1]+c,l[2]+c,l[3],l[4],'l'}) end
	return end local a=angle(l) local re=midpoint(l)
	if l[2]>l[4] then re[1]=re[1]-c*math.sin(a) else re[1]=re[1]+c*math.sin(a) end
	if l[3]>l[1] then re[2]=re[2]-c*math.cos(a) else re[2]=re[2]+c*math.cos(a) end
	table.insert(out,{l[1],l[2],re[1],re[2],'r'}) table.insert(out,{re[1],re[2],l[3],l[4],'l'}) return
end

-- copy all values of table b into table a
function copy(a,b) for i = 1, #b do table.insert(a, b[i]) end end
function midpoint(l) return {(l[1]+l[3])/2,(l[2]+l[4])/2} end
function length(l) return math.sqrt(math.abs(l[1]-l[3])*math.abs(l[1]-l[3])+math.abs(l[2]-l[4])*math.abs(l[2]-l[4])) end
function angle(l) return math.atan(math.abs(l[2]-l[4])/math.abs(l[1]-l[3])) end