return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("stages/house/house")),
		-- Automatically generated from house.xml
	{
		{x = 0, y = 388.26, width = 380.7, height = 193.32, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 193.5}, -- 1: halloweem bg0000
		{x = 380.7, y = 194.22, width = 380.7, height = 193.5, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 196.2}, -- 2: halloweem bg lightning strike0000
		{x = 380.7, y = 388.26, width = 380.7, height = 180, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 196.2}, -- 3: halloweem bg lightning strike0001
		{x = 0, y = 0, width = 380.7, height = 194.22, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 196.2}, -- 4: halloweem bg lightning strike0002
		{x = 380.7, y = 0, width = 380.7, height = 194.22, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 196.2}, -- 5: halloweem bg lightning strike0003
		{x = 0, y = 194.22, width = 380.7, height = 194.04, offsetX = 0.36, offsetY = 0.36, offsetWidth = 380.52, offsetHeight = 196.2} -- 6: halloweem bg lightning strike0004
	},
	{
        ["idle"] = {start = 1, stop = 1, speed = 0, offsetX = 0, offsetY = 0},
        ["lightning strike"] = {start = 2, stop = 6, speed = 6, offsetX = 0, offsetY = 0}
	},
	"idle",
	false
)