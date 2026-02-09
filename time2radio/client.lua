local Framework = exports.framework:GetObject()
local PlayerData = Framework.Character:Get() -- Just for resource restart (same as event handler)
local radioMenu = false
local onRadio = false
local RadioChannel = 0
local RadioVolume = 50
local hasRadio = false
local radioProp = nil

--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["voip"]:setRadioChannel(0)
    else
        onRadio = true
        exports["voip"]:setVoiceProperty("radioEnabled", true)
    end
    exports["voip"]:setRadioChannel(channel)
    TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. channel .. '`', false)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        TriggerEvent('notification', 'You\'re connected to: ' .. channel .. ' MHz', 'success')
    else
        TriggerEvent('notification', 'You\'re connected to: ' .. channel .. '.00 MHz', 'success')
    end
end

exports('ConnectRadioBlaze', connecttoradio)

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    RadioChannel = 0
    onRadio = false
    exports["voip"]:setRadioChannel(0)
    exports["voip"]:setVoiceProperty("radioEnabled", false)
    TriggerEvent('notification', 'You left the channel.' , 'error')
end

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local function calculateTimeToDisplay()
    local hour = tonumber(GlobalState.currentTime.hour)
    local minute = tonumber(GlobalState.currentTime.minute)
    if not hour or not minute then return end

    if minute < 10 then
        minute = string.format('0%s', tostring(minute))
    end

    return string.format('%s:%s', hour, minute)
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    print('toggle radio', toggle)
    if radioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({
            action = 'setVisible',
            data = calculateTimeToDisplay()
        })
    else
        toggleRadioAnimation(false)
        -- SendNUIMessage({type = "close"})
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
    end
end

local function IsRadioOn()
    return onRadio
end

local function DoRadioCheck(PlayerItems)
    local _hasRadio = false

    for _, item in pairs(PlayerItems) do
        if item.name == "radio" then
            _hasRadio = true
            break;
        end
    end

    hasRadio = _hasRadio
end

--Exports
exports("IsRadioOn", IsRadioOn)

--Events

-- Handles state right when the player selects their character and location.
RegisterNetEvent('framework:characterLoaded', function(character)
    PlayerData = Framework.Character:Get()
end)

-- Resets state on logout, in case of character change.
RegisterNetEvent('framework:characterUnloaded', function()
    PlayerData = {}
    leaveradio()
end)

-- Handles state if resource is restarted live.
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        PlayerData = Framework.Character:Get()
    end
end)

RegisterNetEvent('radio:use', function()
    local radio = exports.inventory:GetItemCount('radio')
    if radio > 0 then
        toggleRadio(not radioMenu)
    else
        TriggerEvent('notification', 'You do not have a radio on you.', 'error')
    end
end)

RegisterCommand('radio:use', function()
    local radio = exports.inventory:GetItemCount('radio')
    if radio > 0 then
        if LocalPlayer.state.isDead then
            TriggerEvent('notification', 'You cannot use a radio while dead.', 'error')
            return
        end

        toggleRadio(not radioMenu)
    else
        TriggerEvent('notification', 'You do not have a radio on you.', 'error')
    end
end, false)

RegisterKeyMapping('radio:use', 'OpenRadio', 'keyboard', 'j')

