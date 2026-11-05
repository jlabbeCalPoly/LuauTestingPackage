-- Services
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- Folders
local TestingPackage = ServerScriptService.TestingPackage

-- Modules
-- <list your main game manager module here>

local function test()
	if RunService:IsStudio() then
		local TestRunner = require(TestingPackage.TestRunner)
		TestRunner.run()
	end
	
	TestingPackage:Destroy()
end

local function start()
	-- <start you main game manager module here>
end

test()
start()