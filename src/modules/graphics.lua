--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local imageType = "png"
local fade = {1}
local isFading = false

local fadeTimer

local screenWidth, screenHeight

return {
	screenBase = function(width, height)
		screenWidth, screenHeight = width, height
	end,
	getWidth = function()
		return screenWidth
	end,
	getHeight = function()
		return screenHeight
	end,

	imagePath = function(path)
		return "assets/images/" .. path .. "." .. imageType
	end,
	setImageType = function(type)
		imageType = type
	end,
	getImageType = function()
		return imageType
	end,
	screenDepth = function(screen)
		local depth = screen ~= "bottom" and -love.graphics.getDepth() or 0
		if screen == "right" then
			depth = -depth
		end
		return depth
	end,

	newImage = function(imageData, optionsTable)
		local image, width, height

		local options

		local object = {
			x = 0,
			y = 0,
			orientation = 0,
			sizeX = 1,
			sizeY = 1,
			offsetX = 0,
			offsetY = 0,
			shearX = 0,
			shearY = 0,
			alpha = 1,
			color = {1,1,1},
			depth = 0,

			setImage = function(self, imageData)
				image = imageData
				if type(image) == "string" then
					image = love.graphics.newImage(image)
				end
				width = image:getWidth()
				height = image:getHeight()
			end,

			getImage = function(self)
				return image
			end,

			draw = function(self)
				local x = self.x
				local y = self.y

				local curColor = {love.graphics.getColor()}

				if options and options.floored then
					x = math.floor(x)
					y = math.floor(y)
				end

				love.graphics.setColor(self.color[1] * curColor[1], self.color[2] * curColor[2], self.color[3] * curColor[3], self.alpha * curColor[4])

				love.graphics.draw(
					image,
					self.x - (graphics.screenDepth(love.graphics.getActiveScreen()) * self.depth),
					self.y,
					self.orientation,
					self.sizeX,
					self.sizeY,
					math.floor(width / 2) + self.offsetX,
					math.floor(height / 2) + self.offsetY,
					self.shearX,
					self.shearY
				)

				love.graphics.setColor(curColor)
			end,

			release = function(self)
				image:release()
				self = nil
			end
		}

		object:setImage(imageData)

		options = optionsTable

		return object
	end,

	newSprite = function(imageData, frameData, animData, animName, loopAnim, optionsTable)
		local sheet, sheetWidth, sheetHeight

		local frames = {}
		local frame
		local anims = animData
		local anim = {
			name = nil,
			start = nil,
			stop = nil,
			speed = nil,
			offsetX = nil,
			offsetY = nil
		}

		local isAnimated
		local isLooped

		local options

		local object = {
			x = 0,
			y = 0,
			orientation = 0,
			sizeX = 1,
			sizeY = 1,
			offsetX = 0,
			offsetY = 0,
			shearX = 0,
			shearY = 0,
			alpha = 1,
			color = {1,1,1},
			secondary = optionsTable and optionsTable.secondary or nil,
			depth = 0,

			setSheet = function(self, imageData)
				sheet = imageData
				sheet:setWrap("clampzero", "clampzero")
				sheetWidth = sheet:getWidth()
				sheetHeight = sheet:getHeight()
			end,

			getSheet = function(self)
				return sheet
			end,

			animate = function(self, animName, loopAnim)
				-- check if it exists
				if not anims[animName] then
					if animName:find("alt") then -- remove " alt"
						animName:gsub(" alt", "")
						if not anims[animName] then -- check again
							print("Animation " .. animName .. " alt does not exist!")
							return
						end
					end
					return
				end
				anim.name = animName
				anim.start = anims[animName].start
				anim.stop = anims[animName].stop
				anim.speed = anims[animName].speed
				anim.offsetX = anims[animName].offsetX
				anim.offsetY = anims[animName].offsetY

				frame = anim.start
				isLooped = loopAnim

				isAnimated = true
			end,
			getAnims = function(self)
				return anims
			end,
			getAnimName = function(self)
				return anim.name
			end,
			setAnimSpeed = function(self, speed)
				anim.speed = speed
			end,
			isAnimated = function(self)
				return isAnimated
			end,
			isLooped = function(self)
				return isLooped
			end,

			setOptions = function(self, optionsTable)
				options = optionsTable
			end,
			getOptions = function(self)
				return options
			end,

			update = function(self, dt)
				if isAnimated then
					frame = frame + anim.speed * dt
				end

				if isAnimated and frame > anim.stop then
					if isLooped then
						frame = anim.start
					else
						isAnimated = false
					end
				end

				if self.secondary then
					self.secondary.x = self.x
					self.secondary.y = self.y + 60
					self.secondary:update(dt)
				end
			end,
			draw = function(self)
				local flooredFrame = math.floor(frame)
				local curColor = {love.graphics.getColor()}

				if flooredFrame <= anim.stop then
					local x = self.x
					local y = self.y
					local width
					local height

					if options and options.floored then
						x = math.floor(x)
						y = math.floor(y)
					end

					if options and options.noOffset then
						if frameData[flooredFrame].offsetWidth ~= 0 then
							width = frameData[flooredFrame].offsetX
						end
						if frameData[flooredFrame].offsetHeight ~= 0 then
							height = frameData[flooredFrame].offsetY
						end
					else
						if frameData[flooredFrame].offsetWidth == 0 then
							width = math.floor(frameData[flooredFrame].width / 2)
						else
							width = math.floor(frameData[flooredFrame].offsetWidth / 2) + frameData[flooredFrame].offsetX
						end
						if frameData[flooredFrame].offsetHeight == 0 then
							height = math.floor(frameData[flooredFrame].height / 2)
						else
							height = math.floor(frameData[flooredFrame].offsetHeight / 2) + frameData[flooredFrame].offsetY
						end
					end

					love.graphics.setColor(self.color[1] * curColor[1], self.color[2] * curColor[2], self.color[3] * curColor[3], self.alpha * curColor[4])

					if self.secondary then
						self.secondary:draw()
					end

					love.graphics.draw(
						sheet,
						frames[flooredFrame],
						x - (graphics.screenDepth(love.graphics.getActiveScreen()) * self.depth),
						y,
						self.orientation,
						self.sizeX,
						self.sizeY,
						width + anim.offsetX + self.offsetX,
						height + anim.offsetY + self.offsetY,
						self.shearX,
						self.shearY
					)
				end

				love.graphics.setColor(curColor)
			end,

			release = function(self)
				sheet:release()
				self = nil
			end
		}

		object:setSheet(imageData)

		for i = 1, #frameData do
			table.insert(
				frames,
				love.graphics.newQuad(
					frameData[i].x,
					frameData[i].y,
					frameData[i].width,
					frameData[i].height,
					sheetWidth,
					sheetHeight
				)
			)
		end

		object:animate(animName, loopAnim)

		options = optionsTable

		return object
	end,

	setFade = function(value)
		if fadeTimer then
			Timer.cancel(fadeTimer)

			isFading = false
		end

		fade[1] = value
	end,
	getFade = function(value)
		return fade[1]
	end,
	fadeOut = function(duration, func)
		if fadeTimer then
			Timer.cancel(fadeTimer)
		end

		isFading = true

		fadeTimer = Timer.tween(
			duration,
			fade,
			{0},
			"linear",
			function()
				isFading = false

				if func then func() end
			end
		)
	end,
	fadeIn = function(duration, func)
		if fadeTimer then
			Timer.cancel(fadeTimer)
		end

		isFading = true

		fadeTimer = Timer.tween(
			duration,
			fade,
			{1},
			"linear",
			function()
				isFading = false

				if func then func() end
			end
		)
	end,
	isFading = function()
		return isFading
	end,

	clear = function(r, g, b, a, s, d)
		local fade = fade[1]

		love.graphics.clear(fade * r, fade * g, fade * b, a, s, d)
	end,
	setColor = function(r, g, b, a)
		local fade = fade[1]

		love.graphics.setColor(fade * r, fade * g, fade * b, a)
	end,
	setBackgroundColor = function(r, g, b, a)
		local fade = fade[1]

		love.graphics.setBackgroundColor(fade * r, fade * g, fade * b, a)
	end,
	getColor = function()
		local r, g, b, a = love.graphics.getColor()
		local fade = fade[1]

		return r / fade, g / fade, b / fade, a
	end
}