RegisterNetEvent('radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

RegisterNUICallback('radios:setFaveRadio', function (_, cb)
  if not RadioChannel or RadioChannel == 0 then
    TriggerEvent('notification', 'You must connect to a radio before you can favourite it!', 'error')
    return
  end
  
  local data, err = lib.callback.await("radios:addFavourite", false, RadioChannel)
  if err ~= nil then
    TriggerEvent("notification", err, "error")
    return
  end
  
  TriggerEvent("notification", "Successfully added radio to your favourites!", "success")
  SendNUIMessage({ action = 'setFaves', data = data.radios})
  cb(1)
end)

RegisterNuiCallback("fetchFavouriteRadios", function(_, cb)
  local radios, err = lib.callback.await("radios:fetchFavouriteRadios", false)
  if err ~= nil then
    cb({ok = false, radios = nil})
    return
  end

  cb({ ok = true, radios = radios})
end)

RegisterNUICallback('deleteRadio', function (id, cb)
  local success, err = lib.callback.await("radios:deleteFavouriteRadio", false, id)
  if err ~= nil then
    TriggerEvent("notification", "Failed to delete favourite radio!", "error")
    cb({ok = false})
    return
  end

  TriggerEvent("notification", "Successfully added radio to favourites list!", "error")
  cb({ok = true})
end)

local function joinRadioCallback(rchannel)
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if rchannel ~= RadioChannel then
                if Config.RestrictedChannels[rchannel] ~= nil then
                    if Config.RestrictedChannels[rchannel][ReturnJob()] then
                        connecttoradio(rchannel)
                    else
                        TriggerEvent('notification', 'You can not connect to this signal!', 'error')
                    end
                else
                    connecttoradio(rchannel)
                end
            else
                TriggerEvent('notification', 'You\'re already connected to this channel' , 'error')
            end
        else
            TriggerEvent('notification', 'This frequency is not available.' , 'error')
        end
    else
        TriggerEvent('notification', 'This frequency is not available.' , 'error')
    end
end

RegisterNUICallback('joinFaveRadio', function (data, cb)
    cb(1)
    SendNUIMessage({
        action = 'setRadio',
        data = data
    })
    joinRadioCallback(tonumber(data))
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local rchannel = tonumber(data)
    joinRadioCallback(rchannel)
    cb("ok")
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    if RadioChannel == 0 then
        TriggerEvent('notification', 'You\'re not connected to a signal', 'error')
    else
        leaveradio()
    end
    cb("ok")
end)

RegisterNUICallback("volumeUp", function(_, cb)
	if RadioVolume <= 95 then
        TriggerEvent("InteractSound_CL:PlayOnOne", "radiooff", 0.2)
		RadioVolume = RadioVolume + 5
		TriggerEvent('notification', 'Volume Updated: ' .. RadioVolume, "success")
		exports["voip"]:setRadioVolume(RadioVolume)
	else
		TriggerEvent('notification', 'The radio is already set to maximum volume', "error")
	end
    cb('ok')
end)

RegisterNUICallback("volumeDown", function(_, cb)
	if RadioVolume >= 10 then
        TriggerEvent("InteractSound_CL:PlayOnOne", "radiooff", 0.2)
		RadioVolume = RadioVolume - 5
		TriggerEvent('notification', 'Volume Updated: ' .. RadioVolume, "success")
		exports["voip"]:setRadioVolume(RadioVolume)
	else
		TriggerEvent('notification', 'The radio is already set to the lowest volume', "error")
	end
    cb('ok')
end)

RegisterNUICallback('setVolumne', function (data, cb)
    cb(1)
    if data >= 10 and data <= 95 then
        TriggerEvent("InteractSound_CL:PlayOnOne", "radiooff", 0.2)
		RadioVolume = data
		TriggerEvent('notification', 'Volume Updated: ' .. RadioVolume, "success")
		exports["voip"]:setRadioVolume(RadioVolume)
	else
		TriggerEvent('notification', 'The radio cannot exceed these values', "error")
	end
end)

RegisterNUICallback("increaseradiochannel", function(_, cb)
    local newChannel = RadioChannel + 1
    if Config.RestrictedChannels[newChannel] ~= nil then
        if Config.RestrictedChannels[newChannel][ReturnJob()]  then
            connecttoradio(newChannel)
            TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
        else
            TriggerEvent('notification', 'You can not connect to this signal!', 'error')
        end
    else
        connecttoradio(newChannel)
        TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
    end
    cb("ok")
end)

RegisterNUICallback("decreaseradiochannel", function(_, cb)
    if not onRadio then return end
    local newChannel = RadioChannel - 1
    if newChannel >= 1 then 
        if Config.RestrictedChannels[newChannel] ~= nil then
            if Config.RestrictedChannels[newChannel][ReturnJob()] then
                connecttoradio(newChannel)
                TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
            else
                TriggerEvent('notification', 'You can not connect to this signal!', 'error')
            end
        else
            connecttoradio(newChannel)
            TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
        end
    end
end)

RegisterNUICallback('radioClicks', function(_, cb)
    local micClicks = exports['voip']:getRadioClicks()

    if micClicks == 'true' then
        exports['voip']:setVoiceProperty('micClicks', false)
        TriggerEvent('notification', 'Radio Clicks muted!', 'error')
    elseif micClicks == 'false' then
        exports['voip']:setVoiceProperty('micClicks', true)
        TriggerEvent('notification', 'Radio Clicks un-muted!', 'success')
    end

    cb("ok")
end)

RegisterNUICallback('radioClicksNew', function (data, cb)
    cb(1)
    local text = data and 'un-muted!' or 'muted!'
    exports['voip']:setVoiceProperty('micClicks', data)
    TriggerEvent('notification', 'Radio Clicks ' .. text, 'success')
end)

RegisterNetEvent('framework:characterLoaded', function (data)
    Wait(1000)
    local micClicks = exports['voip']:getRadioClicks()

    -- TODO: fave
    SendNUIMessage({
        action = 'initData',
        data = {
            clicks = micClicks
        }
    })
end)

RegisterNUICallback('poweredOff', function(_, cb)
    leaveradio()
    cb("ok")
end)

RegisterNUICallback('escape', function(_, cb)
    toggleRadio(false)
    cb("ok")
end)

RegisterCommand('+increaseRadioChannel', function()
    local hasRadio = exports.inventory:GetItemCount('radio')
    if hasRadio < 0 then return end
    
    local newChannel = RadioChannel + 1
    if newChannel > 999 then newChannel = 999 end

    if Config.RestrictedChannels[newChannel] ~= nil then
        if Config.RestrictedChannels[newChannel][ReturnJob()] then
            connecttoradio(newChannel)
            TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
        else
            TriggerEvent('notification', 'You can not connect to this signal!', 'error')
        end
    else
        connecttoradio(newChannel)
        TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
    end
end)
RegisterKeyMapping('+increaseRadioChannel', 'Increase Radio Freq', 'keyboard', 'F5')

RegisterCommand('+decreaseRadioChannel', function()
    local hasRadio = exports.inventory:GetItemCount('radio')
    if hasRadio < 0 then return end

    local newChannel = RadioChannel - 1
    if newChannel < 1 then newChannel = 1 end

    if Config.RestrictedChannels[newChannel] ~= nil then
        if Config.RestrictedChannels[newChannel][ReturnJob()] then
            connecttoradio(newChannel)
            TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
        else
            TriggerEvent('notification', 'You can not connect to this signal!', 'error')
        end
    else
        connecttoradio(newChannel)
        TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. newChannel .. '`', false)
    end
end)
RegisterKeyMapping('+decreaseRadioChannel', 'Decrease Radio Freq', 'keyboard', 'F6')

