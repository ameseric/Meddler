--[[
	Main configuration file for Love
--]]


function love.conf(t)			--General love settings. Look up this when in doubt.
    t.window.width = 1024
    t.window.height = 720
    t.window.fullscreen = false
    t.window.vsync = true
    t.window.title = "Meddlers 0.0.1.000"

    t.window.fsaa = 0

    t.modules.physics = false


end

