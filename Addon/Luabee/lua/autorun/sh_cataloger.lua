
-- LUABEE.Cataloged = {}
-- --LUABEE.Cataloged.timer = {}
-- --LUABEE.Cataloged.timer.Create = {}
-- --LUABEE.Cataloged.timer.Create[1] = "name"
-- --LUABEE.Cataloged.timer.Create[2] = "time"
-- --LUABEE.Cataloged.timer.Create[3] = "repeat"
-- --LUABEE.Cataloged.timer.Create[4] = "func"

local function GetFunctionDetails(func, funcname) --Does not work correctly. Gets functions, but WAY too many to sort through. Also gets C functions with no info associated. Better to leave this alone.
    local dbi = debug.getinfo(func)
    if dbi.what == "C" then return {} end
    local fd = file.Read(string.Replace(dbi.source, "@", ""), "GAME")
    if not fd then return {} end
    fd = string.Explode("\n", fd)
    if string.find(fd[dbi.linedefined], funcname) then
        local rtrn = {}
        for word in string.gmatch(fd[dbi.linedefined],"([%w_]+)%s*")do
			if (word == "function") or word == funcname then continue end
            table.insert(rtrn,word)
        end
        return rtrn
    else
        return {}
    end
end

local function CatalogFunctions() --Sends all serverside functions to the client in 1 or more packages maxing 55kb. Again, too many to sort.
    for k,v in pairs(_G)do
        if type(v) == "function" then
           LUABEE.Cataloged[k] = GetFunctionDetails(v,k)
        elseif type(v) == "table" then
            if k == "LUABEE" then continue end
            LUABEE.Cataloged[k] = {}
            for k1,v1 in pairs(v)do
                if type(v1) == "function" then
                    LUABEE.Cataloged[k][k1] = GetFunctionDetails(v1,k1)
                end
            end
        end
    end
	if CLIENT then
		MsgN("[LUABEE] All global clientside functions have been Cataloged.")
	else
		MsgN("[LUABEE] All global serverside functions have been Cataloged.")
	end
end
--hook.Add("Initialize", "FunctionCataloguer", CatalogFunctions)

if SERVER then
	util.AddNetworkString("FunctionDump")
	local function SendServersideFunctions(len, ply)
		net.Start("FunctionDump")
		for k,v in pairs(LUABEE.Cataloged)do --Gotta send in pieces in case there's a LOT.
			if net.BytesWritten() > 55000 then 
				net.Send(ply)
				net.Start("FunctionDump")
			end
			net.WriteString(k)
			net.WriteTable(v)
		end
		net.Send(ply)
		MsgN("[LUABEE] Sent all serverside functions.")
	end
	--hook.Add("PlayerInitialSpawn", "SyncFunctions", function(p) SendServersideFunctions(_, p) end)
	net.Receive("FunctionDump", SendServersideFunctions)
else
	local received = 0
	net.Receive("FunctionDump", function(len)
		LUABEE.Cataloged[net.ReadString()] = net.ReadTable()
		received = received + 1
		MsgN("[LUABEE] Received serverside function list #"..received)
	end)
end
