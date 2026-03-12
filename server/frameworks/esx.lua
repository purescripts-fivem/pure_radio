if Config.framework ~= 'esx' then return end

local ESX = nil

-- ESX init (ESX Legacy / modern ESX)
CreateThread(function()
    -- Wait for es_extended to start
    while GetResourceState('es_extended') ~= 'started' do
        Wait(250)
    end

    -- Preferred: exports
    local ok, obj = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)

    if ok and obj then
        ESX = obj
    else
        -- Fallback (older ESX)
        TriggerEvent('esx:getSharedObject', function(obj2)
            ESX = obj2
        end)
    end

    -- Wait until ESX is actually set
    while ESX == nil do
        Wait(250)
    end
end)

local function EnsureESX()
    if ESX == nil then
        print('[pure_mdt] ESX is nil - es_extended not loaded yet? Check your resource order.')
        return false
    end
    return true
end

function GetPlayerCharId(playerId)
    if not EnsureESX() then return nil end
    local player = ESX.GetPlayerFromId(playerId)
    if not player then return nil end
    -- In ESX Legacy it’s .identifier, in some forks it’s getIdentifier()
    return player.getIdentifier and player.getIdentifier() or player.identifier
end

RegisterNetEvent('esx:playerLoaded', function(source)
    local src = source
    local player = GetPlayerCharId(src)
    if not player then return end
    LoadCharacter(src, player.PlayerData.citizenid)
end)

RegisterNetEvent('esx:playerLogout', function(source)
    RemoveCharacter(source)
end)
