-- Folders
local TestingPackage = script.Parent.Parent
local ExampleModules = script.Parent.Parent.Parent.ExampleModules

-- Modules
local GeneralModule = require(ExampleModules.GeneralModule)
local Mock = require(TestingPackage.Mock)
local ObjectModule = require(ExampleModules.ObjectModule)
local StaticModule = require(ExampleModules.StaticModule)
local TestSuite = require(TestingPackage.TestSuite)

local GeneralModuleTests = TestSuite.new('GeneralModuleTests')

GeneralModuleTests:registerBeforeEach(function()
	GeneralModuleTests.staticModuleMock = Mock.new(StaticModule)
	GeneralModuleTests.objectModuleMock = Mock.new(ObjectModule)
	
	local dependencies : GeneralModule.GeneralModuleDependencies = {
		StaticModule = GeneralModuleTests.staticModuleMock.functions,
		ObjectModule = GeneralModuleTests.objectModuleMock.functions
	}
	GeneralModuleTests.dependencies = dependencies
	
	GeneralModuleTests.generalModule = GeneralModule.new()
	GeneralModuleTests.generalModule:setDependencies(GeneralModuleTests.dependencies)
end)

GeneralModuleTests:registerAfterEach(function()
	GeneralModuleTests.staticModuleMock:reset()
	GeneralModuleTests.objectModuleMock:reset()
end)

GeneralModuleTests:registerTest("useStatic - given doNothing is stubbed after calling useStatic, should return nil", function()
	local value = GeneralModuleTests.generalModule:useStatic()
	GeneralModuleTests.staticModuleMock:stub("doNothing", function()
		return true
	end)
	assert(value == nil, tostring(value))
end)

GeneralModuleTests:registerTest("useStatic - given doNothing is stubbed before calling useStatic, should return true", function()
	GeneralModuleTests.staticModuleMock:stub("doNothing", function()
		return true
	end)
	local value = GeneralModuleTests.generalModule:useStatic()
	assert(value, tostring(value))
end)

GeneralModuleTests:registerTest('useObject - given returnBoolean returns true, should return the string "Hello"', function()
	GeneralModuleTests.objectModuleMock:stub("returnBoolean", function()
		return true
	end)
	local value = GeneralModuleTests.generalModule:useObject()
	assert(value == "Hello", tostring(value))
end)

GeneralModuleTests:registerTest('useObject - given returnBoolean returns true, should return the string "World"', function()
	GeneralModuleTests.objectModuleMock:stub("returnBoolean", function()
		return false
	end)
	local value = GeneralModuleTests.generalModule:useObject()
	assert(value == "World", tostring(value))
end)

return GeneralModuleTests