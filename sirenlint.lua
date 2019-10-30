#!lua

require("lib/shared")

EMVU = {stored = {}}
function EMVU.AddCustomSiren(name, data)
	local runner = RUNNER:New()
	runner.name = name:Replace(" ", "_")

	function runner:testID()
		self:AssertIsNotNumeric(name)
		self:AssertIsNonEmptyString(name)
	end

	function runner:testName()
		self:AssertIsNonEmptyString(data.Name)
	end

	function runner:testCategory()
		self:AssertIsNonEmptyString(data.Category)
	end

	function runner:testSirenSet()
		self:AssertIsTable(data.Set)
		self:AssertIsNotEmpty(data.Set)
	end

	if istable(data.Set) then
		for id, siren in ipairs(data.Set) do
			local tid = "testSirenSet" .. id

			runner[tid .. "Name"] = function(self)
				self:AssertIsNonEmptyString(siren.Name)
			end

			runner[tid .. "Sound"] = function(self)
				self:AssertIsNonEmptyString(siren.Sound)
			end

			runner[tid .. "Icon"] = function(self)
				self:AssertIsNilOrString(siren.Icon)
				if isstring(siren.Icon) then
					self:AssertIsNonEmptyString(siren.Icon)
				end
			end
		end
	end

	function runner:testHorn()
		self:AssertIsNilOrString(data.Horn)
	end

	function runner:testManual()
		self:AssertIsNilOrString(data.Manual)
	end

	runner:Test()
	table.insert(EMVU.stored, runner)
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
	"Stats:\n\tSirens Checked: %d\n\tTests Ran: %d\n\tTests Succeeded: %d\n\tTests Failed: %d\n\tAssertions: %d",
	sirens, tests, succeeded, count, asserts
))
for _, msg in ipairs(failed) do
	print(msg)
end

os.exit(math.min(count, 1))