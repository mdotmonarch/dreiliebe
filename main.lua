-- dreiliebe - main file
-- author: max@mdotmonar.ch

dlb = require("dlb/dlb")

box_v_l = {
	dlb.Vector:new({-0.5, -0.5, -0.5, 1}),
	dlb.Vector:new({0.5, -0.5, -0.5, 1}),
	dlb.Vector:new({0.5, 0.5, -0.5, 1}),
	dlb.Vector:new({-0.5, 0.5, -0.5, 1}),
	dlb.Vector:new({-0.5, -0.5, 0.5, 1}),
	dlb.Vector:new({0.5, -0.5, 0.5, 1}),
	dlb.Vector:new({0.5, 0.5, 0.5, 1}),
	dlb.Vector:new({-0.5, 0.5, 0.5, 1})
}

box_t_l = {
	dlb.Vector:new({1, 2, 3}),
	dlb.Vector:new({1, 3, 4}),
	dlb.Vector:new({1, 4, 8}),
	dlb.Vector:new({1, 8, 5}),
	dlb.Vector:new({1, 5, 6}),
	dlb.Vector:new({1, 6, 2}),
	dlb.Vector:new({7, 8, 5}),
	dlb.Vector:new({7, 5, 6}),
	dlb.Vector:new({7, 6, 2}),
	dlb.Vector:new({7, 2, 3}),
	dlb.Vector:new({7, 3, 4}),
	dlb.Vector:new({7, 4, 8})
}

function love.load()
	camera = dlb.Camera:new("orthographic", 1, 0, 0, 0, 0, 0, 0)
	cube = dlb.TriEntity:new(box_v_l, box_t_l, 100, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 0, 0, 0)
end

function love.draw()
	camera:draw(cube, true, false, false)
end

function love.update(dt)
	cube.orientation = cube.orientation + dlb.Vector:new({dt, dt, dt})
end
