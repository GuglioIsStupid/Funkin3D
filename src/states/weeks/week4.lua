local week4 = {}
local song = 1
local difficulty

function week4:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    boyfriend:release()
    girlfriend:release()
    boyfriend = love.filesystem.load("assets/sprites/week4/boyfriend.lua")()
    girlfriend = love.filesystem.load("assets/sprites/week4/girlfriend.lua")()
    enemy = love.filesystem.load("assets/sprites/week4/mom.lua")()

    bgLimo = love.filesystem.load("assets/sprites/stages/sunset/bgLimo.lua")()
    limoDancer = love.filesystem.load("assets/sprites/stages/sunset/limoDancer.lua")()
    limo = love.filesystem.load("assets/sprites/stages/sunset/limoDrive.lua")()

    sunset = graphics.newImage(graphics.imagePath("stages/sunset/limoSunset"))

    limo.y = 100
    limo.x = 10

    girlfriend.y = 10
    boyfriend.y = -8
    boyfriend.x = 100

    camera.toZoom = 1

    enemy.x = -85
    enemy.y = 5

    bgLimo.y = 65
    limoDancer.y = -22

    self:load()
end

function week4:load()
    weeks:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week4/satin-panties/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week4/satin-panties/Voices.ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week4/high/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week4/high/Voices.ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week4/milf/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week4/milf/Voices.ogg", "stream")
    end
    
    self:initUI()
end

function week4:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week4/satin-panties/satin-panties"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week4/high/high"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week4/milf/milf"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function week4:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    limo:update(dt)
    bgLimo:update(dt)
    limoDancer:update(dt)

    if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 120000 / bpm) < 100 then
        limoDancer:animate("idle", false)

        limoDancer:setAnimSpeed(8.2 / (60 / bpm))
    end

    if song == 3 and musicTime > 56000 and musicTime < 67000 and musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 / bpm) < 100 then
        camera.zoom = camera.toZoom * 1.05
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
    love.graphics.push()
        love.graphics.translate(200,120)

        love.graphics.push()
            love.graphics.translate(camera.x * 0.5, camera.y * 0.5)
            love.graphics.scale(camera.zoom * 1.55, camera.zoom*1.55)
            sunset:draw()
            bgLimo:draw()
            for i = -100, 100, 100 do
                limoDancer.x = i
                limoDancer:draw()
            end

        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            girlfriend:draw()
            limo:draw()
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
    sunset:release()
    bgLimo:release()
    limoDancer:release()
    limo:release()
    weeks:leave()
end

return week4