require( 'xfn' );

async = {};

function async.parallel( todo, onComplete )
	
	local done = #todo;
	for k,func in pairs( todo )do
		func( function()
			if todo[k] then
				done = done - 1;
				todo[k] = nil;
				if done == 0 then
					onComplete( );
				end
			end
		end );
	end
	
end

function async.each( obj, fn, onComplete )
	local done = #todo;
	
	for k,v in pairs( obj )do
		fn( v, function( val )
			if k then
				done = done - 1;
				k = nil;
				if done == 0 then
					onComplete( obj )
				end
			end
		end);
	end
end

-- call fn on each element in obj passing the element and a callback. Write the value passed to the callback into the place of the element.
function async.map( obj, fn, onComplete )
	local done = #todo;
	
	for k,v in pairs( obj )do
		fn( v, function( val )
			if k then
				done = done - 1;
				obj[k] = val;
				k = nil;
				if done == 0 then
					onComplete( obj )
				end
			end
		end);
	end
end
function async.waterfall( todo, ... )
	local function call( i, ... )
		if not todo[i] then return end
		todo[i]( function( err, ... )
			if err then
				error( err );
			else
				call( i + 1, ... );
			end
		end, ... )
	end
	call( 1, ... );
end


/*
function async.auto( todo, onDone )
	local bucket_one = {};
	for k,v in pairs( todo )do
		if isfunction( v ) then
			bucket_one[k] = { 
					func = v,
					req = {}
				}
		else
			bucket_one[k] = {
					func = v[#v];
					req = xfn.filter( v, xfn.NOT( isfunction ) )
				}
		end
	end
	local buckets = { bucket_one };
	while( true )do
		
		local bucket_n = {};
		buckets[#buckets+1] = bucket_n;
		
		for k,v in pairs( buckets )do
			
		end
	end
end
*/