function Notify(text, success)
    return lib.Notify({
        type = success,
        title = text,
    })
end