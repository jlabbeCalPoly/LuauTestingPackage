-- Folders
local TestingPackage = script.Parent
local Tests = TestingPackage.Tests

-- Modules
local TestSuite = require(TestingPackage.TestSuite)

-- String formats
local INVALID_TEST_FILE_STRING_FORMAT = 'Expected a ModuleScript to test %s, but got a %s'
local TEST_SUITE_STRING_FORMAT = 'Results for %s'
local TEST_PASS_STRING_FORMAT = '[PASS] %s'
local TEST_FAIL_STRING_FORMAT = '[FAIL] %s\n%s'
local OVERALL_TEST_RESULTS_STRING_FORMAT = '%s %d/%d tests'

local TestRunner = {}

local function printTestSummary(passed : numbe, failed : number)
	local totalTests = passed + failed
	local printType = if failed == 0 then print else warn

	printType(string.format(TEST_SUITE_STRING_FORMAT, "all tests"))
	printType(string.format(OVERALL_TEST_RESULTS_STRING_FORMAT, "Passed", passed, totalTests))
	printType(string.format(OVERALL_TEST_RESULTS_STRING_FORMAT, "Failed", failed, totalTests))
end

local function printTestResults(results : {[string] : {[string] : TestSuite.TestResult}})
	local passed = 0
	local failed = 0
	
	for testSuiteName, testSuiteResults in pairs(results) do
		print(string.format(TEST_SUITE_STRING_FORMAT, testSuiteName))
		
		for testName, testResult in pairs(testSuiteResults) do
			if testResult.passed then
				print(string.format(TEST_PASS_STRING_FORMAT, testName))
				passed += 1
			else
				warn(string.format(TEST_FAIL_STRING_FORMAT, testName, testResult.message))
				failed += 1
			end
		end
		
		print("\n")
	end
	
	printTestSummary(passed, failed)
end

function TestRunner.run()
	local results : {[string] : {[string] : TestSuite.TestResult}} = {}
	
	for _, module : ModuleScript in pairs(Tests:GetChildren()) do
		if not module:IsA("ModuleScript") then
			error(string.format(
				INVALID_TEST_FILE_STRING_FORMAT), 
				module.Name, 
				module.ClassName
			)
		end
		
		local testSuite = require(module)
		results[module.Name] = testSuite:run()
	end
	
	printTestResults(results)
end

return TestRunner