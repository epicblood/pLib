xfn = {};

function xfn.filter( tbl, func )
	local ir, iw = 1, 1;
	local v ;
	while( tbl[ir] )do
		v = tbl[ir];
		if( func( v ) )then
			tbl[iw] = v;
			iw = iw + 1;
		end
		ir = ir + 1;
	end
	while( iw < ir )do
		tbl[iw] = nil;
		iw = iw + 1;
	end
	return tbl;
end

do
	local function _impl_packRes( succ, ... )
		return succ, { ... }
	end
	function xfn.waterfall( tasks, ... )
		local succ, res = true, {...}
		for k,v in ipairs( tasks )do
			succ, res = _impl_packRes( v( unpack( res ) ) )
			if not succ then 
				break ;
			end
		end
		return unpack( res );
	end
end

function xfn.recurse( iter, act )
	local function process( tbl )
		for k,v in pairs( tbl )do
			local next = iter( v );
			if next and #next > 0 then
				act( v, false );
			else
				act( v, true );
			end
		end
	end
	return function( obj )
		local todo = iter( obj );
		if( todo and #todo > 0 )then
			process( todo );
		end
	end
end

function xfn.forEach( tbl, func )
	for k,v in pairs( tbl )do
		func( v, k );
	end
end

function xfn.map( tbl, func )
	for k,v in pairs( tbl )do
		tbl[k] = func( v, k );
	end
end

// FUNCTIONAL
function xfn.fn_NOT( a )
	return function( ... )
		return not a( ... );
	end
end

function xfn.fn_OR( ... )
	local f = {...}
	return function(...)
		for k,v in pairs( f )do
			if f(...) then return true end
		end
		return false 
	end
end
function xfn.fn_AND( ... )
	local f = {...}
	return function(...)
		for k,v in pairs( f )do
			if not f(...) then return false end
		end
		return true
	end	
end
function xfn.fn_IF( c, a, b )
	return function(...)
		(c(...) and a or b)(...)
	end
end

function xfn.nothing() end
xfn.noop = xfn.nothing;

function xfn.fn_call(...)
	return function(...)
		return xfn.call(...);
	end
end

function xfn.fn_const(a)
	return function() return a end
end

function xfn.fn_mult(a,b)
	return function()
		return a()*b();
	end
end
function xfn.fn_div(a,b)
	return function()
		return a()/b();
	end
end
function xfn.fn_add(a,b)
	return function()
		return a()+b();
	end
end
function xfn.fn_sub(a,b)
	return function()
		return a()-b();
	end
end

function xfn.fn_partial(fn, ... )
	local a = {...}
	return function(...)
		fn(unpack(a),...);
	end
end

function xfn.fn_skipArgs( args, func )
	local shifter = function( args, a,... )
		if( args == 0 )then
			return func(...)
		else
			shifter( args-1,... )
		end
	end
	return function(...)
		return shifter( args-1, ... )
	end
end

// call them in parallel and throw away results
function xfn.fn_series(funcs)
	return function(...)
		local res = {};
		for k,v in ipairs(funcs)do
			res[k] = v(...);
		end
		return res;
	end
end