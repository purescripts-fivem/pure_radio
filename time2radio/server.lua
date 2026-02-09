---@diagnostic disable: undefined-global
RegisterCommand('radio', function(source)
    TriggerClientEvent('radio:use', source)
end, false)

local favouriteRadios = {}

lib.callback.register("radios:fetchFavouriteRadios", function(source)
  local characterId = exports.framework:GetCharacterId(source)
  if not characterId then
    return nil, "Failed to favourite radio channel!"
  end

  local currentRadios = favouriteRadios[source] or {}
  return currentRadios, nil
end)

lib.callback.register("radios:addFavourite", function(source, radio)
  local characterId = exports.framework:GetCharacterId(source)
  if not characterId or type(radio) ~= "number" then
    return nil, "Failed to favourite radio channel!"
  end

  local currentRadios = favouriteRadios[source] or {}

  -- ensure that they're not attempting to favourite a radio that they already have favourited
  if lib.array.find(currentRadios, function(channel)
    return tonumber(channel.radio) == radio
  end, false) ~= nil then
    return nil, "You cannot favourite the same radio twice!"
  end

  if #currentRadios >= 6 then
    return nil, "You cannot favourite more than 6 radios"
  end

  local id = MySQL.insert.await([[
    INSERT IGNORE
    INTO `radios_faves` (`charId`, `radio`)
    VALUES(?, ?);
  ]], { characterId, radio })
  if not id then
    return nil, "Failed to favourite radio channel, please try again!"
  end

  currentRadios[#currentRadios + 1] = { radio = radio, id = id }
  favouriteRadios[source] = currentRadios
  return { radios = favouriteRadios[source] }, nil
end)

lib.callback.register("radios:deleteFavouriteRadio", function(source, id)
  local characterId = exports.framework:GetCharacterId(source)
  if not characterId or type(id) ~= "number" then
    return nil, "Failed to favourite radio channel!"
  end

  local currentRadios = favouriteRadios[source] or {}
  if lib.array.find(currentRadios, function(channel)
    return tonumber(channel.radio) == radio
  end, false) ~= nil then
    return nil, "You can't delete a radio that isn't favourited!"
  end

  MySQL.prepare.await([[
    DELETE
    FROM `radios_faves`
    WHERE `charId` = ? AND `id` = ?;
  ]], {characterId, id})
  favouriteRadios[source] = lib.array.filter(currentRadios, function(channel)
    return channel.id ~= id
  end)
end)

local function loadCharacter(source, characterId)
  local data = MySQL.query.await('SELECT `id`, `radio` FROM `radios_faves` WHERE `charId` = ?;', { characterId })
  if not data then 
    return
  end

  favouriteRadios[source] = data
end

RegisterNetEvent('framework:characterLoaded', function (source, data)
  local characterId = data.id
  loadCharacter(tonumber(source), characterId)
end)

RegisterNetEvent('framework:characterUnloaded', function (source)
  favouriteRadios[tonumber(source)] = nil
end)

CreateThread(function()
  Wait(250)
  for _, playerId in ipairs(GetPlayers()) do
    local characterId = exports.framework:GetCharacterId(tonumber(playerId))
    if not characterId then
      goto skip__character
    end

    loadCharacter(tonumber(playerId), characterId)
    ::skip__character::
  end
end)
