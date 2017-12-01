function love.conf(t)

    t.version = '0.10.0'                -- The LÖVE version this game was made for (string)
    t.window.title = 'X0R'             -- The window title (string)
    -- t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800                -- The window width (number)
    t.window.height = 600               -- The window height (number)
    -- t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = true              -- Let the window be user-resizable (boolean)
    -- t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    -- t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    -- t.window.fullscreen = false         -- Enable fullscreen (boolean)
    -- t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = true               -- Enable vertical sync (boolean)
    -- t.window.msaa = 10                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    -- t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    -- t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    -- t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)
 
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = false
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = false
    t.modules.window = true
    t.modules.thread = true
end
