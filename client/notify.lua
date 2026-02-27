function Notify(text, success)
    print('Notif: ', text, success)
    return lib.notify({
        type = success,
        title = text,
    })
end