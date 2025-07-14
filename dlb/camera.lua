local Vector = require("dlb/vector")
local Entity = require("dlb/entity")

local Camera = {}

-- Constructor
function Camera:new(projection, scale, x, y, z, phi, theta, psi)
	local attributes = Entity:new(scale, x, y, z, phi, theta, psi)
	attributes.type = "camera"
	attributes.projection = projection
	attributes.fov = math.pi/2
	attributes.near = 0.01
	attributes.far = 1000
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

-- Transformation matrices

--- Scale
function Camera:Sc(v, s)
	return Vector:new({
		Vector:new({s, 0, 0, 0})*v,
		Vector:new({0, s, 0, 0})*v,
		Vector:new({0, 0, s, 0})*v,
		1
	})
end

--- Translation
function Camera:Tr(v, p)
	return Vector:new({
		Vector:new({1, 0, 0, p[1]})*v,
		Vector:new({0, 1, 0, p[2]})*v,
		Vector:new({0, 0, 1, p[3]})*v,
		1
	})
end

--- X-axis rotation
function Camera:Rx(v, o)
	return Vector:new({
		Vector:new({1, 0, 0, 0})*v,
		Vector:new({0, math.cos(o[1]), -math.sin(o[1]), 0})*v,
		Vector:new({0, math.sin(o[1]), math.cos(o[1]), 0})*v,
		1
	})
end

--- Y-axis rotation
function Camera:Ry(v, o)
	return Vector:new({
		Vector:new({math.cos(o[2]), 0, math.sin(o[2]), 0})*v,
		Vector:new({0, 1, 0, 0})*v,
		Vector:new({-math.sin(o[2]), 0, math.cos(o[2]), 0})*v,
		1
	})
end

--- Z-axis rotation
function Camera:Rz(v, o)
	return Vector:new({
		Vector:new({math.cos(o[3]), -math.sin(o[3]), 0, 0})*v,
		Vector:new({math.sin(o[3]), math.cos(o[3]), 0, 0})*v,
		Vector:new({0, 0, 1, 0})*v,
		1
	})
end

--- Orthographic projection
function Camera:Po(v)
	local top = math.tan(self.fov/2)
	local bottom = -1*top
	local right = top
	local left = -1*right
	return Vector:new({
		Vector:new({2/(right-left), 0, 0, (right+left)/(right-left)})*v,
		Vector:new({0, 2/(top-bottom), 0, (top+bottom)/(top-bottom)})*v,
		Vector:new({0, 0, -2/(self.far-self.near), -1*(self.far+self.near)/(self.far-self.near)})*v,
		1
	})
end

function Camera:draw(trientity, drawMesh, drawWireframe, drawVertices)
	-- apply local space transformations (scale, x-axis rotation, y-axis rotation, z-axis rotation, translation)
	ls_v_l = {}
	for _, point in pairs(trientity.vertex_list) do
		table.insert(ls_v_l,
			self:Tr(
			self:Rz(
			self:Ry(
			self:Rx(
			self:Sc(
				point,
			trientity.scale),
			trientity.orientation),
			trientity.orientation),
			trientity.orientation),
			trientity.position)
		)
	end

	-- TO-DO: apply camera transformation

	-- apply projection
	pr_v_l = {}
	for _, point in pairs(ls_v_l) do
		table.insert(pr_v_l, self:Po(point))
	end

	-- draw triangles
	for i, triangle in pairs(trientity.face_list) do
		if drawMesh then
			for j = 1, 3 do
				trientity.mesh:setVertex((3*(i-1))+j, {pr_v_l[triangle[j]][1], pr_v_l[triangle[j]][2], pr_v_l[triangle[j]][3], 0.3+0.01*i, 0.3+0.01*i, 0.3+0.01*i, 1})
			end
		end

		if drawWireframe then
			t = {
				pr_v_l[triangle[1]][1],
				pr_v_l[triangle[1]][2],
				pr_v_l[triangle[2]][1],
				pr_v_l[triangle[2]][2],
				pr_v_l[triangle[3]][1],
				pr_v_l[triangle[3]][2],
			}
			love.graphics.setColor(0, 1, 0)
			love.graphics.polygon("line", t)
			love.graphics.setColor(1, 1, 1)
		end
	end

	-- draw mesh
	if drawMesh then
		love.graphics.draw(trientity.mesh)
	end

	-- draw vertices
	if drawVertices then
		love.graphics.setColor(1, 1, 0)
		for _, point in pairs(pr_v_l) do
			love.graphics.circle("fill", point[1], point[2], 3)
		end
		love.graphics.setColor(1, 1, 1)
	end
end

return Camera