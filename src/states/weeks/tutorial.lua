local tutorial = {}
local song = 1

local stageback, stagefront, stagecurtains

function tutorial:enter(song_)
    song = song_ or 1
    weeks:enter()

    boyfriend = love.filesystem.load("assets/sprites/boyfriend.lua")()
    girlfriend = love.filesystem.load("assets/sprites/girlfriend.lua")()
    enemy = girlfriend

    stageback = graphics.newImage(graphics.imagePath("stages/stage/stageback"))
    stagefront = graphics.newImage(graphics.imagePath("stages/stage/stagefront"))
    stagecurtains = graphics.newImage(graphics.imagePath("stages/stage/stagecurtains"))

    stagefront.y = 92
    stagecurtains.y = -23

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    self:load()
end

function tutorial:load()
    inst = love.audio.newSource("assets/songs/tutorial/Inst.ogg", "stream")
    weeks:load()
    self:initUI()
end

function tutorial:initUI()
    weeks:initUI()
    weeks:generateNotes("assets/data/tutorial/tutorial.json")
    weeks:setupCountdown()
end

function tutorial:update(dt)
    weeks:update(dt)
    --weeks:updateEvents(dt)

    if musicThres ~= oldMusicThres and (musicThres == 185 or musicThres == 280) then
        girlfriend:animate("cheer", false)
        boyfriend:animate("hey", false)
    end

    for i = 1, #events do
        if events[i].eventTime <= absMusicTime then
            if camTimer then
                Timer.cancel(camTimer)
            end
            if camTimer2 then
                Timer.cancel(camTimer2)
            end
            
            if events[i].mustHitSection then
                camTimer = Timer.tween(1.25, camera, {x=-boyfriend.x+10, y=-boyfriend.y+30}, "out-quad")
                camTimer2 = Timer.tween(1.25, camera, {toZoom=1}, "in-bounce")
            else
                camTimer = Timer.tween(1.25, camera, {x=-enemy.x+10,y=-enemy.y+25}, "out-quad")
                camTimer2 = Timer.tween(1.25, camera, {toZoom=1.25}, "in-bounce")
            end

            table.remove(events, i)

            break
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