-- dreiliebe - trientity file
-- author: max@mdotmonar.ch

local Entity = require("dlb/entity")
local Vector = require("dlb/vector")

local TriEntity = {}

-- Constructor
function TriEntity:new(args)
	--[[
	args format : {
		geometry: geometry
		scale: number
		position: vector4
		orientation: vector3
	}
	]]--
	local attributes = Entity:new({
		scale = args.scale,
		position = args.position,
		orientation = args.orientation
	})
	attributes.type = "triEntity"
	attributes.vertices = args.geometry.vertices
	attributes.faces = args.geometry.faces
	local mesh_table = {}
	for _, f in pairs(args.geometry.faces) do
		for i = 1,3 do
			table.insert(mesh_table, {})
		end
	end
	attributes.mesh = love.graphics.newMesh({
		{"VertexPosition", "float", 3},
		{"VertexColor", "byte", 4}
	}, mesh_table, "triangles")
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

return TriEntity