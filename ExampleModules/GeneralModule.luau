export type GeneralModuleDependencies = {
	StaticModule: ModuleScript,
	ObjectModule: ModuleScript
}

local GeneralModule = {}
GeneralModule.__index = GeneralModule

function GeneralModule.new()
	local self = {}
	setmetatable(self, GeneralModule)
	
	return self
end

function GeneralModule:setDependencies(dependecies : GeneralModuleDependencies)
	-- Set up the static 
	self.staticModule = dependecies.StaticModule
	self.objectModule = dependecies.ObjectModule
end

function GeneralModule:useObject()
	if self.objectModule:returnBoolean() then
		return "Hello"
	else
		return "World"
	end
end

function GeneralModule:useStatic()
	return self.staticModule.doNothing()
end

return GeneralModule