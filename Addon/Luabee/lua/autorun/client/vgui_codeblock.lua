
local PANEL = {}

AccessorFunc( PANEL, "m_Inputs", "Inputs" )
AccessorFunc( PANEL, "m_Outputs", "Outputs" ) 
AccessorFunc( PANEL, "m_Func", "Function" )
AccessorFunc( PANEL, "m_Color", "Color" )
AccessorFunc( PANEL, "m_DrawColor", "DrawColor" )
AccessorFunc( PANEL, "m_HilightedColor", "HilightedColor" )
AccessorFunc( PANEL, "m_Text", "Text", FORCE_STRING )
AccessorFunc( PANEL, "m_IsUserDefined", "UserDefined", FORCE_BOOL )
AccessorFunc( PANEL, "m_Dragging", "Dragging", FORCE_BOOL )
AccessorFunc( PANEL, "m_DragOffset", "DragOffset" )
AccessorFunc( PANEL, "m_TopButton", "TopButton" )
AccessorFunc( PANEL, "m_BottomButton", "BottomButton" )
AccessorFunc( PANEL, "m_InputButtons", "InputButtons" )
AccessorFunc( PANEL, "m_OutputButtons", "OutputButtons" )
AccessorFunc( PANEL, "m_CallHook", "CallHook", FORCE_BOOL )
AccessorFunc( PANEL, "m_IsHook", "Hook", FORCE_BOOL )
AccessorFunc( PANEL, "m_Activated", "Activated", FORCE_BOOL )
AccessorFunc( PANEL, "m_Constructor", "Constructor")
AccessorFunc( PANEL, "m_CompileString", "CompileString", FORCE_STRING)
AccessorFunc( PANEL, "m_CompileOrder", "CompileOrder")
AccessorFunc( PANEL, "m_IsClass", "IsClass", FORCE_BOOL)
 
Z_POS = {}
Z_POS.MAX = 0
Z_POS.MIN = -1

/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function PANEL:Init()
 
	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetFont( "DermaDefaultBold" )
	
	self.m_Inputs = {} 
	self.m_Outputs = {}
	self:SetColor( Color( 50, 205, 255, 255 ) )
	
	self.m_InputButtons = {}
	self.m_OutputButtons = {}
	
	table.insert(LUABEE.ALL_CODE_BLOCKS, self)
	
	self:PerformLayout()
	
	self.m_LastClicked = 0
	
	self.m_DragOffset = {}
	
	self.m_CallHook = false
	self.m_IsHook = false
	
	self:SetCursor("sizeall")
	
	self:SetActivated(false)
	
	self.m_Constructor = {}
	self.m_CompileOrder = {}
	
end

function PANEL:ChainDelete()
	for k,v in pairs(self.m_InputButtons)do
		if v:GetInputter() then
			v:GetInputter():GetParent():ChainDelete()
		end
	end
	if self.m_BottomButton then
		if self.m_BottomButton:GetInputter() then
			self.m_BottomButton:GetInputter():GetParent():ChainDelete()
		end
	end
	self:Delete()
end

function PANEL:Delete()
	LUABEE.AddHistoryPoint()
	self:ClearAllLinks()
	self:Remove()
end

