function math.round(n, deci)
    deci = 10^(deci or 0)
    return math.floor(n*deci+.5)/deci
end

function lerp(a,b,t)
    return a + (b-a)*t
end
function coolLerp(a, b, t)
    return lerp(a, b, t * 60 * love.timer.getDelta())
end
function clamp(a, b, c)
    return math.max(math.min(a, c), b)
end

function table.find(t, v)
    for i, j in pairs(t) do
        if j == v then
            return i
        end
    end
    return nil
end

function unpackLines(t, sep)
    -- t is a table, can have numbers or strings
    -- sep is a string, the separator
    local str = ""
    for i, j in pairs(t) do
        if type(j) == "table" then
            str = str .. unpackLines(j, sep) .. sep
        else
            str = str .. j .. sep
        end
    end
    return str
end

local desktop = {"Windows", "Linux", "OS"}

__DEBUG__ = false

function love.load()
    if love.graphics.setDefaultFilter then
        love.graphics.setDefaultFilter("nearest", "nearest")
    end
    -- Load libraries
    if __DEBUG__ then
        debugGraph = require "lib.debugGraph"
        graphs = {
            fps = debugGraph:new("fps", 0, 0, 100, 50),
            mem = debugGraph:new("mem", 0, 50, 100, 50),
            texturememory = debugGraph:new("custom", 0, 150, 100, 50),
        }
    end
    Timer = require "lib.timer"
    Gamestate = require "lib.gamestate"
    json = require "lib.json"
    require "lib.dslayout"

    if table.find(desktop, love.system.getOS()) then
        -- is desktop (used for testing)
        input = (require "lib.baton").new {
            controls = {
                -- UI
                uiLeft =    {'axis:leftx-', 'button:dpleft'},
                uiRight =   {'axis:leftx+', 'button:dpright'},
                uiUp =      {'axis:lefty-', 'button:dpup'},
                uiDown =    {'axis:lefty+', 'button:dpdown'},
                uiConfirm = {'button:a'},
                uiBack =    {'button:b'},
                
                -- Gameplay
                gameLeft =  {'axis:leftx-', 'button:dpleft', "axis:rightx-", "button:x", "axis:triggerleft+"},
                gameDown =  {'axis:lefty+', 'button:dpdown', "axis:righty+", "button:y", "button:leftshoulder"},
                gameUp =    {'axis:lefty-', 'button:dpup', "axis:righty-", "button:a", "button:rightshoulder"},
                gameRight = {'axis:leftx+', 'button:dpright', "axis:rightx+", "button:b", "axis:triggerright+"},
            },
            joystick = love.joystick.getJoysticks()[1],
        }
    else
        -- is 3DS
        print("3DS detected, using 3DS controls")
        input = (require "lib.baton").new {
            controls = {
                -- UI
                uiLeft =    {'axis:leftx-', 'button:dpleft'},
                uiRight =   {'axis:leftx+', 'button:dpright'},
                uiUp =      {'axis:lefty-', 'button:dpup'},
                uiDown =    {'axis:lefty+', 'button:dpdown'},
                uiConfirm = {'button:a'},
                uiBack =    {'button:b'},
                
                -- Gameplay
                gameLeft =  {"button:leftshoulder", "axis:leftx-", "axis:rightx-", "button:dpleft", "button:y"},
                gameDown =  {"axis:lefty+", "axis:righty+", "axis:triggerleft+", "button:dpdown", "button:b"},
                gameUp =    {"axis:lefty-", "axis:righty-", "axis:triggerright+", "button:dpup", "button:x"},
                gameRight = {"button:rightshoulder", "axis:leftx+", "axis:rightx+", "button:dpright", "button:a"},
            },
            joystick = love.joystick.getJoysticks()[1],
        }
    end

    uiConfirm = love.audio.newSource("assets/sounds/confirmMenu.ogg", "static")
    uiBack = love.audio.newSource("assets/sounds/cancelMenu.ogg", "static")
    uiScroll = love.audio.newSource("assets/sounds/scrollMenu.ogg", "static")

    dslayout:init {color={r=0.2,g=0.2,b=0.2,a=1}, title="Funkin 3DS"}

    -- Modules
    graphics = require "modules.graphics"
    audio = {
        play = function(sound)
            sound:stop()
            sound:play()
        end
    }

    weekList = {
        {
            "Tutorial",
            {
                "Tutorial"
            }
        },
        {
            "Week 1",
            {
                "Bopeebo",
                "Fresh",
                "Dadbattle"
            }
        },
        {
            "Week 2",
            {
                "Spookeez",
                "South",
                "Monster"
            }
        },
        {
            "Week 3",
            {
                "Pico",
                "Philly Nice",
                "Blammed"
            }
        }
    }
    weekData = {
        require "states.weeks.tutorial",
        require "states.weeks.week1",
        require "states.weeks.week2",
        require "states.weeks.week3"
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
        zoom = 1,
        toZoom = 1,
        x=0,y=0,
        zooming = true,
        locked = false
    }

    uiScale = {
        zoom = 1,
        toZoom = 1,
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

    Gamestate.switch(title)

    graphics.setFade(0)
    graphics.fadeIn(0.5)
end

function love.update(dt)
    input:update()
    Timer.update(dt)    
    Gamestate.update(dt)
    if __DEBUG__ then
        -- graph stuffs
        graphs.fps:update(dt)
        graphs.mem:update(dt)
        graphs.texturememory:update(dt, love.graphics.getStats().texturememory/1024/1024)
        graphs.texturememory.label = "Texture Memory: " .. math.round(love.graphics.getStats().texturememory / 1024 / 1024, 2) .. "MB"
    end
end

function love.keypressed(k)
    if k == "7" then
        Gamestate.switch(debugOffset)
    end
    Gamestate.keypressed(k)
end

function love.draw(screen)
    graphics.setColor(1,1,1,1)
    dslayout:draw(
        screen,
        function()
            Gamestate.topDraw()

            if __DEBUG__ then
                love.graphics.push()
                    love.graphics.setColor(1,1,1,1)
                    love.graphics.scale(0.6, 0.6)
                    for k, v in pairs(graphs) do
                        v:draw()
                    end
                love.graphics.pop()
            end
        end,

        function()
            Gamestate.bottomDraw()

            -- draw debugg stuff
            love.graphics.print(
                "FPS: " .. love.timer.getFPS() .. "\n" ..
                "Memory: " .. math.round(collectgarbage("count")/1024, 2) .. "MB\n",
                0, 190
            )
        end
    )
    love.graphics.setColor(1,1,1,1)
end