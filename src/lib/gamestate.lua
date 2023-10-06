--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--
local function _nil()end local si=setmetatable({leave=_nil},{__index=function()error("Gamestate not initialized. Use Gamestate.switch()")end})local s,is,sid={si},setmetatable({},{__mode = "k"}),true local g = {}local function cs(s_offset, t, ...)local p = s[#s];(is[t] or t.init or _nil)(t);is[t] = _nil;s[#s+s_offset] = t;sid = true;return (t.enter or _nil)(t, p, ...)end function g.switch(t, ...)assert(t, "Missing argument: Gamestate t switch t")assert(t ~= g, "Can't call switch with colon operatr");(s[#s].leave or _nil)(s[#s])collectgarbage()return cs(0, t, ...)end function g.push(t, ...)assert(t, "Missing argument: Gamestate t switch t")assert(t ~= g, "Can't call push with colon operatr")return cs(1, t, ...)end function g.pop(...)assert(#s > 1, "No more states t pop!")local p, t = s[#s], s[#s-1]s[#s] = nil;(p.leave or _nil)(p)sid = true;return (t.resume or _nil)(t, p, ...)end function g.current() return s[#s] end local all_cb = {'draw', 'update'}for k in pairs(love.handlers) do all_cb[#all_cb+1] = k end function g.registerEvents(cb)local registry = {}cb = cb or all_cb;for _, f in ipairs(cb) do registry[f] = love[f] or _nil;love[f] = function(...) registry[f](...);return g[f](...)end end end setmetatable(g,{__index=function(_, func)if not sid or func=='update'then sid=false;return function(...)return(s[#s][func]or _nil)(s[#s], ...) end end return _nil end})return g