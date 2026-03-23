local Fnf3dsRatio = 240/720 -- 240 (3ds height) / 720(fnf game height) = 0.3333*
local weeks = {}

local animList = {
    "left",
    "down",
    "up",
    "right",
}

local inputList = {
    "gameLeft",
    "gameDown",
    "gameUp",
    "gameRight",
}
local countdownFade = {}
local ratingAnim = ""
local ratingPos = {
    x = 200, y = 75
}
local ratingTimers = {}
local isPixelStage = false
function weeks:enter(opts)
    opts = opts or {}
    isPixelStage = opts.pixelStage or false
    local uiFolder = "ui/" .. (isPixelStage and "pixel" or "default")
    if not opts.dontLoadChars then
        if not isPixelStage then
            boyfriend = love.filesystem.load("assets/sprites/boyfriend.lua")()
            girlfriend = love.filesystem.load("assets/sprites/girlfriend.lua")()
            girlfriend:setScale(1.15)
        else
            boyfriend = love.filesystem.load("assets/sprites/pixel/boyfriend.lua")()
            girlfriend = love.filesystem.load("assets/sprites/pixel/girlfriend.lua")()
        end
    end

    sounds = {

    }
    images = {
        notes = love.graphics.newImage(graphics.imagePath(uiFolder .. "/notes")),
    }
    sprites = {

    }
end

function weeks:load()
    audio.stopMusic(inst)
    audio.stopMusic(voices)
    if inst then inst:release() end
    if voices then voices:release() end
    inst = nil
    voices = nil
    collectgarbage("collect")
    useAltAnims = false
    local camRefPos = {25, 2}
    if boyfriend then
        camRefPos[1] = -boyfriend.x + 25
        camRefPos[2] = -boyfriend.y + 2
    end
    camera.x, camera.y = camRefPos[1], camRefPos[2]

    local target = {10, 20}
    if boyfriend then
        target[1] = -boyfriend.x + 10
        target[2] = -boyfriend.y + 20
    end
    camTimer = Timer.tween(1.25, camera, {x=target[1], y=target[2]}, "out-quad")

    graphics.fadeIn(0.5)
end

function weeks:retargetCamera()
    if camTimer then
        Timer.cancel(camTimer)
    end

    local camRefPos = {25, 2}
    if boyfriend then
        camRefPos[1] = -boyfriend.x + 25
        camRefPos[2] = -boyfriend.y + 2
    end
    camera.x, camera.y = camRefPos[1], camRefPos[2]
    local target = {10, 20}
    if boyfriend then
        target[1] = -boyfriend.x + 10
        target[2] = -boyfriend.y + 20
    end
    camTimer = Timer.tween(1.25, camera, {x=target[1], y=target[2]}, "out-quad")
end

function weeks:initUI()
    health = 1
    combo = 0
    score = 0
    musicTime = 0
    musicPos = 0
    danceLeft = false
    beatHit = false
    curBeat = 0
    lastBeat = 0
    noteCounter = 0
    misses = 0

    -- only reload if needed!!
    local uiFolder = "assets/sprites/ui/" .. (isPixelStage and "pixel" or "default") .. "/"
    if not sprites.arrow1 then sprites.arrow1 = love.filesystem.load(uiFolder .. "notes/left.lua") end
    if not sprites.arrow2 then sprites.arrow2 = love.filesystem.load(uiFolder .. "notes/down.lua") end
    if not sprites.arrow3 then sprites.arrow3 = love.filesystem.load(uiFolder .. "notes/up.lua") end
    if not sprites.arrow4 then sprites.arrow4 = love.filesystem.load(uiFolder .. "notes/right.lua") end

    if not enemyArrows then
        enemyArrows = {
            sprites.arrow1(),
            sprites.arrow2(),
            sprites.arrow3(),
            sprites.arrow4()
        }
    end
    if not boyfriendArrows then
        boyfriendArrows = {
            sprites.arrow1(),
            sprites.arrow2(),
            sprites.arrow3(),
            sprites.arrow4()
        }
    end

    enemyNotes = {}
    boyfriendNotes = {}

    if boyfriend then boyfriend.depth = 3 end
    if girlfriend then girlfriend.depth = 3 end
    if enemy then enemy.depth = 3 end

    for i = 1, 4 do
        enemyArrows[i].x = -170 + ((i-1) * 40)
        enemyArrows[i].depth = 6
        
        boyfriendArrows[i].x = 50 + ((i-1) * 40)
        boyfriendArrows[i].depth = 6

        if settingsHandler:get("downscroll") then
            boyfriendArrows[i].y = 90
            enemyArrows[i].y = 90
        else
            boyfriendArrows[i].y = -90
            enemyArrows[i].y = -90
        end

        if isPixelStage then
            enemyArrows[i]:setScale(2)
            boyfriendArrows[i]:setScale(2)
        end

        enemyNotes[i] = {}
        boyfriendNotes[i] = {}
    end
