function EmptyArray()
    return { [1] = nil }
end

function GetRandomNumberDP(min, max)
    local num = math.random() * (max - min + 1) + min
    return math.floor(num * 10 + 0.5) / 10
end