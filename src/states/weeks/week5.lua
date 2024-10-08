local week5 = {
    weekName = "Week 5",
    songs = {
        "cocoa",
        "eggnog",
        "winter-horrorland"
    },
    list = {
        "Cocoa",
        "Eggnog",
        "Winter Horrorland"
    }
}
local song = 1
local difficulty

local walls, christmasTree, escalator, snow

function week5:enter(from, song_, diff)
    camera.zoom = 0.7
    camera.toZoom = 0.7
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter()
    boyfriend:release()
    girlfriend:release()
    boyfriend = love.filesystem.load("assets/sprites/week5/boyfriend.lua")()
    girlfriend = love.filesystem.load("assets/sprites/week5/girlfriend.lua")()

    enemy = love.filesystem.load("assets/sprites/week5/parents.lua")()

    if song ~= 3 then
        walls = graphics.newImage(graphics.imagePath("stages/mall/bgWalls"))
        christmasTree = graphics.newImage(graphics.imagePath("stages/mall/christmasTree"))
        escalator = graphics.newImage(graphics.imagePath("stages/mall/bgEscalator"))
        snow = graphics.newImage(graphics.imagePath("stages/mall/fgSnow"))
        bottomBop = love.filesystem.load("assets/sprites/stages/mall/bottomBop.lua")()
        upperBop = love.filesystem.load("assets/sprites/stages/mall/upperBop.lua")()
        santa = love.filesystem.load("assets/sprites/stages/mall/santa.lua")()

        escalator.y = 10
        snow.y = 196
        snow.sizeX, snow.sizeY = 2, 2

        santa.x, santa.y = -285, 115
        bottomBop.y = 100
        upperBop.y = -38
        upperBop.x = 50

        walls.depth = 2
        christmasTree.depth = 2
        escalator.depth = 2
        snow.depth = 4
        bottomBop.depth = 2.25
        upperBop.depth = 2
        santa.depth = 3
    end

    girlfriend.x, girlfriend.y = 12, 94
    boyfriend.x, boyfriend.y = 69, 143
    enemy.x, enemy.y = -150, 116
    enemy.sizeX, enemy.sizeY = 1.14, 1.14

    self:load()
end

function week5:load()
    weeks:load()

    inst = love.audio.newSource("assets/songs/week5/" .. self.songs[song].."/Inst.ogg", "stream")
    voices = love.audio.newSource("assets/songs/week5/" .. self.songs[song].."/Voices.ogg", "stream")
    
    self:initUI()
end

function week5:initUI()
    weeks:initUI()

    weeks:generateNotes("assets/data/week5/" .. self.songs[song].."/" .. self.songs[song]..difficulty..".lua")

    if song == 3 then
        if walls then walls:release() end
        if christmasTree then christmasTree:release() end
        if escalator then escalator:release() end
        if snow then snow:release() end
        if enemy then enemy:release() end
        if bottomBop then bottomBop:release() end
        if upperBop then upperBop:release() end
        if santa then santa:release() end

        walls = graphics.newImage(graphics.imagePath("stages/mall/evilBG"))
        christmasTree = graphics.newImage(graphics.imagePath("stages/mall/evilTree"))
        snow = graphics.newImage(graphics.imagePath("stages/mall/evilSnow"))
        enemy = love.filesystem.load("assets/sprites/week5/monster.lua")()
        enemy.x, enemy.y = -150, 116
        enemy.sizeX, enemy.sizeY = 1.134, 1.134

        snow.y = 196
        snow.sizeX, snow.sizeY = 2, 2

        walls.depth = 2
        christmasTree.depth = 2
        snow.depth = 4
    end
    weeks:setupCountdown()
end

function week5:update(dt)
    weeks:update(dt)
    weeks:updateEvents(dt)

    if song ~= 3 then
        bottomBop:update(dt)
        upperBop:update(dt)
        santa:update(dt)
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

function week5:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        love.graphics.scale(camera.zoom*1.45, camera.zoom*1.45)

        love.graphics.push()
        love.graphics.translate(camera.x*0.5, camera.y*0.5)
            walls:draw()
            if song~=3 then upperBop:draw() end
            if song~=3 then escalator:draw()end
            christmasTree:draw()
        love.graphics.pop()
        
        love.graphics.push()
        love.graphics.translate(camera.x*0.9, camera.y*0.9)
            if song~=3 then bottomBop:draw() end
            snow:draw()
            girlfriend:draw()

        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x, camera.y)
            boyfriend:draw()
            if song~=3 then santa:draw() end
            enemy:draw()
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week5:bottomDraw()
    weeks:bottomDraw()
end

function week5:exit()
    if escalator then escalator:release() end
    walls:release()
    christmasTree:release()
    snow:release()
    if upperBop then upperBop:release() end
    if bottomBop then bottomBop:release() end
    if santa then santa:release() end
    weeks:exit()
end

return week5