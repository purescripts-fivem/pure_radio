RadioMenu = false
local onRadio = false
local radioProp = nil
RadioChannel = 0

local function loadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

function ConnectRadio(channel)
    RadioChannel = channel
    -- if onRadio then
    --     exports['voip']:setRadioChannel(0)
    -- else
    --     onRadio = true
    --     exports['voip']:setVoiceProperty('radioEnabled', true)
    -- end
    -- exports['voip']:setRadioChannel(channel)
    Notify('You\'re connected to: ' .. channel .. ' MHz', 'success')
end

function LeaveRadio()
    TriggerEvent('InteractSound_CL:PlayOnOne', 'click', 0.6)
    RadioChannel = 0
    onRadio = false
    -- exports['voip']:setRadioChannel(0)
    -- exports['voip']:setVoiceProperty('radioEnabled', false)
    Notify('You left the channel.' , 'error')
end

local function toggleRadioAnimation(pState)
	loadAnimDic('cellphone@')
	if pState then
		TriggerEvent('attachItemRadio','radio01')
		TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_text_read_base', 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_text_read_base', 1.0)
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

function ToggleRadio(toggle)
    RadioMenu = toggle
    SetNuiFocus(RadioMenu, RadioMenu)
    if RadioMenu then
        toggleRadioAnimation(true)
        SendNUIMessage({
            action = 'setVisible',
            data = calculateTimeToDisplay()
        })
    else
        toggleRadioAnimation(false)
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
    end
end

RegisterNUICallback('escape', function(_, cb)
    ToggleRadio(false)
    cb('ok')
end)