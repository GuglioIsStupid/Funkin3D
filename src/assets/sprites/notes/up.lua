return graphics.newSprite(
    images.notes,
    {
        {x = 40.5, y = 171.5, width = 40.25, height = 39.5, offsetX = 0.5, offsetY = 0.5, offsetWidth = 39.25, offsetHeight = 38.5}, -- 1: arrow static instance 0003
        {x = 0, y = 58.25, width = 57.75, height = 57.5, offsetX = -0.5, offsetY = 0, offsetWidth = 59.5, offsetHeight = 58.5}, -- 2: up confirm instance 0000
		{x = 57.75, y = 58.25, width = 57.75, height = 57.5, offsetX = -0.5, offsetY = 0, offsetWidth = 59.5, offsetHeight = 58.5}, -- 3: up confirm instance 0001
		{x = 172.75, y = 108, width = 52.25, height = 52, offsetX = -3.25, offsetY = -2.75, offsetWidth = 59.5, offsetHeight = 58.5}, -- 4: up confirm instance 0002
		{x = 172.75, y = 108, width = 52.25, height = 52, offsetX = -3.25, offsetY = -2.75, offsetWidth = 59.5, offsetHeight = 58.5}, -- 5: up confirm instance 0003
        {x = 266, y = 38.25, width = 37, height = 36.25, offsetX = -1, offsetY = -0.75, offsetWidth = 38.5, offsetHeight = 37.75}, -- 6: up press instance 0000
		{x = 266, y = 38.25, width = 37, height = 36.25, offsetX = -1, offsetY = -0.75, offsetWidth = 38.5, offsetHeight = 37.75}, -- 7: up press instance 0001
		{x = 226.5, y = 161, width = 39.5, height = 38.5, offsetX = 0.5, offsetY = 0.25, offsetWidth = 38.5, offsetHeight = 37.75}, -- 8: up press instance 0002
		{x = 121, y = 171.5, width = 40.25, height = 39.5, offsetX = 0.5, offsetY = 0.5, offsetWidth = 39.25, offsetHeight = 38.5}, -- 9: green instance 0000
        {x = 266, y = 183, width = 13.75, height = 17, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 16}, -- 10: green hold end instance 0000
        {x = 266, y = 217, width = 13.75, height = 12, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 11}, -- 11: green hold piece instance 0000
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