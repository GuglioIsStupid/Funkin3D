local tutorial = {}
local song = 1
local difficulty

local stageback, stagefront, stagecurtains

function tutorial:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    boyfriend = love.filesystem.load("assets/sprites/boyfriend.lua")()
    girlfriend = love.filesystem.load("assets/sprites/girlfriend.lua")()
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

function tutorial:load()
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

function tutorial:initUI()
    weeks:initUI()
    --weeks:generateNotes("assets/data/week1/bopeebo/bopeebo-hard.json")
    if song == 1 then
        weeks:generateNotes("assets/data/week1/bopeebo/bopeebo"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week1/fresh/fresh"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week1/dadbattle/dadbattle"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function tutorial:update(dt)
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

function tutorial:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
        love.graphics.translate(camera.x, camera.y)

        stageback:draw()
        stagefront:draw()
        stagecurtains:draw()

        girlfriend:draw()
        boyfriend:draw()
        enemy:draw()
    love.graphics.pop()
    weeks:topDraw()
end

function tutorial:bottomDraw()
    weeks:bottomDraw()
end

function tutorial:leave()
    weeks:leave()
end

return tutorial