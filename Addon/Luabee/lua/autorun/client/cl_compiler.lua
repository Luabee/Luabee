
hook.Add("Initialize", "Luabee Compile Init", function()
	
	function LUABEE.CompileCurrentTab()
		local tab = LUABEE.Tabs:GetActiveTab()
		local name = "NO_NAME.lua"
		for k, v in pairs( LUABEE.Tabs.Items ) do
			if ( v.Tab != tab ) then continue end
			name = v.Name
		end
		return LUABEE.CompilePanel(tab:GetPanel())
	end
	
	function LUABEE.CompilePanel(pnl, start, NoConsole)
		local start = start or pnl.CallHook
		if not NoConsole then
			print("--> LUABEE: Starting Lua compilation process...")
		end
		local first = start.m_BottomButton
		if first and first:GetInputter() then
			if not NoConsole then
				print("--> LUABEE: Call hook found. Compiling...")
			end
			local compile = first:GetInputter():GetParent():Compile()
			if compile then
				if not NoConsole then
					print("--> LUABEE: Compilation completed!")
				end
			else
				print("--> LUABEE: <Error> Compilation failed. Consult the compile log for info.")
				return
			end
			compile = string.Replace(compile, "%s, ", "_, ")
			
			compile = [[
--==================================LUABEE VARIABLES:====================================
LUABEE = LUABEE or {}
LUABEE.Vars = LUABEE.Vars or {}
/*----------------------------------Legal Notices:---------------------------------------
LUABEE is copyrighted (©) Bob Blackmon; alias Bobbleheadbob.
All files created using LUABEE are property of their creators.
LUABEE is open-source software. Feel free to modify, distribute, and reinvent.
Do not sell LUABEE without permission. That's not cool.
Do, however, feel free to sell anything you create in LUABEE.
Please keep this header on your files if you distribute or sell them.
-----------------------------------------------------------------------------------------
LUABEE INFO: http://facepunch.com/showthread.php?t=1302562
LUABEE DOWNLOAD: https://dl.dropboxusercontent.com/u/104427432/Luabee/luabee.zip
CONTACT ME: http://steamcommunity.com/id/bobblackmon/ | http://facepunch.com/member.php?u=438603
=======================================================================================*/
]]..compile
			if LUABEE.Config.Debug:GetBool() and (not NoConsole) then
				print("\n"..compile.."\n")
			end
			return compile
		else
			print("--> LUABEE: <Error> Call hook is not linked to a code block.")
			RunConsoleCommand("showconsole")
			return ""
		end
	end

	function LUABEE.SaveCompiledData(data, name)
		local name = string.Replace(name,".lua",".txt")
		file.Write(name, data)
	end
	
	function LUABEE.CompileLog(str, dtype)
		local old = {[1]={},[2]={},[3]={}}
		if file.Exists("Luabee/Logs/compilelog.txt", "DATA") then
			old = file.Read("Luabee/Logs/compilelog.txt", "DATA")
			if old == "" then
				old = util.TableToJSON({[1]={},[2]={},[3]={}})
			end
			old = util.JSONToTable(old)
		end
		table.insert(old[dtype], str)
		file.Write("Luabee/Logs/compilelog.txt", util.TableToJSON(old))
	end
	
end)