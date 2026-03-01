if Config.framework ~= 'qbcore' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function ConnectToRadio(channel)
    exports['pma-voice']:setRadioChannel(channel)
end

function GetPlayerJob()
    return QBCore.Functions.GetPlayerData().data.job.name
end