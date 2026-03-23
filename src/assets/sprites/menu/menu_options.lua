return graphics.newSprite(
	graphics.imagePath("menu/menu_options"),
	{
		{x = 0, y = 161.04, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 1: options idle0000
		{x = 0, y = 161.04, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 2: options idle0001
		{x = 0, y = 161.04, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 3: options idle0002
		{x = 202.62, y = 37.95, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 4: options idle0003
		{x = 202.62, y = 37.95, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 5: options idle0004
		{x = 202.62, y = 37.95, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 6: options idle0005
		{x = 202.62, y = 0, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 7: options idle0006
		{x = 202.62, y = 0, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 8: options idle0007
		{x = 202.62, y = 0, width = 162.03, height = 37.95, offsetX = 0.66, offsetY = 0.66, offsetWidth = 160.71, offsetHeight = 36.63, rotated = false}, -- 9: options idle0008
		{x = 0, y = 108.57, width = 201.3, height = 52.47, offsetX = 0, offsetY = 0.33, offsetWidth = 201.3, offsetHeight = 53.79, rotated = false}, -- 10: options selected0000
		{x = 0, y = 55.11, width = 201.63, height = 53.46, offsetX = -0.33, offsetY = 0.33, offsetWidth = 201.3, offsetHeight = 53.79, rotated = false}, -- 11: options selected0001
		{x = 0, y = 0, width = 202.62, height = 55.11, offsetX = 0.66, offsetY = 0.66, offsetWidth = 201.3, offsetHeight = 53.79, rotated = false}, -- 12: options selected0002
	},
	{
		["off"] = {start = 1, stop = 9, speed = 12, offsetX = 0, offsetY = 0},
		["on"] = {start = 10, stop = 12, speed = 12, offsetX = 0, offsetY = 0},
	},
	"off",
	true
)