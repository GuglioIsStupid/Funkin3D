local offset = {}

local menuID, selection
local curDir, dirTable
local sprite, spriteAnims, overlaySprite

function offset:spriteViewerSearch(dir)
    if curDir then
        curDir = curDir .. "/" .. dir
    else
        curDir = dir
    end
    selection = 1
    dirTable = love.filesystem.getDirectoryItems(curDir)
end

function offset:spriteViewer(spritePath)
    local spriteData = love.filesystem.load(spritePath)
    menuID = 2

    sprite = spriteData()
    overlay = spriteData()

    spriteAnims = {}
    for i, _ in pairs(sprite.getAnims()) do
        table.insert(spriteAnims, i)
    end

    sprite:animate(spriteAnims[1])
    overlay:animate(spriteAnims[1])
end

function offset:enter()
    if love.keyboard then love.keyboard.setKeyRepeat(true) end
    svMode = 1
    menuID = 1

    selection = 1

    self:spriteViewerSearch("assets/sprites")

    love.graphics.setFont(font)
end

function offset:update(dt)
    if menuID == 1 then

    elseif menuID == 2 then
        sprite:update(dt)
        overlay:update(dt)
    end
end

function offset:topDraw()
    -- draw a 0.5,0.5,0.5 rgb rectangle
    graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", 0, 0, 400, 240)
    graphics.setColor(1,1,1,0.5)
    if menuID == 1 then
        love.graphics.setColor(1, 1, 1)

        for i, v in ipairs(dirTable) do
            if i == selection then
                love.graphics.setColor(1, 0, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print(v, 10, 0 + ((i-1) * 10))
            love.graphics.setColor(1, 1, 1)
        end
    elseif menuID == 2 then
        -- just print X, Y, sizeX, sizeY
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("X: " .. -overlay.x, 10, 10)
        love.graphics.print("Y: " .. -overlay.y, 10, 30)
        love.graphics.print("SizeX: " .. overlay.sizeX, 10, 50)
        love.graphics.print("SizeY: " .. overlay.sizeY, 10, 70)

        love.graphics.push()
            love.graphics.translate(200, 120)
            love.graphics.scale(1.25, 1.25)
            sprite:draw()
            graphics.setColor(1,1,1,0.5)
            overlay:draw()
        love.graphics.pop()
    end
end

function offset:bottomDraw()
    -- print anims
    if menuID == 2 then
        love.graphics.setColor(1, 1, 1)
        for i, v in ipairs(spriteAnims) do
            if i == selection then
                love.graphics.setColor(1, 0, 0)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print(v, 10, 10 + (i * 10))
            love.graphics.setColor(1, 1, 1)
        end
    end
end

function offset:keypressed(key)
    if menuID == 2 then
        if key == "w" then
            overlay.y = overlay.y - 1
        elseif key == "s" then
            overlay.y = overlay.y + 1
        elseif key == "a" then
            overlay.x = overlay.x - 1
        elseif key == "d" then
            overlay.x = overlay.x + 1
        elseif key == "q" then
            overlay.sizeX = overlay.sizeX - 0.05
            overlay.sizeY = overlay.sizeY - 0.05
        elseif key == "e" then
            overlay.sizeX = overlay.sizeX + 0.05
            overlay.sizeY = overlay.sizeY + 0.05
        end

        if key == "up" then
            selection = selection - 1
            if selection < 1 then
                selection = #spriteAnims
            end
            sprite:animate(spriteAnims[selection])
        elseif key == "down" then
            selection = selection + 1
            if selection > #spriteAnims then
                selection = 1
            end
            sprite:animate(spriteAnims[selection])
        end

        if key == "return" then
            sprite:animate(spriteAnims[selection])
            overlay:animate(spriteAnims[selection])
        end
    elseif menuID == 1 then
        if key == "up" then
            selection = selection - 1
            if selection < 1 then
                selection = #dirTable
            end
        elseif key == "down" then
            selection = selection + 1
            if selection > #dirTable then
                selection = 1
            end
        end

        if key == "return" then
            if love.filesystem.getInfo(curDir .. "/" .. dirTable[selection], "directory") then
                self:spriteViewerSearch(dirTable[selection])
            else
                self:spriteViewer(curDir .. "/" .. dirTable[selection])
            end
        end
    end
end

return offset