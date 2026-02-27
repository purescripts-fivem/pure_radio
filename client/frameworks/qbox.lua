if Config.framework ~= 'qbox' then return end

function ConnectToRadio(channel)
    exports['pma-voice']:setRadioChannel(channel)
end

function GetPlayerJob()
    return QBX.PlayerData.job.name
end