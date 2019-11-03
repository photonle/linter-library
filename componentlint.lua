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
            for bgid, bgval in ipairs(data.Bodygroups) do
                self:AssertIsNumeric(bgid, self:_assertMessage(
                    string.format("bodygroup key ('%s')", tostring(bgid)),
                    "is numeric"
                ))
                self:AssertIsNumeric(bgval, self:_assertMessage(
                    string.format("bodygroup value ('%s')", tostring(bgid)),
                    "is numeric"
                ))
            end
        end
    end

    runner:Test()
    table.insert(self.stored, runner)
end

for _, file in ipairs(files) do
    dofile(file)
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

local count = #failed
local tests = succeeded + #failed
local sirens = #EMVU.stored
print(string.format(
        "Stats:\n\tComponents Checked: %d\n\tTests Ran: %d\n\tTests Succeeded: %d\n\tTests Failed: %d\n\tAssertions: %d",
        sirens, tests, succeeded, count, asserts
))
for _, msg in ipairs(failed) do
    print(msg)
end

os.exit(math.min(count, 1))