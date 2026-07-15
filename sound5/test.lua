local speaker = peripheral.find("speaker")
if not speaker then
    return
end

local url = "https://raw.githubusercontent.com/igorkll/trashfolder/main/sound5/output.pcm"

local function playAudioStream(url)
    local response = http.get(url, nil, true)  -- true для бинарного режима
    if not response then
        print("Failed to load: " .. url)
        return
    end

    if response.getResponseCode() ~= 200 then
        print("Error: " .. response.getResponseCode())
        response.close()
        return
    end

    print("Start playing...")

    local chunkSize = 16 * 1024

    while true do
        local chunk = response.read(chunkSize)
        if not chunk then
            break
        end

        local buffer = chunk
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end

    response.close()
end

playAudioStream(url)
