return graphics.newSprite(
	graphics.imagePath("menu/menu_storymode"),
	{
		{x = 263.34, y = 58.41, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 1: storymode idle0000
		{x = 263.34, y = 58.41, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 2: storymode idle0001
		{x = 263.34, y = 58.41, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 3: storymode idle0002
		{x = 0, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 4: storymode idle0003
		{x = 0, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 5: storymode idle0004
		{x = 0, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 6: storymode idle0005
		{x = 204.27, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 7: storymode idle0006
		{x = 204.27, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 8: storymode idle0007
		{x = 204.27, y = 119.79, width = 204.27, height = 41.58, offsetX = 0.66, offsetY = 0.66, offsetWidth = 202.95, offsetHeight = 40.26, rotated = false}, -- 9: storymode idle0008
		{x = 263.34, y = 0, width = 264, height = 58.41, offsetX = 0.66, offsetY = -0.33, offsetWidth = 262.68, offsetHeight = 59.73, rotated = false}, -- 10: storymode selected0000
		{x = 0, y = 61.05, width = 263.34, height = 58.74, offsetX = 0, offsetY = 0, offsetWidth = 262.68, offsetHeight = 59.73, rotated = false}, -- 11: storymode selected0001
		{x = 0, y = 0, width = 263.34, height = 61.05, offsetX = 0.66, offsetY = 0.66, offsetWidth = 262.68, offsetHeight = 59.73, rotated = false}, -- 12: storymode selected0002
	},
	{
		["off"] = {start = 1, stop = 9, speed = 12, offsetX = 0, offsetY = 0},
		["on"] = {start = 10, stop = 12, speed = 12, offsetX = 0, offsetY = 0},
	},
	"off",
	true
)