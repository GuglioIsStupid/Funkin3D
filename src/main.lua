require "modules.overrides"
local desktop = {"Windows", "Linux", "OS X"}
IS_DESKTOP = false
nest = require("lib.nest").init({ console = "3ds", scale = 1, mode = "720" })

__DEBUG__ = false

function love.load()
    if love.graphics.setDefaultFilter then
        love.graphics.setDefaultFilter("nearest", "nearest")
    end
    Timer = require "lib.timer"
    state = require "lib.state"

    IS_DESKTOP = table.find(desktop, love.system.getOS())

    if IS_DESKTOP then
        -- is desktop (used for testing)
        input = (require "lib.baton").new {
            controls = {
                -- UI
                uiLeft =        { "axis:leftx-", "button:dpleft",  "key:left"  },
                uiRight =       { "axis:leftx+", "button:dpright", "key:right" },
                uiUp =          { "axis:lefty-", "button:dpup",    "key:up"    },
                uiDown =        { "axis:lefty+", "button:dpdown",  "key:down"  },
                uiConfirm =     { "button:a",    "key:return"    },
                uiBack =        { "button:b",    "key:escape"    },
                uiErectButton = { "button:back", "key:tab"       },
                
                -- Gameplay
                gameLeft =  { "axis:leftx-", "button:dpleft",  "axis:rightx-", "button:x", "axis:triggerleft+",    "key:left",  "key:a"   },
                gameDown =  { "axis:lefty+", "button:dpdown",  "axis:righty+", "button:y", "button:leftshoulder",  "key:down",  "key:s"   },
                gameUp =    { "axis:lefty-", "button:dpup",    "axis:righty-", "button:a", "button:rightshoulder", "key:up",    "key:w"   },
                gameRight = { "axis:leftx+", "button:dpright", "axis:rightx+", "button:b", "axis:triggerright+",   "key:right", "key:d"   },
            },
            joystick = love.joystick.getJoysticks()[1],
        }
    else
        -- is 3DS
        input = (require "lib.baton").new {
            controls = {
                -- UI
                uiLeft =        { "axis:leftx-", "button:dpleft"  },
                uiRight =       { "axis:leftx+", "button:dpright" },
                uiUp =          { "axis:lefty-", "button:dpup"    },
                uiDown =        { "axis:lefty+", "button:dpdown"  },
                uiConfirm =     { "button:a"    },
                uiBack =        { "button:b"    },
                uiErectButton = { "button:back" },
                
                -- Gameplay
                gameLeft =  { "button:leftshoulder",  "axis:leftx-",  "axis:rightx-",       "button:dpleft",  "button:y"   },
                gameDown =  { "axis:lefty+",          "axis:righty+", "axis:triggerleft+",  "button:dpdown",  "button:b"   },
                gameUp =    { "axis:lefty-",          "axis:righty-", "axis:triggerright+", "button:dpup",    "button:x"   },
                gameRight = { "button:rightshoulder", "axis:leftx+",  "axis:rightx+",       "button:dpright", "button:a"   },
            },
            joystick = love.joystick.getJoysticks()[1],
        }
    end

    uiConfirm = love.audio.newSource("assets/sounds/confirmMenu.ogg", "static")
    uiBack = love.audio.newSource("assets/sounds/cancelMenu.ogg", "static")
    uiScroll = love.audio.newSource("assets/sounds/scrollMenu.ogg", "static")

    -- Modules
    graphics = require "modules.graphics"
    audio = {play = function(sound)
        sound:stop()
        sound:play()
    end}

    isErect = false

    weekData = {
        require "states.weeks.tutorial",
        require "states.weeks.week1",
        require "states.weeks.week2",
        require "states.weeks.week3",
        require "states.weeks.week4",
        require "states.weeks.week5",
        require "states.weeks.week6"
    }

    -- States
    title = require "states.menu.title"
    title.music = love.audio.newSource("assets/music/freakyMenu.ogg", "stream")
    title.music:setLooping(true)
    title.music:setVolume(0.5)
    title.music:play()

    menuSelect = require "states.menu.menuSelect"
    storyMode = require "states.menu.storyMode"
    freeplay = require "states.menu.freeplay"

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
    love.graphics.setFont(uiFont)

    state.switch(title)

    graphics.setFade(0)
    graphics.fadeIn(0.5)
end

function love.update(dt)
    local dt = math.min(dt, 1/30)
    input:update()
    Timer.update(dt)
    state.update(dt)
end

function love.keypressed(k)
    if k == "7" then
        state.switch(debugOffset)
    end
    state.keypressed(k)
    nest.video.keypressed(k)
end

function love.draw(screen)
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

        -- draw debug stuff
        love.graphics.print(
            "FPS: " .. love.timer.getFPS() .. "\n" ..
            "Memory: " .. math.round(collectgarbage("count"), 2) .. "KB\n",
            0, 190
        )
    else
        state.topDraw()
    end

    love.graphics.pop()
    
    love.graphics.setColor(1,1,1,1)
end