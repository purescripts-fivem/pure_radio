function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function isEmpty(t)
    if type(t) ~= "table" then return true end
    for _ in pairs(t) do
    return false
    end
    return true
end

function ServerNuiCallback(event)
    RegisterNUICallback(event, function (data, cb)
        local response = lib.callback.await(('mdt:%s'):format(event), false, data)
        if (type(response) == "table" and isEmpty(response)) then cb(EmptyArray()) return end
        cb(response)
    end)
end
RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
end)