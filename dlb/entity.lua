local Vector = require("dlb/vector")

local Entity = {}

-- Constructor
function Entity:new(scale, x, y, z, phi, theta, psi)
	local attributes = {
		type = "entity",
		scale = scale,
		position = Vector:new({x, y, z, 1}),
		orientation = Vector:new({phi, theta, psi})
	}
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

return Entity