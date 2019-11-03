TEST = {}

function TEST:New()
	return setmetatable({
		success = false,
		message = "",

		errored = false,
		error = "",

		assertions = 0,
		name = "Test"
	}, TEST)
end

function TEST:Run()
end

function TEST:Assert(assertion, message)
	if isnil(message) then message = "Assertion failed." end

	self.assertions = self.assertions + 1
	if not assertion then
		self.success = false
		self.message = message
		error("break")
	end
end

function TEST:_assertMessage(value, failure)
	return string.format("Failed to assert that '%s' is %s", tostring(value), failure)
end

function TEST:Test()
	print(string.format("Test %s %s", self.name, "started"))
	local suc, msg = pcall(self.Run, self)
	self.success = suc

	if not suc then
		if msg:find("break$") then
			print(string.format("Test %s %s: %s", self.name, "failed", self.message))
		else
			self.errored = true
			self.error = msg
			print(string.format("Test %s %s: %s", self.name, "errored", self.error))
		end
	elseif self.assertions == 0 then
		print(string.format("Test %s %s, performed no assertions.", self.name, "succeeded riskily"))
	else
		print(string.format("Test %s %s, performed %d %s.", self.name, "succeeded", self.assertions, self.assertions == 1 and "assertion" or "assertions"))
	end
end

TEST.__index = TEST

function setupAssertion(failure, vMod)
	return function(self, value, message)
		if isnil(message) then
			message = self:_assertMessage(value, failure)
		end

		return self:Assert(vMod(value), message)
	end
end

function phraseToID(identifier)
	local s, e = identifier:find("[%s-](%l)")
	while s and e do
		identifier =
			string.sub(identifier, 1, s) ..
			string.upper(string.sub(identifier, e, e)) ..
			string.sub(identifier, e + 1)
		s, e = identifier:find("[%s-](%l)")
	end

	s, e = identifier:find("%s")
	while s and e do
		identifier =
			string.sub(identifier, 1, s - 1) ..
			string.sub(identifier, e + 1)
		s, e = identifier:find("[%s-]")
	end

	s, e = identifier:find("^(%l)")
	if s then
		identifier =
			string.upper(string.sub(identifier, e, e)) ..
			string.sub(identifier, e + 1)
	end
	return identifier
end

function setupDual(onto, failure, func)
	local identifier = phraseToID(failure)
	onto["AssertIs" .. identifier] = setupAssertion(failure, func)
	onto["AssertIsNot" .. identifier] = setupAssertion(
	"not " .. failure,
	function(v) return not func(v) end
	)
end

local setup = curry(setupDual, TEST)
setup("true", function(v) return v == true end)
setup("false", function(v) return v == false end)
setup("truthy", function(v) return v end)
setup("nil", isnil)
setup("numeric", isnumeric)
setup("number", isnumber)
setup("function", isfunction)
setup("table", istable)
setup("string", isstring)
setup("empty", function(v) return isnil(v) or #v == 0 end)
setup("non-empty string", function(v) return not isnil(v) and isstring(v) and #v > 0 end)
setup("nil or string", function(v) return isnil(v) or isstring(v) end)