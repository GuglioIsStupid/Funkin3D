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
local a={}a.__index=a;local function b()end;local function c(d,e)d.time=d.time+e;d.during(e,math.max(d.limit-d.time,0))while d.time>=d.limit and d.count>0 do if d.after(d.after)==false then d.count=0;break end;d.time=d.time-d.limit;d.count=d.count-1 end end;function a:update(e)local f={}for d in pairs(self.functions)do f[d]=d end;for d in pairs(f)do if self.functions[d]then c(d,e)if d.count==0 then self.functions[d]=nil end end end end;function a:during(g,h,i)local d={time=0,during=h,after=i or b,limit=g,count=1}self.functions[d]=true;return d end;function a:after(g,j)return self:during(g,b,j)end;function a:every(g,i,k)local k=k or math.huge;local d={time=0,during=b,after=i,limit=g,count=k}self.functions[d]=true;return d end;function a:cancel(d)self.functions[d]=nil end;function a:clear()self.functions={}end;function a:script(l)local m=coroutine.wrap(l)m(function(n)self:after(n,m)coroutine.yield()end)end;a.tween=setmetatable({out=function(l)return function(o,...)return 1-l(1-o,...)end end,chain=function(p,q)return function(o,...)return(o<.5 and p(2*o,...)or 1+q(2*o-1,...))*.5 end end,linear=function(o)return o end,quad=function(o)return o*o end,cubic=function(o)return o*o*o end,quart=function(o)return o*o*o*o end,quint=function(o)return o*o*o*o*o end,sine=function(o)return 1-math.cos(o*math.pi/2)end,expo=function(o)return 2^(10*(o-1))end,circ=function(o)return 1-math.sqrt(1-o*o)end,back=function(o,r)r=r or 1.70158;return o*o*((r+1)*o-r)end,bounce=function(o)local s,t=7.5625,1/2.75;return math.min(s*o^2,s*(o-1.5*t)^2+.75,s*(o-2.25*t)^2+.9375,s*(o-2.625*t)^2+.984375)end,elastic=function(o,u,v)u,v=u and math.max(1,u)or 1,v or.3;return-u*math.sin(2*math.pi/v*(o-1)-math.asin(1/u))*2^(10*(o-1))end},{__call=function(w,self,x,y,z,A,i,...)local function B(y,z,C)for D,E in pairs(z)do local F=y[D]assert(type(E)==type(F),'Type mismatch in field "'..D..'".')if type(E)=='table'then B(F,E,C)else local G,H=pcall(function()return(E-F)*1 end)assert(G,'Field "'..D..'" does not support arithmetic operations')C[#C+1]={y,D,H}end end;return C end;A=w[A or'linear']local I,n,J=B(y,z,{}),0,{...}local K=0;return self:during(x,function(e)n=n+e;local o=A(math.min(1,n/x),unpack(J))local L=o-K;K=o;for M,N in ipairs(I)do local F,O,H=unpack(N)F[O]=F[O]+H*L end end,i)end,__index=function(P,O)if type(O)=='function'then return O end;assert(type(O)=='string','Method must be function or string.')if rawget(P,O)then return rawget(P,O)end;local function Q(R,l)local A=rawget(P,O:match(R))if A then return l(A)end;return nil end;local C,S=rawget(P,'out'),rawget(P,'chain')return Q('^in%-([^-]+)$',function(...)return...end)or Q('^out%-([^-]+)$',C)or Q('^in%-out%-([^-]+)$',function(l)return S(l,C(l))end)or Q('^out%-in%-([^-]+)$',function(l)return S(C(l),l)end)or error('Unknown interpolation method: '..O)end})function a.new()return setmetatable({functions={},tween=a.tween},a)end;local T=a.new()local U={}for D in pairs(a)do if D~="__index"then U[D]=function(...)return T[D](T,...)end end end;U.tween=setmetatable({},{__index=a.tween,__newindex=function(D,E)a.tween[D]=E end,__call=function(n,...)return T:tween(...)end})return setmetatable(U,{__call=a.new})