function PANEL:OpenInfo()
	local info = vgui.Create("DFrame")
	info:SetSize(ScrW()*(2/3), ScrH()*(2/3))
	info:Center()
	info:SetDeleteOnClose(true)
	info:SetDraggable(true)
	info:SetSizable(false)
	info:SetVisible(true)
	info:SetTitle("Function Info")
	local RealmLabel = vgui.Create("DLabel", info)
		RealmLabel:SetFont("DermaLarge")
	local CategoryLabel = vgui.Create("DLabel", info)
		CategoryLabel:SetFont("DermaLarge")
	local FuncName = {}
		FuncName.Box = vgui.Create("DPanel", info)
			FuncName.Box.Paint = function(s)
				draw.RoundedBox(4, 0, 0, s:GetWide(), s:GetTall(), Color(0,0,0,150))
			end
		FuncName.Label = vgui.Create("DLabel", FuncName.Box)
			FuncName.Label:SetFont("DermaLarge")
	local Info = {}
		Info.Box = vgui.Create("DPanel", info)
			Info.Box.Paint = function(s)
				draw.RoundedBox(4, 0, 0, s:GetWide(), s:GetTall(), Color(0,0,0,150))
			end
			Info.Box:SetSize(info:GetWide()/2,info:GetTall()/2)
			Info.Box:Center()
		Info.Text = vgui.Create("DLabel", Info.Box)
			Info.Text:SetFont("HUDHintTextLarge")
		Info.Title = vgui.Create("DLabel", info)
			Info.Title:SetFont("DermaLarge")
			Info.Title:SetText("Description:")
			Info.Title:SizeToContents()
			
	local Returns = {}
		Returns.Box = vgui.Create("DListView", info)
			Returns.Box:SetSize(200, 100)
			Returns.Box:CenterVertical()
			Returns.Box:AlignLeft((info:GetWide()/8)-Returns.Box:GetWide()/2)
			Returns.Box:AddColumn(" # "):SetFixedWidth(25)
			Returns.Box:AddColumn("Name")
		Returns.Text = vgui.Create("DLabel", info)
			Returns.Text:SetFont("DermaLarge")
			Returns.Text:SetText("Returns:")
			Returns.Text:SizeToContents()
			Returns.Text:AlignLeft((info:GetWide()/8)-Returns.Text:GetWide()/2)
			local x,y = Returns.Box:GetPos()
			Returns.Text:AlignTop(y-Returns.Text:GetTall()-5)
			x,y = Returns.Text:GetPos()
			
	local Args = {}
		Args.Box = vgui.Create("DListView", info)
			Args.Box:SetSize(200, 100)
			Args.Box:CenterVertical()
			Args.Box:AlignRight((info:GetWide()/8)-Args.Box:GetWide()/2)
			Args.Box:AddColumn(" # "):SetFixedWidth(25)
			Args.Box:AddColumn("Name")
		Args.Text = vgui.Create("DLabel", info)
			Args.Text:SetFont("DermaLarge")
			Args.Text:SetText("Args:")
			Args.Text:SizeToContents()
			Args.Text:AlignRight((info:GetWide()/8)-Args.Text:GetWide()/2)
			local x,y = Args.Box:GetPos()
			Args.Text:AlignTop(y-Args.Text:GetTall()-5)
			x,y = Args.Text:GetPos()
			
	local Buttons = {}
		Buttons.Place = vgui.Create("DButton", info)
			Buttons.Place:SetSize(info:GetWide()*(2/9), 60)
			Buttons.Place:SetFont("DermaLarge")
			Buttons.Place:SetText("Place")
			Buttons.Place.DoClick = function()
				self:Duplicate(LUABEE.Tabs:GetActiveTab():GetPanel())
				info:Close()
			end
		Buttons.Modify = vgui.Create("DButton", info)
			Buttons.Modify:SetSize(info:GetWide()*(4/9), 60)
			Buttons.Modify:SetFont("DermaLarge")
			Buttons.Modify:SetText("Modify")
			Buttons.Modify.DoClick = function()
				self:Modify()
				info:Close()
			end
	info.m_Function = self.m_CatalogTable
	local f = self.m_CatalogTable
	RealmLabel:SetText(f.realm)
	RealmLabel:SizeToContents()
	RealmLabel:AlignLeft(42+(RealmLabel:GetTall()/2))
	RealmLabel:AlignTop(42+(RealmLabel:GetTall()/2))
	CategoryLabel:SetText(f.category)
	CategoryLabel:SizeToContents()
	CategoryLabel:AlignRight(42+(CategoryLabel:GetTall()/2))
	CategoryLabel:AlignTop(42+(CategoryLabel:GetTall()/2))
	FuncName.Label:SetText(f.name)
	FuncName.Label:SizeToContents()
	local w,h = FuncName.Label:GetSize()
	FuncName.Box:SetSize(w+10,h+10)
	FuncName.Box:AlignTop(42-5)
	FuncName.Box:CenterHorizontal()
	x,y = FuncName.Box:GetPos()
	FuncName.Label:Center()
	FuncName.Box:SetPos(x-5,y)
	Info.Text:SetText(f.desc)
	Info.Text:SizeToContents()
	Info.Text:SetPos(10,10)
	x,y = Info.Box:GetPos()
	Info.Title:SetPos(x,y-5-Info.Title:GetTall())
	for k,v in ipairs(f.returns)do
		Returns.Box:AddLine(k,v)
	end
	for k,v in ipairs(f.args)do
		Args.Box:AddLine(k,v)
	end
	if f.userdefined then
		Buttons.Place:AlignBottom(15)
		Buttons.Place:CenterHorizontal()
		x,y = Buttons.Place:GetPos()
		w = Buttons.Place:GetWide()
		Buttons.Place:SetPos(x-(w/2)-10, y)
		Buttons.Place:AlignBottom(15)
		Buttons.Modify:CenterHorizontal()
		x,y = Buttons.Modify:GetPos()
		w = Buttons.Modify:GetWide()
		Buttons.Modify:SetPos(x+(w/2)+10, y)
		Buttons.Modify:SetVisible(true)
	else
		Buttons.Place:CenterHorizontal()
		Buttons.Place:AlignBottom(15)
		Buttons.Modify:SetVisible(false)
		if f.callhook then
			Buttons.Place:SetVisible(false)
		end
	end
	
	info:MakePopup()
