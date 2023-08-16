local week4 = {}
local song = 1
local difficulty

function week4:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week3/pico.lua")()

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    camera.toZoom = 1

    enemy.x = -85
    enemy.y = 25

    self:load()
end

function week4:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week3/pico/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week3/pico/Voices.ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week3/philly/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week3/philly/Voices.ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week3/blammed/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week3/blammed/Voices.ogg", "stream")
    end
    weeks:load()
    self:initUI()
end

function week4:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week3/pico/pico"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week3/philly/philly"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week3/blammed/blammed"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function week4:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if song == 3 and musicTime > 56000 and musicTime < 67000 and musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 / bpm) < 100 then
        if camScaleTimer then Timer.cancel(camScaleTimer) end

        camScaleTimer = Timer.tween((60 / bpm) / 16, camera, {zoom = camera.toZoom * 1.05}, "out-quad", function() camScaleTimer = Timer.tween((60 / bpm), camera, {sizeX = camera.toZoom}, "out-quad") end)
    end

    if not countingDown and not inst:isPlaying() then
        song = song + 1
        if song > 3 then
            Gamestate.switch(title)
        else
            self:load()
        end
    end
end

function week4:topDraw()
    local curWinColor = winColors[winColor]

    love.graphics.push()
        love.graphics.translate(200,120)

        love.graphics.push()
            love.graphics.translate(camera.x * 0.25, camera.y * 0.25)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
        love.graphics.pop()
        
        love.graphics.push()
            love.graphics.translate(camera.x * 0.5, camera.y * 0.5)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            
            graphics.setColor(1,1,1)
        love.graphics.pop()
        

        love.graphics.push()
            love.graphics.translate(camera.x * 0.9, camera.y * 0.9)
            love.graphics.scale(camera.zoom * 1.3, camera.zoom*1.3)
            
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

function week4:bottomDraw()
    weeks:bottomDraw()
end

function week4:leave()
    sky:release()
    city:release()
    cityWindows:release()
    weeks:leave()
end

return week4