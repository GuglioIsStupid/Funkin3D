local freeplay = state()
local curSelect = 0
local diffs = {"-easy", "", "-hard"}
local diffNames = {"Easy", "Normal", "Hard"}
local diffColours = {{0, 1, 0}, {1, 1, 0}, {1, 0, 0}}
local diffSelect = 2

local screen = "weeks"
local selectedWeek = nil
local songSelect = 0
local songList = {}
local scrollOffset = 0
local maxVisibleSongs = 4

local allWeeks

function freeplay:enter()
    curSelect = 0
    diffSelect = 2
    screen = "weeks"
    selectedWeek = nil
    songSelect = 0
    scrollOffset = 0

    allWeeks = {}
    for _, week in ipairs(weekData) do
        table.insert(allWeeks, week)
    end
    for modName, mod in pairs(modmanager._modList) do
        if mod.weeks then
            for _, week in ipairs(mod.weeks) do
                week._mod = modName
                table.insert(allWeeks, week)
            end
        end
    end

    graphics.fadeIn(0.5)
end

local function updateSelection(change)
    change = change or 0

    if screen == "weeks" then
        curSelect = curSelect + change

        if curSelect > #allWeeks - 1 then
            curSelect = 0
        elseif curSelect < 0 then
            curSelect = #allWeeks - 1
        end
    elseif screen == "songs" then
        songSelect = songSelect + change

        if songSelect > #songList - 1 then
            songSelect = 0
            scrollOffset = 0
        elseif songSelect < 0 then
            songSelect = #songList - 1
            scrollOffset = math.max(0, #songList - maxVisibleSongs)
        end

        if songSelect < scrollOffset then
            scrollOffset = songSelect
        elseif songSelect >= scrollOffset + maxVisibleSongs then
            scrollOffset = songSelect - maxVisibleSongs + 1
        end
    end

    audio.playSound(uiScroll)
end

local function updateDiffSelection(change)
    change = change or -1

    diffSelect = diffSelect + change

    if diffSelect > #diffs then
        diffSelect = 1
    elseif diffSelect < 1 then
        diffSelect = #diffs
    end

    audio.playSound(uiScroll)
end

local function loadSongsForWeek(weekIndex)
    songList = {}

    local week = allWeeks[weekIndex]
    if week and week.list then
        for _, songName in ipairs(week.list) do
            table.insert(songList, songName)
        end
    end

    songSelect = 0
    scrollOffset = 0
end

function freeplay:update(dt)
    if screen == "weeks" then
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
            audio.playSound(uiConfirm)
            selectedWeek = curSelect + 1
            loadSongsForWeek(selectedWeek)
            screen = "songs"
        end

        if input:pressed("uiBack") then
            audio.playSound(uiBack)
            graphics.fadeOut(0.3, function()
                state.switch(menuSelect)
            end)
        end
    elseif screen == "songs" then
        if input:pressed("uiUp") then
            updateSelection(-1)
        elseif input:pressed("uiDown") then
            updateSelection(1)
        end

        if input:pressed("uiConfirm") then
            audio.playSound(uiConfirm)

            Timer.after(1, function()
                graphics.fadeOut(0.3, function()
                    state.switch(allWeeks[selectedWeek], songSelect + 1, diffs[diffSelect])
                end)
                if title.music then
                    title.music:stop()
                end
            end)
        end

        if input:pressed("uiBack") then
            audio.playSound(uiBack)
            screen = "weeks"
            selectedWeek = nil
            songSelect = 0
            scrollOffset = 0
        end
    end

    isErect = input:down("uiErectButton")
end

function freeplay:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)

        if screen == "weeks" then
            love.graphics.setFont(uiFont)
            love.graphics.printf("FREEPLAY", -150, -100, 320, "center")
        elseif screen == "songs" then
            love.graphics.setFont(uiFont)
            love.graphics.printf(allWeeks[selectedWeek].weekName, -150, -100, 320, "center")
        end
    love.graphics.pop()
end

function freeplay:bottomDraw()
    love.graphics.push()
        love.graphics.translate(160, 120)

        if screen == "weeks" then
            love.graphics.setFont(uiFont)
            love.graphics.printf(allWeeks[curSelect+1].weekName, -150, -100, 320, "center")
            love.graphics.setFont(uiFont2)
            love.graphics.printf(unpackLines(allWeeks[curSelect+1].list, "\n"), -150, -50, 320, "center")

            love.graphics.setFont(uiFont)
            love.graphics.printf({{1,1,1},"Difficulty: ", diffColours[diffSelect],diffNames[diffSelect]}, -150, 50, 320, "center")

        elseif screen == "songs" then
            love.graphics.setFont(uiFont2)

            for i = 1, math.min(maxVisibleSongs, #songList) do
                local songIndex = scrollOffset + (i - 1)
                local songName = songList[songIndex + 1]

                if songName then
                    local yPos = -80 + (i - 1) * 30
                    local isSelected = songIndex == songSelect

                    if isSelected then
                        love.graphics.setColor(1, 1, 0)
                    else
                        love.graphics.setColor(1, 1, 1)
                    end

                    love.graphics.printf(songName, -150, yPos, 320, "center")
                end
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(uiFont)
            love.graphics.printf({{1,1,1},"Difficulty: ", diffColours[diffSelect],diffNames[diffSelect]}, -150, 80, 320, "center")
        end

    love.graphics.pop()
end

function freeplay:exit()

end

return freeplay