end

function PANEL:OnLinked(button)
end
function PANEL:OnLinkRemoved(button)
end

function PANEL:Modify()--Only call if this is a user-defined function.
	
end

function PANEL:ChainDuplicate()
	for k,v in pairs(self.m_InputButtons)do
		if v:GetInputter() then
			v:GetInputter():GetParent():ChainDuplicate()
		end
	end
	if self.m_BottomButton then
		if self.m_BottomButton:GetInputter() then
			self.m_BottomButton:GetInputter():GetParent():ChainDuplicate()
		end
	end
	timer.Simple(.1, function()
		local newself = self:Duplicate(self:GetParent()) --TODO: Create new links.
	end)
	-- for k,v in pairs(self.m_InputButtons)do
		-- if v:GetInputter() then
			-- newself.m_InputButtons[k]:Link(v:GetInputter())
		-- end
	-- end
end

function PANEL:Duplicate(parent)
	LUABEE.AddHistoryPoint()
	local block = vgui.Create("CodeBlock", parent)
	
	for k,v in pairs(self.m_Constructor)do
		block[k]=v
	end
	
	block.m_Constructor = self.m_Constructor
	block.m_CatalogTable = self.m_CatalogTable
	
	block:SetColor(self:GetColor())
	block:SetPos(gui.MousePos())
	block:SetFunction(self:GetFunction())
	block:SetOutputs(self:GetOutputs())
	block:SetInputs(self:GetInputs())
	block:SetText(self:GetText())
	block:SetUserDefined(self:GetUserDefined())
	block:Activate()
	
	for k,v in pairs(self:GetChildren())do
		if v.m_IsInput then
			for k1,v1 in pairs(block:GetChildren())do
				if v1.m_IsInput then
					v1:SetValue(v:GetValue())
				end
			end
		end
	end
	
	timer.Simple(.001, function()
		block:StartDragging({block:GetWide()/2, block:GetTall()/2})
	end)
	return block
end

function PANEL:DoubleClicked()--always left click.
	LUABEE.AddHistoryPoint()
	self:ClearAllLinks()
end

function PANEL:ClearAllLinks()
	for k,v in pairs(self.m_InputButtons)do --clear inputs and outputs
		v:ClearInputs()
		v:ClearOutputs()
	end
	for k,v in pairs(self.m_OutputButtons)do
		v:ClearInputs()
		v:ClearOutputs()
	end
	if self.m_TopButton then
		self.m_TopButton:ClearInputs()
		self.m_TopButton:ClearOutputs()
	end
	if self.m_BottomButton then
		self.m_BottomButton:ClearInputs()
		self.m_BottomButton:ClearOutputs()
	end
end

