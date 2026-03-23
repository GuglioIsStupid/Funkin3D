local week7 = {
    weekName = "Week 7",
    songs = {
        "ugh",
        "guns",
        "stress"
    },
    list = {
        "Ugh",
        "Guns",
        "Stress"
    },
    weirdChartFormat = true
}
local song = 1
local difficulty

local buildings, clouds, ground, mountains, ruins, sky

function week7:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()

    enemy = love.filesystem.load("assets/sprites/week7/tankman.lua")()

    girlfriend.y = -10
    boyfriend.y = 35
    boyfriend.x = 85

    enemy.x = -85
    enemy:setScale(0.85)
    enemy.flipX = true
    enemy.depth = 3

    sky = graphics.newImage(graphics.imagePath("stages/tank/tankSky"))
    mountains = graphics.newImage(graphics.imagePath("stages/tank/tankMountains"))
    buildings = graphics.newImage(graphics.imagePath("stages/tank/tankBuildings"))
    clouds = graphics.newImage(graphics.imagePath("stages/tank/tankClouds"))
    ground = graphics.newImage(graphics.imagePath("stages/tank/tankGround"))
    ruins = graphics.newImage(graphics.imagePath("stages/tank/tankRuins"))

    mountains.y = 20
    buildings.y = 20
    clouds.y = -20
    ground.y = 50
    ruins.y = -20

    self:load()
end

function week7:load()
    weeks:load()

    inst = love.audio.newSource("assets/songs/week7/" .. self.songs[song].."/Inst.ogg", "stream")
    voices = love.audio.newSource("assets/songs/week7/" .. self.songs[song].."/Voices.ogg", "stream")

    if song == 3 then
        if girlfriend then girlfriend:release() end
        if boyfriend then boyfriend:release() end
        girlfriend = love.filesystem.load("assets/sprites/speaker.lua")()
        boyfriend = love.filesystem.load("assets/sprites/week7/bfAndGf.lua")()
        boyfriend:setScale(0.8)
        girlfriend.y = -10
        boyfriend.y = 18
        boyfriend.x = 90

        boyfriend.depth = 3
        girlfriend.depth = 3
    end

    self:initUI()
end

function week7:initUI()
    weeks:initUI()
    
    weeks:generateNotes("assets/data/week7/" .. self.songs[song].."/" .. self.songs[song]..difficulty..".lua")

    weeks:setupCountdown()
end

function week7:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if not countingDown and not inst:isPlaying() then
        song = song + 1
        if song > 3 or not storyMode then
            state.switch(title)
        else
            self:load()
        end
    end
end

function week7:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)

        love.graphics.push()
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            sky:draw()
        love.graphics.pop()

        love.graphics.push()
        love.graphics.translate(camera.x*0.4, camera.y*0.4)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            clouds:draw()
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x*0.2, camera.y*0.2)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            mountains:draw()
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x*0.3, camera.y*0.3)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            buildings:draw()
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x*1.35, camera.y*1.35)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            ruins:draw()
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(camera.x*1, camera.y*1)
            love.graphics.scale(camera.zoom*1.3, camera.zoom*1.3)

            ground:draw()
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
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week7:bottomDraw()
    weeks:bottomDraw()
end

function week7:exit()
    sky:release()
    mountains:release()
    buildings:release()
    clouds:release()
    ground:release()
    ruins:release()

    weeks:exit()
end

return week7