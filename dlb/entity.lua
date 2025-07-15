-- dreiliebe - entity file
-- author: max@mdotmonar.ch

local Vector = require("dlb/vector")

local Entity = {}

-- Constructor
function Entity:new(args)
	--[[
	args format : {
		scale: number (default 1)
		position: vector4 (default {0, 0, 0, 1})
		orientation: vector3 (default {0, 0, 0})
	}
	]]--
	local attributes = args
	attributes.scale = args.scale or 1
	attributes.position = args.position or Vector:new({0, 0, 0, 1})
	attributes.orientation = args.orientation or Vector:zeros(3)
	attributes.type = "entity"
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

return Entity