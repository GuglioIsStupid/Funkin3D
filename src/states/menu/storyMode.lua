local story = {}
local curSelect = 0
local diffs = {"-easy", "", "-hard"}
local diffNames = {"Easy", "Normal", "Hard"}
local diffColours = {{0, 1, 0}, {1, 1, 0}, {1, 0, 0}}
local diffSelect = 2

function story:enter()
    curSelect = 0
    diffSelect = 2

    graphics.fadeIn(0.5)
end

function updateSelection(change)
    local change = change or 0

    curSelect = curSelect + change

    if curSelect > #weekList-1 then
        curSelect = 0
    elseif curSelect < 0 then
        curSelect = #weekList-1
    end

    audio.play(uiScroll)
end

function updateDiffSelection(change)
    local change = change or -1

    diffSelect = diffSelect + change

    if diffSelect > #diffs then
        diffSelect = 1
    elseif diffSelect < 1 then
        diffSelect = #diffs
    end

    audio.play(uiScroll)
end

function story:update(dt)
    if input:pressed("uiUp") then
        updateSelection(-1)
    elseif input:pressed("uiDown") then
        updateSelection(1)
    end

    if input:pressed("uiLeft") then
        updateDiffSelection(-1)
    elseif input:pressed("uiRight") then
        updateDiffSelection(1)
    end

    if input:pressed("uiConfirm") then
        audio.play(uiConfirm)

        Timer.after(1, function()
            graphics.fadeOut(0.5)
            state.switch(weekData[curSelect+1], 1, diffs[diffSelect])
            title.music:stop()
        end)
    end

    isErect = input:down("uiErectButton")
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
        love.graphics.setFont(uiFont2)
        love.graphics.printf(unpackLines(weekList[curSelect+1][2], "\n"), -150, -50, 320, "center")

        love.graphics.setFont(uiFont)
        love.graphics.printf({{1,1,1},"Difficulty: ", diffColours[diffSelect],diffNames[diffSelect]}, -150, 50, 320, "center")
    love.graphics.pop()
end

function story:exit()
    
end

return story