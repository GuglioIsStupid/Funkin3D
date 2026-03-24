local manager = {}

manager.modsEnabled = true
manager._modList = {}

local function resolvePath(mod, path)
    local modPath = "mods/" .. mod .. "/" .. path
    if love.filesystem.getInfo(modPath) then
        return modPath
    end
    return path
end

local function makeFilesystem(mod, envBase)
    return {
        load = function(path)
            local chunk = love.filesystem.load(resolvePath(mod, path))
            setfenv(chunk, _G)
            return chunk
        end,

        read = function(path)
            return love.filesystem.read(resolvePath(mod, path))
        end,

        getInfo = function(path)
            return love.filesystem.getInfo(resolvePath(mod, path))
        end,

        getDirectoryItems = function(path)
            local modPath = "mods/" .. mod .. "/" .. path
            if love.filesystem.getInfo(modPath) then
                return love.filesystem.getDirectoryItems(modPath)
            end
            return love.filesystem.getDirectoryItems(path)
        end
    }
end

local function makeAudio(mod)
    return {
        newSource = function(path, type)
            return love.audio.newSource(resolvePath(mod, path), type)
        end,
        play = love.audio.play,
        stop = love.audio.stop
    }
end

local function makeGraphics(mod)
    return love.graphics
end

local function makeGraphicsImagePath(mod)
    return function(path)
        local ext = graphics.getImageType()
        local base = "assets/images/" .. path .. "." .. ext
        local modded = "mods/" .. mod .. "/assets/images/" .. path .. "." .. ext
        if love.filesystem.getInfo(modded) then
            return modded
        end
        return base
    end
end

local function makeRequire(mod, envBase)
    local cache = {}
    return function(path)
        if cache[path] then
            return cache[path]
        end

        local fullPath = resolvePath(mod, path)
        local chunk = love.filesystem.load(fullPath)
        setfenv(chunk, envBase)

        local success, result = pcall(chunk)
        if success then
            cache[path] = result
            return result
        else
            error("Failed to require " .. path .. ": " .. tostring(result))
        end
    end
end

function manager:loadMods()
    local modFiles = love.filesystem.getDirectoryItems("mods")

    for _, mod in pairs(modFiles) do
        local modPath = "mods/" .. mod

        if love.filesystem.getInfo(modPath).type == "directory" then
            local metaFile = modPath .. "/meta.lua"

            if love.filesystem.getInfo(metaFile) then
                local metaChunk = love.filesystem.load(metaFile)

                local passthrough = {
                    enemy = true,
                    boyfriend = true,
                    girlfriend = true,
                    inst = true,
                    voices = true,
                }

                local envBase = setmetatable({}, {
                    __index = _G,
                    __newindex = function(t, k, v)
                        if passthrough[k] then
                            _G[k] = v
                        else
                            rawset(t, k, v)
                        end
                    end
                })

                envBase._G = envBase

                envBase.io = nil
                envBase.os = nil
                envBase.debug = nil
                envBase.package = nil

                envBase.love = {
                    timer = love.timer,
                    filesystem = makeFilesystem(mod, envBase),
                    audio = makeAudio(mod),
                    graphics = makeGraphics(mod)
                }

                envBase.graphics = setmetatable({
                    imagePath = makeGraphicsImagePath(mod)
                }, { __index = graphics })

                envBase.weeks = weeks
                envBase.require = makeRequire(mod, envBase)

                envBase.load = function(str, name)
                    return load(str, name, "t", envBase)
                end

                setfenv(metaChunk, envBase)

                local success, meta = pcall(metaChunk)

                if success and type(meta) == "table" then
                    if type(meta.name) ~= "string" then
                        error("Mod " .. mod .. " missing name")
                    end

                    if type(meta.description) ~= "string" then
                        error("Mod " .. mod .. " missing description")
                    end

                    if meta.weeks and type(meta.weeks) ~= "table" then
                        error("Mod " .. mod .. " weeks must be a table")
                    end

                    self._modList[mod] = meta

                    print("Loaded mod " .. mod .. ": " .. meta.name)
                else
                    print("Failed to load mod " .. mod .. ": " .. tostring(meta))
                end
            else
                print("Mod " .. mod .. " is missing a meta.lua file")
            end
        end
    end
end

return manager