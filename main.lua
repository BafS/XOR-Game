local moonshine = require 'lib/moonshine'

colors = {
	{255, 255, 255},
	{255, 0, 0},
	{0, 255, 0},
	{0, 0, 255},
	{150, 0, 150},
	{255, 255, 0},
	{0, 150, 150},
	{200, 100, 0},
	{120, 120, 120}
}

DEV_MODE = true

-- component = require 'component'

function setState(newstate)
	if states[newstate] then
		-- component.reload()

		if states[newstate].load then
			states[newstate].load()
		end

		state = newstate
	end
end

function love.load()
	window = {}

	local fontPath = 'res/SHPinscher-Regular.otf'

	fontTitle = love.graphics.newFont(fontPath, 120);
	fontNm = love.graphics.newFont(fontPath, 42);
	fontSm = love.graphics.newFont(fontPath, 32);

	window.width, window.height, window.flags = love.window.getMode()

	effect = moonshine(moonshine.effects.chromasep)
		.chain(moonshine.effects.glow)
		.chain(moonshine.effects.filmgrain)
		.chain(moonshine.effects.scanlines)
		.chain(moonshine.effects.vignette)
		.chain(moonshine.effects.crt)

	effect.glow.min_luma = 0
	effect.chromasep.radius = 1.5
	effect.vignette.opacity = 0.15
	effect.glow.strength = 8
	effect.crt.distortionFactor = {1.03, 1.033}
	effect.scanlines.opacity = 0.1
	effect.scanlines.thickness = 3

	love.mouse.setVisible(false)

	states = {
		game = require 'states/game',
		menu = require 'states/menu'
	}
	-- setState('game')
	setState('menu')

	-- t is just a variable we use to help us with the update rate in love.update.
	t = 0 -- (re)set t to 0

	canvas = love.graphics.newCanvas(800, 600)
	love.graphics.setCanvas(canvas)

	love.graphics.setCanvas()
end

function love.update(dt)
	-- if DEV_MODE then
		require('lib/lurker').update() -- @DEV
	-- end

	states[state].update(dt)
end

function love.draw()
	love.graphics.setNewFont(10)
	love.graphics.setColor(80, 80, 80)
	love.graphics.print('FPS: '..tostring(love.timer.getFPS()), window.width - 48, 8)
	
	love.graphics.setColor(255, 255, 255)
	effect(function()
		states[state].draw()
	end)
end

function love.keypressed(k, u)
	states[state].keypressed(k, u)
end

function love.mousepressed(x, y, b)
	if states[state].mousepressed then
		states[state].mousepressed(x, y, b)
	end
end

function love.mousereleased(x, y, b, t)
	if states[state].mousereleased then
		states[state].mousereleased(x, y, b, t)
	end
end

function love.resize(w, h)
	print(('Window resized to width: %d and height: %d.'):format(w, h))
end