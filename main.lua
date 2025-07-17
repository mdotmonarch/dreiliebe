-- dreiliebe - main file
-- author: max@mdotmonar.ch

dlb = require("dlb/dlb")

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)

	-- add lots of cubes to list
	cube_list = {}
	w = 4
	h = 3
	for i = -w, w do
		for j = -h, h do
			table.insert(cube_list, dlb.TriEntity:new({
				geometry = dlb.Loader.obj("models/cube.obj"),
				texture = dlb.Loader.texture("textures/rubik.png"),
				scale = 0.25,
				position = dlb.Vector:new({love.graphics.getWidth()/2+(100*i), love.graphics.getHeight()/2+(100*j), 0, 1}),
				orientation = dlb.Vector:new({math.random()*2*math.pi, math.random()*2*math.pi, math.random()*2*math.pi})
			}))
		end
	end

	-- load camera
	camera = dlb.Camera:new({position = dlb.Vector:new({0, 0, 1, 1})})
end

function love.draw()
	-- draw cubes
	for _, cube in pairs(cube_list) do
		camera:draw({drawable = cube})
	end
end

function love.update(dt)
	-- rotate cubes
	for _, cube in pairs(cube_list) do
		cube.orientation = cube.orientation + dlb.Vector:new({dt/4, 3*dt/8, 5*dt/8})
	end
end