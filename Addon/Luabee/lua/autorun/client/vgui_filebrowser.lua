

local PANEL = {}

AccessorFunc(PANEL, "m_ActionName", "ActionName", FORCE_STRING)
AccessorFunc(PANEL, "m_Action", "Action")
AccessorFunc(PANEL, "m_Directory", "Directory", FORCE_STRING)
AccessorFunc(PANEL, "m_History", "History")
AccessorFunc(PANEL, "m_HistoryPoint", "HistoryPoint", FORCE_NUMBER)

function PANEL:Init()

	self:SetFocusTopLevel( true )

	-- self:SetCursor( "sizeall" )

	self:SetPaintShadow( true )

	self.btnClose = vgui.Create( "DButton", self )
	self.btnClose:SetText( "" )
	self.btnClose.DoClick = function ( button ) self:Close() end
	self.btnClose.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowCloseButton", panel, w, h ) end

	self.btnMaxim = vgui.Create( "DButton", self )
	self.btnMaxim:SetText( "" )
	self.btnMaxim.DoClick = function ( button ) self:Close() end
	self.btnMaxim.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMaximizeButton", panel, w, h ) end
	self.btnMaxim:SetDisabled( true )

	self.btnMinim = vgui.Create( "DButton", self )
	self.btnMinim:SetText( "" )
	self.btnMinim.DoClick = function ( button ) self:Close() end
	self.btnMinim.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "WindowMinimizeButton", panel, w, h ) end
	self.btnMinim:SetDisabled( true )

	self.lblTitle = vgui.Create( "DLabel", self )
	self.lblTitle.UpdateColours = function( label, skin )

	if ( self:IsActive() ) then return label:SetTextStyleColor( skin.Colours.Window.TitleActive ) end

	return label:SetTextStyleColor( skin.Colours.Window.TitleInactive )

	end
	
	self:SetScreenLock( true )
	self:SetDeleteOnClose( true )
	self:SetTitle( "Luabee File Browser" )

	self:SetMinWidth( 50 );
	self:SetMinHeight( 50 );

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )
	
	self:SetSize(500,300)
	self:SetPos(0,0)
	self:SetSizable(false)
	self:SetBackgroundBlur(true)
	self:SetDraggable(true)
		
	self.m_PathBox = vgui.Create("DTextEntry", self)
		self.m_PathBox:SetValue("Data/Luabee/Saved Files")
		self.m_PathBox:SetPos(56, 22+5)
		self.m_PathBox:SetWide(300)
		self.m_PathBox.OnEnter = function(s)
			self:SetDirectory(s:GetValue())
		end
		
	self.m_FileList = vgui.Create("DListView", self)
		self.m_FileList:SetMultiSelect(false)
		self.m_FileList:SetSize(self:GetWide()-20,214)
		self.m_FileList:CenterVertical()
		self.m_FileList:AlignLeft(10)
		local x,y = self.m_FileList:GetPos()
		self.m_FileList:SetPos(x,y+8)
		self.m_FileList:AddColumn("Name")
		self.m_FileList:AddColumn("Type"):SetFixedWidth(50)
		self.m_FileList.OnRowSelected = function(s,line)
			local name, Type = s:GetLine(line):GetValue(1), s:GetLine(line):GetValue(2)
			if Type == "file" then
				self.m_NameBox:SetValue(name)
				self.m_NameBox:SelectAllOnFocus()
			end
		end
		self.m_FileList.DoDoubleClick = function(s,i,line)
			local name, Type = line:GetValue(1), line:GetValue(2)
			if Type == "file" then
				self:PerformAction()
			else
				self:SetDirectory(self:GetDirectory().."/"..name)
			end
		end
		self.m_FileList.OnRowRightClick = function(s,i)
			local line = s:GetLine(i)
			local opt=DermaMenu()
			
			if line:GetValue(2) == "file" then
				opt:AddOption(self.m_ActionName, function()
					self:PerformAction()
				end)
			end
			if line:GetValue(2) == "file" then
				opt:AddOption("Rename", function() 
					Derma_StringRequest("Name your file.", "Rename", line:GetValue(1), function(text)
						local d = file.Read(self.m_Directory.."/"..line:GetValue(1), "GAME")
						file.Delete(string.Replace(self.m_Directory, "Data/", "").."/"..line:GetValue(1))
						file.Write(string.Replace(self.m_Directory, "Data/", "").."/"..string.Safe(string.Replace(text,".txt",""))..".txt", d)
						self:Refresh()
					end)
				end)
			end
			if line:GetValue(2) == "file" then
				opt:AddOption("Delete", function() 
					Derma_Query("Are you sure you want to delete this file?", "Delete","Yes", function()
						file.Delete(string.Replace(self.m_Directory, "Data/", "").."/"..line:GetValue(1))
						self:Refresh()
					end,
					"Cancel", function()
					end)
				end)
			end
			opt:AddSpacer()
			opt:AddOption("New Folder", function()self:NewFolder()end)
			opt:Open()
		end
		
	self.m_BackButton = vgui.Create("DImageButton", self)
		self.m_BackButton:SetPos(10, 22+5)
		self.m_BackButton:SetImage("VGUI/Luabee/Back_Arrow.png")
		self.m_BackButton:SetSize(20,20)
		self.m_BackButton.DoClick = function(s)
			s:DoDoubleClick()
			self:Back()
		end
		
	self.m_ForwardButton = vgui.Create("DImageButton", self)
		self.m_ForwardButton:SetPos(31, 22+5)
		self.m_ForwardButton:SetImage("VGUI/Luabee/Forward_Arrow.png")
		self.m_ForwardButton:SetSize(20,20)
		self.m_ForwardButton.DoClick = function(s)
			s:DoDoubleClick()
			self:Forward()
		end
		
	self.m_UpButton = vgui.Create("DImageButton", self)
		self.m_UpButton:SetPos(5+300+55, 22+5)
		self.m_UpButton:SetImage("VGUI/Luabee/Up_Folder.png")
		self.m_UpButton:SetSize(20,20)
		self.m_UpButton.DoClick = function(s)
			s:DoDoubleClick()
			self:Up()
		end
		
	self.m_NewFolderButton = vgui.Create("DImageButton", self)
		self.m_NewFolderButton:SetPos(5+300+55+25, 22+5)
		self.m_NewFolderButton:SetImage("VGUI/Luabee/New_Folder.png")
		self.m_NewFolderButton:SetSize(20,20)
		self.m_NewFolderButton.DoClick = function(s)
			s:DoDoubleClick()
			self:NewFolder()
		end
		
	self.m_NameLabel = vgui.Create("DLabel", self)
		self.m_NameLabel:SetText("File Name:")
		self.m_NameLabel:SizeToContents()
		self.m_NameLabel:AlignBottom(13)
		self.m_NameLabel:AlignLeft(12)
	
	self.m_NameBox = vgui.Create("DTextEntry", self)
		self.m_NameBox:SetValue("new.txt")
		self.m_NameBox:AlignBottom(10)
		self.m_NameBox:AlignLeft(70)
		self.m_NameBox:SetWide(280)
		self.m_NameBox:SetTall(23)
		self.m_NameBox:SelectAllOnFocus()
		
	self.m_ActionButton = vgui.Create("DButton", self)
		self.m_ActionButton:SetText("Open")
		self.m_ActionButton:AlignBottom(8)
		self.m_ActionButton:AlignLeft(355)
		self.m_ActionButton.DoClick = function(s)
			self:PerformAction()
		end
	
	self.m_CancelButton = vgui.Create("DButton", self)
		self.m_CancelButton:SetText("Cancel")
		self.m_CancelButton:AlignBottom(8)
		self.m_CancelButton:AlignRight(10)
		self.m_CancelButton.DoClick = function(s)
			self:Close()
		end
		
	self.m_History = {}
	self.m_HistoryPoint = 0
