local audio = {}

audio._playingSfxSources = {}
audio._playingMusicSources = {}

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function audio.play(sound)
    print("DEPRECATED! Please use audio.playSound or audio.playMusic instead.")
    sound:stop()
    sound:play()
end

function audio.playSound(sound, volume)
    if not sound then return end
    volume = (volume or 1) * settingsHandler.data.sfxVolume * settingsHandler.data.volume
    if volume then
        sound:setVolume(volume)
    end
    sound:stop()
    sound:play()
    if not table.contains(audio._playingSfxSources, sound) then
        table.insert(audio._playingSfxSources, {sound = sound, volume = volume})
    end
end

function audio.playMusic(music, volume)
    if not music then return end
    volume = (volume or 1) * settingsHandler.data.musicVolume * settingsHandler.data.volume
    if volume then
        music:setVolume(volume)
    end
    music:stop()
    music:play()
    if not table.contains(audio._playingMusicSources, music) then
        table.insert(audio._playingMusicSources, {music = music, volume = volume})
    end
end

function audio.stopMusic(music)
    if not music then return end
    music:stop()
    for i, source in ipairs(audio._playingMusicSources) do
        if source.music == music then
            table.remove(audio._playingMusicSources, i)
            break
        end
    end
end

function audio.stopAllMusic()
    for _, source in ipairs(audio._playingMusicSources) do
        source.music:stop()
    end
    audio._playingMusicSources = {}
end

function audio.stopAllSfx()
    for _, source in ipairs(audio._playingSfxSources) do
        source.sound:stop()
    end
    audio._playingSfxSources = {}
end

function audio.stopAll()
    audio.stopAllMusic()
    audio.stopAllSfx()
end

function audio.update()
    for i = #audio._playingSfxSources, 1, -1 do
        local source = audio._playingSfxSources[i]
        source.sound:setVolume(settingsHandler.data.sfxVolume * settingsHandler.data.volume * (source.volume or 1))
        if not source.sound:isPlaying() then
            table.remove(audio._playingSfxSources, i)
        end
    end

    for i = #audio._playingMusicSources, 1, -1 do
        local source = audio._playingMusicSources[i]
        source.music:setVolume(settingsHandler.data.musicVolume * settingsHandler.data.volume * (source.volume or 1))
        if not source.music:isPlaying() then
            table.remove(audio._playingMusicSources, i)
        end
    end
end

function audio.setSfxVolume(sound, volume)
    for _, source in ipairs(audio._playingSfxSources) do
        if source.sound == sound then
            source.volume = volume
            source.sound:setVolume(volume * settingsHandler.data.sfxVolume * settingsHandler.data.volume)
            break
        end
    end
end

function audio.setMusicVolume(music, volume)
    for _, source in ipairs(audio._playingMusicSources) do
        if source.music == music then
            source.volume = volume
            source.music:setVolume(volume * settingsHandler.data.musicVolume * settingsHandler.data.volume)
            break
        end
    end
end

return audio