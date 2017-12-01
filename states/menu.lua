local menu = {}

local t = 0
local updaterate = 0.1

function menu.load()
	print 'MENU'
	globI = 0
end

function menu.update(dt)
	t = t + dt
	globI = (globI + 0.5) % 20

	if t > updaterate then
		t = t - updaterate
	end
end

function printkey(k)
	if k == '11' then
		return '11'
	else
		return k
	end
end

function menu.draw()
	love.graphics.setFont(fontTitle);
	local title = 'X0R'
	local pressStart = 'Press start to begin...'

	love.graphics.setLineWidth(1)
	for i = 0, 15 do
		love.graphics.setColor(4*i, 16*i, 17*i)
		local y = math.floor(window.height / 1.75 + math.pow(i+globI/20, 2.5) / 2.5)
		love.graphics.line(0, y, 800, y)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(fontTitle);
	local width = fontTitle:getWidth(title)
	love.graphics.print(title, window.width / 2 - width / 2, 120)

	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(fontNm);
	local width = fontNm:getWidth(pressStart)
	love.graphics.print(pressStart, window.width / 2 - width / 2, 280)
end

function menu.keypressed(key)
	if (key == ' ' or key == 'space' or key == 'return') then
		setState('game')
	end
end

return menu
