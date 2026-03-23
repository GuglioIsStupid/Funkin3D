local settings = { data = {} }

local FILE_NAME = "settings.lua"
local CURRENT_VERSION = 2

local DEFAULT_SETTINGS = {
    volume = 1,
    sfxVolume = 1,
    musicVolume = 1,
    downscroll = false,
    debug = "OFF",
    metaversion = CURRENT_VERSION,
}

local function tableToString(tbl)
    local result = "{\n"
    for k, v in pairs(tbl) do
        local key = type(k) == "string" and string.format("%q", k) or tostring(k)
        local value
        if type(v) == "table" then
            value = tableToString(v)
        elseif type(v) == "string" then
            value = string.format("%q", v)
        else
            value = tostring(v)
        end
        result = result .. string.format("  [%s] = %s,\n", key, value)
    end
    return result .. "}"
end

local function validateType(value, defaultValue)
    local expectedType = type(defaultValue)
    if type(value) == expectedType then
        return value
    end
    return defaultValue
end

local function migrateSettings(data, version)
    -- todo: if i change some setting formats in the future, migrate old settings to new form ats if i do change it
    return data
end

function settings.load()
    if not love.filesystem.getInfo(FILE_NAME) then
        settings.data = {}
        for k, v in pairs(DEFAULT_SETTINGS) do
            settings.data[k] = v
        end
        return
    end

    local success, chunk = pcall(love.filesystem.load, FILE_NAME)
    if not success or not chunk then
        settings:reset()
        return
    end

    local loadSuccess, data = pcall(chunk)
    if not loadSuccess or not data or type(data) ~= "table" then
        settings:reset()
        return
    end

    local version = data.metaversion or 0
    if version ~= CURRENT_VERSION then
        data = migrateSettings(data, version)
    end

    settings.data = {}
    for k, v in pairs(data) do
        settings.data[k] = v
    end

    for k, defaultValue in pairs(DEFAULT_SETTINGS) do
        if settings.data[k] == nil then
            settings.data[k] = defaultValue
        else
            settings.data[k] = validateType(settings.data[k], defaultValue)
        end
    end
end

function settings.save()
    settings.data.metaversion = CURRENT_VERSION
    local dataString = "return " .. tableToString(settings.data)
    local success, err = pcall(love.filesystem.write, FILE_NAME, dataString)
    if not success then
        print("Failed to save settings: " .. err)
    end
end

function settings:reset()
    settings.data = {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        settings.data[k] = v
    end
end

function settings:get(key)
    return settings.data[key]
end

function settings:set(key, value)
    if DEFAULT_SETTINGS[key] ~= nil then
        settings.data[key] = validateType(value, DEFAULT_SETTINGS[key])
        self.save()
    else
        print("Warning: setting '" .. key .. "' does not exist")
    end
end

return settings
