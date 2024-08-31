local tutorial = {
    weekName = "Tutorial",
    songs = {
        "tutorial"
    },
    list = {
        "Tutorial"
    }
}
local song = 1

local stageback, stagefront, stagecurtains

function tutorial:enter(song_)
    song = song_ or 1
    weeks:enter()

    enemy = girlfriend

    stageback = graphics.newImage(graphics.imagePath("stages/stage/stageback"))
    stagefront = graphics.newImage(graphics.imagePath("stages/stage/stagefront"))
    stagecurtains = graphics.newImage(graphics.imagePath("stages/stage/stagecurtains"))

    stagefront.y = 92
    stagecurtains.y = -23

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    stageback.depth = 2.5
    stagefront.depth = 2.5
    stagecurtains.depth = 2.5

    self:load()
end

function tutorial:load()
    weeks:load()
    inst = love.audio.newSource("assets/songs/" .. self.songs[1].."/Inst.ogg", "stream")
    
    self:initUI()
end

function tutorial:initUI()
    weeks:initUI()
    weeks:generateNotes("assets/data/" .. self.songs[1].."/" .. self.songs[1]..".lua")
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
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x*1.1, camera.y*1.1)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)
            stagecurtains:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function tutorial:bottomDraw()
    weeks:bottomDraw()
end

function tutorial:exit()
    stageback:release()
    stagefront:release()
    stagecurtains:release()
    weeks:exit()
end

return tutorial