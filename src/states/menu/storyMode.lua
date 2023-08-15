local story = {}
local curSelect = 0
local diffs = {"-easy", "", "-hard"}
local diffNames = {"Easy", "Normal", "Hard"}
local diffSelect = 2

function story:enter()
    curSelect = 0
    diffSelect = 2

    graphics.fadeIn(0.5)
end

function updateSelection(updown)
    if updown == "up" then
        curSelect = curSelect - 1
        if curSelect < 0 then
            curSelect = #weekList-1
        end
    elseif updown == "down" then
        curSelect = curSelect + 1
        if curSelect > #weekList-1 then
            curSelect = 0
        end
    end

    audio.play(uiScroll)
end

function updateDiffSelection(leftright)
    if leftright == "left" then
        diffSelect = diffSelect - 1
        if diffSelect < 1 then
            diffSelect = #diffNames
        end
    elseif leftright == "right" then
        diffSelect = diffSelect + 1
        if diffSelect > #diffNames then
            diffSelect = 1
        end
    end

    audio.play(uiScroll)
end

function story:update(dt)
    if input:pressed("uiUp") then
        updateSelection("up")
    elseif input:pressed("uiDown") then
        updateSelection("down")
    end

    if input:pressed("uiLeft") then
        updateDiffSelection("left")
    elseif input:pressed("uiRight") then
        updateDiffSelection("right")
    end

    if input:pressed("uiConfirm") then
        audio.play(uiConfirm)

        Timer.after(1, function()
            graphics.fadeOut(0.5)
            Gamestate.switch(weekData[curSelect+1], 1, diffs[diffSelect])
            title.music:stop()
        end)
    end
end

function story:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)
        
    love.graphics.pop()
end

function story:bottomDraw()
    love.graphics.push()
        love.graphics.translate(160, 120)
        love.graphics.setFont(uiFont)
        love.graphics.printf(weekList[curSelect+1][1], -150, -100, 320, "center")
        -- unpack [2] seperately to allow for newlines
        love.graphics.setFont(uiFont2)
        love.graphics.printf(unpackLines(weekList[curSelect+1][2], "\n"), -150, -50, 320, "center")

        love.graphics.setFont(uiFont)
        love.graphics.printf("Difficulty: " .. diffNames[diffSelect], -150, 50, 320, "center")
    love.graphics.pop()
end

function story:leave()
    
end

return story