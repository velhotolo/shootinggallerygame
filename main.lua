function love.load()
	target = {} -- table for the target entity and its attributes
	target.x = 300
	target.y = 300
	target.radius = 50

	score = 0 -- variable for score
	timer = 0 -- a variable for the time
	gameState = 1 -- this variable is used to set when in game (or not)

	gameFont = love.graphics.newFont(40) -- to load the game font (and the default size)

	sprites = {} -- a table to load images, one per attribute
	sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")
	sprites.target = love.graphics.newImage("sprites/target.png")
	sprites.sky = love.graphics.newImage("sprites/sky.jpg")

	love.mouse.setVisible(false)
end

function love.update(dt) -- setting game states and timer configuration
	if timer > 0 then
		timer = timer - dt
	end
	if timer < 0 then
		timer = 0
		gameState = 1
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1) -- this color will be applied in non-image elements from now on
	love.graphics.draw(sprites.sky, 0, 0)
	love.graphics.setFont(gameFont)

	love.graphics.setColor(1, 0, 0) -- this color will be applied in non-image elements from now on
	love.graphics.print("Score:" .. score, 8, 8)
	love.graphics.print("Time:" .. math.ceil(timer), 300, 8)

	if gameState == 1 then
		love.graphics.printf("Click to start!", 0, 250, love.graphics.getWidth(), "center")
	end
	love.graphics.setColor(1, 1, 1) -- this color will be applied in non-image elements from now on
	if gameState == 2 then
		love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
	end

	love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 and gameState == 2 then
		local mousetoTarget = distanceBetween(x, y, target.x, target.y) -- here we find out when the click is done on top of the target
		if mousetoTarget < target.radius then
			score = score + 1
			target.x = math.random(target.radius, love.graphics.getWidth() - target.radius) -- randomizing target positions
			target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
		else
			if mousetoTarget > target.radius then
				score = score - 1

				if score < 0 then -- making sure score won't go below 0
					score = 0
				end
			end
		end
	elseif button == 1 and gameState == 1 then -- code to start the game
		gameState = 2
		timer = 10
		score = 0
	end
end

function distanceBetween(x1, y1, x2, y2) -- formula to find when clicking on top of the target
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
