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
local notMissed = {}
local countdownFade = {}

function weeks:enter()
    boyfriend = love.filesystem.load("assets/sprites/boyfriend.lua")()
    girlfriend = love.filesystem.load("assets/sprites/girlfriend.lua")()

    sounds = {

    }
    images = {
        notes = love.graphics.newImage(graphics.imagePath("notes"))
    }
    sprites = {

    }
    notMissed = {}
end

function weeks:load()
    if inst then inst:release() end
    if voices then voices:release() end
    collectgarbage("collect")
    useAltAnims = false
    camera.x, camera.y = -boyfriend.x + 25, -boyfriend.y + 2
    for i = 1, 4 do
        notMissed[i] = true
    end

    camTimer = Timer.tween(1.25, camera, {x=-boyfriend.x+10, y=-boyfriend.y+20}, "out-quad")

    graphics.fadeIn(0.5)
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
    if not sprites.leftarrow then sprites.leftarrow = love.filesystem.load("assets/sprites/notes/left.lua") end
    if not sprites.downarrow then sprites.downarrow = love.filesystem.load("assets/sprites/notes/down.lua") end
    if not sprites.uparrow then sprites.uparrow = love.filesystem.load("assets/sprites/notes/up.lua") end
    if not sprites.rightarrow then sprites.rightarrow = love.filesystem.load("assets/sprites/notes/right.lua") end

    if not enemyArrows then
        enemyArrows = {
            sprites.leftarrow(),
            sprites.downarrow(),
            sprites.uparrow(),
            sprites.rightarrow()
        }
    end
    if not boyfriendArrows then
        boyfriendArrows = {
            sprites.leftarrow(),
            sprites.downarrow(),
            sprites.uparrow(),
            sprites.rightarrow()
        }
    end

    enemyNotes = {}
    boyfriendNotes = {}

    for i = 1, 4 do
        enemyArrows[i].x = -170 + ((i-1) * 40)
        

        boyfriendArrows[i].x = 50 + ((i-1) * 40)

        if downscroll then
            boyfriendArrows[i].y = 90
            enemyArrows[i].y = 90
        else
            boyfriendArrows[i].y = -90
            enemyArrows[i].y = -90
        end

        enemyNotes[i] = {}
        boyfriendNotes[i] = {}
    end
end

