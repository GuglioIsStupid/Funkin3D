local menuSelect = state()
local curSelect = 1
local confirmPressed = false

function menuSelect:enter()
    menuBG = graphics.newImage(graphics.imagePath("menu/menuBG"))
    menuBG.sizeY = 1.05

    -- ui buttons
    curSelect = 1
    storymodeButton = love.filesystem.load("assets/sprites/menu/menu_storymode.lua")()
    freeplayButton = love.filesystem.load("assets/sprites/menu/menu_freeplay.lua")()
    optionsButton = love.filesystem.load("assets/sprites/menu/menu_options.lua")()

    storymodeButton.y = -70
    freeplayButton.y = 0
    optionsButton.y = 70

    storymodeButton.sizeX, storymodeButton.sizeY = 1.3, 1.3
    freeplayButton.sizeX, freeplayButton.sizeY = 1.55, 1.55
    optionsButton.sizeX, optionsButton.sizeY = 1.3, 1.3

    storymodeButton.depth = 3
    freeplayButton.depth = 3
    optionsButton.depth = 3

    confirmPressed = false

    self:updateSelection(0)

    graphics.fadeIn(0.3)
end

function menuSelect:updateSelection(change)
    local change = change or 0

    curSelect = curSelect + change

    if curSelect > 3 then
        curSelect = 1
    elseif curSelect < 1 then
        curSelect = 3
    end

    if curSelect == 1 then
        storymodeButton:animate("on", true)
        freeplayButton:animate("off", true)
        optionsButton:animate("off", true)
    elseif curSelect == 2 then
        storymodeButton:animate("off", true)
        freeplayButton:animate("on", true)
        optionsButton:animate("off", true)
    elseif curSelect == 3 then
        storymodeButton:animate("off", true)
        freeplayButton:animate("off", true)
        optionsButton:animate("on", true)
    end

    audio.playSound(uiScroll)
end

function menuSelect:update(dt)
    storymodeButton:update(dt)
    freeplayButton:update(dt)
    optionsButton:update(dt)

    if input:pressed("uiUp") then
        self:updateSelection(-1)
    elseif input:pressed("uiDown") then
        self:updateSelection(1)
    end

    if input:pressed("uiConfirm") and not confirmPressed then
        confirmPressed = true
        audio.playSound(uiConfirm)
        Timer.after(1, function()
            graphics.fadeOut(0.3, function()
                if curSelect == 1 then
                    state.switch(storyMode)
                elseif curSelect == 2 then
                    state.switch(freeplay)
                elseif curSelect == 3 then
                    state.switch(settingsMenu)
                end
            end)
        end)
    end

    if input:pressed("uiBack") then
        audio.playSound(uiBack)
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
        freeplayButton:draw()
        optionsButton:draw()
    love.graphics.pop()
end

function menuSelect:bottomDraw()

end

function menuSelect:exit()
    storymodeButton:release()
    freeplayButton:release()
    optionsButton:release()
    menuBG:release()
end

return menuSelect