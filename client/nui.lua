RegisterNUICallback('joinRadio', function(data, cb)
    local job = GetPlayerJob()
    local success = CheckAndConnectRadioChannel(tonumber(data), job)
    cb(success)
    SendNUIMessage({
        action = 'setConnected',
        data = true
    })
end)

RegisterNUICallback('joinFaveRadio', function (data, cb)
    cb(1)
    local job = GetPlayerJob()
    local success CheckAndConnectRadioChannel(tonumber(data), job)
    if not success then return end
    SendNUIMessage({
        action = 'setRadio',
        data = data
    })
    SendNUIMessage({
        action = 'setConnected',
        data = true
    })
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    cb(1)
    if RadioChannel == 0 then
        Notify('You\'re not connected to a signal', 'error')
    else
        LeaveRadio()
    end
end)

RegisterNUICallback('deleteFaveRadio', function (id, cb)
    local success = lib.callback.await('pure_radio:deleteFaveRadio', false, id)
    if not success then Notify('Failed to delete favourite radio!', 'error') cb(false) return end
    Notify('Successfully added radio to favourites list!', 'success')
    cb(true)
end)

RegisterNUICallback('fetchFavouriteRadios', function (_, cb)
    local radios = lib.callback.await('pure_radio:fetchRadios', false)
    cb(radios)
end)

RegisterNUICallback('addFaveRadio', function (_, cb)
    cb(1)
    if not RadioChannel or RadioChannel == 0 then
        Notify('You must connect to a radio before you can favourite it!', 'error')
        return
    end
    local radios, error = lib.callback.await('pure_radio:addFaveRadio', false, RadioChannel)
    if not radios then Notify(error, 'error') return end
    Notify('Successfully added radio to your favourites!', 'success')
    SendNUIMessage({
        action = 'setFaves',
        data = radios
    })
end)

RegisterNUICallback('setVolumne', function (data, cb)
    cb(1)
    if data >= 10 and data <= 95 then
        TriggerEvent('InteractSound_CL:PlayOnOne', 'radiooff', 0.2)
		RadioVolume = data
        Notify('Volume Updated: ' .. RadioVolume, 'success')
		exports['pma-voice']:setRadioVolume(RadioVolume)
	else
        Notify('The radio cannot exceed these values', 'error')
	end
end)

RegisterNUICallback('radioClicksNew', function (data, cb)
    cb(1)
    local text = data and 'un-muted!' or 'muted!'
    exports['pma-voice']:setVoiceProperty('micClicks', data)
    Notify('Radio Clicks ' .. text, 'success')
end)

local hasUiLoaded = false
function SetupUI()
    if (hasUiLoaded) then return end

    local data = {
        locales = GetLocale(),
        config = Config,
    }

    SendReactMessage('setInitData', data)
    hasUiLoaded = true

    -- local micClicks = exports['pma-voice']:getRadioClicks()
    -- SendNUIMessage({
    --     action = 'setClicks',
    --     data = {
    --         clicks = micClicks
    --     }
    -- })
end

RegisterNetEvent('pure_radio:sendRadios', function (data)
    SendNUIMessage({
        action = 'setFaves',
        data = data
    })
end)