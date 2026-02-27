function CheckAndConnectRadioChannel(radio, job)
    if radio > Config.maxFrequency then Notify('You can not connect to this signal!', 'error') return end
    if Config.restrictedChannels[radio] and not Config.restrictedChannels[radio][job] then Notify('You can not connect to this signal!', 'error') return end
    ConnectRadio(radio)
end

RegisterCommand('+increaseRadioChannel', function()
    local hasRadio = CheckRadioItem()
    if not hasRadio then return end

    local newChannel = RadioChannel + 1
    if newChannel > Config.maxFrequency then newChannel = Config.maxFrequency end
    local job = GetPlayerJob()
    CheckAndConnectRadioChannel(newChannel, job)
end, false)
RegisterKeyMapping('+increaseRadioChannel', 'Increase Radio Freq', 'keyboard', 'F5')

RegisterCommand('+decreaseRadioChannel', function()
    local hasRadio = CheckRadioItem()
    if not hasRadio then return end

    local newChannel = RadioChannel - 1
    if newChannel < 1 then newChannel = 1 end
    local job = GetPlayerJob()
    CheckAndConnectRadioChannel(newChannel, job)
end, false)
RegisterKeyMapping('+decreaseRadioChannel', 'Decrease Radio Freq', 'keyboard', 'F6')

local function useRadio()
    local hasRadio = CheckRadioItem()
    if not hasRadio then Notify('You do not have a radio on you.', 'error') return end
    ToggleRadio(not RadioMenu)
end

RegisterNetEvent('radio:use', function()
    useRadio()
end)

RegisterCommand('radio:use', function()
    useRadio()
end, false)

RegisterKeyMapping('radio:use', 'OpenRadio', 'keyboard', 'j')