function PANEL:OnMousePressed(mc)
	if self:GetActivated() then
		if mc == MOUSE_LEFT then
			if self.m_LastClicked >= (CurTime()-.3) then --double clicked
				self:DoubleClicked()
			else
				self.m_LastClicked = CurTime()
				if input.IsKeyDown(KEY_SPACE) then
					self:GetParent():StartDragging()
				else
					self:StartDragging()
					
					LUABEE.AddHistoryPoint()
				end
			end
			if LUABEE.TopDropdowns:GetActiveButton() then
				local b = LUABEE.TopDropdowns:GetActiveButton()
				b:SetSelected(false)
				b.mnu:Hide()
				b:GetParent():SetToggled(false)
			end
		else
			if not self:GetDragging() then
				local dmenu = DermaMenu()
				dmenu:AddOption("Run", function() self:NewRun() end)
				if not self:GetCallHook() then
					dmenu:AddSpacer()
					dmenu:AddOption("Duplicate", function() self:Duplicate(self:GetParent()) end)
					dmenu:AddOption("Chain Duplicate", function() self:ChainDuplicate(self:GetParent()) end)
					dmenu:AddSpacer()
				end
				if self:GetUserDefined() then
					dmenu:AddOption("Modify", function() self:Modify() end)
				end
				if not self:GetCallHook() then
					dmenu:AddSpacer()
					dmenu:AddOption("Delete", function() self:Delete() end)
					dmenu:AddOption("Chain Delete", function() self:ChainDelete() end)
					dmenu:AddSpacer()
				end
				dmenu:AddSpacer()
				dmenu:AddOption("About", function() self:OpenInfo() end)
				dmenu:AddSpacer()
				dmenu:AddOption("Cancel", function() end)
				dmenu:Open()
			end
		end
	else
		if mc == MOUSE_LEFT then
			local new = self:Duplicate(LUABEE.WINDOW)
			new:SetPos(self:LocalToScreen(self:GetPos()))
			new:StartDragging()
		else
			local dmenu = DermaMenu()
			if self:GetUserDefined() then
				dmenu:AddOption("Modify", function() self:Modify() end)
			end
			dmenu:AddSpacer()
			dmenu:AddOption("About", function() self:OpenInfo() end)
			dmenu:AddSpacer()
			dmenu:AddOption("Cancel", function() end)
			dmenu:Open()
		end
	end
end

function PANEL:OnMouseReleased()
	if self:GetActivated() then
		self:SetParent(LUABEE.Tabs:GetActiveTab():GetPanel())
		local ox,oy = self:GetDragOffset()[1] or 0, self:GetDragOffset()[2] or 0
		local mx,my = self:GetParent():ScreenToLocal(gui.MousePos())
		self:SetPos(mx-ox,my-oy)
		
		self:StopDragging()
		if self:GetParent().StopDragging then
			self:GetParent():StopDragging()
		end
	end
end

function PANEL:Think()
	
	if self.m_Dragging then
		local ox,oy = self:GetDragOffset()[1], self:GetDragOffset()[2]
		local mx,my =  self:GetParent():ScreenToLocal(gui.MousePos())
		self:SetPos(mx-ox,my-oy)
	end
	
	if self:IsHovered() then
		self:SetDrawColor(self:GetHilightedColor())
	else
		self:SetDrawColor(self:GetColor())
	end
	
end

function PANEL:StartDragging(t)
	self.m_Dragging = true
	self:MouseCapture(true)
	self:MoveToFront()
	if not t then
		local mx,my = self:ScreenToLocal(gui.MousePos())
		self:SetDragOffset({mx,my})
	else
		self:SetDragOffset(t)
	end
end

function PANEL:StopDragging()
	self.m_Dragging = false
	self:MouseCapture(false)
end

function PANEL:SetCallHook(b)
	self.m_CallHook = b
	self:SetHook(b)
end

function PANEL:SetInputs( t )
	if not type(t) == "table" then t = {} end
	self.m_Inputs = t
end 

function PANEL:SetOutputs( t )
	if not type(t) == "table" then t = {} end
	self.m_Outputs = t
end

