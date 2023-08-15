local story = {}
local curSelect = 0

function story:enter()
    

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

function story:update(dt)
    if input:pressed("uiUp") then
        updateSelection("up")
    elseif input:pressed("uiDown") then
        updateSelection("down")
    end

    if input:pressed("uiConfirm") then
        audio.play(uiConfirm)
        if curSelect == 1 then
            Timer.after(1, function()
                graphics.fadeOut(0.5)
                Gamestate.switch(storyMode)
            end)
        elseif curSelect == 2 then
            Timer.after(1, function()
                graphics.fadeOut(0.5)
                Gamestate.switch(freePlay)
            end)
        end
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
    love.graphics.pop()
end

function story:leave()

end

return story