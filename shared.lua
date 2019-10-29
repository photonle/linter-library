Format = string.format

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


function istype(rType, var) return type(var) == rType end
istable = curry(istype, "table")
isstring = curry(istype, "string")