-- dreiliebe - vector file
-- author: max@mdotmonar.ch

local Vector = {}

-- Constructor
function Vector:new(arg)
	local attributes = arg
	attributes.type = "vector"
	self.__index = self
	return setmetatable(attributes, self)
end

function Vector:zeros(n)
	attributes = {}
	for i=1,n do
		table.insert(attributes, 0)
	end
	return Vector:new(attributes)
end

function Vector:ones(n)
	attributes = {}
	for i=1,n do
		table.insert(attributes, 1)
	end
	return Vector:new(attributes)
end

-- tostring
Vector.__tostring = function(v)
	str = "<"
	for i=1,#v do
		if i == #v then
			str = str..string.format("%.3f", v[i])
		else
			str = str..string.format("%.3f", v[i])..", "
		end
	end
	return str..">"
end

-- basic operations
---- negation
Vector.__unm = function(v)
	local n_v = {}
	for i=1,#v do
		table.insert(n_v, -1*v[i])
	end
	return Vector:new(n_v)
end
---- addition
Vector.__add = function(v1, v2)
	local n_v = {}
	for i=1,#v1 do
		table.insert(n_v, v1[i]+v2[i])
	end
	return Vector:new(n_v)
end
---- substraction
Vector.__sub = function(v1, v2)
	local n_v = {}
	for i=1,#v1 do
		table.insert(n_v, v1[i]-v2[i])
	end
	return Vector:new(n_v)
end
---- multiplication (scalar multiplication and dot product)
function Vector.__mul(v1, v2)
	if type(v1) == "vector" and type(v2) == "vector" then
		local dot = 0
		for i=1,#v1 do
			dot = dot + (v1[i]*v2[i])
		end
		return dot
	elseif type(v1) == "number" and type(v2) == "vector" then
		local n_v = {}
		for i=1,#v2 do
			table.insert(n_v, v1*v2[i])
		end
		return Vector:new(n_v)
	elseif type(v1) == "vector" and type(v2) == "number" then
		local n_v = {}
		for i=1,#v1 do
			table.insert(n_v, v2*v1[i])
		end
		return Vector:new(n_v)
	end
end

---- magnitude
function Vector:norm() return (self*self)^0.5 end

return Vector