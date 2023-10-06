local week5 = {}
local song = 1
local difficulty

local stageback, stagefront, stagecurtains

function week5:enter(from, song_, diff)
    camera.zoom = 0.7
    camera.toZoom = 0.7
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week5/parents.lua")()

    walls = graphics.newImage(graphics.imagePath("stages/mall/bgWalls"))
    christmasTree = graphics.newImage(graphics.imagePath("stages/mall/christmasTree"))
    escalator = graphics.newImage(graphics.imagePath("stages/mall/bgEscalator"))
    snow = graphics.newImage(graphics.imagePath("stages/mall/fgSnow"))

    escalator.y = 10
    snow.y = 196
    snow.sizeX, snow.sizeY = 2, 2

    girlfriend.x, girlfriend.y = 12, 94
    boyfriend.x, boyfriend.y = 69, 143
    enemy.x, enemy.y = -150, 116

    self:load()
end

function week5:load()
    weeks:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week5/cocoa/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week5/cocoa/Voices.ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week5/eggnog/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week5/eggnog/Voices.ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week5/winter-horrorland/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week5/winter-horrorland/Voices.ogg", "stream")
    end
    
    self:initUI()
end

function week5:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week5/cocoa/cocoa"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week5/eggnog/eggnog"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week5/winter-horrorland/winter-horrorland"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function week5:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if not countingDown and not inst:isPlaying() then
        song = song + 1
        if song > 3 then
            Gamestate.switch(title)
        else
            self:load()
        end
    end
end

function week5:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        love.graphics.scale(camera.zoom*1.45, camera.zoom*1.45)

        love.graphics.push()
        love.graphics.translate(camera.x*0.5, camera.y*0.5)
            walls:draw()
            escalator:draw()
            christmasTree:draw()
        love.graphics.pop()
        
        love.graphics.push()
        love.graphics.translate(camera.x*0.9, camera.y*0.9)
            snow:draw()
            girlfriend:draw()

        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week5:bottomDraw()
    weeks:bottomDraw()
end

function week5:leave()
    stageback:release()
    stagefront:release()
    stagecurtains:release()
    weeks:leave()
end

return week5