end

function PANEL:Refresh()
	self.m_FileList:Clear()
	local files, dirs = file.Find(self.m_Directory.."/*", "GAME")
	for k,v in SortedPairs(dirs)do
		self.m_FileList:AddLine(v,"folder")
	end
	for k,v in SortedPairs(files)do
		self.m_FileList:AddLine(v,"file")
	end
end

function PANEL:SetDirectory(directory,bBackForward)
	if (not (string.Left(directory, 23) == "Data/Luabee/Saved Files")) or (not (string.len(directory)>=23)) or (not (file.Exists(directory, "GAME"))) then 
		self:SetDirectory("Data/Luabee/Saved Files") 
		return
	end
	self.m_PathBox:SetText(directory)
	directory = string.Trim(directory, "/")
	self.m_Directory = directory
	self:Refresh()
	if not bBackForward then
		for k,v in ipairs(self.m_History)do
			if k > self.m_HistoryPoint then
				self.m_History[k]=nil
			end
		end
		table.insert(self.m_History, directory)
		self.m_HistoryPoint = self.m_HistoryPoint + 1
	end
end

function PANEL:Back()
	if #self.m_History == 0 then return end
	self.m_HistoryPoint = math.max(self.m_HistoryPoint - 1, 1)
	self:SetDirectory(self.m_History[self.m_HistoryPoint], true)
end
function PANEL:Forward()
	if #self.m_History == 0 then return end
	if #self.m_History == self.m_HistoryPoint then return end
	self.m_HistoryPoint = math.min(self.m_HistoryPoint + 1, #self.m_History)
	self:SetDirectory(self.m_History[self.m_HistoryPoint], true)
end
function PANEL:Up()
	local dir = string.Explode("/", string.Trim(self.m_Directory,"/"))
	dir[#dir]=nil
	dir = table.concat(dir,"/")
	self:SetDirectory(dir)
end

function PANEL:NewFolder()
	Derma_StringRequest("New Folder", "Name your folder.", "New Folder", function(text)
		file.CreateDir(string.Replace(self.m_Directory, "Data/", "").."/"..string.Safe(text))
		self.m_FileList:Clear()
		local files, dirs = file.Find(self.m_Directory.."/*", "GAME")
		for k,v in SortedPairs(dirs)do
			self.m_FileList:AddLine(v,"folder")
		end
		for k,v in SortedPairs(files)do
			self.m_FileList:AddLine(v,"file")
		end
	end)
end

function PANEL:PerformAction()
	local v = self.m_NameBox:GetValue()
	if string.Right(v, 4) != ".txt" then
		self.m_NameBox:SetValue(v..".txt")
	end
	local val = string.Replace(self.m_PathBox:GetValue(), "Data/", "")
	val = string.Replace(val, "//", "/")
	self.m_Action(val, self.m_NameBox:GetValue())
	self:Close()
end

function PANEL:SetAction(act_name, func)
	self:SetActionName(act_name)
	self.m_Action = func
	self.m_ActionButton:SetText(act_name)
end

vgui.Register("FileBrowser", PANEL, "DFrame")

