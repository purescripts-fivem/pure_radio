RegisterNUICallback('joinRadio', function(data, cb)
    cb(1)
    local job = 'lspd'-- TODO
    CheckAndConnectRadioChannel(tonumber(data), job)
end)

RegisterNUICallback('joinFaveRadio', function (data, cb)
    cb(1)
    SendNUIMessage({
        action = 'setRadio',
        data = data
    })
    local job = 'lspd'-- TODO
    CheckAndConnectRadioChannel(tonumber(data), job)
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