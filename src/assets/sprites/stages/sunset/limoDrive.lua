return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("stages/sunset/limoDrive")),
	-- Automatically generated from limoDrive.xml
	{
		{x = 0, y = 149.5, width = 461.15, height = 149.5, offsetX = -10.35, offsetY = 0.46, offsetWidth = 471.04, offsetHeight = 148.58}, -- 1: Limo stage0000
		{x = 0, y = 299, width = 461.15, height = 149.5, offsetX = -10.35, offsetY = 0.46, offsetWidth = 471.04, offsetHeight = 148.58}, -- 2: Limo stage0001
		{x = 0, y = 0, width = 461.15, height = 149.5, offsetX = -10.35, offsetY = 0.46, offsetWidth = 471.04, offsetHeight = 148.58}, -- 3: Limo stage0002
		{x = 0, y = 149.5, width = 461.15, height = 149.5, offsetX = -10.35, offsetY = 0.46, offsetWidth = 471.04, offsetHeight = 148.58} -- 4: Limo stage0003
	},
	{
        ["idle"] = {start = 1, stop = 4, speed = 24, offsetX = 0, offsetY = 0},
	},
	"idle",
	false
)