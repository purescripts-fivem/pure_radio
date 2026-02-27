local favouriteRadios = {}

function LoadCharacter(playerId, charId)
    local radios = MySQL.query.await('SELECT `id`, `radio` FROM `pure_radios_faves` WHERE charId = ?', {charId})
    if not radios then return end
    favouriteRadios[playerId] = radios
end

function RemoveCharacter(playerId)
    favouriteRadios[playerId] = nil
end

lib.callback.register('pure_radio:deleteFaveRadio', function (playerId, radio)
    local charId = GetPlayerCharId(playerId)
    if not charId then return end
    local currentRadios = favouriteRadios[playerId] or {}
    local index = 0
    for i = 1, #currentRadios do
        if (currentRadios[i].radio == radio) then
            index = i
        end
    end
    if (index == 0) then return end
    table.remove(currentRadios, index)
    MySQL.query.await('DELETE FROM `pure_radios_faves` WHERE id = ? AND charId = ?', {radio, charId})
end)

lib.callback.register('pure_radio:fetchRadios', function (playerId)
    return favouriteRadios[playerId] or {}
end)

lib.callback.register('pure_radio:addFaveRadio', function (playerId, radio)
    local charId = GetPlayerCharId(playerId)
    if not charId then return end
    local currentRadios = favouriteRadios[playerId] or {}

    for i = 1, #currentRadios do
        if (currentRadios[i].radio == radio) then
            return
        end
    end

    if (#currentRadios >= Config.maxFaves) then return end

    local id = MySQL.insert.await('INSERT INTO `pure_radios_faves` (`charId`, `radio`) VALUES (?, ?)', {charId, radio})
    currentRadios[#currentRadios+1] = {id = id, radio = radio}
    favouriteRadios[playerId] = currentRadios
    return favouriteRadios[playerId]
end)

CreateThread(function()
  Wait(250)
  for _, playerId in ipairs(GetPlayers()) do
    local charId = GetPlayerCharId(playerId)
    if not charId then
      goto skip__character
    end

    LoadCharacter(tonumber(playerId), charId)
    ::skip__character::
  end
end)
