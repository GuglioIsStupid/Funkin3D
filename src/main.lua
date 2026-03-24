require "modules.overrides"
DESKTOPS = {"Windows", "Linux", "OS X"}
IS_DESKTOP = false
if love._console and love._console == "3ds" then
    nestscale = 1
else
    nestscale = 1.5
end
nest = require("lib.nest").init({ console = "3ds", scale = nestscale, mode = "720" })

__DEBUG__ = false
__VERSION__ = love.filesystem.read("assets/data/version.txt") or "Unknown Version"

function love.load()
    if love.graphics.setDefaultFilter then
        love.graphics.setDefaultFilter("nearest", "nearest")
    end
    Timer = require "lib.timer"
    state = require "lib.state"

    IS_DESKTOP = table.find(DESKTOPS, love.system.getOS())

    input = require "modules.input"

    uiConfirm = love.audio.newSource("assets/sounds/confirmMenu.ogg", "static")
    uiBack = love.audio.newSource("assets/sounds/cancelMenu.ogg", "static")
    uiScroll = love.audio.newSource("assets/sounds/scrollMenu.ogg", "static")

    -- Modules
    settingsHandler = require "modules.settings"
    settingsHandler.load()
    graphics = require "modules.graphics"
    audio = require "modules.audio"

    isErect = false

    weekData = {
        require "states.weeks.tutorial",
        require "states.weeks.week1",
        require "states.weeks.week2",
        require "states.weeks.week3",
        require "states.weeks.week4",
        require "states.weeks.week5",
        require "states.weeks.week6",
        require "states.weeks.week7"
    }

    -- States
    title = require "states.menu.title"
    title.music = love.audio.newSource("assets/music/freakyMenu.ogg", "stream")
    title.music:setLooping(true)
    audio.playMusic(title.music, 0.5)

    menuSelect = require "states.menu.menuSelect"
    storyMode = require "states.menu.storyMode"
    freeplay = require "states.menu.freeplay"
    settingsMenu = require "states.menu.settings"

    debugOffset = require "states.debug.offsets"

    camera = {
        zoom=1,
        toZoom=1,
        x=0,y=0,
        zooming=true,
        locked=false
    }

    uiScale = {
        zoom=1,
        toZoom=1,
        x=0,y=0
    }

    spriteTimers = {
		0, -- Girlfriend
		0, -- Enemy
		0 -- Boyfriend
	}

    weeks = require "states.weeks"

    font = love.graphics.newFont("assets/fonts/vcr.ttf", 12)
    uiFont = love.graphics.newFont("assets/fonts/vcr.ttf", 24)
    uiFont2 = love.graphics.newFont("assets/fonts/vcr.ttf", 18)

    pixelFont = love.graphics.newFont("assets/fonts/pixel.ttf", 12)
    pixelUiFont = love.graphics.newFont("assets/fonts/pixel.ttf", 24)
    pixelUiFont2 = love.graphics.newFont("assets/fonts/pixel.ttf", 18)

    love.graphics.setFont(uiFont)

    state.switch(title)

    graphics.setFade(0)
    graphics.fadeIn(0.5)
end

function love.update(dt)
    input:update()
    Timer.update(dt)
    state.update(dt)
    audio.update()
end

function love.keypressed(k)
    if k == "7" then
        state.switch(debugOffset)
    end
    state.keypressed(k)
    nest.video.keypressed(k)
end

function love.draw(screen)
    if screen == "right" and love.graphics.getDepth() == 0 then return end
    love.graphics.push()
    if love._console and love._console == "Wii U" then
        if screen == "gamepad" then
            love.graphics.scale(2, 2)
            love.graphics.translate(60, 0)
        else
            love.graphics.scale(3, 3)
            love.graphics.translate(12, 0)
        end
    end
    graphics.setColor(1,1,1,1)

    if screen == "bottom" or screen == "gamepad" then
        state.bottomDraw()

        if settingsHandler.data.debug ~= "OFF" then
            local str = "FPS: " .. love.timer.getFPS() .. "\n"
            if settingsHandler.data.debug ~= "FPS" then
                str = str .. "Memory: " .. math.round(collectgarbage("count"), 2) .. "KB\n"
            end
            love.graphics.print(str, 0, 190 + (settingsHandler.data.debug == "FPS" and 20 or 0))
        end
    else
        state.topDraw()
    end

    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)
end

function love.quit()
    settingsHandler.save()
end