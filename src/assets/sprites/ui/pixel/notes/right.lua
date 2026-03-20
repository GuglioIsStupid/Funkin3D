return graphics.newSprite(
    images.notes,
    {
		{ x = 51, y = 0,  width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 1: Right Arrow
        { x = 51, y = 17, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 2: Right Arrow On
        { x = 51, y = 34, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 3: Right Arrow Press
        { x = 51, y = 51, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 4: Right Arrow Confirm 1
        { x = 51, y = 68, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 5: Right Arrow Confirm 2
        { x = 21, y = 85, width = 7,  height = 7,  offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 10: Right Hold
        { x = 21, y = 91, width = 7,  height = 7,  offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 11: Right End
	},
    {
		["off"] = {start = 1, stop = 1, speed = 0, offsetX = 0, offsetY = 0},
		["on"] = {start = 2, stop = 2, speed = 0, offsetX = 0, offsetY = 0},
		["press"] = {start = 3, stop = 3, speed = 0, offsetX = 0, offsetY = 0},
		["confirm"] = {start = 4, stop = 5, speed = 24, offsetX = 0, offsetY = 0},
		["hold"] = {start = 6, stop = 6, speed = 0, offsetX = 0, offsetY = 0},
		["end"] = {start = 7, stop = 7, speed = 0, offsetX = 0, offsetY = 0}
	},
    "off",
    false
)