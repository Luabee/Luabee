LUABEE.DragThink = function() end
LUABEE.Config = {}
LUABEE.ALL_CODE_BLOCKS = {}
LUABEE.ALL_IOS = {}
LUABEE.Dropdowns = {}
LUABEE.Dropdowns.Buttons = {}
LUABEE.Dropdowns.Menus = {}

hook.Add("Initialize", "LUABEE_INIT", function()
	print("--> LUABEE Initializing...")
	
	LUABEE.WINDOW = vgui.Create( "DFrame" )
		LUABEE.WINDOW:SetSize( ScrW(), ScrH() )
		LUABEE.WINDOW:SetTitle( "Luabee" )
		LUABEE.WINDOW:SetVisible( false )
		LUABEE.WINDOW:SetDraggable( false )
		LUABEE.WINDOW:SetSizable( false )
		LUABEE.WINDOW:ShowCloseButton( true )
		LUABEE.WINDOW:SetDeleteOnClose( false )
		LUABEE.WINDOW:Center()
		LUABEE.WINDOW.btnMinim:SetDisabled(false)
		LUABEE.WINDOW.Minim = false
		function LUABEE.WINDOW.btnMinim:DoClick()
			LUABEE.WINDOW.Minim = !LUABEE.WINDOW.Minim
		end
	
	LUABEE.Tabs = vgui.Create("DPropertySheet", LUABEE.WINDOW)
		LUABEE.Tabs:SetPos(277,44)
		LUABEE.Tabs:SetSize(ScrW()-277,ScrH()-46)
		LUABEE.Tabs:SetFadeTime(.2)
	
		function LUABEE.Tabs:CreateTab(name,tip,bNoCallHook)
			
			local pnl = vgui.Create("BlockBackground")
				pnl.m_Variables = {}
				
			if not bNoCallHook then
				pnl.CallHook = vgui.Create("CodeBlock", pnl)
					pnl.CallHook:SetText("Call Hook")
					pnl.CallHook:SetFunction(function() end)
					pnl.CallHook:SetCallHook(true)
					pnl.CallHook.m_CatalogTable = {callhook=true,category="Luabee Stuff",realm="Shared",name="Call Hook",args={},returns={},desc="This is the call hook of this file.\nWhen the file is ran or saved, the call hook is where it all begins.\nYou can not place or delete a call hook as there must only be one per file.\nSee the tutorial on the call hook for more info."}
					pnl.CallHook:SetPos(50,50)
					pnl.CallHook:SetColor(Color(0,170,0,255))
					pnl.CallHook:Activate()
			end
			
			local tab = self:AddSheet(name, pnl, "icon16/page.png", false, false, (tip or ""))
				self:SetActiveTab(tab.Tab)
				tab.Tab.m_CurrentArgs = {}
				tab.Tab.Txt = name
				tab.Tab.DoRightClick = function()
					local mnu = DermaMenu()
					mnu:AddOption("New", function() self:CreateTab("new.lua", "new.lua") end)
					mnu:AddOption("Close", function() self:CloseTab(tab.Tab, true) end)
					--mnu:AddOption("Close All BUT This", function() for k,v in pairs(self.Items)do if v == tab.Tab then continue end; self:CloseTab(v.Tab, true) end end)
					mnu:AddOption("Save", function() end)
					mnu:AddOption("Save As...", function() end)
					mnu:AddOption("Duplicate", function() end)
					mnu:AddOption("Rename", function()
						Derma_StringRequest("Luabee", "Rename this file", tab.Tab.Txt, function(text)
							text = string.Trim(text)
							if text == "" or text == ".lua" then
								text = "new.lua"
							end
							text = string.Safe(text)--custom string function.
							if string.Right(text,4) != "_lua" then
								text = text..".lua"
							else
								text = string.Left(text,string.len(text)-4)..".lua"
							end
							LUABEE.Tabs:RenameTab(tab.Tab, text)
							local dir = string.Explode("/", tab.Tab.SaveDir)
							table.remove(dir, #dir)
							dir = table.concat(dir,"/")
							tab.Tab.SaveDir = dir.."/"..string.Replace(text, ".lua", ".txt")
							tab.Tab.ExportDir = nil
						end)
					end)
					mnu:Open()
				end
				tab.Tab.m_History = {}
				tab.Tab.m_HistoryPoint = 0
			return tab.Tab
		end
		function LUABEE.Tabs:RenameTab(tab, name)--[tab] must be a tab object
			for k, v in pairs( self.Items ) do
				if ( v.Tab != tab ) then continue end
				self.Items[k].Name = name
			end
			for k, v in pairs(self.tabScroller.Panels) do
				if ( v != tab ) then continue end
				self.tabScroller.Panels[k]:SetText(name)
				self.tabScroller.Panels[k].Txt = name
			end
			tab:SizeToContents()
			self.tabScroller:InvalidateLayout()
			self.tabScroller:SizeToContents()
		end
		
		function LUABEE.Tabs:CloseTab( tab, bRemovePanelToo )
			LUABEE.FileOpened = true
			if #self.Items == 1 and false then
				
			else
				for k, v in pairs( self.Items ) do
					if ( v.Tab != tab ) then continue end
					table.remove( self.Items, k )
				end
				for k, v in pairs(self.tabScroller.Panels) do
					if ( v != tab ) then continue end
					table.remove( self.tabScroller.Panels, k )
				end
				self.tabScroller:InvalidateLayout( true )
				if ( tab == self:GetActiveTab() ) then
					if self.Items[1] then
						self.m_pActiveTab = self.Items[1].Tab
					else
						self.m_pActiveTab = nil
						self.Items = {}
					end
				end
				local pnl = tab:GetPanel()
				if ( bRemovePanelToo ) then
					pnl:Remove()
				end
				tab:Remove()
				self:InvalidateLayout( true )
			
				return pnl
			end
		end
		
		function LUABEE.Tabs:OnMousePressed(mc)
			if LUABEE.TopDropdowns:GetActiveButton() then
				local b = LUABEE.TopDropdowns:GetActiveButton()
				b:SetSelected(false)
				b.mnu:Hide()
				b:GetParent():SetToggled(false)
			end
			local mnu = DermaMenu()
			mnu:AddOption("New", function() self:CreateTab("new.lua", "new.lua") end)
			mnu:AddOption("Open...", function()
				local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
					fb:SetDirectory("Data/Luabee/Saved Files")
					fb:Center()
					fb:SetAction("Open", function(path,name)
						LUABEE.OpenFile(path, name)
					end) 
			end)
			mnu:Open()
		end
		function LUABEE.Tabs.tabScroller:OnMousePressed(mc)
			if LUABEE.TopDropdowns:GetActiveButton() then
				local b = LUABEE.TopDropdowns:GetActiveButton()
				b:SetSelected(false)
				b.mnu:Hide()
				b:GetParent():SetToggled(false)
			end
		end
		
		LUABEE.Tabs:CreateTab("new.lua", "new.lua")
	
	LUABEE.BlockSelector = vgui.Create("DPropertySheet", LUABEE.WINDOW)
		LUABEE.BlockSelector:SetPos(2,44)
		LUABEE.BlockSelector:SetSize(275,ScrH()-46)
		function LUABEE.BlockSelector:OnMouseWheeled(d)
			self:GetActiveTab():GetPanel():OnMouseWheeled(d)
		end
		for k,v in pairs(LUABEE.CatalogedFunctions) do
			local Canvas = vgui.Create("DPanelList", LUABEE.BlockSelector)
			Canvas:EnableVerticalScrollbar(true)
			--Canvas:SetAutoSize(true)
			Canvas:SetPadding(5)
			Canvas:SetSpacing(2)
			Canvas.ccats = {}
			function Canvas:OnMousePressed()
				local b = LUABEE.TopDropdowns:GetActiveButton()
				if b then
					b:SetSelected(false)
					b.mnu:Hide()
					b:GetParent():SetToggled(false)
				end
			end
			
			for name,library in SortedPairs(v)do
				if name == "__Icon" then continue end
				
				local ccat = vgui.Create("DCollapsibleCategory")
					ccat:SetLabel( name )
					ccat:SetExpanded(false)
					ccat:SetAnimTime(.05)
					function ccat:OnMouseWheeled(d)
						Canvas:OnMouseWheeled(d)
					end
					ccat.Header.DoClick = function()

						ccat:Toggle()
						for k,v in pairs(Canvas.ccats)do
							if v == ccat then continue end
							v:SetExpanded(false)
						end

					end
				
				local plist = vgui.Create("DPanelList")
					plist:SetPadding(5)
					plist:SetSpacing(20)
					plist.H = 0
					
				local c = library.__Color
				for index,func in pairs(library)do
					if index == "__Color" then continue end
					local blk = vgui.Create("CodeBlock")
						func.category = name
						blk:SetColor(c)
						if func.block then
							for k,v in pairs(func.block)do
								blk[k]=v
							end
							blk.m_Constructor = func.block
						end
						if func.func then
							blk:SetFunction(func.func)
						elseif _G[name] then
							if k!="Classes" then
								blk:SetFunction(_G[name][string.Explode(".", func.name)[2]])
							end
						elseif _G[func.name] then
							blk:SetFunction(_G[func.name])
						end
						blk.m_CatalogTable = func
						blk:SetText(func.name)
						blk:SetOutputs(func.returns)
						blk:SetInputs(func.args)
						blk:Activate()
						blk:SetActivated(false)
						function blk:OnMouseWheeled(d)
							Canvas:OnMouseWheeled(d)
						end
					
					plist:AddItem(blk)
					plist.H = plist.H + blk:GetTall() + plist:GetSpacing()
					
				end
				function plist.Think()
					plist:SetSize(ccat:GetWide(), plist.H)
				end
				function plist:OnMouseWheeled(d)
					Canvas:OnMouseWheeled(d)
				end
				
				local w,h = ccat:GetWide(), plist.H
				ccat:SetSize(w,h+ccat.Header:GetTall())
				ccat.Think = function()
					if ccat:GetExpanded() then
						local w,h = ccat:GetWide(), plist.H
						ccat:SetSize(w,h+ccat.Header:GetTall())
					end
					ccat.animSlide:Run()
				end
				ccat:SetContents(plist)
				table.insert(Canvas.ccats, ccat)
				Canvas:AddItem(ccat)
				
				function plist:OnMousePressed()
					local b = LUABEE.TopDropdowns:GetActiveButton()
					if b then
						b:SetSelected(false)
						b.mnu:Hide()
						b:GetParent():SetToggled(false)
					end
				end
				
			end
			
			LUABEE.BlockSelector:AddSheet(k, Canvas, v.__Icon, false, false, k)
		end
	
	LUABEE.FunctionLookup = vgui.Create("DFrame")
		LUABEE.FunctionLookup:SetSize(300,342)
		LUABEE.FunctionLookup:Center()
		LUABEE.FunctionLookup:SetDeleteOnClose(false)
		LUABEE.FunctionLookup:SetTitle("Function Search")
		LUABEE.FunctionLookup:SetDraggable(true)
		LUABEE.FunctionLookup:SetSizable(false)
		LUABEE.FunctionLookup:SetVisible(false)
		local dlist = vgui.Create("DListView", LUABEE.FunctionLookup)
			dlist:SetSize(250,250)
			dlist:SetPos(25,57)
			dlist:AddColumn("Function")
		
		local search = vgui.Create("DTextEntry", LUABEE.FunctionLookup)
			search:SetWide(LUABEE.FunctionLookup:GetWide()-50)
			search:CenterHorizontal()
			search:AlignTop(32)
			search.OnEnter = function(txtbox)
				dlist:DoDoubleClick(1,dlist:GetLine(1))
			end
			search.OnTextChanged = function(txtbox)
				local text = txtbox:GetValue()
				local listitems = {}
				for k,v in pairs(LUABEE.CatalogedFunctions)do
					for k1,v1 in pairs(v)do
						if k1 == "__Icon" then continue end
						for k2,v2 in pairs(v1)do
							if k2 == "__Color" then continue end
							if string.match(v2.name, text) then
								v2.category = k1
								v2.type = k
								table.insert(listitems, v2)
							end
						end
					end
				end
				dlist:Clear()
				for k,v in pairs(listitems)do
					dlist:AddLine(v.name).tbl = v
				end
			end
		
		dlist.DoDoubleClick = function(parent, index, line)
			if not line then return end
			local blk = vgui.Create("CodeBlock",LUABEE.Tabs:GetActiveTab():GetPanel())
			local func = line.tbl
			local name = func.category
			local c = LUABEE.CatalogedFunctions[func.type][name].__Color
			
			blk:SetColor(c)
			if func.block then
				for k,v in pairs(func.block)do
					blk[k]=v
				end
				blk.m_Constructor = func.block
			end
			if func.func then
				blk:SetFunction(func.func)
			elseif _G[name] then
				blk:SetFunction(_G[name][string.Explode(".", func.name)[2]])
			elseif _G[func.name] then
				blk:SetFunction(_G[func.name])
			end
			blk.m_CatalogTable = func
			blk:SetText(func.name)
			blk:SetOutputs(func.returns)
			blk:SetInputs(func.args)
			blk:Activate()
			LUABEE.FunctionLookup:Close()
			timer.Simple(.03, function()
				blk:StartDragging({blk:GetWide()/2, blk:GetTall()/2})
				blk:MouseCapture(true)
			end)
		end
	
	
	function LUABEE.AddTopDropdown(name,tbl)
		
		table.insert(LUABEE.Dropdowns.Buttons, name)
		table.insert(LUABEE.Dropdowns.Menus, tbl)
	end
	LUABEE.AddTopDropdown("File",{
			{"New", function() 
				LUABEE.Tabs:CreateTab("new.lua", "new.lua")
			end},
			{"Run...", function() 
				Derma_Query("Where do you want to run this?", "Run",
				"Clientside", function()	
					RunString(LUABEE.CompileCurrentTab())
				end,
				"Shared", function()
					local c = LUABEE.CompileCurrentTab()
					RunString(c)
					LUABEE.RunServer(c)
				end, 
				"Serverside", function()
					LUABEE.RunServer(LUABEE.CompileCurrentTab())
				end,
				"Cancel",function()
				end)
			end},
			{"Open...", function()
				LUABEE.OpenFileWithBrowser()
			end},
			{"Save", function()
				LUABEE.SaveThis()
			end},
			{"Save As...", function()
				local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
					fb:SetDirectory("Data/Luabee/Saved Files")
					fb:Center()
					fb:SetAction("Save", function(path,name)
						LUABEE.SaveFile(path.."/"..name, LUABEE.CreateFileData(LUABEE.Tabs:GetActiveTab():GetPanel()))
						LUABEE.Tabs:GetActiveTab().SaveDir = path.."/"..name
					end)
			end},
			{"Export", function()
				LUABEE.ExportThis()
			end},
			{"Export As...", function()
				local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
					fb:SetDirectory("Data/Luabee/Saved Files/Compiled Lua")
					fb:Center()
					fb:SetAction("Export", function(path,name)
						LUABEE.SaveCompiledData(LUABEE.CompileCurrentTab(), path.."/"..name)
						LUABEE.Tabs:GetActiveTab().ExportDir = path.."/"..name
					end)
			end},
			{"Close", function() LUABEE.Tabs:CloseTab(LUABEE.Tabs:GetActiveTab(), true) end},
			{"Exit", function() LUABEE.WINDOW:Close() end},
		})
	LUABEE.AddTopDropdown("Edit",{
		{"Undo", LUABEE.Undo},
		{"Redo", LUABEE.Redo},
		{"Delete All", function()
			Derma_Query("Are you sure you want to delete all blocks on this file?", "Delete All",
			"Yes", function()	
				for k,v in pairs(LUABEE.Tabs:GetActiveTab():GetPanel():GetChildren())do 
					if not v.m_Constructor then continue end
					if v.m_CallHook then continue end
					v:Delete()
				end 
			end,
			"No", function() end
			)
		end},
		{"Unlink All", function()
			Derma_Query("Are you sure you want to remove all links on this file?", "Unlink All",
			"Yes", function()	
				for k,v in pairs(LUABEE.Tabs:GetActiveTab():GetPanel():GetChildren())do
					if v.ClearAllLinks then
						v:ClearAllLinks()
					end
				end 
			end,
			"No", function() end
			)
		end},
	})
	LUABEE.AddTopDropdown("View",{
		{"Console...", function() RunConsoleCommand("showconsole") end},
		{"Function search...", function()
			LUABEE.FunctionLookup:SetVisible(true)
			LUABEE.FunctionLookup:MakePopup()
		end},
		{"Jump to call hook", function() 
			LUABEE.JumpToCallHook()
		end},
		{"Jump to point...", function() 
			LUABEE.OpenJumpMenu()
		end},
	})
	LUABEE.AddTopDropdown("Settings",{
		{"Preferences...", function() end},
	})
	LUABEE.AddTopDropdown("Help",{
		{"Tutorials...", function() end},
		{"About...", function()
			Msg([[
===========================[Luabee Info]===========================
||                                                               ||
|| Luabee was developed as an open source project. The goal from ||
|| the start was to make Lua available for every Garry's modder. ||
|| Several people contributed to making Luabee, each of whom was ||
|| given nothing for their volunteer time.                       ||
||                                                               ||
|| In no specific order:                                         ||
|| |TT| Fakerz: http://steamcommunity.com/id/perselaks/          ||
|| Sparkz: http://steamcommunity.com/id/UlrichDude/              ||
|| CDi-Fail: http://steamcommunity.com/profiles/76561198004263412||
||                                                               ||
|| Luabee was envisioned, designed, and developed by:            ||
|| Bobbleheadbob: http://steamcommunity.com/id/bobblackmon/      ||
||                                                               ||
|| Thank you for using Luabee. We hope you have as much fun with ||
|| using it as we did with making it.                            ||
===================================================================
]])
		RunConsoleCommand("showconsole")
		end},
	})

	hook.Add("Think", "LUABEE.DragThink", LUABEE.DragThink)

		
	LUABEE.TopDropdowns = vgui.Create("TopDropdowns", LUABEE.WINDOW)
	
	function LUABEE.WINDOW:OnMousePressed(mc)
		if LUABEE.TopDropdowns:GetActiveButton() then
			local b = LUABEE.TopDropdowns:GetActiveButton()
			b:SetSelected(false)
			b.mnu:Hide()
			b:GetParent():SetToggled(false)
		end
	end
	
	concommand.Add("Luabee", function()
		
		LUABEE.WINDOW:SetVisible(true)
		LUABEE.WINDOW:MakePopup()
		
	end)
	
	print("--> LUABEE Initialized.")

	// Shortened, made iterable - Josh 'Acecool' Moser
	// I'm unsure of your intention with this function, but I did a test and it performed identically for me with no limit of vars.
	function LUABEE.GetValidArgs( ... )
		local _args = { };
		local _input = { ... };

		for i = 1, #_input do
			if ( _input[ i ] ) then
				table.insert( _args, _input[ i ] );
			else
				break;
			end
		end

		return unpack( _args );
	end
end)

function LUABEE.OpenJumpMenu()
	local f = vgui.Create("DFrame", LUABEE.WINDOW)
	f:SetSize(200,172)
	f:Center()
	f:SetDeleteOnClose(true)
	f:SetTitle("Jump to Point")
	f:MakePopup()
	
	local x = vgui.Create("DNumberWang",f)
	x:CenterVertical()
	local w = x:GetWide()
	x:AlignLeft(100-w-10)
	
	local y = vgui.Create("DNumberWang",f)
	y:CenterVertical()
	w = y:GetWide()
	y:AlignLeft(100+10)
	
	local jump = vgui.Create("DButton", f)
	jump:CenterHorizontal()
	jump:AlignBottom(30)
	jump:SetText("Go")
	function jump:DoClick()
		local pnl = LUABEE.Tabs:GetActiveTab():GetPanel()
		local x2,y2 = x:GetValue(), y:GetValue()
		pnl:JumpToPoint(x2+50,y2+50,true)
		f:Close()
	end
end

function LUABEE.JumpToCallHook()
	local pnl = LUABEE.Tabs:GetActiveTab():GetPanel()
	local x,y = pnl.CallHook:GetPos()
	local w,h = pnl.CallHook:GetSize()
	pnl:JumpToPoint(x+w/2,y+h/2,true)
end

// Shortened - Josh 'Acecool' Moser
// http://www.lua.org/pil/20.2.html
// Caps = Inverse, so W strips all NON alpha-numeric
function string.Safe( text )
	text = string.gsub( text, "%W", "_" ); // gsub returns :: text, replacementsDone - print( gsub ) == "text	0"
	return text;
end

function LUABEE.RunServer(c)
	net.Start("Luabee_Code")
		net.WriteString(c)
	net.SendToServer()
end

function LUABEE.ExportThis()
	if LUABEE.Tabs:GetActiveTab().ExportDir then
		LUABEE.SaveCompiledData(LUABEE.CompileCurrentTab(), LUABEE.Tabs:GetActiveTab().ExportDir)
	else
		local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
			fb:SetDirectory("Data/Luabee/Saved Files")
			fb:Center()
			fb:SetAction("Export", function(path,name)
				LUABEE.SaveCompiledData(LUABEE.CompileCurrentTab(), path.."/"..name)
				LUABEE.Tabs:GetActiveTab().ExportDir = path.."/"..name
			end)
	end
end

function LUABEE.SaveThis()
		if LUABEE.Tabs:GetActiveTab().SaveDir then
			LUABEE.SaveFile( LUABEE.Tabs:GetActiveTab().SaveDir, LUABEE.CreateFileData(LUABEE.Tabs:GetActiveTab():GetPanel()))
		else
			local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
				fb:SetDirectory("Data/Luabee/Saved Files")
				fb:Center()
				fb:SetAction("Save", function(path,name)
					LUABEE.SaveFile(path.."/"..name, LUABEE.CreateFileData(LUABEE.Tabs:GetActiveTab():GetPanel()))
					LUABEE.Tabs:GetActiveTab().SaveDir = path.."/"..name
				end)
		end
end

function LUABEE.OpenFileWithBrowser()
	local fb = vgui.Create("FileBrowser", LUABEE.WINDOW)
		fb:SetDirectory("Data/Luabee/Saved Files")
		fb:Center()
		fb.m_NameBox:SetValue("")
		fb:SetAction("Open", function(path,name)
			LUABEE.OpenFile(path, name)
		end)
end

function LUABEE.Undo()
	local self = LUABEE.Tabs:GetActiveTab()
	if #self.m_History == 0 then return end
	
	self.m_HistoryPoint = math.max(self.m_HistoryPoint - 1, 1)
	
	local h = self.m_History[self.m_HistoryPoint]
	local name = "new.lua"
	for k, v in pairs( LUABEE.Tabs.Items ) do
		if ( v.Tab != tab ) then continue end
		name = v.Name
	end
	local hist = self.m_History
	local hp = self.m_HistoryPoint
	
	LUABEE.Tabs:CloseTab(self,true)
	local new = LUABEE.OpenFileData(name,h)
	new.m_History = hist
	new.m_HistoryPoint = hp
	
end

function LUABEE.Redo()
	local self = LUABEE.Tabs:GetActiveTab()
	if #self.m_History == 0 then return end
	if #self.m_History == self.m_HistoryPoint then return end
	self.m_HistoryPoint = math.min(self.m_HistoryPoint + 1, #self.m_History)
	
	local h = self.m_History[self.m_HistoryPoint]
	local name = "new.lua"
	for k, v in pairs( LUABEE.Tabs.Items ) do
		if ( v.Tab != tab ) then continue end
		name = v.Name
	end
	local hist = self.m_History
	local hp = self.m_HistoryPoint
	
	LUABEE.Tabs:CloseTab(self,true)
	local new = LUABEE.OpenFileData(name,h)
	new.m_History = hist
	new.m_HistoryPoint = hp
	
end

function LUABEE.AddHistoryPoint()
	local self = LUABEE.Tabs:GetActiveTab()
	for k,v in ipairs(self.m_History)do
		if k > self.m_HistoryPoint then
			self.m_History[k]=nil
		end
	end
	table.insert(self.m_History, LUABEE.CreateFileData(self:GetPanel(),true))
	self.m_HistoryPoint = self.m_HistoryPoint + 1
	
	if LUABEE.Config.Debug:GetBool() then
		print("--> LUABEE: Added history point.")
		debug.Trace()
		PrintTable(self.m_History)
		print("\nHistoryPoint:", self.m_HistoryPoint)
	end
end
