-- dreiliebe - loader file
-- author: max@mdotmonar.ch

local Vector = require("dlb/vector")

local loader = {}

function loader.obj(path)
	local obj = {
		vertices = {},
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
			table.insert(obj.vertices, Vector:new({tonumber(words[2]), tonumber(words[3]), tonumber(words[4]), 1}))
		-- faces
		elseif words[1] == "f" then
			local v1 = string.gsub(words[2], "/%w+/%w+", "")
			local v2 = string.gsub(words[3], "/%w+/%w+", "")
			local v3 = string.gsub(words[4], "/%w+/%w+", "")
			table.insert(obj.faces, Vector:new({tonumber(v1), tonumber(v2), tonumber(v3)}))
		end
	end

	return obj
end

return loader