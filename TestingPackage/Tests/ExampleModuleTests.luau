-- Folders
local TestingPackage = script.Parent.Parent

-- Modules
local TestSuite = require(TestingPackage.TestSuite)

local ExampleModuleTests = TestSuite.new('MyModuleTests')

ExampleModuleTests:registerTest("passingTest - should pass", function()
	assert(true, "this test should pass")
end)

ExampleModuleTests:registerTest("failingTest - should fail", function()
	assert(false, "this test should fail")
end)

return ExampleModuleTests