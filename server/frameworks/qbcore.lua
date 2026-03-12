if Config.framework ~= 'qbcore' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function GetPlayerCharId(playerId)
    local player = QBCore.Functions.GetPlayer(playerId)
    if not player then return end
    local charId = player.PlayerData.citizenid
    return charId
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    Wait(3000)
    local player = GetPlayerCharId(src)
    if not player then return end
    LoadCharacter(src, player.PlayerData.citizenid)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function()
    local src = source
    RemoveCharacter(src)
end)

---@param source number
AddEventHandler('playerDropped', function()
    local src = source
    RemoveCharacter(src)
end)