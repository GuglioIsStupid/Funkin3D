local week2 = {}
local song = 1
local difficulty

local house

function week2:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week2/spooky.lua")()

    house = love.filesystem.load("assets/sprites/stages/house/house.lua")()
    house.sizeX, house.sizeY = 1.3, 1.3

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    camera.toZoom = 1.15

    enemy.x = -85
    enemy.y = 15

    thunder = {
        love.audio.newSource("assets/sounds/thunder_1.ogg", "static"),
        love.audio.newSource("assets/sounds/thunder_2.ogg", "static")
    }

    self:load()
end

function week2:load()
    weeks:load()
    if song == 1 then
        inst = love.audio.newSource("assets/songs/week2/spookeez/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week2/spookeez/Voices.ogg", "stream")
    elseif song == 2 then
        inst = love.audio.newSource("assets/songs/week2/south/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week2/south/Voices.ogg", "stream")
    elseif song == 3 then
        inst = love.audio.newSource("assets/songs/week2/monster/Inst.ogg", "stream")
        voices = love.audio.newSource("assets/songs/week2/monster/Voices.ogg", "stream")
        enemy:release()
        enemy = love.filesystem.load("assets/sprites/week2/monster.lua")()
        enemy.sizeX, enemy.sizeY = 1.15, 1.15
        enemy.x, enemy.y = -85, 10
    end
    
    self:initUI()
end

function week2:initUI()
    weeks:initUI()

    if song == 1 then
        weeks:generateNotes("assets/data/week2/spookeez/spookeez"..difficulty..".json")
    elseif song == 2 then
        weeks:generateNotes("assets/data/week2/south/south"..difficulty..".json")
    elseif song == 3 then
        weeks:generateNotes("assets/data/week2/monster/monster"..difficulty..".json")
    end
    weeks:setupCountdown()
end

function week2:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)
    house:update(dt)

    if not house:isAnimated() then
        house:animate("normal")
    end
    if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 * (love.math.random(17) + 7) / bpm) < 100 then
        audio.play(thunder[love.math.random(2)])

        house:animate("lightning", false)
        girlfriend:animate("fear", false)
        boyfriend:animate("shaking", false)
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

function week2:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)

        love.graphics.push()
            love.graphics.translate(camera.x*0.9, camera.y*0.9)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            house:draw()

            girlfriend:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week2:bottomDraw()
    weeks:bottomDraw()
end

function week2:leave()
    house:release()

    for i = 1, #thunder do
        thunder[i]:release()
        thunder[i] = nil
    end
    weeks:leave()
end

return week2