end

function weeks:generateNotes(chart)
    events = {}

    chart = love.filesystem.load(chart)().song
    songname = chart.song

    for i = 1, #chart.notes do
        bpm = chart.notes[i].changeBPM and chart.notes[i].bpm or bpm or 100

        if bpm then
            break
        end
    end
    if not bpm then
        bpm = chart.bpm or 100
    end

    speed = chart.speed * Fnf3dsRatio

    for _, section in ipairs(chart.notes) do
        local mustHitSection = section.mustHitSection or false
        for j, noteData in ipairs(section.sectionNotes) do
            local time = noteData[1]
            local noteType = noteData[2]
            local noteVer = noteData[4] or "normal"
            local holdLength = noteData[3] or 0
            local altAnim = section.altAnim or false
            
            if j == 1 then
                table.insert(events, {eventTime = section.sectionNotes[1][1], mustHitSection = mustHitSection, bpm = bpm, altAnim = altAnim})
            end

            local id = noteType % 4 + 1

            local noteObject = sprites["arrow" .. id]()

            noteObject.y = -90 + time * 0.45 * speed
            if settingsHandler:get("downscroll") then
                noteObject.y = 90 - time * 0.45 * speed
            end
            noteObject.time = time
            noteObject.ver = noteVer
            noteObject.depth = 6
            if isPixelStage then
                noteObject:setScale(2)
            end
            noteObject:animate("on", false)

            local isEnemyNote = (mustHitSection and noteType >= 4) or (not mustHitSection and noteType < 4)
            if state.current().weirdChartFormat then
                isEnemyNote = noteType >= 4
            end
            local notesTable = isEnemyNote and enemyNotes or boyfriendNotes
            local arrowsTable = isEnemyNote and enemyArrows or boyfriendArrows

            noteObject.x = arrowsTable[id].x

            table.insert(notesTable[id], noteObject)

            if holdLength > 0 then
                for k = 24 / speed, holdLength, 24 / speed do
                    local holdNote = sprites["arrow" .. id]()

                    holdNote.y = -90 + (time + k) * 0.45 * speed
                    if settingsHandler:get("downscroll") then
                        holdNote.y = 90 - (time + k) * 0.45 * speed
                    end
                    holdNote.time = time + k
                    holdNote.depth = 6
                    holdNote:animate("hold", false)
                    if isPixelStage then
                        holdNote:setScale(2)
                    end

                    holdNote.x = arrowsTable[id].x

                    table.insert(notesTable[id], holdNote)
                end

                local endNote = notesTable[id][#notesTable[id]]

                if settingsHandler:get("downscroll") then
                    endNote.offsetY = 3
                    endNote.flipY = true
                else
                    endNote.offsetY = -3
                end
                if isPixelStage then
                    endNote.offsetY = 0
                end
                endNote:animate("end", false)
            end
        end
    end

    for i = 1, 4 do
        --[[ table.sort(enemyNotes[i], function(a, b) return a.time < b.time end)
        table.sort(boyfriendNotes[i], function(a, b) return a.time < b.time end) ]]
        -- above but also for downscroll
        if not settingsHandler:get("downscroll") then
            table.sort(enemyNotes[i], function(a, b) return a.y < b.y end)
            table.sort(boyfriendNotes[i], function(a, b) return a.y < b.y end)
        else
            table.sort(enemyNotes[i], function(a, b) return a.y > b.y end)
            table.sort(boyfriendNotes[i], function(a, b) return a.y > b.y end)
        end
    end

    -- Workarounds for bad charts that have multiple notes around the same place
    for i = 1, 4 do
        local offset = 0

        for j = 2, #enemyNotes[i] do
            local index = j - offset

            if enemyNotes[i][index]:getAnimName() == "on" and enemyNotes[i][index - 1]:getAnimName() == "on" and (math.abs(enemyNotes[i][index].y - enemyNotes[i][index - 1].y) <= 10) then
                table.remove(enemyNotes[i], index)

                offset = offset + 1
            end
        end
    end
    for i = 1, 4 do
        local offset = 0

        for j = 2, #boyfriendNotes[i] do
            local index = j - offset

            if boyfriendNotes[i][index]:getAnimName() == "on" and boyfriendNotes[i][index - 1]:getAnimName() == "on" and (math.abs(boyfriendNotes[i][index].y - boyfriendNotes[i][index - 1].y) <= 10) then
                table.remove(boyfriendNotes[i], index)

                offset = offset + 1
            end
        end
    end

    -- Clear up memory of unused vars
    chart = nil

    table.sort(events, function(a, b) return a.eventTime < b.eventTime end)

    collectgarbage("collect")
end

function weeks:safeAnimate(sprite, animName, loopAnim, timerID)
    sprite:animate(animName, loopAnim)
    spriteTimers[timerID] = 12
end

function weeks:setupCountdown()
    lastReportedPlaytime = 0
    musicTime = (240/bpm)*-1000
    musicThres = 0

    countingDown = true
    countdownFade[1] = 0
    Timer.after(
        (60 / bpm),
        function()
            countdownFade[1] = 1
            Timer.tween(
                (60 / bpm),
                countdownFade,
                {0},
                "linear",
                function()
                    countdownFade[1] = 1
                    Timer.tween(
                        (60 / bpm),
                        countdownFade,
                        {0},
                        "linear",
                        function()
                            countdownFade[1] = 1
                            Timer.tween(
                                (60 / bpm),
                                countdownFade,
                                {0},
                                "linear",
                                function()
                                    countingDown = false

                                    previousFrameTime = love.timer.getTime() * 1000
                                    musicTime = 0

                                    audio.playMusic(inst)
                                    audio.playMusic(voices)
                                end
                            )
                        end
                    )
                end
            )
        end
    )
end

function weeks:update(dt)
    oldMusicThres = musicThres
    if boyfriend then boyfriend:update(dt) end
    if girlfriend then girlfriend:update(dt) end
    if enemy then enemy:update(dt) end
    if not graphics.isFading() and not countingDown then
        local time = love.timer.getTime()
        local seconds = inst:tell("seconds")

        musicTime = musicTime + (time*1000) - (previousFrameTime or 0)
        previousFrameTime = time*1000

        if (lastReportedPlaytime or 0) ~= seconds * 1000 then
            lastReportedPlaytime = seconds * 1000
            musicTime = (musicTime + lastReportedPlaytime) / 2
        end
    elseif countingDown then
        musicTime = musicTime + 1000 * dt
    end
    if settingsHandler:get("downscroll") then
        musicPos = -musicTime * 0.45 * speed
    else
        musicPos = musicTime * 0.45 * speed
    end
    absMusicTime = math.abs(musicTime)
    musicThres = math.floor(absMusicTime/100)

    for i = 1, 4 do
        local enemyNote = enemyNotes[i]
        local boyfriendNote = boyfriendNotes[i]
        local enemyArrow = enemyArrows[i]
        local boyfriendArrow = boyfriendArrows[i]
        local noteNum = i
        local curInput = inputList[i]

        enemyArrow:update(dt)
        boyfriendArrow:update(dt)

        if not enemyArrow:isAnimated() then
			enemyArrow:animate("off", false)
		end

        if #enemyNote > 0 then
            if (not settingsHandler:get("downscroll") and (enemyNote[1].y-musicPos) <= -90) or (settingsHandler:get("downscroll") and (enemyNote[1].y-musicPos) >= 90) then
                if voices then audio.setMusicVolume(voices, 1) end

                if enemy then
                    if enemyNote[1].ver ~= "Hey!" then
                        self:safeAnimate(enemy, animList[i] .. (useAltAnims and " alt" or ""), false, 2)
                    else
                        self:safeAnimate(enemy, "hey", false, 2)
                    end
                end

                enemyArrow:animate("confirm")

                table.remove(enemyNote, 1)

                collectgarbage("step")
            end
        end

        if #boyfriendNote > 0 then
            if (not settingsHandler:get("downscroll") and (boyfriendNote[1].y-musicPos) < -130) or (settingsHandler:get("downscroll") and (boyfriendNote[1].y-musicPos) > 130) then
                if voices then audio.setMusicVolume(voices, 0) end

                if girlfriend then
                    if combo >= 5 then
                        self:safeAnimate(girlfriend, "sad", true, 1)
                    end
                end

                combo = 0
                if boyfriendNote[1]:getAnimName() ~= "hold" and boyfriendNote[1]:getAnimName() ~= "end" then 
                    health = health - 0.095
                    misses = misses + 1
                else
                    health = health - 0.0125
                end

                table.remove(boyfriendNote, 1)

                collectgarbage("step")
            end
        end

        if input:pressed(curInput) then
            local success = true

            boyfriendArrow:animate("press")

            if #boyfriendNote > 0 then
                if boyfriendNote[1] and boyfriendNote[1]:getAnimName() == "on" then
                    if boyfriendNote[1].time - musicTime <= 200 then
                        local notePos

                        notePos = math.abs(boyfriendNote[1].time - musicTime)

                        if voices then audio.setMusicVolume(voices, 1) end

                        if notePos <= 40 then
                            score = score + 350
                            ratingAnim = "sick"
                        elseif notePos <= 110 then
                            score = score + 200
                            ratingAnim = "good"
                        elseif notePos <= 170 then
                            score = score + 100
                            ratingAnim = "bad"
                        else
                            success = false
                            ratingAnim = "shit"
                        end
                        combo = combo + 1
                        noteCounter = noteCounter + 1
                        if ratingTimers[1] then Timer.cancel(ratingTimers[1]) end
                        ratingPos.x, ratingPos.y = 210, 100
                        ratingTimers[1] = Timer.tween(
                            0.5, ratingPos, {
                                y = 120
                            }, "out-sine"
                        )
                        ratingAnim = ratingAnim .. "!"

                        if success then
                            boyfriendArrow:animate("confirm")

                            if boyfriend then
                                boyfriend:animate(animList[i])
                            end
                                
                            health = health + 0.095

                            success = true
                        end

                        table.remove(boyfriendNote, 1)

                        collectgarbage("step")
                    end
                end
            end

            if not success then
                if girlfriend then
                    if combo >= 5 then self:safeAnimate(girlfriend, "sad", true, 1) end
                end
                if boyfriend then
                    boyfriend:animate(animList[i] .. " miss")
                end

                score = score - 10
                combo = 0
                health = health - 0.135
                misses = misses + 1
            end
        end
        
        if #boyfriendNote > 0 and input:down(curInput) and ((not settingsHandler:get("downscroll") and (boyfriendNote[1].y-musicPos) <= -90) or (settingsHandler:get("downscroll") and (boyfriendNote[1].y-musicPos) >= 90)) and (boyfriendNote[1]:getAnimName() == "hold" or boyfriendNote[1]:getAnimName() == "end") then
            if voices then audio.setMusicVolume(voices, 1) end

            boyfriendArrow:animate("confirm")
            if boyfriend then
                self:safeAnimate(boyfriend, animList[i] .. (useAltAnims and " alt" or ""), false, 2)
            end

            health = health + 0.0125

            table.remove(boyfriendNote, 1)

            collectgarbage("step")
        end

        if input:released(curInput) then
            boyfriendArrow:animate("off")
        end
    end

    if health < 0 then
        health = 0
    end
    if health >= 2 then
        health = 2
    end

    curBeat = math.floor(musicTime / (60000 / bpm))
    if curBeat ~= lastBeat then
        lastBeat = curBeat
        beatHit = false
        danceLeft = not danceLeft
        if girlfriend then
            if ((girlfriend:getAnimName() ~= "danceLeft" and girlfriend:getAnimName() ~= "danceRight") and not girlfriend:isAnimated()) or 
                (girlfriend:getAnimName() == "danceLeft" or girlfriend:getAnimName() == "danceRight") or girlfriend:getAnimName() == "sad" then
                if danceLeft then
                    self:safeAnimate(girlfriend, "danceLeft", false, 1)
                else
                    self:safeAnimate(girlfriend, "danceRight", false, 1)
                end
            end
        end

        if curBeat % 4 == 0 then
            camera.zoom = camera.zoom + 0.015
            uiScale.zoom = uiScale.zoom + 0.03
        end
    end

    if camera.zooming and not camera.locked then
        camera.zoom = lerp(camera.toZoom, camera.zoom, clamp(1 - (dt * 3.125), 0, 1))
        uiScale.zoom = lerp(uiScale.toZoom, uiScale.zoom, clamp(1 - (dt * 3.125), 0, 1))
    end

    if musicThres ~= oldMusicThres and math.fmod(absMusicTime, 120000 / bpm) < 100 then
        if enemy then
            if spriteTimers[2] == 0 and ((enemy:getAnimName() ~= "idle" and not enemy:isAnimated()) or enemy:getAnimName() == "idle") then
                self:safeAnimate(enemy, "idle", false, 2)
            end
        end
        if boyfriend then
            if spriteTimers[3] == 0 and ((boyfriend:getAnimName() ~= "idle" and not boyfriend:isAnimated()) or boyfriend:getAnimName() == "idle") then
                self:safeAnimate(boyfriend, "idle", false, 3)
            end
        end
    end

    for i = 2, 3 do
        local spriteTimer = spriteTimers[i]

        if spriteTimer > 0 then
            spriteTimers[i] = spriteTimer - 1
        end
    end
end

function weeks:updateEvents(dt)
    if #events > 1 then
        if events[1].eventTime <= absMusicTime then
            if camTimer then
                Timer.cancel(camTimer)
            end
                
            if events[1].mustHitSection then
                camTimer = Timer.tween(1.25, camera, {x=-boyfriend.x+10, y=-boyfriend.y+30}, "out-quad")
            else
                camTimer = Timer.tween(1.25, camera, {x=-enemy.x-20,y=-enemy.y+25}, "out-quad")
            end

            useAltAnims = events[1].altAnim

            table.remove(events, 1)

            collectgarbage("step")
        end
    end
end

function weeks:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)
        love.graphics.scale(uiScale.zoom, uiScale.zoom)
        for i = 1, 4 do
            enemyArrows[i]:draw()
            boyfriendArrows[i]:draw()

            -- draw notes if they are on screen!
            love.graphics.push()
                love.graphics.translate(0, -musicPos)
                for j = 1, #enemyNotes[i] do
                    if (not settingsHandler:get("downscroll") and (enemyNotes[i][j].y-musicPos) < 120) or (settingsHandler:get("downscroll") and (enemyNotes[i][j].y-musicPos) > -120) then
                        enemyNotes[i][j]:draw()
                    else
                        break
                    end
                end

                for j = 1, #boyfriendNotes[i] do
                    if (not settingsHandler:get("downscroll") and (boyfriendNotes[i][j].y-musicPos) < 120) or (settingsHandler:get("downscroll") and (boyfriendNotes[i][j].y-musicPos) > -120) then
                        boyfriendNotes[i][j]:draw()
                    else
                        break
                    end
                end
            love.graphics.pop()
        end
    love.graphics.pop()
