local menuSelect = {}
local curSelect = 1
local confirmPressed = false

function menuSelect:enter()
    menuBG = graphics.newImage(graphics.imagePath("menu/menuBG"))
    menuBG.sizeY = 1.05

    -- ui buttons
    curSelect = 1
    storymodeButton = love.filesystem.load("assets/sprites/menu/menu_storymode.lua")()
    freeplayButton = love.filesystem.load("assets/sprites/menu/menu_freeplay.lua")()

    storymodeButton.y = -50
    freeplayButton.y = 50

    storymodeButton.sizeX, storymodeButton.sizeY = 1.3, 1.3
    freeplayButton.sizeX, freeplayButton.sizeY = 1.3, 1.3

    storymodeButton.depth = 3
    freeplayButton.depth = 3

    confirmPressed = false

    graphics.fadeIn(0.3)
end

function menuSelect:updateSelection(change)
    local change = change or 0

    curSelect = curSelect + change

    if curSelect > 2 then
        curSelect = 1
    elseif curSelect < 1 then
        curSelect = 2
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
        self:updateSelection(-1)
    elseif input:pressed("uiDown") then
        self:updateSelection(1)
    end

    if input:pressed("uiConfirm") and not confirmPressed then
        confirmPressed = true
        if curSelect == 1 then
            audio.play(uiConfirm)
            Timer.after(1, function()
                graphics.fadeOut(0.3, function()
                    state.switch(storyMode)
                end)
            end)
        elseif curSelect == 2 then
            audio.play(uiBack)
            confirmPressed = false
        end
    end

    if input:pressed("uiBack") then
        audio.play(uiBack)
        graphics.fadeOut(0.3, function()
            state.switch(title)
        end)
    end
end

function menuSelect:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)
        menuBG:draw()

        storymodeButton:draw()
        graphics.setColor(0.5, 0.5, 0.5)
        freeplayButton:draw()
        graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

function menuSelect:bottomDraw()

end

function menuSelect:exit()
    storymodeButton:release()
    freeplayButton:release()
    menuBG:release()
end

return menuSelect