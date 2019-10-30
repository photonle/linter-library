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

require("lib/shared")

EMVU = {}
function EMVU:AddAutoComponent(data, name)
    print(Format("Checking %s.", name))

    local id = 0
    local test = function(desc, bool)
        id = id + 1
        print(Format("\tTest #%d: %s", id, desc))

        if bool then
            print("\t\tPassed.")
        else
            print("\t\tFailed!")
            os.exit(1)
        end
    end

    test("Name must be present.", name)
    test("Name must be a string.", isstring(name))
    test("Name must be non-numeric.", tonumber(name) == nil)

    test("Model must NOT be present OR be string", data.Model == nil or isstring(data.Model))
    test("Skin must NOT be present OR be number", data.Skin == nil or isnumber(data.Skin))

    test("Bodygroups must NOT be present OR be table", data.Bodygroups == nil or istable(data.Bodygroups))
    if data.Bodygroups then
        for bgid, bgval in ipairs(data.Bodygroups) do
            test("Bodygroup key must be numeric.", isnumber(bgid))
            test("Bodygroup value must be numeric.", isnumber(bgval))
        end
    end
end

for _, file in ipairs(files) do
    dofile(file)
end