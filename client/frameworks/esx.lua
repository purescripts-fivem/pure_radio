if Config.framework ~= 'esx' then return end

local ESX = nil

CreateThread(function()
    -- wait until es_extended is started
    while GetResourceState('es_extended') ~= 'started' do
        Wait(250)
    end

    -- grab shared object
    local ok, obj = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)

    if ok and obj then
        ESX = obj
    else
        -- fallback old ESX
        TriggerEvent('esx:getSharedObject', function(o)
            ESX = o
        end)
    end

    while ESX == nil do
        Wait(250)
    end

    -- wait for PlayerData to exist
    while ESX.PlayerData == nil or ESX.PlayerData.job == nil do
        Wait(250)
    end
end)

local function EnsureESX()
    return ESX ~= nil and ESX.PlayerData ~= nil
end

function ConnectToRadio(channel)
    exports['pma-voice']:setRadioChannel(channel)
end

function GetPlayerJob()
    if not EnsureESX() then return false end
    return ESX.PlayerData.job.name
end