-- dreiliebe - camera file
-- author: max@mdotmonar.ch

local Vector = require("dlb/vector")
local Entity = require("dlb/entity")

local Camera = {}

-- Constructor
function Camera:new(args)
	--[[
	args format : {
		projection: string
		fov: number
		near: number
		far: number
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
	attributes.type = "camera"
	attributes.projection = args.projection
	attributes.fov = args.fov
	attributes.near = args.near
	attributes.far = args.far
	self.__index = self
	self.__tostring = function(self) return string.format("%s (scale: %s, position: %s, orientation: %s)", self.type, self.scale, self.position, self.orientation) end
	return setmetatable(attributes, self)
end

-- Transformation matrices

--- Scale
function Camera:Sc(v, s)
	--[[
	return Vector:new({
		Vector:new({s, 0, 0, 0})*v,
		Vector:new({0, s, 0, 0})*v,
		Vector:new({0, 0, s, 0})*v,
		1
	})
	]]--
	return Vector:new({
		s*v[1],
		s*v[2],
		s*v[3],
		1
	})
end

--- Translation
function Camera:Tr(v, p)
	--[[
	return Vector:new({
		Vector:new({1, 0, 0, p[1]})*v,
		Vector:new({0, 1, 0, p[2]})*v,
		Vector:new({0, 0, 1, p[3]})*v,
		1
	})
	]]--
	return Vector:new({
		v[1]+p[1],
		v[2]+p[2],
		v[3]+p[3],
		1
	})
end

--- X-axis rotation
function Camera:Rx(v, o)
	--[[
	return Vector:new({
		Vector:new({1, 0, 0, 0})*v,
		Vector:new({0, math.cos(o[1]), -math.sin(o[1]), 0})*v,
		Vector:new({0, math.sin(o[1]), math.cos(o[1]), 0})*v,
		1
	})
	]]--
	return Vector:new({
		v[1],
		v[2]*math.cos(o[1])-v[3]*math.sin(o[1]),
		v[2]*math.sin(o[1])+v[3]*math.cos(o[1]),
		1
	})
end

--- Y-axis rotation
function Camera:Ry(v, o)
	--[[
	return Vector:new({
		Vector:new({math.cos(o[2]), 0, math.sin(o[2]), 0})*v,
		Vector:new({0, 1, 0, 0})*v,
		Vector:new({-math.sin(o[2]), 0, math.cos(o[2]), 0})*v,
		1
	})
	]]--
	return Vector:new({
		v[1]*math.cos(o[2])+v[3]*math.sin(o[2]),
		v[2],
		v[3]*math.cos(o[2])-v[1]*math.sin(o[2]),
		1
	})
end

--- Z-axis rotation
function Camera:Rz(v, o)
	--[[
	return Vector:new({
		Vector:new({math.cos(o[3]), -math.sin(o[3]), 0, 0})*v,
		Vector:new({math.sin(o[3]), math.cos(o[3]), 0, 0})*v,
		Vector:new({0, 0, 1, 0})*v,
		1
	})
	]]--
	return Vector:new({
		v[1]*math.cos(o[3])-v[2]*math.sin(o[3]),
		v[1]*math.sin(o[3])+v[2]*math.cos(o[3]),
		v[3],
		1
	})
end

--- Orthographic projection
function Camera:Po(v)
	local top = math.tan(self.fov/2)
	local bottom = -1*top
	local right = top
	local left = -1*right
	--[[
	return Vector:new({
		Vector:new({2/(right-left), 0, 0, (right+left)/(right-left)})*v,
		Vector:new({0, 2/(top-bottom), 0, (top+bottom)/(top-bottom)})*v,
		Vector:new({0, 0, -2/(self.far-self.near), -1*(self.far+self.near)/(self.far-self.near)})*v,
		1
	})
	]]--
	return Vector:new({
		(v[1]*2/(right-left))+(v[4]*(right+left)/(right-left)),
		(v[2]*2/(top-bottom))+(v[4]*(top+bottom)/(top-bottom)),
		(-v[3]*2/(self.far-self.near))+(-v[4]*(self.far+self.near)/(self.far-self.near)),
		1
	})
end

function Camera:draw(args)
	--[[
	args format : {
		drawable: triEntity
		drawMesh: boolean
		drawWireframe: boolean
		drawVertices: boolean
	}
	]]--

	-- apply local space transformations (scale, x-axis rotation, y-axis rotation, z-axis rotation, translation)
	ls_vertices = {}
	for _, vertex in pairs(args.drawable.vertices) do
		table.insert(ls_vertices,
			self:Tr(
			self:Rz(
			self:Ry(
			self:Rx(
			self:Sc(
				vertex,
			args.drawable.scale),
			args.drawable.orientation),
			args.drawable.orientation),
			args.drawable.orientation),
			args.drawable.position)
		)
	end

	-- TO-DO: apply camera transformation

	-- apply projection
	pr_vertices = {}
	for _, vertex in pairs(ls_vertices) do
		table.insert(pr_vertices, self:Po(vertex))
	end

	-- draw triangles
	for i, triangle in pairs(args.drawable.faces) do
		if args.drawMesh then
			for j = 1, 3 do
				args.drawable.mesh:setVertex((3*(i-1))+j, {pr_vertices[triangle[j]][1], pr_vertices[triangle[j]][2], pr_vertices[triangle[j]][3], 0.3+(i*0.01), 0.3+(i*0.01), 0.3+(i*0.01), 1})
			end
		end

		if args.drawWireframe then
			t = {
				pr_vertices[triangle[1]][1],
				pr_vertices[triangle[1]][2],
				pr_vertices[triangle[2]][1],
				pr_vertices[triangle[2]][2],
				pr_vertices[triangle[3]][1],
				pr_vertices[triangle[3]][2],
			}
			love.graphics.setColor(0, 1, 0)
			love.graphics.polygon("line", t)
			love.graphics.setColor(1, 1, 1)
		end
	end

	-- draw mesh
	if args.drawMesh then
		love.graphics.draw(args.drawable.mesh)
	end

	-- draw vertices
	if args.drawVertices then
		love.graphics.setColor(1, 1, 0)
		for _, vertex in pairs(pr_vertices) do
			love.graphics.circle("fill", vertex[1], vertex[2], 3)
		end
		love.graphics.setColor(1, 1, 1)
	end
end

return Camera