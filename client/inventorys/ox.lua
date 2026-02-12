if Config.inventory ~= 'ox' then return end

function CheckRadioItem()
    local hasRadio = exports.inventory:GetItemCount('radio')
    if hasRadio <= 0 then return end
    return true
end