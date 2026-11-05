-- String formats
local TEST_FAILURE_STRING_FORMAT = `\t%s: %s`

local TestSuite = {}
TestSuite.__index = TestSuite

export type TestResult = {
	passed: boolean,
	message: string,
}

type TestCase = {
	name: string,
	callback: () -> (),
}

function TestSuite.new(name: string)
	local self = {}
	local self = setmetatable(self, TestSuite)

	self.name = name
	self.tests = {}

	self.beforeEachCallback = nil
	self.afterEachCallback = nil

	return self
end

-- Registers a test case
function TestSuite:registerTest(
	name: string, 
	callback: () -> ()
) : nil
	table.insert(
		self.tests, 
		{
			name = name,
			callback = callback,
		}
	)
end

-- Registers a setup callback
function TestSuite:registerBeforeEach(callback: () -> ()) : nil
	self.beforeEachCallback = callback
end

-- Registers a cleanup callback
function TestSuite:registerAfterEach(callback: () -> ()) : nil
	self.afterEachCallback = callback
end

-- Executes all tests in the suite
function TestSuite:run() : {[string]: TestResult}
	local results: {[string]: TestResult} = {}

	for _, testCase in self.tests do
		local passed = true
		local messages = {}

		-- Setup
		if self.beforeEachCallback then
			local success, err = pcall(self.beforeEachCallback)

			if not success then
				passed = false
				table.insert(
					messages, 
					string.format(TEST_FAILURE_STRING_FORMAT, "Before each", tostring(err))
				)
			end
		end

		-- Execute test only if setup succeeded
		if passed then
			local success, err = pcall(testCase.callback)

			if not success then
				passed = false
				table.insert(
					messages, 
					string.format(TEST_FAILURE_STRING_FORMAT, "Test result", tostring(err))
				)
			end
		end

		-- Always attempt cleanup
		if self.afterEachCallback then
			local success, err = pcall(self.afterEachCallback)

			if not success then
				passed = false
				table.insert(
					messages, 
					string.format(TEST_FAILURE_STRING_FORMAT, "After each", tostring(err))
				)
			end
		end

		results[testCase.name] = {
			passed = passed,
			message = if passed then "Passed"
				else table.concat(messages, "\n"),
		}
	end

	return results
end

return TestSuite