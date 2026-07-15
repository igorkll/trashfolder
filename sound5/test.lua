-- stream.lua
-- Воспроизведение аудиофайла по URL через потоковую загрузку

-- Проверяем, есть ли динамик
local speaker = peripheral.find("speaker")
if not speaker then
    print("Динамик не найден! Прикрепите динамик к компьютеру.")
    return
end

local url = "https://raw.githubusercontent.com/igorkll/trashfolder/main/sound5/output.pcm"


-- Функция для воспроизведения аудио из HTTP-потока
local function playAudioStream(url)
    -- Открываем HTTP-соединение для загрузки файла
    local response = http.get(url, nil, true)  -- true для бинарного режима
    if not response then
        print("Не удалось загрузить файл по URL: " .. url)
        return
    end

    if response.getResponseCode() ~= 200 then
        print("Ошибка HTTP: " .. response.getResponseCode())
        response.close()
        return
    end

    print("Начинаем воспроизведение...")

    local chunkSize = 16 * 1024

    -- Читаем файл по частям
    while true do
        local chunk = response.read(chunkSize)
        if not chunk then
            break  -- Конец файла
        end

        -- Декодируем DFPWM в PCM
        local buffer = chunk

        -- Отправляем аудио на динамик
        -- Если буфер динамика заполнен, ждём события и пробуем снова[reference:3][reference:4]
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end

    response.close()
    print("Воспроизведение завершено.")
end

-- Запускаем воспроизведение
playAudioStream(url)
