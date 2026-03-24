local week6 = {
    weekNum = 6,
    weekAsset = "week",
    weekAssetCustom = false,
    weekName = "Week 6",
    songs = {
        "senpai",
        "roses",
        "thorns"
    },
    list = {
        "Senpai",
        "Roses",
        "Thorns"
    }
}
local song = 1
local difficulty

local sky, school, street, treesBack
local trees, petals, freaks

function week6:enter(from, song_, diff)
    song = song_ or 1
    difficulty = diff or ""
    weeks:enter({ pixelStage = true })

    girlfriend.y = -15
    boyfriend.y = 35
    boyfriend.x = 85

    self:load()
end

function week6:load()
    weeks:load()

    inst = love.audio.newSource("assets/songs/week6/" .. self.songs[song].."/Inst.ogg", "stream")
    voices = love.audio.newSource("assets/songs/week6/" .. self.songs[song].."/Voices.ogg", "stream")

    if song == 1 then
        enemy = love.filesystem.load("assets/sprites/week6/senpai.lua")()
    elseif song == 2 then
        if enemy then enemy:release() end
        enemy = love.filesystem.load("assets/sprites/week6/senpai-angry.lua")()
    elseif song == 3 then
        if enemy then enemy:release() end
        enemy = love.filesystem.load("assets/sprites/week6/spirit.lua")()
    end
    if enemy then enemy.x = -85 end

    if song ~= 3 and not sky then
        sky = graphics.newImage(graphics.imagePath("stages/school/weebSky"))
        school = graphics.newImage(graphics.imagePath("stages/school/weebSchool"))
        street = graphics.newImage(graphics.imagePath("stages/school/weebStreet"))
        treesBack = graphics.newImage(graphics.imagePath("stages/school/weebTreesBack"))

        --sky.depth = 1
        school.depth = 2
        street.depth = 2
        treesBack.depth = 2
    elseif song == 3 then
        if sky then sky:release() end
        if school then school:release() end
        if street then street:release() end
        if treesBack then treesBack:release() end
        school = graphics.newImage(graphics.imagePath("stages/evil-school/weebSchool"))
        street = graphics.newImage(graphics.imagePath("stages/evil-school/weebStreet"))
        treesBack = graphics.newImage(graphics.imagePath("stages/evil-school/weebBackTrees"))

        school.depth = 2
        street.depth = 2
        treesBack.depth = 2
    end

    self:initUI()
end

function week6:initUI()
    weeks:initUI()

    weeks:generateNotes("assets/data/week6/" .. self.songs[song].."/" .. self.songs[song]..difficulty..".lua")

    weeks:setupCountdown()
end

function week6:update(dt)
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

function week6:topDraw()
    love.graphics.push()
        love.graphics.translate(200,120)
        love.graphics.scale(1.4, 1.4)


        love.graphics.push()
        love.graphics.translate(camera.x*0.9, camera.y*0.9)
            love.graphics.scale(camera.zoom*1.45, camera.zoom*1.45)
            if song ~= 3 then sky:draw() end
            school:draw()
        love.graphics.pop()

        love.graphics.push()
        love.graphics.translate(camera.x, camera.y)
            love.graphics.scale(camera.zoom*1.45, camera.zoom*1.45)
            street:draw()
            treesBack:draw()

            --trees:draw()
            --petals:draw()
            --freaks:draw()
            girlfriend:draw()
            boyfriend:draw()
            enemy:draw()
        love.graphics.pop()
        love.graphics.push()
            love.graphics.translate(camera.x*1.1, camera.y*1.1)
            love.graphics.scale(camera.zoom*1.45, camera.zoom*1.45)
        love.graphics.pop()
    love.graphics.pop()
    weeks:topDraw()
end

function week6:bottomDraw()
    weeks:bottomDraw()
end

function week6:exit()
    if sky then sky:release() end
    school:release()
    if street then street:release() end
    if treesBack then treesBack:release() end
    if trees then trees:release() end
    if petals then petals:release() end
    if freaks then freaks:release() end
    weeks:exit()
end

return week6