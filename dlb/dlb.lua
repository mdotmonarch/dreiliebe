-- dreiliebe - dlb file
-- author: max@mdotmonar.ch

-- expand type function
local tmp_type = type
type = function(o)
	local otype = tmp_type(o)
	if otype == "table" and o.type ~= nil then
		return o.type
	end
	return otype
end

love.graphics.setDepthMode("lequal", true)

local dlb = {}

dlb.Vector = require("dlb/vector")
dlb.Entity = require("dlb/entity")
dlb.TriEntity = require("dlb/trientity")
dlb.Camera = require("dlb/camera")

return dlb