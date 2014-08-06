if SERVER then
	
	util.AddNetworkString('pnet.ready');
	
	local ready = {};
	hook.Add('PlayerDisconnected','pnet', function(pl)
		ready[pl] = nil;
	end);
	
	function net.waitForPlayer(pl, func)
		if ready[pl] == true then
			func()
		else
			if not ready[pl] then
				ready[pl] = {};
			end
			ready[pl][#ready[pl]+1] = func;
		end
	end
	
else
	
	hook.Add('Think','pnet.waitForPlayer', function()
		if IsValid(LocalPlayer()) then
			hook.Remove('Think', 'pnet.waitForPlayer');
			net.Start('pnet.ready');
			net.SendToServer();
		end
	end);
	
end