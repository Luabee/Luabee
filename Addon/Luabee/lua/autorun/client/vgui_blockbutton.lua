
local PANEL = {}

AccessorFunc( PANEL, "m_Type", "Type", FORCE_NUMBER)
AccessorFunc( PANEL, "m_Hilighted", "HilightedColor")
AccessorFunc( PANEL, "m_Inputter", "Inputter")
AccessorFunc( PANEL, "m_Color", "Color")
AccessorFunc( PANEL, "m_DefaultColor", "DefaultColor")
AccessorFunc( PANEL, "m_OutputsTo", "Outputs")

LUABEE_INPUT = 1 --used in PANEL:SetType()
LUABEE_OUTPUT = 2
LUABEE_TOP = 4
LUABEE_BOTTOM = 8

function PANEL:Init()

	self:SetSize(20,20)
	self.m_OutputsTo = {}
	self.m_Type = LUABEE_INPUT
	self.m_DefaultColor = Color(210, 72, 46,240)
	self.m_Hilighted = Color(235,0,47, 240)
	self.m_LastClicked = CurTime()
	self:SetColor(Color(210, 72, 46,240))
	self.DragThink = function() end
	self.IsBlockButton = true
	table.insert(LUABEE.ALL_IOS, self)
	self:SetCursor("hand")
	
end

function PANEL:OnMousePressed(mc)
	if LUABEE.TopDropdowns:GetActiveButton() then
		local b = LUABEE.TopDropdowns:GetActiveButton()
		b:SetSelected(false)
		b.mnu:Hide()
		b:GetParent():SetToggled(false)
	end
	if self.m_LastClicked >= (CurTime()-.3) then
		self:ClearOutputs()
		self:ClearInputs()
	else
		self.m_LastClicked = CurTime()
		LUABEE.Dragging = self
		function self:DragThink()
			if not input.IsMouseDown(MOUSE_LEFT) then
				self.DragThink = function() end
			end
		end
	end
end

function PANEL:OnMouseReleased(mc)
	if mc == MOUSE_LEFT then
		
		if LUABEE.Dragging and LUABEE.Dragging == self then
			if Type == LUABEE_INPUT or Type == LUABEE_BOTTOM then
				self:GetInputter():RemoveOutput(self)
				self:SetInputter(nil)
			end
		elseif LUABEE.Dragging then
			self:Link(LUABEE.Dragging)
		end
		
	end
end

function PANEL:Think()
	if self:IsHovered() then
		self:SetColor(self:GetHilightedColor())
	else
		self:SetColor(self:GetDefaultColor())
	end
	self:DragThink()
end

function PANEL:AddOutput(p)
	table.insert(self.m_OutputsTo, p)
end
function PANEL:RemoveOutput(ip)
	if type(ip) == "number" then
		table.remove(self.m_OutputsTo,ip)
	else
		table.remove(self.m_OutputsTo,self:FindOutputIndex(p))
	end
	self:GetParent():OnLinkRemoved(self)
end
function PANEL:ClearOutputs()
	if self.m_OutputsTo then
		for k,v in pairs(self.m_OutputsTo)do
			if IsValid(v) then
				v:ClearInputs()
			end
		end
	end
	self.m_OutputsTo = {}
end
function PANEL:FindOutputIndex(p)
	if not table.HasValue(self.m_OutputsTo) then return -1 end
	return table.KeyFromValue(self.m_OutputsTo, p)
end

function PANEL:ClearInputs()
	if self.m_Inputter then
		self.m_Inputter:RemoveOutput(self)
	end
	self.m_Inputter = nil
	if self.m_InputLine then
		self.m_InputLine:Remove()
	end
	self.m_InputLine = nil
	self:GetParent():OnLinkRemoved(self)
end

function PANEL:CompatibleLink(p)
	local i1,i2 = self:GetType(), p:GetType()
	if (i1==LUABEE_TOP and i2==LUABEE_BOTTOM) or (i2==LUABEE_TOP and i1==LUABEE_BOTTOM) then
		return (self:GetParent():GetActivated() and p:GetParent():GetActivated()) and (self:GetParent() != p:GetParent())
	elseif (i1==LUABEE_INPUT and i2==LUABEE_OUTPUT) or (i2==LUABEE_INPUT and i1==LUABEE_OUTPUT) then
		return (self:GetParent():GetActivated() and p:GetParent():GetActivated()) and (self:GetParent() != p:GetParent())
	end
	
	return false
	
end

function PANEL:CreateInputLine(p)
	
	local ln = vgui.Create("ElbowedLine")
	ln:SetPoints(self,p)
	if self.m_InputLine then
		self.m_InputLine:Remove()
	end
	self.m_InputLine = ln
	
end

function PANEL:Link(p, b)
	
	local stype, ptype = self:GetType(), p:GetType()
	if self:CompatibleLink(p) then
		if not b then
			LUABEE.AddHistoryPoint()
		end
		if stype == LUABEE_BOTTOM or stype == LUABEE_INPUT then
			if self:GetParent().m_TopButton then
				if table.HasValue(self:GetParent().m_TopButton:GetOutputs(), p:GetParent().m_BottomButton) then return end
			end
			if p:GetInputter() then
				p:GetInputter():RemoveOutput(p)
			end
			self:SetInputter(p)
			p:AddOutput(self)
			self:CreateInputLine(p)
			
			self:GetParent():OnLinked(self)
			p:GetParent():OnLinked(p)
		else
			if self:GetParent().m_BottomButton and p:GetParent().m_TopButton then
				if self:GetParent().m_BottomButton:GetInputter() == p:GetParent().m_TopButton then return end
			end
			if self:GetInputter() then
				self:GetInputter():RemoveOutput(self)
			end
			p:SetInputter(self)
			self:AddOutput(p)
			p:CreateInputLine(self)
			
			self:GetParent():OnLinked(self)
			p:GetParent():OnLinked(p)
		end
	end
end

function PANEL:Paint()
	
	draw.NoTexture()
	local w,h = self:GetSize()
	local x,y = 0,0
	local r,g,b,a = self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a
	
	surface.SetDrawColor(r,g,b,a)
	surface.DrawRect(x+5,y+5,w-10,h-10)
	
end

vgui.Register("BlockButton", PANEL, "DPanel")