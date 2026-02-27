if Config.framework ~= 'qbox' then return end

function GetPlayerCharId(playerId)
    local player = exports.qbx_core:GetPlayer(playerId)
    if not player then return end
    local charId = player.PlayerData.citizenid
    return charId
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    Wait(3000)
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end
    LoadCharacter(player.PlayerData.citizenid)
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