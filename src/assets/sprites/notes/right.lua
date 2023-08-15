return graphics.newSprite(
    images.notes,
    {
        {x = 226.5, y = 40.25, width = 39.5, height = 40.25, offsetX = 0.25, offsetY = 0.5, offsetWidth = 38.75, offsetHeight = 39.25}, -- 1: arrow static instance 0002
        {x = 55.25, y = 115.75, width = 55.25, height = 55.75, offsetX = -0.25, offsetY = -0.5, offsetWidth = 57, offsetHeight = 57.75}, -- 2: right confirm instance 0000
		{x = 0, y = 115.75, width = 55.25, height = 55.75, offsetX = -0.25, offsetY = -0.5, offsetWidth = 57, offsetHeight = 57.75}, -- 3: right confirm instance 0001
		{x = 116.5, y = 56.5, width = 55.5, height = 55.5, offsetX = -0.25, offsetY = -0.5, offsetWidth = 57, offsetHeight = 57.75}, -- 4: right confirm instance 0002
		{x = 116.5, y = 56.5, width = 55.5, height = 55.5, offsetX = -0.25, offsetY = -0.5, offsetWidth = 57, offsetHeight = 57.75}, -- 5: right confirm instance 0003
        {x = 266, y = 146.75, width = 35.5, height = 36.25, offsetX = -0.25, offsetY = -1.5, offsetWidth = 37.25, offsetHeight = 38}, -- 6: right press instance 0000
		{x = 266, y = 146.75, width = 35.5, height = 36.25, offsetX = -0.25, offsetY = -1.5, offsetWidth = 37.25, offsetHeight = 38}, -- 7: right press instance 0001
		{x = 161.25, y = 171.5, width = 38, height = 38.75, offsetX = 0.5, offsetY = 0.25, offsetWidth = 37.25, offsetHeight = 38}, -- 8: right press instance 0002
        {x = 226.5, y = 80.5, width = 39.5, height = 40.25, offsetX = 0.5, offsetY = 0.5, offsetWidth = 38.5, offsetHeight = 39.25}, -- 9: red instance 0000
        {x = 279.75, y = 200, width = 13.75, height = 17, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 16}, -- 10: red hold end instance 0000
        {x = 279.75, y = 217, width = 13.75, height = 12, offsetX = 0.5, offsetY = 0.5, offsetWidth = 12.75, offsetHeight = 11}, -- 11: red hold piece instance 0000
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