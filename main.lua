-- dreiliebe - main file
-- author: max@mdotmonar.ch

dlb = require("dlb/dlb")

function love.load()
	-- load model
	cube = dlb.TriEntity:new({
		geometry = dlb.Loader.obj("models/cube.obj"),
		scale = 1000,
		position = dlb.Vector:new({love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1})
	})

	-- load camera
	camera = dlb.Camera:new({
		position = dlb.Vector:new({0, 0, 1, 1})
	})
end

function love.draw()
	-- draw the object
	camera:draw({
		drawable = cube
	})
end

function love.update(dt)
	cube.orientation = cube.orientation + dlb.Vector:new({dt, dt, dt})
end
