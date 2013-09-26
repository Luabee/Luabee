

hook.Add("Initialize", "Saving Luabee Files", function()
	file.CreateDir("Luabee", "DATA")
	file.CreateDir("Luabee/Logs", "DATA")
	file.CreateDir("Luabee/Saved Files", "DATA")
	file.CreateDir("Luabee/Saved Files/Compiled Lua", "DATA")

	function LUABEE.SaveCurrentTab()
		local tab = LUABEE.Tabs:GetActiveTab()
		local name = "new.lua"
		for k, v in pairs( LUABEE.Tabs.Items ) do
			if ( v.Tab != tab ) then continue end
			name = v.Name
		end
		LUABEE.SaveFile(name, LUABEE.CreateFileData(tab:GetPanel()))
	end
	
	function LUABEE.CreateFileData(panel,NoConsole)
		if not NoConsole then
			print("--> LUABEE: Saving...")
		end
		local File = {}
		--local name = string.Replace(name,".lua",".txt")
		for key,block in ipairs(panel:GetChildren())do
			
			if not block.NewRun then continue end
			local blk = {}
			
			if !block:GetCallHook() then
				local index
				for k,v in pairs(LUABEE.CatalogedFunctions[block.m_CatalogTable.Section][block.m_CatalogTable.category or block.category])do
					if block.m_CatalogTable.name == v.name then
						index = k
					end
				end
				blk.TableIndex = {category=block.m_CatalogTable.category or block.category, section=block.m_CatalogTable.Section, index=index}
			end
			blk.ID = key
			blk.X, blk.Y = block:GetPos()
			blk.CallHook = block:GetCallHook()
			blk.category = block.category or block.m_CatalogTable.category
			
			blk.inputters = {}
			for k,v in ipairs(block:GetChildren())do
				if v.GetInputter then
					local ID
					local buttonID
					if v:GetInputter() then
						ID = table.KeyFromValue(panel:GetChildren(), v:GetInputter():GetParent())
						buttonID = table.KeyFromValue(v:GetInputter():GetParent():GetChildren(), v:GetInputter())
					end
					if ID and buttonID then
						blk.inputters[k] = {ID=ID,buttonID=buttonID}
					end
				elseif v.m_IsInput then
					blk.value = v:GetValue()
				end
			end
			
			File[key]=blk
			
		end
		if LUABEE.Config.Debug:GetBool() then
			if not NoConsole then
				PrintTable(File)
			end
		end
		
		return File
	end
	
	function LUABEE.SaveFile(name,File)
		
		local save = util.TableToJSON(File)
		file.Write(name, save)
		
		print("--> LUABEE: Saved file to C:/.../steamapps/common/GarrysMod/garrysmod/data/Luabee/Saved Files/"..name)
	end
	
	function LUABEE.OpenFile(path, name)
		local path = path or ""
		local safename = string.Left(string.Safe(name), string.len(string.Safe(name))-4)..".lua"
		
		if LUABEE.Config.Debug:GetBool() then
			print("--> LUABEE: Opening C:/.../steamapps/common/GarrysMod/garrysmod/data/"..path.."/"..name.."...")
		end
		
		local save = file.Read(path.."/"..name, "DATA")
		if not save then
			print("--> LUABEE: <Error> File not found.")
			RunConsoleCommand("showconsole")
			return
		end
		local File = util.JSONToTable(save)
		
		if not File then
			print("--> LUABEE: <Error> File is corrupted or of the wrong type. It's probably an exported Lua file.")
			RunConsoleCommand("showconsole")
			return
		end
		
		if not LUABEE.FileOpened then
			LUABEE.Tabs:CloseTab(LUABEE.Tabs:GetActiveTab(), true)
		end
		
		LUABEE.FileOpened = true
		
		local tab = LUABEE.Tabs:CreateTab(safename, path.."/"..safename, true)
		local panel = tab:GetPanel()
		
		tab.SaveDir = path.."/"..name
		
		if LUABEE.Config.Debug:GetBool() then
			PrintTable(File)
		end
		
		for ID,block in pairs(File)do-- create them all...
			
			local blk = vgui.Create("CodeBlock", panel)
			blk:SetCallHook(block.CallHook)
			if block.CallHook then
				panel.CallHook = blk
				blk:SetText("Call Hook")
				blk:SetFunction(function() end)
				blk:SetCallHook(true)
				blk.m_CatalogTable = {callhook=true,category="Luabee Stuff",realm="Shared",name="Call Hook",args={},returns={},desc="This is the call hook of this file.\nWhen the file is ran or saved, the call hook is where it all begins.\nYou can not place or delete a call hook as there must only be one per file.\nSee the tutorial on the call hook for more info."}
				blk.m_Constructor = {}
				blk:SetPos(block.X, block.Y)
				blk:SetColor(Color(0,170,0,255))
				blk:Activate()
				continue
			end
			
			blk.m_CatalogTable = LUABEE.CatalogedFunctions[block.TableIndex.section][block.TableIndex.category or block.category][block.TableIndex.index]
			
			blk:SetPos(block.X, block.Y)
			
			blk:SetColor(LUABEE.CatalogedFunctions[block.TableIndex.section][block.TableIndex.category].__Color)
			if blk.m_CatalogTable.block then
				for k,v in pairs(blk.m_CatalogTable.block)do
					blk[k]=v
				end
				blk.m_Constructor = blk.m_CatalogTable.block
			end
			if blk.m_CatalogTable.func then
				blk:SetFunction(blk.m_CatalogTable.func)
			elseif _G[block.TableIndex.category] then
				--Disabling this to avoid collision.
				--blk:SetFunction(_G[block.TableIndex.category][string.Explode(".", blk.m_CatalogTable.name)[2]])
			elseif _G[blk.m_CatalogTable.name] then
				blk:SetFunction(_G[blk.m_CatalogTable.name])
			end
			blk:SetText(blk.m_CatalogTable.name)
			blk:SetOutputs(blk.m_CatalogTable.returns)
			blk:SetInputs(blk.m_CatalogTable.args)
			blk:Activate()
			
			blk.ID = block.ID
			
			if block.value then
				for k,v in pairs(blk:GetChildren())do
					if v.m_IsInput then
						v:SetValue(block.value)
					end
				end
			end
			
			function blk:OnMouseWheeled(d)
				panel:OnMouseWheeled(d)
			end
			
			blk.Inputters = block.inputters
			
			blk.category = block.category
			
		end
		
		for ID, block in ipairs(panel:GetChildren())do-- ...then connect them all.
			for k,v in pairs(block.Inputters or {})do
			
				local inputblock, button
				for key,val in ipairs(panel:GetChildren())do
					if val.ID == v.ID then
						inputblock = val
						for id, btn in pairs(val:GetChildren())do
							if id == v.buttonID then
								button = btn
							end
						end
					end
				end
				
				if inputblock and button then
					button:Link(block:GetChildren()[k], true)
				end
				
			end
		end
		if LUABEE.Config.Debug:GetBool() then
			print("--> LUABEE: File Opened.")
		end
		
	end
	
	function LUABEE.OpenFileData(name, File)
		--File = util.JSONToTable(File)
		local tab = LUABEE.Tabs:CreateTab(name, name, true)
		local panel = tab:GetPanel()
		
		if LUABEE.Config.Debug:GetBool() then
			PrintTable(File)
		end
		
		for ID,block in pairs(File)do-- create them all...
			
			local blk = vgui.Create("CodeBlock", panel)
			blk:SetCallHook(block.CallHook)
			if block.CallHook then
				panel.CallHook = blk
				blk:SetText("Call Hook")
				blk:SetFunction(function() end)
				blk:SetCallHook(true)
				blk.m_CatalogTable = {callhook=true,category="Luabee Stuff",realm="Shared",name="Call Hook",args={},returns={},desc="This is the call hook of this file.\nWhen the file is ran or saved, the call hook is where it all begins.\nYou can not place or delete a call hook as there must only be one per file.\nSee the tutorial on the call hook for more info."}
				blk.m_Constructor = {}
				blk:SetPos(block.X, block.Y)
				blk:SetColor(Color(0,170,0,255))
				blk:Activate()
				continue
			end
			
			blk.m_CatalogTable = LUABEE.CatalogedFunctions[block.TableIndex.section][block.TableIndex.category or block.category][block.TableIndex.index]
			
			blk:SetPos(block.X, block.Y)
			
			blk:SetColor(LUABEE.CatalogedFunctions[block.TableIndex.section][block.TableIndex.category].__Color)
			if blk.m_CatalogTable.block then
				for k,v in pairs(blk.m_CatalogTable.block)do
					blk[k]=v
				end
				blk.m_Constructor = blk.m_CatalogTable.block
			end
			if blk.m_CatalogTable.func then
				blk:SetFunction(blk.m_CatalogTable.func)
			elseif _G[block.TableIndex.category] then
				--Disabling this for classes issues. Not necessary anyway.
				--blk:SetFunction(_G[block.TableIndex.category][string.Explode(".", blk.m_CatalogTable.name)[2]])
			elseif _G[blk.m_CatalogTable.name] then
				blk:SetFunction(_G[blk.m_CatalogTable.name])
			end
			blk:SetText(blk.m_CatalogTable.name)
			blk:SetOutputs(blk.m_CatalogTable.returns)
			blk:SetInputs(blk.m_CatalogTable.args)
			blk:Activate()
			
			blk.ID = block.ID
			
			if block.value then
				for k,v in pairs(blk:GetChildren())do
					if v.m_IsInput then
						v:SetValue(block.value)
					end
				end
			end
			
			function blk:OnMouseWheeled(d)
				panel:OnMouseWheeled(d)
			end
			
			blk.Inputters = block.inputters
			
			blk.category = block.category
			
		end
		
		for ID, block in ipairs(panel:GetChildren())do-- ...then connect them all.
			for k,v in pairs(block.Inputters or {})do
			
				local inputblock, button
				for key,val in ipairs(panel:GetChildren())do
					if val.ID == v.ID then
						inputblock = val
						for id, btn in pairs(val:GetChildren())do
							if id == v.buttonID then
								button = btn
							end
						end
					end
				end
				
				if inputblock and button then
					button:Link(block:GetChildren()[k], true)
				end
				
			end
		end
		
		return tab
	end
	
	
end)
