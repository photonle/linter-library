function curry(func, ...)
    local args = {...}
    local cArgs = #args

    return function(...)
        local m = select('#', ...)
        for i = 1, m do
            args[cArgs + i] = select(i, ...)
        end
        return func(unpack(args, 1, cArgs + m))
    end
end