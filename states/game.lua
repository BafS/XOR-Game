local game = {}

local updaterate = 0.2 -- DEBUG bigger = slow
local timer = 20
local blocSize = 33.3

local signals = {}
local level = {}
local levelZone = {}
local levelSignal = {}
local levelSignalTmp = {}
local paintMode = 1
local isRunning = false
local levelNumber = 1
local numberOfEnd
local win = false
local numberOfLevels = 3

function loadLevelImage(levelNumber)
	print(levelNumber)
	print(levelNumber)
	print(levelNumber)
	print(levelNumber)
	return love.image.newImageData('levels/l' .. levelNumber .. '.png')
end

function getLevel(image)
	local pixels = {}
	for x = 1, image:getWidth() do
		local col = {}
		for y = 1, image:getHeight() do
			-- Pixel coordinates range from 0 to image width - 1 / height - 1.
			local r, g, b = image:getPixel(x - 1, y - 1)
			local pixel
			if r == 255 and g == 255 and b == 255 then
				pixel = 0 -- empty
			elseif r == b and b == g then
				pixel = 2 -- zone
			elseif r > 200 or g > 100 then
				pixel = 1 -- path
			end
			col[y] = pixel
		end
		pixels[x] = col
	end
	return pixels
end

-- Todo remove duplication
function getSpecialZone(image)
	local pixels = {}
	for x = 1, image:getWidth() do
		local col = {}
		for y = 1, image:getHeight() do
			-- Pixel coordinates range from 0 to image width - 1 / height - 1.
			local r, g, b = image:getPixel(x - 1, y - 1)
			local pixel = 0
			if r == b and b == g and r < 250 then
				pixel = 1
			elseif r < 200 and g > 100 then
				pixel = 2 -- end
				numberOfEnd = numberOfEnd + 1
			end
			col[y] = pixel
		end
		pixels[x] = col
	end
	return pixels
end

function drawLevel(level, levelSize)
	for x = 1, levelSize.width do
		for y = 1, levelSize.height do
			local type = level[x][y]
			local typeSignal = levelSignal[x][y]
			local typeZone = levelZone[x][y]

			if type == 0 then
				love.graphics.setColor(1, 7, 36) -- empty
			elseif type == 1 then
				love.graphics.setColor(14, 86, 40) -- circuit path
			elseif type == 2 then
				love.graphics.setColor(46, 14, 39) -- paint zone
			end
			if typeZone == 2 then
				-- print(x..' '..y)
				love.graphics.setColor(255, 255, 255) -- end
			end
			love.graphics.rectangle('fill', (x-1) * blocSize, (y-1) * blocSize, blocSize, blocSize)

			if typeSignal ~= 0 then
				if typeSignal == 1 then
					love.graphics.setColor(80, 225, 255)
				else
					love.graphics.setColor(225, 80, 255)
				end
				love.graphics.rectangle('fill', (x-1) * blocSize, (y-1) * blocSize, blocSize, blocSize)
			end
		end
	end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function nextTick()
	levelSignalTmp = deepcopy(levelSignal)

	local endTouched = 0

	for x = 1, levelSize.width - 1 do
		for y = 1, levelSize.height - 1 do
			local setSignal = function(value)
				-- Check if the path is available
				if level[x][y] == 1 then
					levelSignalTmp[x][y] = value
				end
			end

			current = levelSignal[x][y]

			if x > 1 then
				left = levelSignal[x-1][y]
			else
				left = 0
			end

			right = levelSignal[x+1][y]

			if y > 1 then
				top = levelSignal[x][y-1]
			else
				top = 0
			end

			bottom = levelSignal[x][y+1]

			if left + 1 == current or left - 2 == current then
				setSignal(left)
			elseif right + 1 == current or right - 2 == current then
				setSignal(right)
			elseif top + 1 == current or top - 2 == current then
				setSignal(top)
			elseif bottom + 1 == current or bottom - 2 == current then
				setSignal(bottom)
			end

			-- Touche a ending zone
			if levelSignalTmp[x][y] == 2 and levelZone[x][y] == 2 then
				endTouched = endTouched + 1
			end

			-- All the zones are touched at the same time
			if numberOfEnd == endTouched then
				win = true
				isRunning = false
			end
		end
	end

	return levelSignalTmp
end

function initSignals()
	-- init to 0
	for x = 1, image:getWidth() do
		local col = {}
		for y = 1, image:getHeight() do
			col[y] = 0
		end
		levelSignal[x] = col
	end

	-- init signals
	for y = 1, levelSize.height do
		local type = level[1][y]
		if type == 1 then
			print(y) -- debug
			levelSignal[1][y] = 1
			levelSignal[2][y] = 2
		end
	end
end

function game.load()
	config = {{}}

	numberOfEnd = 0
	image = loadLevelImage(levelNumber)
	levelSize = {
		['height'] = image:getHeight(),
		['width'] = image:getWidth()
	}

	levelZone = getSpecialZone(image)
	level = getLevel(image)

	initSignals()
end

function game.update(dt)
	t = t + dt

	if love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		x = math.floor(x / blocSize) + 1
		y = math.floor(y / blocSize) + 1

		if levelZone[x][y] == 1 then
			level[x][y] = paintMode
		end
	end

	if t > updaterate then
		if isRunning then
			levelSignal = nextTick()
		end

		t = t - updaterate
	end
end

function game.draw()
	love.graphics.setFont(fontSm);

	drawLevel(level, levelSize)

	local x, y = love.mouse.getPosition() -- get the position of the mouse
	
	-- Cursor
	love.graphics.setColor(26, 255, 166)
	love.graphics.rectangle('fill', math.floor(x / blocSize) * blocSize, math.floor(y / blocSize) * blocSize, blocSize, blocSize)

	love.graphics.print('[space] to pause/run', 10, window.height - 75)
	love.graphics.print('[return] to restart', 10, window.height - 50)
	love.graphics.print('Level #'..levelNumber, 10, 5)
	love.graphics.print('Paint mode: '..paintMode, 10, 30)
	if isRunning then
		love.graphics.print('Game is running...', 420, 5)
	end
	love.graphics.print('[1] draw paint mode', 420, window.height - 75)
	love.graphics.print('[2] erase paint mode', 420, window.height - 50)

	if win then
		if numberOfLevels == levelNumber then
			love.graphics.print('All level completed !', 20, (window.height / 2) + 50)
		else
			love.graphics.print('[return] to go to next level', 20, (window.height / 2) + 50)
		end
		love.graphics.setFont(fontTitle);
		love.graphics.print('YOU WIN', 20, (window.height / 2) - 120)

	end
end

function game.keypressed(key)
	if key == ' ' or key == 'space' then
		isRunning = not isRunning
		
	elseif key == 'return' then
		if win then
			print('next level')
			win = false
			isRunning = false
			if numberOfLevels == levelNumber then
				levelNumber = 1
				setState('menu')
			else
				levelNumber = levelNumber + 1
				game.load()
			end
		else
			print('restart')
			initSignals()
		end
	else		
		-- return
		if key == '1' then
			paintMode = 1
		elseif key == '2' then
			paintMode = 2
		end
	end
end

return game
