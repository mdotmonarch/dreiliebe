local Vector = require("dlb/vector")

local Entity = {}

-- Constructor
function Entity:new(args)
	--[[
	args format : {
		scale: number
		position: vector4
		orientation: vector3
	}
	]]--
	local attributes = args
	attributes.type = "entity"
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

return Entity