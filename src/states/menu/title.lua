local title = {}

function title:enter()
    gfTitle = love.filesystem.load("assets/sprites/menu/gfTitle.lua")()
    logoBumpin = love.filesystem.load("assets/sprites/menu/logoBumpin.lua")()

    gfTitle.x = 100
    gfTitle.y = 25
    logoBumpin.x = -100
    logoBumpin.y = -25

    if not title.music:isPlaying() then
        title.music:play()
    end
end

function title:update(dt)
    gfTitle:update(dt)
    logoBumpin:update(dt)

    if input:pressed("uiConfirm") then
        print("switching to game")
        audio.play(uiConfirm)
        Timer.after(1, function()
            graphics.fadeOut(0.5, function()
                Gamestate.switch(menuSelect)
            end)
        end)
    end
end

function title:topDraw()
    love.graphics.push()
        graphics.setColor(1,1,1)
        love.graphics.translate(200, 120)
        gfTitle:draw()
        logoBumpin:draw()
    love.graphics.pop()
end

function title:bottomDraw()
    love.graphics.push()
        love.graphics.printf(
            "Funkin 3DS" .. "\n" ..
            "v" .. (version or "1 BETA") .. "\n" ..
            "By: GuglioIsStupid" .. "\n\n" ..
            "Special thanks to:" .. "\n" ..
            "The Funkin Crew" .. "\n",
            0, 0, 320, "right"
        )
    love.graphics.pop()
end

function title:leave()
    gfTitle:release()
    logoBumpin:release()
end

return title