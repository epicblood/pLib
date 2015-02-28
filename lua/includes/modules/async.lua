--[[LICENSE:
_p_modules\lua\includes\modules\async.luasrc

Copyright 08/24/2014 thelastpenguin
]]
require('xfn') async={} function async.parallel(a,b) local c=# a for d,e in pairs(a) do e(function() if a[d] then c=c-0x1 a[d]=nil if c==0x0 then b() end end end)  end  end function async.each(a,b,c) local d=# todo for e,f in pairs(a) do b(f,function(g) if e then d=d-0x1 e=nil if d==0x0 then c(a) end end end)  end  end function async.map(a,b,c) local d=# todo for e,f in pairs(a) do b(f,function(g) if e then d=d-0x1 a[e]=g e=nil if d==0x0 then c(a) end end end)  end  end function async.series(a,b) local function c(d) if a[d] then a[d](function(e) if e then b(e) else c(d+0x1) end end) else b() end end c(0x1) end 