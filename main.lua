-- dreiliebe - main file
-- author: max@mdotmonar.ch

dlb = require("dlb/dlb")

function love.load()
	-- load model
	cube_geometry = dlb.Loader.obj("models/cube.obj")
	cube = dlb.TriEntity:new(cube_geometry, 1000, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 0, 0, 0)

	-- load camera
	camera = dlb.Camera:new("orthographic", 1, 0, 0, 0, 0, 0, 0)
end

function love.draw()
	camera:draw(cube, true, false, false)
end

function love.update(dt)
	cube.orientation = cube.orientation + dlb.Vector:new({dt, dt, dt})
end
