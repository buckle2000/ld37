--[[    Copyright 2016 buckle2000

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local json = require("json")

local Frame = Class{
	init = function (self, quad, duration)
		self.quad = quad
		self.duration = duration
	end
}

--##########################

local Tag = Class()

function Tag:init(from, to, dir)
	self.from = from
	self.to = to
	self.direction = dir
	self:reset()
end
-- a tag that loop through all frames
function Tag.all(frame_count, dir)	
	return Tag(1, frame_count, dir or 'forward')
end

function Tag:reset()
	local dir = self.direction
	if dir == "forward" then
		self.current = self.from
	elseif dir == "reverse" then
		self.current = self.to
	elseif dir == "pingpong" then
		self.current = self.from
		self._pingpong = false
	end
end

function Tag:next()
	local cframe = self.current
	local dir = self.direction
	local pingpong = dir == "pingpong"
	if dir == "forward" or (pingpong and not self._pingpong) then
		cframe = cframe + 1
		if cframe > self.to then
			if pingpong then
				self._pingpong = true
				cframe = self.to - 1
			else
				cframe = self.from
			end
		end
	elseif dir == "reverse" or (pingpong and self._pingpong) then
		cframe = cframe - 1
		if cframe < self.from then
			if pingpong then
				self._pingpong = false
				cframe = self.from + 1
			else
				cframe = self.to
			end
		end
	else
		error("Animation play direction "..dir.." is not supported.")
	end
	self.current = cframe
	return cframe
end

--#################################################

local Animation = Class()

--- Animation
-- animation class
-- @field _all_tag play all frame

--- Constructor
-- @param partial_path something like 'path/to/image'
--   will load 'path/to/image.png'
--   and 'path/to/image.json' (must exist)
function Animation:init(img_name)
	do
		local gcp = self.entity.graphics
		assert(not gcp, "Already has graphics component.")
		self.entity:add("graphics", love.graphics.newImage(CONST.PATH_IMAGE .. img_name .. ".png"))
	end

	-- load config
	local cfg = json.decode(love.filesystem.read(CONST.PATH_IMAGE .. img_name .. ".json"))
	local sw, sh = cfg.meta.size.w, cfg.meta.size.h
	self.frames = {}
	for i,frame in ipairs(cfg.frames) do
		self.frames[i] = Frame(
			love.graphics.newQuad(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h, sw, sh),
			frame.duration / 1000
		)
	end
	self.tags = {}
	for i,tag in ipairs(cfg.meta.frameTags) do
		self.tags[tag.name] = Tag(tag.from + 1, tag.to + 1, tag.direction) -- +1 because lua index starts at 1
	end
	self._all_tag = Tag.all(#self.frames)
	self:set_tag()
	self.acc_t = 0
end

function Animation:get_frame()
	return self.frames[self.cframe]
end

function Animation:get_tag()
	if self.ctag==nil then
		return self._all_tag
	else
		return self.tags[self.ctag]
	end
end

function Animation:step()
	self.cframe = self:get_tag():next()
end

-- @param name tag name
--   if 'name' is nil, play all frames
function Animation:set_tag(name)
	local tag
	if name==nil then
		tag = self._all_tag
	else
		tag = self.tags[name]
		assert(tag, "Tag "..name.." does not exist.")
	end
	tag:reset()
	self.cframe = tag.current
	self.ctag = name
end

function Animation:update(dt)
	local acc = self.acc_t
	acc = acc + dt
	local frame = self:get_frame()
	if acc > frame.duration then
		acc = acc - frame.duration
		self:step()
	end
	self.acc_t = acc
end

return {
	Animation = Animation,
	Tag = Tag,
	Frame = Frame,
}
