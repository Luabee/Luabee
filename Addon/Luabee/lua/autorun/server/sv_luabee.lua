
util.AddNetworkString("Luabee_Code")
net.Receive("Luabee_Code", function(len,ply)
	if ply:IsSuperAdmin() then
		RunString(net.ReadString())
	end
end)