function PANEL:UpdateSize()
	local w,h = 20, 40
	local ew = 0
	if #self:GetOutputs() != 0 then
		ew = 20
	end
	if #self:GetInputs() != 0 then
		w = w + 20
	else
		w=w+ew
	end
	if #self:GetInputs() <= 1 and #self:GetOutputs() == 0 then
		h=h+30
	end
	
	local i 
	if #self:GetOutputs() > #self:GetInputs() then
		i = #self:GetOutputs()
	else
		i = #self:GetInputs()
	end
	h = h + (math.max(i-1,0)*20)+(i*20)
	
	local txtsize = 0
	for k,v in pairs(self:GetInputs())do
		surface.SetFont("DefaultSmall")
		local w2, h2 = surface.GetTextSize(v)
		if w2 > txtsize then txtsize = w2 end
	end
	for k,v in pairs(self:GetOutputs()) do
		surface.SetFont("DefaultSmall")
		local w2, h2 = surface.GetTextSize(v)
		if w2 > txtsize then txtsize = w2 end
	end
	if math.Round(txtsize/2) != txtsize/2 then
		txtsize = txtsize + 1
	end
	w = w+txtsize+2
	
	txtsize = self.Label:GetSize()
	if math.Round(txtsize/2) != txtsize/2 then
		txtsize = txtsize + 6
	end
	w = w+txtsize+40
	if math.Round(w/2) != w/2 then
		w=w+1
	end
	if math.Round(h/2) != h/2 then
		h=h+1
	end
	
	self:SetSize(w,h)
end

function PANEL:GetX()
	local x,y = self:GetPos()
	return x
end

function PANEL:GetY()
	local x,y = self:GetPos()
	return y
end

function PANEL:SetX(i)
	local x,y = self:GetPos()
	self:SetPos(i,y)
end

function PANEL:SetY(i)
	local x,y = self:GetPos()
	self:SetPos(x,i)
end

function PANEL:SendToBack()
	self:MoveToBack()
end

function PANEL:SetColor(c)
	self.m_Color = c
	self.m_DrawColor = c
	self.m_HilightedColor = Color(c.r*1.2,c.g*1.2,c.b*1.2,c.a)
	if c.r+c.g+c.b < 140 then
		self.LabelCol = Color(255,255,255)
		self.Label:SetTextColor(Color(0,0,0,255))
	else
		self.LabelCol = Color(0,0,0)
		self.Label:SetTextColor(Color(255,255,255,255))
	end
end
 
function PANEL:Activate()--Called to initialize the buttons and whatnot.
	self:PerformLayout()
	local inputs, outputs = self:GetInputs(), self:GetOutputs()
	
	local num = #inputs
	local max = (20*num)+(20*math.max(num-1,0))
	local x2,y2
	local w,h = self:GetSize()
	
	self.m_InputButtons = {}
	self.m_OutputButtons = {}
	
	for i,v in ipairs(inputs)do
		x2,y2 = w-20, (20*i)+(20*math.max(i-1,0))+((h-max)/2)-20
		local b = vgui.Create("BlockButton", self)
		b:SetPos(x2,y2)
		b:SetType(LUABEE_INPUT)
		table.insert(self.m_InputButtons, b)
	end
	
	if #outputs != 0 then
	
		num = #outputs
		max = (20*num)+(20*math.max(num-1,0))
		for i,v in ipairs(outputs)do
			x2,y2 = 0, (20*i)+(20*math.max(i-1,0))+((h-max)/2)-20
			local b = vgui.Create("BlockButton", self)
			b:SetPos(x2,y2)
			b:SetType(LUABEE_OUTPUT)
			table.insert(self.m_OutputButtons, b)
		end
		
	else
		
		if !self:GetHook() then
			local b = vgui.Create("BlockButton", self)
			b:SetPos(self:GetWide()/2-10, 0)
			b:SetType(LUABEE_TOP)
			self.m_TopButton = b
		end
		
		local b = vgui.Create("BlockButton", self)
		b:SetPos(self:GetWide()/2-10,self:GetTall()-20)
		b:SetType(LUABEE_BOTTOM)
		self.m_BottomButton = b
		
	end
	
	if self.m_CatalogTable.IsClass then
		self.m_IsClass = true
	else
		self.m_IsClass = false
	end
	
	self:SetActivated(true)
	
