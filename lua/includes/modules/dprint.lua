local col_grey = Color(100,100,100);
local HSVToColor = HSVToColor ;
local incr = SERVER and 72 or 0;
local fileColors = {};
local fileAbbrev = {};
function dprint(...)
	local info = debug.getinfo(2)
	local fname = info.short_src;
	if fileAbbrev[fname] then
		fname = fileAbbrev[fname];
	else
		local oldfname = fname;
		fname = string.Explode('/', fname);
		fname = fname[#fname];
		fileAbbrev[oldfname] = fname;
	end
	
	if not fileColors[fname] then
		incr = incr + 1;
		fileColors[fname] = HSVToColor(incr * 100 % 255, 1, 1)
	end
	
	MsgC(fileColors[fname], fname..':'..info.linedefined);
	print( '  ', ... )
end

function fdebug(name)
	local col = Color(math.random(1,255), math.random(1,255), math.random(1, 255));
	return function(...)
		MsgC(col, name .. ' - ');
		dprint(...);
	end
end