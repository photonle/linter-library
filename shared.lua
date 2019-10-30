Format = string.format
function AddCSLuaFile() end
function Vector(x, y, z)
	return {x = x, y = y, z = z}
end
function Angle(p, y, r)
	return {p = p, y = y, r = r}
end

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
isnumber = curry(istype, "number")
isnumeric = function(val, base) return tonumber(val, base) ~= nil  end