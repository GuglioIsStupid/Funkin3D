local config = state()

local settings = {}
local settingOrder = {}

local function createsetting(name, type, options, description)
    settings[name] = {
        type = type,
        options = options,
        description = description or "",
    }
    table.insert(settingOrder, name)
end

createsetting("volume", "number", {min=0, max=1, step=0.01}, "Master volume for all sounds")
createsetting("sfxVolume", "number", {min=0, max=1, step=0.01}, "Volume for sound effects")
createsetting("musicVolume", "number", {min=0, max=1, step=0.01}, "Volume for the music")
createsetting("downscroll", "boolean", nil, "Arrows scroll down instead of up")
createsetting("debug", "options", {options={"OFF", "ON", "FPS"}, step=1}, "Enable debug mode (shows memory usage and fps)")

local settingNames = settingOrder

local curSelect = 0
local scrollOffset = 0
local maxVisibleItems = 5
local leftHeldTime = 0
local rightHeldTime = 0
local holdThreshold = 0.3
local accelerationMultiplier = 1

function config:enter()
    curSelect = 0
    scrollOffset = 0
    leftHeldTime = 0
    rightHeldTime = 0
    graphics.fadeIn(0.5)
end

local function updateSelection(change)
    change = change or 0

    curSelect = curSelect + change

    if curSelect > #settingNames - 1 then
        curSelect = 0
        scrollOffset = 0
    elseif curSelect < 0 then
        curSelect = #settingNames - 1
        scrollOffset = math.max(0, #settingNames - maxVisibleItems)
    end

    if curSelect < scrollOffset then
        scrollOffset = curSelect
    elseif curSelect >= scrollOffset + maxVisibleItems then
        scrollOffset = curSelect - maxVisibleItems + 1
    end

    audio.playSound(uiScroll)
end

local function updateSettingValue(change, accel)
    accel = accel or 1
    local settingName = settingNames[curSelect + 1]
    local setting = settings[settingName]
    local currentValue = settingsHandler:get(settingName)

    if setting.type == "number" then
        local newValue = currentValue + (setting.options.step * change * accel)
        newValue = math.max(setting.options.min, math.min(setting.options.max, newValue))
        settingsHandler:set(settingName, newValue)
    elseif setting.type == "boolean" then
        settingsHandler:set(settingName, not currentValue)
    elseif setting.type == "options" then
        local options = setting.options.options
        local currentIndex = 1
        for i, option in ipairs(options) do
            if option == currentValue then
                currentIndex = i
                break
            end
        end
        local newIndex = currentIndex + (change * math.ceil(accel))
        if newIndex > #options then
            newIndex = 1
        elseif newIndex < 1 then
            newIndex = #options
        end
        settingsHandler:set(settingName, options[newIndex])
    end

    audio.playSound(uiScroll)
end

function config:update(dt)
    if input:pressed("uiUp") then
        updateSelection(-1)
    elseif input:pressed("uiDown") then
        updateSelection(1)
    end

    if input:pressed("uiLeft") then
        updateSettingValue(-1)
        leftHeldTime = 0
    elseif input:down("uiLeft") then
        leftHeldTime = leftHeldTime + dt
        if leftHeldTime > holdThreshold then
            accelerationMultiplier = 1 + (leftHeldTime - holdThreshold) * 3
            updateSettingValue(-1, accelerationMultiplier)
        end
    else
        leftHeldTime = 0
    end

    if input:pressed("uiRight") then
        updateSettingValue(1)
        rightHeldTime = 0
    elseif input:down("uiRight") then
        rightHeldTime = rightHeldTime + dt
        if rightHeldTime > holdThreshold then
            accelerationMultiplier = 1 + (rightHeldTime - holdThreshold) * 3
            updateSettingValue(1, accelerationMultiplier)
        end
    else
        rightHeldTime = 0
    end

    if input:pressed("uiBack") then
        audio.playSound(uiBack)
        graphics.fadeOut(0.3, function()
            state.switch(menuSelect)
        end)
    end
end

function config:topDraw()
    love.graphics.push()
        love.graphics.translate(200, 120)

        local selectedSettingName = settingNames[curSelect + 1]
        local selectedSetting = settings[selectedSettingName]

        love.graphics.setFont(uiFont)
        love.graphics.printf(selectedSettingName, -150, -100, 320, "center")

        love.graphics.setFont(uiFont2)
        love.graphics.printf(selectedSetting.description, -150, -40, 320, "center")
    love.graphics.pop()
end

function config:bottomDraw()
    love.graphics.push()
        love.graphics.translate(160, 120)
        love.graphics.setFont(uiFont2)

        for i = 1, math.min(maxVisibleItems, #settingNames) do
            local settingIndex = scrollOffset + (i - 1)
            local settingName = settingNames[settingIndex + 1]

            if settingName then
                local yPos = -80 + (i - 1) * 30
                local isSelected = settingIndex == curSelect

                if isSelected then
                    love.graphics.setColor(1, 1, 0)
                else
                    love.graphics.setColor(1, 1, 1)
                end

                love.graphics.printf(settingName, -150, yPos, 320, "left")

                local setting = settings[settingName]
                local currentValue = settingsHandler:get(settingName)
                local valueStr = ""
                if setting.type == "boolean" then
                    valueStr = currentValue and "ON" or "OFF"
                elseif setting.type == "options" then
                    valueStr = tostring(currentValue)
                else
                    valueStr = string.format("%.2f", currentValue)
                end
                love.graphics.printf(valueStr, -160, yPos, 320, "right")
            end
        end

        love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

function config:exit()
end

return config
