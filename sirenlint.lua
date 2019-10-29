#!lua

local files = {}
for k, v in ipairs(arg) do
	if k > 0 then
		table.insert(files, v)
	end
end

if #files == 0 then
	print("No files to lint!")
	os.exit(1)
end

dofile("shared.lua")

EMVU = {}
function EMVU.AddCustomSiren(name, data)
	print(Format("Checking %s.", name))

	local id = 0
	local tprint = function(...) return print("\t", ...) end
	local test = function(desc, test)
		id = id + 1
		print(Format("\tTest #%d: %s", id, desc))

		if test then
			print("\t\tPassed.")
		else
			print("\t\tFailed!")
			os.exit(1)
		end
	end

	test("IDs must be non-numeric.", tonumber(name) == nil)
	test("Must have a name.", isstring(data.Name))
	test("Must have a category.", isstring(data.Category))
	test("Must have siren set.", istable(data.Set))

	for idx, set in pairs(data.Set) do
		test(Format("Set #%d - Must have name.", idx), isstring(set.Name))
		test(Format("Set #%d - Must have sound.", idx), isstring(set.Sound))
		test(Format("Set #%d - Must have icon.", idx), isstring(set.Icon))
	end

	test("May have horn", not data.Horn or isstring(data.Horn))
end

for _, file in ipairs(files) do
	dofile(file)
end