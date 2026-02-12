lib.callback.register('pure_radio:deleteFaveRadio', function (playerId, id)
    -- local characterId = exports.framework:GetCharacterId(source)
    -- if not characterId or type(id) ~= "number" then
    -- return nil, "Failed to favourite radio channel!"
    -- end

    -- local currentRadios = favouriteRadios[source] or {}
    -- if lib.array.find(currentRadios, function(channel)
    -- return tonumber(channel.radio) == radio
    -- end, false) ~= nil then
    -- return nil, "You can't delete a radio that isn't favourited!"
    -- end

    -- MySQL.prepare.await([[
    -- DELETE
    -- FROM `radios_faves`
    -- WHERE `charId` = ? AND `id` = ?;
    -- ]], {characterId, id})
    -- favouriteRadios[source] = lib.array.filter(currentRadios, function(channel)
    -- return channel.id ~= id
    -- end)
end)

lib.callback.register('pure_radio:fetchRadios', function (playerId)
    return false
end)

lib.callback.register('pure_radio:addFaveRadio', function (playerId, id)
    -- local characterId = exports.framework:GetCharacterId(source)
    -- if not characterId or type(radio) ~= "number" then
    -- return nil, "Failed to favourite radio channel!"
    -- end

    -- local currentRadios = favouriteRadios[source] or {}

    -- -- ensure that they're not attempting to favourite a radio that they already have favourited
    -- if lib.array.find(currentRadios, function(channel)
    -- return tonumber(channel.radio) == radio
    -- end, false) ~= nil then
    -- return nil, "You cannot favourite the same radio twice!"
    -- end

    -- if #currentRadios >= 6 then
    -- return nil, "You cannot favourite more than 6 radios"
    -- end

    -- local id = MySQL.insert.await([[
    -- INSERT IGNORE
    -- INTO `radios_faves` (`charId`, `radio`)
    -- VALUES(?, ?);
    -- ]], { characterId, radio })
    -- if not id then
    -- return nil, "Failed to favourite radio channel, please try again!"
    -- end

    -- currentRadios[#currentRadios + 1] = { radio = radio, id = id }
    -- favouriteRadios[source] = currentRadios
    -- return { radios = favouriteRadios[source] }, nil
end)