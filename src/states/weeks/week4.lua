local week4 = {
    weekName = "Week 4",
    songs = {
        "satin-panties",
        "high",
        "milf"
    },
    list = {
        "Satin Panties",
        "High",
        "MILF"
    }
}
local song = 1
local difficulty

function week4:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    girlfriend:release()
    girlfriend = love.filesystem.load("assets/sprites/week4/girlfriend.lua")()
    enemy = love.filesystem.load("assets/sprites/week4/mom.lua")()

    bgLimo = graphics.newImage(graphics.imagePath("stages/sunset/bgLimo"))
    limo = graphics.newImage(graphics.imagePath("stages/sunset/limoDrive"))
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

    sunset.depth = 1
    bgLimo.depth = 2
    limo.depth = 3

    self:load()
end

function week4:load()
    weeks:load()

    inst = love.audio.newSource("assets/songs/week4/" .. self.songs[song].."/Inst.ogg", "stream")
    voices = love.audio.newSource("assets/songs/week4/" .. self.songs[song].."/Voices.ogg", "stream")

    self:initUI()
end

function week4:initUI()
    weeks:initUI()

    weeks:generateNotes("assets/data/week4/" .. self.songs[song].."/" .. self.songs[song]..difficulty..".lua")

    weeks:setupCountdown()
end

function week4:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if song == 3 and musicTime > 56000 and musicTime < 67000 and musicThres ~= oldMusicThres and math.fmod(absMusicTime, 60000 / bpm) < 100 then
        camera.zoom = camera.toZoom * 1.05
        uiScale.zoom = uiScale.toZoom * 1.05
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

function week4:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)

        love.graphics.push()
            love.graphics.translate(camera.x * 0.5, camera.y * 0.5)
            love.graphics.scale(camera.zoom * 1.55, camera.zoom*1.55)
            sunset:draw()
            bgLimo:draw()

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

function week4:exit()
    sunset:release()
    bgLimo:release()
    limo:release()
    weeks:exit()
end

return week4