end

function PANEL:GenerateCompileString()
	local str
	if not self.m_IsClass then
		str = self:GetText().."( "
		for k,v in ipairs(self.m_InputButtons)do
			str = str.."%s, "
		end
		str = str..")"
	else
		-- Panel:SetSize(100,1000) for example.
		--str = [[FindMetaTable("]]..string.Explode(":", self:GetText())[1]..[["):]]..string.Explode(":", self:GetText())[2]
		str = "(%s):"..string.Explode(":", self:GetText())[2].."("
		for i=2, #self.m_InputButtons do
			str = str.."%s, "
		end
		str = str..")"
	end
	
	return string.Replace( str, "%s, )", "%s )" )
end

function PANEL:Compile()
	self:SetCompileOrder(self.m_InputButtons)
	self:SetCompileString(self:GenerateCompileString())
	LUABEE.CompileLog(self:GetCompileString(), 1)
	local s = {}
	for k,v in ipairs(self:CompileChildren())do
		s[k] = tostring(v)
	end
	local fin = string.format(self.m_CompileString, LUABEE.GetValidArgs(s[1],s[2],s[3],s[4],s[5],s[6],s[7],s[8],s[9],s[10],s[11],s[12],s[13],s[14],s[15],s[16],s[17],s[18],s[19],s[20]))
	if !fin or fin=="" then
		LUABEE.CompileLog("ERROR: A compile string was nil --> '"..fin.."'", 3)
	end
	if self.m_BottomButton and not self.m_OutputButtons[1] then
		if self.m_BottomButton:GetInputter() then
			fin=fin.."\n"..self.m_BottomButton:GetInputter():GetParent():Compile()
		end
	end
	LUABEE.CompileLog(fin, 2)
	return fin
end

function PANEL:CompileChildren()
	local rtrn = {}
	for k,v in ipairs(self.m_CompileOrder)do
		if v:GetInputter() then
			rtrn[k]=v:GetInputter():GetParent():Compile()
		end
	end
	return rtrn
end
 
function PANEL:Run()
	local rtrn = {}
	local args = {}
	for k,v in ipairs(self.m_InputButtons)do --Run Each Input, save return value.
		if v:GetInputter() then
			local ParentReturns = {}
			local OutputNum = table.KeyFromValue(v:GetInputter():GetParent().m_OutputButtons, v:GetInputter()) --usually 1, but prepare for anything. 
			ParentReturns[1], ParentReturns[2], ParentReturns[3], ParentReturns[4], ParentReturns[5], ParentReturns[6], ParentReturns[7], ParentReturns[8] = v:GetInputter():GetParent():Run()
			table.insert(args, ParentReturns[OutputNum])
		end
	end
	
	rtrn[1], rtrn[2], rtrn[3], rtrn[4], rtrn[5], rtrn[6], rtrn[7], rtrn[8] = self.m_Func(LUABEE.GetValidArgs(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12],args[13],args[14],args[15],args[16],args[17],args[18],args[19],args[20]))--Run this function.
	
	if self.m_BottomButton then
		if self.m_BottomButton:GetInputter() then
			self.m_BottomButton:GetInputter():GetParent():Run()--Run the next function.
		end
	else
		return LUABEE.GetValidArgs(rtrn[1], rtrn[2], rtrn[3], rtrn[4], rtrn[5], rtrn[6], rtrn[7], rtrn[8])
	end
	
	
end

function PANEL:NewRun()
	if !self:GetCallHook() then
		RunString("LUABEE = LUABEE or {}\nLUABEE.Vars = LUABEE.Vars or {}\n"..self:Compile())
	else
		if self.m_BottomButton:GetInputter() then
			RunString("LUABEE = LUABEE or {}\nLUABEE.Vars = LUABEE.Vars or {}\n"..self.m_BottomButton:GetInputter():GetParent():Compile())
		end
	end
end
 
