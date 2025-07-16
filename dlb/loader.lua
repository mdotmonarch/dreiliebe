-- dreiliebe - loader file
-- author: max@mdotmonar.ch

local Vector = require("dlb/vector")

local loader = {}

-- load textures such as .png files
function loader.texture(path)
	local texture = love.graphics.newImage(path)
	texture:setFilter("nearest")
	return texture
end

-- load .obj models
function loader.obj(path)
	local obj = {
		vertices = {},
		normals = {},
		texture_coordinates = {},
		faces = {}
	}
	local lines = {}
	for line in io.lines(path) do
		table.insert(lines, line)
	end
	for _, line in pairs(lines) do
		local words = {}
		for word in string.gmatch(line, "%S+") do
			table.insert(words, word)
		end

		-- vertices
		if words[1] == "v" then
			table.insert(obj.vertices, Vector:new({tonumber(words[2]), tonumber(words[3]), tonumber(words[4]), 1})) -- homogeneous coordinates
		-- face normals
		elseif words[1] == "vn" then
			table.insert(obj.normals, Vector:new({tonumber(words[2]), tonumber(words[3]), tonumber(words[4])}))
		-- texture coordinates
		elseif words[1] == "vt" then
			table.insert(obj.texture_coordinates, Vector:new({tonumber(words[2]), tonumber(words[3])}))
		-- faces
		elseif words[1] == "f" then
			local v = {}
			local vt = {}
			local n = {}
			for i = 2,4 do
				local v_vt_n = {}
				for d in string.gmatch(words[i], "%d+") do table.insert(v_vt_n, tonumber(d)) end
				table.insert(v, v_vt_n[1])
				table.insert(vt, v_vt_n[2])
				table.insert(n, v_vt_n[3])
			end
			table.insert(obj.faces, 
				{
					vertex_indices = Vector:new(v),
					texture_coordinate_indices = Vector:new(vt),
					normal_indices = Vector:new(n)
				}
			)
		end
	end

	return obj
end

return loader