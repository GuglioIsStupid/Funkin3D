local menuSelect = {}
local curSelect = 1

function menuSelect:enter()
    menuBG = graphics.newImage(graphics.imagePath("menu/menubg"))
    menuBG.sizeY = 1.05

    -- ui buttons
    curSelect = 1
    storymodeButton = love.filesystem.load("assets/sprites/menu/menu_storymode.lua")()
    freeplayButton = love.filesystem.load("assets/sprites/menu/menu_freeplay.lua")()

    storymodeButton.y = -50
    freeplayButton.y = 50

    graphics.fadeIn(0.3)
end

function updateSelection(updown)
    if updown == "up" then
        curSelect = curSelect - 1
        if curSelect < 1 then
            curSelect = 2
        end
    elseif updown == "down" then
        curSelect = curSelect + 1
        if curSelect > 2 then
            curSelect = 1
        end
    end

    if curSelect == 1 then
        storymodeButton:animate("on", true)
        freeplayButton:animate("off", true)
    elseif curSelect == 2 then
        storymodeButton:animate("off", true)
        freeplayButton:animate("on", true)
    end

    audio.play(uiScroll)
end

function menuSelect:update(dt)
    storymodeButton:update(dt)
    freeplayButton:update(dt)

    if input:pressed("uiUp") then
        updateSelection("up")
    elseif input:pressed("uiDown") then
        updateSelection("down")
    end

    if input:pressed("uiConfirm") then
        audio.play(uiConfirm)
        if curSelect == 1 then
            Timer.after(1, function()
                graphics.fadeOut(0.5)
                Gamestate.switch(storyMode)
            end)
        elseif curSelect == 2 then
            Timer.after(1, function()
                graphics.fadeOut(0.5)
                Gamestate.switch(freeplay)
            end)
        end
    end
end

function menuSelect:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)
        menuBG:draw()

        storymodeButton:draw()
        freeplayButton:draw()
    love.graphics.pop()
end

function menuSelect:bottomDraw()

end

function menuSelect:leave()
    storymodeButton:release()
    freeplayButton:release()
    menuBG:release()
end

return menuSelect