/*---------------------------------------------------------
	PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	if self:GetText() then
		self.Label:SetText(self:GetText())
	else
		self.Label:SetText(self:GetText() or "")
	end
	self.Label:SizeToContents()

	self:UpdateSize()
	
	self.Label:Center()
	
	//self.Label:CopyBounds( self )
	
 
	-- self:SetToolTip(self:GetWide()..", "..self:GetTall())
	
end

function PANEL:Paint()

 	draw.NoTexture()
	local w,h = self:GetSize()
	local x,y = 0,0
	local r,g,b,a = self.m_DrawColor.r, self.m_DrawColor.g, self.m_DrawColor.b, self.m_DrawColor.a
	local inputs = self:GetInputs()
	local outputs = self:GetOutputs()
	
	surface.SetDrawColor(r,g,b,a)
	
	surface.DrawRect(x,y,20,20)--top left
	surface.DrawRect(x,h-20,20,20)--bottom left
	surface.DrawRect(w-20,h-20,20,20)--bottom right
	surface.DrawRect(w-20,y,20,20)--top right
	surface.DrawRect(x+20,y+20,w-40,h-40)--Center Square
	
	if #inputs != 0 then
		local num = #inputs
		local max = (20*num)+(20*math.max(num-1,0))
		for i=1, num-1 do
			local x2,y2 = w-20, (20*i)+(20*math.max(i-1,0))+(h-max)/2
			surface.DrawRect(x2,y2,20,20)--Each Spacer
		end
		surface.DrawRect(x+w-20,20,20,(h-max-40)/2)--Gap Closer right top
		surface.DrawRect(x+w-20,20+max+(h-max-40)/2,20,(h-max-40)/2)--Gap Closer right bottom
		
		for k,v in pairs(inputs)do
			surface.SetFont("DefaultSmall")
			local txtw,txth = surface.GetTextSize(v)
			local x2,y2 = w-20-txtw-2, (20*k)+(20*math.max(k-1,0))+((h-max)/2)-20+(txth/3)
			surface.SetTextColor(self.LabelCol)
			surface.SetTextPos(x2,y2)
			surface.DrawText(v)--Input Labels
		end
	else
		surface.DrawRect(w-20,y+20,20,h-40) --Gap Closer Right
	end
	
	if #outputs != 0 then
		local num = #outputs
		local max = (20*num)+(20*math.max(num-1,0))
		for i=1, num-1 do
			local x2,y2 = x, (20*i)+(20*math.max(i-1,0))+(h-max)/2
			surface.DrawRect(x2,y2,20,20)--Each Spacer
		end
		surface.DrawRect(x,20,20,(h-max-40)/2)--Gap Closer left top
		surface.DrawRect(x,20+max+(h-max-40)/2,20,(h-max-40)/2)--Gap Closer left bottom
		
		surface.DrawRect(x+20,y,w-40,20)--Top Bar
		surface.DrawRect(x+20,h-20,w-40,20)--Bottom Bar
		
		for k,v in pairs(outputs) do
			surface.SetFont("DefaultSmall")
			local txtw,txth = surface.GetTextSize(v)
			local x2,y2 = x+20+2, (20*k)+(20*math.max(k-1,0))+((h-max)/2)-20+(txth/3)
			surface.SetTextColor(self.LabelCol)
			surface.SetTextPos(x2,y2)
			surface.DrawText(v)--Output Labels
		end
	else
		if !self:GetHook() then
			surface.DrawRect(x,y+20,20,h-40)--Left Bar
			surface.DrawRect(x+20,y,(w/2)-20-10,20)--Top Left Filler Bar
			surface.DrawRect(x+(w/2)+10,y,(w/2)-20-10,20)--Top Right Filler Bar
		else
			
			surface.DrawRect(x+20,y,w-20,20)--Top filler for CallHooks
		end
		surface.DrawRect(x,y+20,20,h-40)--Left Bar
		surface.DrawRect(x+20,h-20,(w/2)-20-10,20)--Bottom Left Filler Bar
		surface.DrawRect(x+(w/2)+10,h-20,(w/2)-20-10,20)--Bottom Right Filler Bar
	end
	
	local x2,y2 = self.Label:GetPos()
	local w2,h2 = self.Label:GetSize()
	local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
	draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
	
end

vgui.Register( "CodeBlock", PANEL, "DPanel" ) --ToDo: Make A CodeBlock Base panel