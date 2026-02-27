if Config.framework ~= 'qbcore' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerCharId(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if not player then return end
    local charId = player.PlayerData.citizenid
    return charId
end