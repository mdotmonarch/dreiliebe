-- dreiliebe - main file
-- author: max@mdotmonar.ch

dlb = require("dlb/dlb")

function love.load()
	-- load model
	cube = dlb.TriEntity:new({
		geometry = dlb.Loader.obj("models/cube.obj"),
		scale = 1000,
		position = dlb.Vector:new({love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1}),
		orientation = dlb.Vector:new(3)
	})

	-- load camera
	camera = dlb.Camera:new({
		projection = "orthographic",
		fov = math.pi/2,
		near = 0.01,
		far = 1000,
		scale = 1,
		position = dlb.Vector:new({0, 0, 100, 1}),
		orientation = dlb.Vector:new(3)
	})
end

function love.draw()
	-- draw the object
	camera:draw({
		drawable = cube,
		drawMesh = true,
		drawWireframe = false,
		drawVertices = false
	})
end

function love.update(dt)
	cube.orientation = cube.orientation + dlb.Vector:new({dt, dt, dt})
end
