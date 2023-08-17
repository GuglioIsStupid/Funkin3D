return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("stages/sunset/bgLimo")),
	-- Automatically generated from bgLimo.xml
	{
		{x = 505.08, y = 88.09, width = 505.08, height = 87.86, offsetX = -3.91, offsetY = -0.69, offsetWidth = 510.14, offsetHeight = 88.32}, -- 1: background limo pink0000
		{x = 505.08, y = 0, width = 509.45, height = 88.09, offsetX = 0.46, offsetY = -0.46, offsetWidth = 510.14, offsetHeight = 88.32}, -- 2: background limo pink0001
		{x = 0, y = 89.01, width = 505.08, height = 89.01, offsetX = -3.91, offsetY = 0.46, offsetWidth = 510.14, offsetHeight = 88.32}, -- 3: background limo pink0002
		{x = 0, y = 0, width = 505.08, height = 89.01, offsetX = -3.91, offsetY = 0.46, offsetWidth = 510.14, offsetHeight = 88.32} -- 4: background limo pink0003
	},
	{
        ["idle"] = {start = 1, stop = 4, speed = 24, offsetX = 0, offsetY = 0},
	},
	"idle",
	false
)