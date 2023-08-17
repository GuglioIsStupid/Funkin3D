return graphics.newSprite(
	love.graphics.newImage(graphics.imagePath("week4/mom")),
	-- Automatically generated from mom.xml
	{
		{x = 454.94, y = 198.03, width = 104.88, height = 137.08, offsetX = 0.23, offsetY = -4.14, offsetWidth = 105.57, offsetHeight = 140.99}, -- 1: MOM DOWN POSE0000
		{x = 667.23, y = 376.05, width = 104.65, height = 141.91, offsetX = 0.46, offsetY = 0.46, offsetWidth = 105.57, offsetHeight = 140.99}, -- 2: MOM DOWN POSE0001
		{x = 561.66, y = 198.72, width = 102.35, height = 141.91, offsetX = -3.68, offsetY = 0.46, offsetWidth = 105.57, offsetHeight = 140.99}, -- 3: MOM DOWN POSE0002
		{x = 561.66, y = 198.72, width = 102.35, height = 141.91, offsetX = -3.68, offsetY = 0.46, offsetWidth = 105.57, offsetHeight = 140.99}, -- 4: MOM DOWN POSE0003
		{x = 667.23, y = 376.05, width = 104.65, height = 141.91, offsetX = 0.46, offsetY = 0.46, offsetWidth = 105.57, offsetHeight = 140.99}, -- 5: MOM DOWN POSE0004
		{x = 211.14, y = 363.4, width = 108.33, height = 187.45, offsetX = 0.46, offsetY = 0, offsetWidth = 110.17, offsetHeight = 187.22}, -- 6: Mom Idle0000
		{x = 262.43, y = 176.18, width = 108.33, height = 184, offsetX = 0.46, offsetY = -3.45, offsetWidth = 110.17, offsetHeight = 187.22}, -- 7: Mom Idle0001
		{x = 319.47, y = 363.4, width = 106.72, height = 186.53, offsetX = -0.46, offsetY = -1.15, offsetWidth = 110.17, offsetHeight = 187.22}, -- 8: Mom Idle0002
		{x = 667.23, y = 188.14, width = 106.72, height = 187.91, offsetX = -0.46, offsetY = 0.23, offsetWidth = 110.17, offsetHeight = 187.22}, -- 9: Mom Idle0003
		{x = 667.23, y = 0, width = 106.72, height = 188.14, offsetX = -0.46, offsetY = 0.46, offsetWidth = 110.17, offsetHeight = 187.22}, -- 10: Mom Idle0004
		{x = 131.79, y = 176.18, width = 130.64, height = 185.61, offsetX = 0.23, offsetY = -1.15, offsetWidth = 131.1, offsetHeight = 186.3}, -- 11: Mom Left Pose0000
		{x = 0, y = 176.18, width = 131.79, height = 187.22, offsetX = 0.23, offsetY = 0.46, offsetWidth = 131.1, offsetHeight = 186.3}, -- 12: Mom Left Pose0001
		{x = 0, y = 176.18, width = 131.79, height = 187.22, offsetX = 0.23, offsetY = 0.46, offsetWidth = 131.1, offsetHeight = 186.3}, -- 13: Mom Left Pose0002
		{x = 0, y = 0, width = 152.95, height = 176.18, offsetX = 0.46, offsetY = 0.46, offsetWidth = 154.56, offsetHeight = 175.26}, -- 14: Mom Pose Left0000
		{x = 152.95, y = 0, width = 152.26, height = 173.19, offsetX = 0.46, offsetY = -2.53, offsetWidth = 154.56, offsetHeight = 175.26}, -- 15: Mom Pose Left0001
		{x = 305.21, y = 0, width = 149.73, height = 173.19, offsetX = 0.46, offsetY = -2.53, offsetWidth = 154.56, offsetHeight = 175.26}, -- 16: Mom Pose Left0002
		{x = 105.57, y = 363.4, width = 105.57, height = 194.12, offsetX = 0.46, offsetY = -2.76, offsetWidth = 108.79, offsetHeight = 198.03}, -- 17: Mom Up Pose0000
		{x = 561.66, y = 0, width = 105.57, height = 198.72, offsetX = -0.92, offsetY = 0.23, offsetWidth = 108.79, offsetHeight = 198.03}, -- 18: Mom Up Pose0001
		{x = 454.94, y = 0, width = 106.72, height = 198.03, offsetX = -1.84, offsetY = -0.46, offsetWidth = 108.79, offsetHeight = 198.03}, -- 19: Mom Up Pose0002
		{x = 454.94, y = 0, width = 106.72, height = 198.03, offsetX = -1.84, offsetY = -0.46, offsetWidth = 108.79, offsetHeight = 198.03}, -- 20: Mom Up Pose0003
		{x = 0, y = 363.4, width = 105.57, height = 198.03, offsetX = -0.92, offsetY = -0.46, offsetWidth = 108.79, offsetHeight = 198.03}, -- 21: Mom Up Pose0004
		{x = 0, y = 363.4, width = 105.57, height = 198.03, offsetX = -0.92, offsetY = -0.46, offsetWidth = 108.79, offsetHeight = 198.03} -- 22: Mom Up Pose0005
	},
	{
        ["idle"] = {start = 6, stop = 10, speed = 12, offsetX = 0, offsetY = 0},
        ["down"] = {start = 1, stop = 5, speed = 12, offsetX = 4, offsetY = -22},
		["left"] = {start = 11, stop = 13, speed = 12, offsetX = 10, offsetY = -1},
		["right"] = {start = 14, stop = 16, speed = 12, offsetX = 8, offsetY = -7},
		["up"] = {start = 17, stop = 22, speed = 12, offsetX = 9, offsetY = 7},
	},
	"idle",
	false
)