end

function weeks:bottomDraw()
    love.graphics.push()
        -- Healthbar
        love.graphics.translate(23, 25)
        love.graphics.scale(0.85, 0.85)
        graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", 10, 28, 300, 15)
        graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", 310, 28, -health * 150, 15)
        love.graphics.setLineWidth(5)
        graphics.setColor(0,0,0)
        love.graphics.rectangle("line", 10, 28, 300, 15)
        graphics.setColor(1,1,1)
        love.graphics.setLineWidth(1)
        graphics.setColor(1,1,1)
        -- 
    love.graphics.pop()
    -- Score
    local lastFont = love.graphics.getFont()
    love.graphics.setFont(isPixelStage and pixelUiFont or uiFont)
    love.graphics.print(
        "Score: " .. score .. "\n" ..
        "Combo: " .. combo .. "\n" ..
        "Misses: " .. misses .. "\n",
    10, 75)

    love.graphics.print(
        string.capitalize(ratingAnim),
        ratingPos.x, ratingPos.y
    )
    love.graphics.setFont(lastFont)
end

function weeks:exit()
    camera.toZoom = 1
    camera.zoom = 1
    uiScale.toZoom = 1
    uiScale.zoom = 1

    -- Clear EVERYTHING, can't have unused stuff lying around!!!
    -- The 3ds needs all the memory it can get!
    for i = 1, 4 do
        for j = 1, #enemyNotes[i] do
            enemyNotes[i][j]:release()
            enemyNotes[i][j] = nil
        end
        for j = 1, #boyfriendNotes[i] do
            boyfriendNotes[i][j]:release()
            boyfriendNotes[i][j] = nil
        end
        enemyArrows[i]:release()
        boyfriendArrows[i]:release()
        enemyArrows[i] = nil
        boyfriendArrows[i] = nil
    end

    if enemy then enemy:release();enemy = nil end
    if boyfriend then boyfriend:release();boyfriend = nil end
    if girlfriend then girlfriend:release();girlfriend = nil end

    events = nil 
    enemyNotes = nil 
    boyfriendNotes = nil 
    enemyArrows = nil 
    boyfriendArrows = nil 
    sprites = nil 
    sounds = nil 
    images = nil 
    ratingAnim = ""

    inst = nil
    voices = nil

    collectgarbage("collect")
end

return weeks