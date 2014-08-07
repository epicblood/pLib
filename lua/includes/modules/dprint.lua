local col_grey = Color(100,100,100);
function dprint(...)
	local info = debug.getinfo(1)
	MsgC(col_grey, info.short_src..':'..info.linedefined);
	print( '   ', ... )
end

function fdebug(name)
	local col = Color(math.random(1,255), math.random(1,255), math.random(1, 255));
	return function(...)
		MsgC(col, name .. ' -   ');
		print(...);
	end
end