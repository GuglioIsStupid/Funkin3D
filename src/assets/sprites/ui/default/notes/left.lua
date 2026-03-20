return graphics.newSprite(
    images.notes,
    {
        {x = 226.5, y = 120.75, width = 39.5, height = 40.25, offsetX = 0.25, offsetY = 0.5, offsetWidth = 38.75, offsetHeight = 39.5}, -- 1: arrow static instance 0000
        {x = 116.5, y = 0, width = 56.25, height = 56.5, offsetX = 0, offsetY = 0, offsetWidth = 57.5, offsetHeight = 58}, -- 2: left confirm instance 0000
		{x = 172.75, y = 0, width = 53.75, height = 54.25, offsetX = -1.25, offsetY = -1.25, offsetWidth = 57.5, offsetHeight = 58}, -- 3: left confirm instance 0001
		{x = 110.5, y = 115.75, width = 55.5, height = 55.25, offsetX = -0.5, offsetY = -0.5, offsetWidth = 57.5, offsetHeight = 58}, -- 4: left confirm instance 0002
		{x = 110.5, y = 115.75, width = 55.5, height = 55.25, offsetX = -0.5, offsetY = -0.5, offsetWidth = 57.5, offsetHeight = 58}, -- 5: left confirm instance 0003
        {x = 266, y = 110.25, width = 35.75, height = 36.5, offsetX = -0.5, offsetY = -0.25, offsetWidth = 36.5, offsetHeight = 37.25}, -- 6: left press instance 0000
		{x = 266, y = 110.25, width = 35.75, height = 36.5, offsetX = -0.5, offsetY = -0.25, offsetWidth = 36.5, offsetHeight = 37.25}, -- 7: left press instance 0001
		{x = 266, y = 0, width = 37.5, height = 38.25, offsetX = 0.5, offsetY = 0.5, offsetWidth = 36.5, offsetHeight = 37.25}, -- 8: left press instance 0002
        {x = 226.5, y = 0, width = 39.5, height = 40.25, offsetX = 0.5, offsetY = 0.5, offsetWidth = 38.5, offsetHeight = 39.25}, -- 9: purple instance 0000
        {x = 266, y = 200, width = 13.75, height = 17, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 16}, -- 10: pruple end hold instance 0000
        {x = 279.75, y = 229, width = 13.75, height = 12, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 11}, -- 11: purple hold piece instance 0000
    },
    {
        ["off"] = {start = 1, stop = 1, speed = 0, offsetX = 0, offsetY = 0},
		["confirm"] = {start = 2, stop = 5, speed = 24, offsetX = 0, offsetY = 0},
		["press"] = {start = 6, stop = 8, speed = 24, offsetX = 0, offsetY = 0},
		["end"] = {start = 10, stop = 10, speed = 0, offsetX = 0, offsetY = 0},
		["on"] = {start = 9, stop = 9, speed = 0, offsetX = 0, offsetY = 0},
		["hold"] = {start = 11, stop = 11, speed = 0, offsetX = 0, offsetY = 0}
    },
    "off",
    false
)