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

EMVU = {stored = {}}
function EMVU:AddAutoComponent(data, name)
    local runner = RUNNER:New()
    runner.name = name:Replace(" ", "_")

    function runner:testName()
        self:AssertIsNotNumeric(name)
        self:AssertIsNonEmptyString(name)
    end

    function runner:testModel()
        self:AssertIsNilOrString(data.Model)
        if data.Model then
            self:AssertIsNonEmptyString(data.Model)
            self:AssertIsNotNumeric(data.Model)
            self:Assert(data.Model:sub(1, 7) == "models/", self:_assertMessage(data.Model, "in the models/ directory"))
        end
    end

    function runner:testSkin()
        self:AssertIsNilOrNumber(data.Skin)
    end

    function runner:testBodygroups()
        self:AssertIsNilOrTable(data.Bodygroups)
        if data.Bodygroups then
            for id, bgdata in ipairs(data.Bodygroups) do
                self:AssertIsTable(bgdata)

                local bgid, bgval = bgdata[1], bgdata[2]
                self:AssertIsNumeric(bgid, self:_assertMessage(
                    string.format("bodygroup key ('%s')", tostring(bgid)),
                    "numeric"
                ))
                self:AssertIsNumeric(bgval, self:_assertMessage(
                    string.format("bodygroup value ('%s')", tostring(bgid)),
                    "numeric"
                ))
            end
        end
    end

    function runner:testColorInput()
        self:AssertIsNilOrTable(data.DefaultColors)
        if data.DefaultColors then
            for id, color in pairs(data.DefaultColors) do
                self:AssertIsNumeric(id)
                self:AssertIsString(color)
            end
        end

        if data.Sections then
            for sectionID, sectionData in pairs(data.Sections) do
                for frameID, lights in ipairs(sectionData) do
                    for lightIdx, light in ipairs(lights) do
                        local lightID, col = unpack(light)
                        if col:StartWith("_") then
                            local colId = tonumber(col:sub(1))
                            self:AssertIsString(data.DefaultColors[colId], self:_assertMessage(string.format("default color ('%s' / %s)", col, colId), "string"))
                        end
                    end
                end
            end
        end
    end

    runner:Test()
    table.insert(self.stored, runner)
end

local badFiles = {}
for _, file in ipairs(files) do
    local success, msg = pcall(dofile, file)
    if not success then
        table.insert(badFiles, {file, msg})
    end
end

local failed = {}
local succeeded = 0
local asserts = 0
for _, runner in ipairs(EMVU.stored) do
    for _, test in ipairs(runner.tests) do
        if test.success then
            succeeded = succeeded + 1
            asserts = asserts + test.assertions
        else
            print(test)
            table.insert(failed, string.format(
                "Test %s :: [%s][%s]\n\t%s",
                test.errored and "Errored" or "Failed",
                runner.name,
                test.name,
                test.errored and test.error or test.message
            ))
        end
    end
end
for _, file in ipairs(badFiles) do
    print("Error whilst loading " .. file[1] .. "\n\t" .. file[2])
end

local count = #failed
local tests = succeeded + #failed
local sirens = #EMVU.stored
print(string.format(
        "Stats:\n\tFiles Failed: %d\n\tComponents Checked: %d\n\tTests Ran: %d\n\tTests Succeeded: %d\n\tTests Failed: %d\n\tAssertions: %d",
        #badFiles, sirens, tests, succeeded, count, asserts
))
for _, msg in ipairs(failed) do
    print(msg)
end

os.exit(math.min(count, 1))