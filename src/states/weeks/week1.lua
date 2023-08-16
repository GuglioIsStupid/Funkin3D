local week1 = {}
local song = 1
local difficulty

local stageback, stagefront, stagecurtains

function week1:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week1/daddy-dearest.lua")()

    stageback = graphics.newImage(graphics.imagePath("stages/stage/stageback"))
    stagefront = graphics.newImage(graphics.imagePath("stages/stage/stagefront"))
    stagecurtains = graphics.newImage(graphics.imagePath("stages/stage/stagecurtains"))

    stagefront.y = 92
    stagecurtains.y = -23

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    enemy.x = -85

    self:load()
end

function week1:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week1/bopeebo/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/bopeebo/Voices.ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week1/fresh/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/fresh/Voices.ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week1/dadbattle/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week1/dadbattle/Voices.ogg", "stream")
    end
    weeks:load()
    self:initUI()
end

function week1:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week1/bopeebo/bopeebo"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week1/fresh/fresh"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week1/dadbattle/dadbattle"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function week1:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if song == 1 and musicThres ~= oldMusicThres and math.fmod(absMusicTime + 500, 480000 / bpm) < 100 then
        boyfriend:animate("hey", false)
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

function week1:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        

        love.graphics.push()
        love.graphics.translate(camera.x*0.9, camera.y*0.9)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            stageback:draw()
            stagefront:draw()
            girlfriend:draw()
        love.graphics.pop()
        
        love.graphics.push()
        love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x*1.1, camera.y*1.1)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            stagecurtains:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week1:bottomDraw()
    weeks:bottomDraw()
end

function week1:leave()
    stageback:release()
    stagefront:release()
    stagecurtains:release()
    weeks:leave()
end

return week1