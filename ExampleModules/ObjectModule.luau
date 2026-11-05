export type ObjectModuleDependencies = {}

local ObjectModule = {}
ObjectModule.__index = ObjectModule

function ObjectModule.new()
	local self = {}
	setmetatable(self, ObjectModule)
	
	return self
end

function ObjectModule:setDependencies(dependencies : ObjectModuleDependencies)
	-- Does nothing
end

function ObjectModule:returnBoolean()
	-- Does nothing
end

return ObjectModule