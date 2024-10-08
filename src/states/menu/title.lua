local title = {}
local confirmPressed = false

function title:enter()
    gfTitle = love.filesystem.load("assets/sprites/menu/gfTitle.lua")()
    logoBumpin = love.filesystem.load("assets/sprites/menu/logoBumpin.lua")()

    gfTitle.x = 80
    gfTitle.y = 25
    logoBumpin.x = -80
    logoBumpin.y = -25

    logoBumpin.sizeX, logoBumpin.sizeY = 1.3, 1.3
    gfTitle.sizeX, gfTitle.sizeY = 1.15, 1.15

    logoBumpin.depth = 3
    gfTitle.depth = 3

    if not title.music:isPlaying() then
        title.music:play()
    end
    confirmPressed = false

    graphics.setFade(0)
    graphics.fadeIn(0.3)
end

function title:update(dt)
    gfTitle:update(dt)
    logoBumpin:update(dt)

    if input:pressed("uiConfirm") and not confirmPressed then
        audio.play(uiConfirm)
        confirmPressed = true
        Timer.after(1, function()
            graphics.fadeOut(0.3, function()
                state.switch(menuSelect)
            end)
        end)
    end

    if input:pressed("uiBack") then
        audio.play(uiBack)
        graphics.fadeOut(0.5, function()
            love.event.quit()
        end)
    end
end

function title:topDraw()
    love.graphics.push()
        graphics.setColor(1,1,1)
        love.graphics.translate(200, 120)
        logoBumpin:draw()
        gfTitle:draw()
    love.graphics.pop()
end

function title:bottomDraw()
    love.graphics.push()
        love.graphics.printf(
            "Funkin 3DS" .. "\n" ..
            "Beta" .. (version or "4") .. "\n" ..
            "By: GuglioIsStupid" .. "\n\n" ..
            "Special thanks to:" .. "\n" ..
            "The Funkin Crew" .. "\n",
            0, 0, 320, "left"
        )
    love.graphics.pop()
end

function title:leave()
    gfTitle:release()
    logoBumpin:release()
end

return title