function ChangeChannel(channel)
    if channel > 999 then channel = 999 end

    if Config.RestrictedChannels[channel] ~= nil then
        if Config.RestrictedChannels[channel][ReturnJob()] then
            connecttoradio(channel)
            TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. channel .. '`', false)
        else
            TriggerEvent('notification', 'You can not connect to this signal!', 'error')
        end
    else
        connecttoradio(channel)
        TriggerServerEvent("logs:server:createlog", "radiologs", "Radio Logs", "red", "Steam Name: **".. GetPlayerName(PlayerId()) .. "**\n**New Channel:** `".. channel .. '`', false)
    end
end

exports('ChangeChannel', ChangeChannel)

function CheckJob(job)
    if LocalPlayer.state.isLoggedIn then
        local jobs = exports['phone']:GetPlayerJobs()

        for i = 1, #jobs do 
           if jobs[i].name == job then return true end
        end
		return false
    end
end

-- function ReturnJob()
--     if LocalPlayer.state.isLoggedIn then
--         local jobs = exports.clothing:getPlayerJobs()
        

--         return jobs[1]
--     end
-- end

function ReturnJob()
    if LocalPlayer.state.isLoggedIn then
        local jobs = exports['phone']:GetPlayerJobs()       

        return jobs[1].name
    end
end

--Main Thread
CreateThread(function()
    while true do
        Wait(2500)
        if onRadio then
            local hasRadio = exports.inventory:GetItemCount('radio')

            if hasRadio < 1 then
                leaveradio()
                return
            end

            if LocalPlayer.state.isDead then
                if RadioChannel ~= 0 then
                    exports['voip']:setRadioVolume(15.0)
                end
            end
        end
    end
end)
