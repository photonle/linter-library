RUNNER = {}

local id = 0
function RUNNER:New()
    id = id + 1
    return setmetatable({tests = {}, name = string.format("unnamed runner #%d", id)}, RUNNER)
end

function RUNNER:Test()
    for tid, tname in ipairs(self.tests) do
        self.tests[tid] = TEST:New()
        self.tests[tid].name = self.name .. "::" .. string.sub(tname, 5):Replace("_", " ")
        self.tests[tid].Run = self[tname]
        self.tests[tid]:Test()
    end
end

function RUNNER:IsSuccessful()
    for _, test in pairs(self.tests) do
        if not test.success then
            return false
        end
    end

    return true
end

RUNNER.__index = RUNNER
RUNNER.__newindex = function(self, key, value)
    rawset(self, key, value)
    if isstring(key) and string.sub(key, 1, 4):lower() == "test" then
        table.insert(self.tests, key)
    end
end