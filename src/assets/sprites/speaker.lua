return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("SPEAKER")),
	{
		{x = 161.69, y = 81.88, width = 161.69, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 1: Speaker0000
		{x = 0.0, y = 0.0, width = 162.61, height = 81.88, offsetX = 0.46, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 2: Speaker0001
		{x = 161.69, y = 163.76, width = 161.46, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 3: Speaker0002
		{x = 0.0, y = 163.76, width = 161.69, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 4: Speaker0003
		{x = 0.0, y = 163.76, width = 161.69, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 5: Speaker0004
		{x = 0.0, y = 81.88, width = 161.69, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 6: Speaker0005
		{x = 162.61, y = 0.0, width = 161.69, height = 81.88, offsetX = 0.0, offsetY = 0.46, offsetWidth = 161.69, offsetHeight = 81.19}, -- 7: Speaker0006
		{x = 324.3, y = 0.0, width = 161.46, height = 81.65, offsetX = 0.0, offsetY = 0.23, offsetWidth = 161.69, offsetHeight = 81.19}, -- 8: Speaker0007
	},
	{
		["idle"] = {start = 1, stop = 8, speed = 12, offsetX = 0, offsetY = 0}
	},
	"idle",
	false
)