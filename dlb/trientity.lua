-- dreiliebe - trientity file
-- author: max@mdotmonar.ch

local Entity = require("dlb/entity")
local Vector = require("dlb/vector")

local TriEntity = {}

-- Constructor
function TriEntity:new(v_l, t_l, scale, x, y, z, phi, theta, psi)
	local attributes = Entity:new(scale, x, y, z, phi, theta, psi)
	attributes.type = "triEntity"
	attributes.vertex_list = v_l
	attributes.face_list = t_l
	local mesh_table = {}
	for _, f in pairs(t_l) do
		for i = 1,3 do
			table.insert(mesh_table, {0, 0, 0, 1, 1, 1, 1})
		end
	end
	attributes.mesh = love.graphics.newMesh({
	{"VertexPosition", "float", 3},
	{"VertexColor", "byte", 4}
	}, mesh_table, "triangles", "dynamic")
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

return TriEntity