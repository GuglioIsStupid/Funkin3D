return graphics.newSprite(
    images.notes,
    {
		{ x = 34, y = 0,  width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 12: Up Arrow
        { x = 34, y = 17, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 13: Up Arrow On
        { x = 34, y = 34, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 14: Up Arrow Press
        { x = 34, y = 51, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 15: Up Arrow Confirm 1
        { x = 34, y = 68, width = 17, height = 17, offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 16: Up Arrow Confirm 2
        { x = 14, y = 85, width = 7,  height = 7,  offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 21: Up Hold
        { x = 14, y = 91, width = 7,  height = 7,  offsetX = 0, offsetY = 0, offsetWidth = 0, offsetHeight = 0 }, -- 22: Up End
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