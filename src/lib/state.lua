-- Short and sweet state library for LÖVE. States and substates supported! (Substate draws above the state)
-- GuglioIsStupid - 2023
-- Version: 1.0.0
--[[

The MIT License (MIT)

=====================

Copyright © 2023 GuglioIsStupid

Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
and associated documentation files (the “Software”), to deal in the Software without 
restriction, including without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

local a={}a.__index=a;local b=nil;local c=nil;local d=nil;local function e()end;local function f(g,...)if b and b.exit then b:exit()end;c=b;b=g;if b.enter then b:enter(c, ...)end;return b end;function a.switch(g,...)assert(g,"Called state.switch with no state")assert(type(g)=="table","Called state.switch with invalid state")f(g,...)return b end;function a.current()return b end;function a.last()return c end;function a.killSubstate(...)if d and d.exit then d:exit()end;d=nil;b:substateReturn(...)return end;function a.currentSubstate()return d end;function a.returnToLast()assert(c,"Called state.return with no last state")f(c)return b end;function a.substate(g,...)assert(g,"Called state.substate with no state")assert(type(g)=="table","Called state.substate with invalid state")d=g;if d.enter then d:enter(...)end;return d end;function new()return setmetatable({},{})end;setmetatable(a,{__index=function(h,i)return function(...)local j={...}local function k()if b and b[i]then b[i](b,unpack(j))end;if d and d[i]then d[i](d,unpack(j))end end;return k()end end,__call=function()return new()end})return a
