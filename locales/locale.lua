Locales = {}

function GetLocale()
    local lang = Config.language
    if not Locales[lang] then
        lang = 'en'
    end
    return Locales[lang]
end

function _Lang(key)
    local locale = GetLocale()
    local value = locale[key]
    if not value then return print('ERROR: Missing locale for: ', key) end
    return value
end