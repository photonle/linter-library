--[[-- Garry's Mod Lua Library / Workarounds / Functions.
@author John Internet
@copyright Photon Lighting Engine 2019
@license MIT
--]]--

--- Format is a shorthand for string.format
--- @string str Input string to format.
--- @see string.format
--- @treturn string
Format = string.format

--- Empty function to mimic its GLua counterpart.
function AddCSLuaFile() end

--- Create a 3d vector table.
--- @number x
--- @number y
--- @number z
--- @treturn Vector
function Vector(x, y, z)
    return {x = x, y = y, z = z}
end

--- Create a 3d angle.
--- @number p
--- @number y
--- @number r
--- @treturn Angle
function Angle(p, y, r)
    return {p = p, y = y, r = r}
end

function string.ToTable( str )
    local tbl = {}

    for i = 1, string.len( str ) do
        tbl[i] = string.sub( str, i, i )
    end

    return tbl
end

local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function string.Explode(separator, str, withpattern)
    if ( separator == "" ) then return totable( str ) end
    if ( withpattern == nil ) then withpattern = false end

    local ret = {}
    local current_pos = 1

    for i = 1, string_len( str ) do
        local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
        if ( not start_pos ) then break end
        ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
    current_pos = end_pos + 1
    end

    ret[ #ret + 1 ] = string_sub( str, current_pos )

    return ret
end

function string.Replace( str, tofind, toreplace )
    local tbl = string.Explode( tofind, str )
    if ( tbl[ 1 ] ) then return table.concat( tbl, toreplace ) end
    return str
end

--- Copied from Garry's Mod GitHub.
-- Adaptations by Internet.
-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L24
-- @tab t Table to copy from.
-- @tab lookup_table Lookup array of already copied tables.
function table.Copy(t, lookup_table)
    if t == nil then return nil end
    lookup_table = lookup_table or {}

    local copy = setmetatable({}, getmetatable(t))
    for k, v in pairs(t) do
        if istable(v) then
            lookup_table[t] = copy
            copy[k] = lookup_table[v] or table.Copy(v, lookup_table)
        else
            copy[k] = v
        end
    end
    return copy
end

local strsub = string.sub
local strlen = string.len

--- Check if a string starts with another string.
-- @see https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L301
-- @string str String to check.
-- @string start Substring to check against.
-- @treturn boolean If str begins with start.
function string.StartWith(str, start)
    return strsub(str, 1, strlen(start)) == start
end

--- Check if a string ends with another string.
-- @see https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/string.lua#L307
-- @string str String to check.
-- @string start Substring to check against.
-- @treturn boolean If str begins with start.
function string.EndsWith(str, ends)
    return ends == "" or sub(str, -len(ends)) == ends
end

--- Add the contents of two tables together.
-- @see https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L112
-- @table dest Destination table.
-- @table source Source table.
-- @treturn table Combined table.
function table.Add(dest, source)
	if not istable(source) then return dest end
	if not istable(dest) then dest = {} end

	for k, v in pairs(source) do
		table.insert(dest, v)
	end

	return dest
end