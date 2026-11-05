--[[
	Author: Julian Labbe
	Date: 11/4/26
	
	Create a basic mock-implementation for a provided module script
]]

-- String formats
local INVALID_TYPE_STRING_FORMAT = 'Module is set up incorrectly, found a %s'

local Mock = {}
Mock.__index = Mock

function Mock.new(module : {[string]: any})
	local self = {}
	local self = setmetatable(self, Mock)

	self:initialize(module)
	return self
end

function Mock:initialize(module : {[string]: any})
	local functions : {[string] : () -> any} = {}
	local functionStubs : {[string] : {}} = {}
	local log : {} = {}
	
	self.functions = functions
	self.functionStubs = functionStubs
	self.log = log
	
	self:initializeInterface(
		module, 
		functions
	)
end

function Mock:initializeInterface(
	module : {[string]: any},
	functions : {[string] : () -> any}
)
	for key, value in pairs(module) do
		if type(value) == "function" then
			functions[key] = function(...)
				local arguments = table.pack(...)
				self:logCall(key, arguments)
				
				if self.functionStubs[key] then
					return self.functionStubs[key]()
				end
			end
		else
			if (key == "__index") then
				continue
			end
			error(string.format(INVALID_TYPE_STRING_FORMAT, type(value)))
		end
	end
end

--- Stubs a method with custom behavior.
--- @param key string Name of the function to stub
--- @param value any Value to stub the key with 
function Mock:stub(key : string, value : any)
	if (self.functions[key] == nil) then
		error("Module does not have a function named " .. key)
	end
	self.functionStubs[key] = value
end

function Mock:clearStubs()
	table.clear(self.functionStubs)
end

function Mock:logCall(
	function_name : string,
	arguments : { any }
)
	table.insert(
		self.log,
		{
			["function"] = function_name,
			["arguments"] = arguments
		}
	)
end

function Mock:getLog(index : number)
	if index < 1 then
		error("Index must be greater than 0")
	end
	
	if index > #self.log then
		error("Index is larger than the log size")
	end
	
	return self.log[index]
end

function Mock:clearLogs()
	table.clear(self.log)
end

function Mock:reset()
	self:clearStubs()
	self:clearLogs()
end

return Mock