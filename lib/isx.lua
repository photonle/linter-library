require("lib/functional")

function istype(rType, var) return type(var) == rType end

local function dt(rType)
    _G["is" .. rType] = curry(istype, rType)
end

dt("table")
dt("number")
dt("string")
dt("function")

isnumeric = function(val) return tonumber(val) ~= nil end
ishex = function(val) return tonumber(val, 16) ~= nil end
isnil = function(val) return val == nil end