function weeks:generateNotes(chart)
    local eventBpm
    events = {}

    chart = json.decode(love.filesystem.read(chart)).song
    songname = chart.song

    for i = 1, #chart.notes do
        bpm = chart.notes[i].bpm

        if bpm then
            break
        end
    end
    if not bpm then
        bpm = chart.bpm or 100
    end

    speed = chart.speed * Fnf3dsRatio

    for i = 1, #chart.notes do
        for j = 1, #chart.notes[i].sectionNotes do
            local sprite
            local sectionNotes = chart.notes[i].sectionNotes

            local mustHitSection = chart.notes[i].mustHitSection
            local altAnim = chart.notes[i].altAnim or false
            local noteType = sectionNotes[j][2]
            local noteTime = sectionNotes[j][1]
            local noteVer = sectionNotes[j][4] or "normal"
            
            if j == 1 then
                table.insert(events, {eventTime = sectionNotes[1][1], mustHitSection = mustHitSection, bpm = bpm, altAnim = altAnim})
            end

            if noteType == 0 or noteType == 4 then
                sprite = sprites.leftarrow
            elseif noteType == 1 or noteType == 5 then
                sprite = sprites.downarrow
            elseif noteType == 2 or noteType == 6 then
                sprite = sprites.uparrow
            elseif noteType == 3 or noteType == 7 then
                sprite = sprites.rightarrow
            end

            if mustHitSection then
                if noteType >= 4 then
                    local id = noteType - 3 
                    local c = #enemyNotes[id]+1
                    local x = enemyArrows[id].x

                    table.insert(enemyNotes[id], sprite())
                    enemyNotes[id][c].x = x
                    enemyNotes[id][c].y = -90 + noteTime * 0.45 * speed
                    enemyNotes[id][c].time = noteTime
                    enemyNotes[id][c].ver = noteVer

                    enemyNotes[id][c]:animate("on", false)

                    if sectionNotes[j][3] > 0 then
                        local c

                        for k = 24 / speed, sectionNotes[j][3], 24 / speed do
                            local c = #enemyNotes[id]+1

                            table.insert(enemyNotes[id], sprite())
                            enemyNotes[id][c].x = x
                            enemyNotes[id][c].y = -90 + (noteTime + k) * 0.45 * speed
                            enemyNotes[id][c].time = noteTime + k
                            enemyNotes[id][c].alpha = 0.6

                            enemyNotes[id][c]:animate("hold", false)

                            c = nil
                        end

                        c = #enemyNotes[id]

                        enemyNotes[id][c].offsetY = -3
                        enemyNotes[id][c]:animate("end", false)

                        c = nil
                    end

                    id = nil
                    c = nil
                    x = nil
                    
                elseif noteType < 4 and noteType >= 0 then
                    local id = noteType + 1
                    local c = #boyfriendNotes[id]+1
                    local x = boyfriendArrows[id].x

                    table.insert(boyfriendNotes[id], sprite())
                    boyfriendNotes[id][c].x = x
                    boyfriendNotes[id][c].y = -90 + noteTime * 0.45 * speed
                    boyfriendNotes[id][c].time = noteTime
                    boyfriendNotes[id][c].ver = noteVer

                    boyfriendNotes[id][c]:animate("on", false)

                    if sectionNotes[j][3] > 0 then
                        local c

                        for k = 24 / speed, sectionNotes[j][3], 24 / speed do
                            local c = #boyfriendNotes[id]+1

                            table.insert(boyfriendNotes[id], sprite())
                            boyfriendNotes[id][c].x = x
                            boyfriendNotes[id][c].y = -90 + (noteTime + k) * 0.45 * speed
                            boyfriendNotes[id][c].time = noteTime + k
                            boyfriendNotes[id][c].alpha = 0.6

                            boyfriendNotes[id][c]:animate("hold", false)

                            c = nil
                        end

                        c = #boyfriendNotes[id]

                        boyfriendNotes[id][c].offsetY = -3
                        boyfriendNotes[id][c]:animate("end", false)

                        c = nil
                    end

                    id = nil
                    c = nil
                    x = nil
                end
            else
                -- now its swapped
                if noteType >= 4 then
                    local id = noteType - 3 
                    local c = #boyfriendNotes[id]+1
                    local x = boyfriendArrows[id].x
    
                    table.insert(boyfriendNotes[id], sprite())
                    boyfriendNotes[id][c].x = x
                    boyfriendNotes[id][c].y = -90 + noteTime * 0.45 * speed
                    boyfriendNotes[id][c].time = noteTime
                    boyfriendNotes[id][c].ver = noteVer
    
                    boyfriendNotes[id][c]:animate("on", false)
    
                    if sectionNotes[j][3] > 0 then
                        local c
    
                        for k = 24 / speed, sectionNotes[j][3], 24 / speed do
                            local c = #boyfriendNotes[id]+1
    
                            table.insert(boyfriendNotes[id], sprite())
                            boyfriendNotes[id][c].x = x
                            boyfriendNotes[id][c].y = -90 + (noteTime + k) * 0.45 * speed
                            boyfriendNotes[id][c].time = noteTime + k
                            boyfriendNotes[id][c].alpha = 0.6
    
                            boyfriendNotes[id][c]:animate("hold", false)

                            c = nil
                        end
    
                        c = #boyfriendNotes[id]
    
                        boyfriendNotes[id][c].offsetY = -3
                        boyfriendNotes[id][c]:animate("end", false)

                        c = nil
                    end

                    id = nil
                    c = nil
                    x = nil
                elseif noteType < 4 and noteType >= 0 then
                    local id = noteType + 1
                    local c = #enemyNotes[id]+1
                    local x = enemyArrows[id].x
    
                    table.insert(enemyNotes[id], sprite())
                    enemyNotes[id][c].x = x
                    enemyNotes[id][c].y = -90 + noteTime * 0.45 * speed
                    enemyNotes[id][c].time = noteTime
                    enemyNotes[id][c].ver = noteVer
    
                    enemyNotes[id][c]:animate("on", false)
    
                    if sectionNotes[j][3] > 0 then
                        local c
    
                        for k = 24 / speed, sectionNotes[j][3], 24 / speed do
                            local c = #enemyNotes[id]+1
    
                            table.insert(enemyNotes[id], sprite())
                            enemyNotes[id][c].x = x
                            enemyNotes[id][c].y = -90 + (noteTime + k) * 0.45 * speed
                            enemyNotes[id][c].time = noteTime + k
                            enemyNotes[id][c].alpha = 0.6
    
                            enemyNotes[id][c]:animate("hold", false)

                            c = nil
                        end
    
                        c = #enemyNotes[id]
    
                        enemyNotes[id][c].offsetY = -3
                        enemyNotes[id][c]:animate("end", false)

                        c = nil
                    end

                    id = nil
                    c = nil
                    x = nil
                end
            end

            sprite = nil
            sectionNotes = nil
            mustHitSection = nil
            altAnim = nil
            noteType = nil
            noteTime = nil
            noteVer = nil
        end
    end

    for i = 1, 4 do
        table.sort(enemyNotes[i], function(a, b) return a.y < b.y end)
        table.sort(boyfriendNotes[i], function(a, b) return a.y < b.y end)
    end

    -- Workarounds for bad charts that have multiple notes around the same place
    for i = 1, 4 do
        local offset = 0

        for j = 2, #enemyNotes[i] do
            local index = j - offset

            if enemyNotes[i][index]:getAnimName() == "on" and enemyNotes[i][index - 1]:getAnimName() == "on" and ((enemyNotes[i][index].y - enemyNotes[i][index - 1].y <= 10)) then
                table.remove(enemyNotes[i], index)

                offset = offset + 1
            end
        end
    end
    for i = 1, 4 do
        local offset = 0

        for j = 2, #boyfriendNotes[i] do
            local index = j - offset

            if boyfriendNotes[i][index]:getAnimName() == "on" and boyfriendNotes[i][index - 1]:getAnimName() == "on" and ((boyfriendNotes[i][index].y - boyfriendNotes[i][index - 1].y <= 10)) then
                table.remove(boyfriendNotes[i], index)

                offset = offset + 1
            end
        end
    end

    -- Clear up memory of unused vars
    chart = nil
    eventBpm = nil

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

                                    if inst then inst:play() end
                                    if voices then voices:play() end
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
    boyfriend:update(dt)
    girlfriend:update(dt)
    enemy:update(dt)
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
    if downscroll then
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
            if (not downscroll and (enemyNote[1].y-musicPos) <= -90) or (downscroll and (enemyNote[1].y-musicPos) >= 90) then
                if voices then voices:setVolume(1) end

                if enemyNote[1].ver ~= "Hey!" then
                    self:safeAnimate(enemy, animList[i] .. (useAltAnims and " alt" or ""), false, 2)
                else
                    self:safeAnimate(enemy, "hey", false, 2)
                end

                enemyArrow:animate("confirm")

                table.remove(enemyNote, 1)

                collectgarbage("step")
            end
        end

        if #boyfriendNote > 0 then
            if (not downscroll and (boyfriendNote[1].y-musicPos) < -130) or (downscroll and (boyfriendNote[1].y-musicPos) > 130) then
                if voices then voices:setVolume(0) end

                if combo >= 5 then
                    self:safeAnimate(girlfriend, "sad", true, 1)
                end

                notMissed[noteNum] = false

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
                for j = 1, #boyfriendNote do
                    if boyfriendNote[j] and boyfriendNote[j]:getAnimName() == "on" then
                        if boyfriendNote[j].time - musicTime <= 270 then
                            local notePos
                            local ratingAnim

                            notMissed[noteNum] = true

                            notePos = math.abs(boyfriendNote[j].time - musicTime)

                            if voices then voices:setVolume(1) end

                            if notePos <= 110 then
                                score = score + 350
                                ratingAnim = "sick"
                            elseif notePos <= 180 then
                                score = score + 200
                                ratingAnim = "good"
                            elseif notePos <= 240 then
                                score = score + 100
                                ratingAnim = "bad"
                            else
                                success = false
                                ratingAnim = "shit"
                            end
                            combo = combo + 1
                            noteCounter = noteCounter + 1

                            if success then
                                boyfriendArrow:animate("confirm")

                                boyfriend:animate(animList[i])
                                
                                health = health + 0.095

                                success = true
                            end

                            table.remove(boyfriendNote, j)

                            collectgarbage("step")
                        else
                            break
                        end
                    end
                end
            end

            if not success then
                notMissed[noteNum] = false

                if combo >= 5 then self:safeAnimate(girlfriend, "sad", true, 1) end
                boyfriend:animate(animList[i] .. " miss")

                score = score - 10
                combo = 0
                health = health - 0.135
                misses = misses + 1
            end
        end
        
        if #boyfriendNote > 0 and input:down(curInput) and ((not downscroll and (boyfriendNote[1].y-musicPos) <= -90) or (downscroll and (boyfriendNote[1].y-musicPos) >= 90)) and (boyfriendNote[1]:getAnimName() == "hold" or boyfriendNote[1]:getAnimName() == "end") then
            if voices then voices:setVolume(1) end

            boyfriendArrow:animate("confirm")
            self:safeAnimate(boyfriend, animList[i] .. (useAltAnims and " alt" or ""), false, 2)

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
        if ((girlfriend:getAnimName() ~= "danceLeft" and girlfriend:getAnimName() ~= "danceRight") and not girlfriend:isAnimated()) or 
            (girlfriend:getAnimName() == "danceLeft" or girlfriend:getAnimName() == "danceRight") or girlfriend:getAnimName() == "sad" then
            if danceLeft then
                self:safeAnimate(girlfriend, "danceLeft", false, 1)
            else
                self:safeAnimate(girlfriend, "danceRight", false, 1)
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
        if spriteTimers[2] == 0 and ((enemy:getAnimName() ~= "idle" and not enemy:isAnimated()) or enemy:getAnimName() == "idle") then
            self:safeAnimate(enemy, "idle", false, 2)
        end
        if spriteTimers[3] == 0 and ((boyfriend:getAnimName() ~= "idle" and not boyfriend:isAnimated()) or boyfriend:getAnimName() == "idle") then
            self:safeAnimate(boyfriend, "idle", false, 3)
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
    for i = 1, #events do
        if events[i].eventTime <= absMusicTime then
            if camTimer then
                Timer.cancel(camTimer)
            end
            
            if events[i].mustHitSection then
                camTimer = Timer.tween(1.25, camera, {x=-boyfriend.x+10, y=-boyfriend.y+30}, "out-quad")
            else
                camTimer = Timer.tween(1.25, camera, {x=-enemy.x-20,y=-enemy.y+25}, "out-quad")
            end

            useAltAnims = events[i].altAnim

            table.remove(events, i)

            collectgarbage("step")
            break
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
                for j = #enemyNotes[i], 1, -1 do
                    if (not downscroll and (enemyNotes[i][j].y-musicPos) < 120) or (downscroll and (enemyNotes[i][j].y-musicPos) > -120) then
                        enemyNotes[i][j]:draw()
                    end
                end

                for j = #boyfriendNotes[i], 1, -1 do
                    if (not downscroll and (boyfriendNotes[i][j].y-musicPos) < 120) or (downscroll and (boyfriendNotes[i][j].y-musicPos) > -120) then
                        boyfriendNotes[i][j]:draw()
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
    love.graphics.print(
        "Score: " .. score .. "\n" ..
        "Combo: " .. combo .. "\n" ..
        "Misses: " .. misses .. "\n",
    10, 75)
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

    enemy:release()
    boyfriend:release()
    girlfriend:release()

    events = nil 
    enemyNotes = nil 
    boyfriendNotes = nil 
    enemyArrows = nil 
    boyfriendArrows = nil 
    sprites = nil 
    sounds = nil 
    images = nil 
    
    if inst then inst:release() end
    if voices then voices:release() end

    collectgarbage("collect")
end

return weeks