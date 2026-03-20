return graphics.newSprite(
    images.notes,
    {
        {x = 80.75, y = 171.5, width = 40.25, height = 39.5, offsetX = 0.5, offsetY = 0.25, offsetWidth = 39.25, offsetHeight = 38.75}, -- 1: arrow static instance 0001
		{x = 0, y = 0, width = 58.25, height = 58.25, offsetX = 0, offsetY = 0.25, offsetWidth = 60, offsetHeight = 59}, -- 2: down confirm instance 0000
		{x = 58.25, y = 0, width = 58.25, height = 58.25, offsetX = 0, offsetY = 0.25, offsetWidth = 60, offsetHeight = 59}, -- 3: down confirm instance 0001
		{x = 172.75, y = 54.25, width = 53.5, height = 53.75, offsetX = -1.5, offsetY = -2.75, offsetWidth = 60, offsetHeight = 59}, -- 4: down confirm instance 0002
		{x = 172.75, y = 54.25, width = 53.5, height = 53.75, offsetX = -1.5, offsetY = -2.75, offsetWidth = 60, offsetHeight = 59}, -- 5: down confirm instance 0003
        {x = 266, y = 74.5, width = 36.75, height = 35.75, offsetX = -0.5, offsetY = -0.25, offsetWidth = 37.5, offsetHeight = 36.5}, -- 6: down press instance 0000
		{x = 266, y = 74.5, width = 36.75, height = 35.75, offsetX = -0.5, offsetY = -0.25, offsetWidth = 37.5, offsetHeight = 36.5}, -- 7: down press instance 0001
		{x = 0, y = 211, width = 38.5, height = 37.5, offsetX = 0.5, offsetY = 0.5, offsetWidth = 37.5, offsetHeight = 36.5}, -- 8: down press instance 0002
        {x = 0, y = 171.5, width = 40.5, height = 39.5, offsetX = 0.5, offsetY = 0.5, offsetWidth = 39.5, offsetHeight = 38.5}, -- 9: blue instance 0000
        {x = 279.75, y = 183, width = 13.75, height = 17, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 16}, -- 10: blue hold end instance 0000
        {x = 266, y = 229, width = 13.75, height = 12, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 11}, -- 11: blue hold piece instance 0000
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