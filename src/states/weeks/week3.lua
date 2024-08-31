local week3 = {
    weekName = "Week 3",
    songs = {
        "pico",
        "philly",
        "blammed"
    },
    list = {
        "Pico",
        "Philly Nice",
        "Blammed"
    }
}
local song = 1
local difficulty

local sky, city, cityWindows, behindTrain, street
local winColors, winColor, winAlpha

function week3:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week3/pico.lua")()

    winColors = {
        {49, 162, 253}, -- Blue
        {49, 253, 140}, -- Green
        {251, 51, 245}, -- Magenta
        {253, 69, 49}, -- Orange
        {251, 166, 51}, -- Yellow
    }
    winAlpha = 1
    winColor = 1

    sky = graphics.newImage(graphics.imagePath("stages/city/sky"))
    city = graphics.newImage(graphics.imagePath("stages/city/city"))
    cityWindows = graphics.newImage(graphics.imagePath("stages/city/city-windows"))
    behindTrain = graphics.newImage(graphics.imagePath("stages/city/behind-train"))
    street = graphics.newImage(graphics.imagePath("stages/city/street"))

    sky.sizeX, sky.sizeY = 1.35, 1.35
    city.sizeX, city.sizeY = 1.35, 1.35
    cityWindows.sizeX, cityWindows.sizeY = 1.35, 1.35
    behindTrain.sizeX, behindTrain.sizeY = 1.35, 1.35
    street.sizeX, street.sizeY = 1.35, 1.35

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    camera.toZoom = 1

    enemy.x = -85
    enemy.y = 25
    enemy.sizeX = -1

    self:load()
end

function week3:load()
    weeks:load()

    inst = love.audio.newSource("assets/songs/week3/" .. self.songs[song].."/Inst.ogg", "stream")
    voices = love.audio.newSource("assets/songs/week3/" .. self.songs[song].."/Voices.ogg", "stream")

    self:initUI()
end

function week3:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week3/pico/pico"..difficulty..".lua")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week3/philly/philly"..difficulty..".lua")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week3/blammed/blammed"..difficulty..".lua")
    end
    weeks:setupCountdown()
end

function week3:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 240000 / bpm) < 100 then
        winColor = winColor + 1

        if winColor > #winColors then
            winColor = 1
        end
        winAlpha = 1
    end

    if winAlpha > 0 then
        winAlpha = winAlpha - ((bpm/260) * dt)
    end

    if not countingDown and not inst:isPlaying() then
        song = song + 1
        if song > 3 then
            state.switch(title)
        else
            self:load()
        end
    end
end

function week3:topDraw()
    local curWinColor = winColors[winColor]

    love.graphics.push()
        love.graphics.translate(200,120)
        --love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
        --love.graphics.translate(camera.x, camera.y)

        love.graphics.push()
            love.graphics.translate(camera.x * 0.25, camera.y * 0.25)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            sky:draw()
        love.graphics.pop()
        
        love.graphics.push()
            love.graphics.translate(camera.x * 0.5, camera.y * 0.5)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            city:draw()
            graphics.setColor(curWinColor[1]/255,curWinColor[2]/255,curWinColor[3]/255, winAlpha)
            cityWindows:draw()
            graphics.setColor(1,1,1)
        love.graphics.pop()
        

        love.graphics.push()
            love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            behindTrain:draw()
            street:draw()
            girlfriend:draw()
        love.graphics.pop()

       
        
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week3:bottomDraw()
    weeks:bottomDraw()
end

function week3:exit()
    sky:release()
    city:release()
    cityWindows:release()
    weeks:exit()
end

return week3