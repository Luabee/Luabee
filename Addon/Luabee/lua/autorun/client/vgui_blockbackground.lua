

local PANEL = {}

AccessorFunc(PANEL, "m_ScrollPos", "ScrollPos")
AccessorFunc(PANEL, "m_MouseOffset", "MouseOffset")
AccessorFunc(PANEL, "m_Dragging", "Dragging")

function PANEL:Init()

	self.m_ScrollPos = {0,0}
	self.m_MouseOffset = {0,0}
	self.m_ChildrenDragPoses = {}
	self:SetDragging(false)
	
end
	
function PANEL:OnMousePressed(mc)
	if LUABEE["TopDropdowns"] then
		if LUABEE.TopDropdowns:GetActiveButton() then
			local b = LUABEE.TopDropdowns:GetActiveButton()
			b:SetSelected(false)
			b.mnu:Hide()
			b:GetParent():SetToggled(false)
		end
	end
	
	if mc == MOUSE_LEFT and input.IsKeyDown(KEY_SPACE) then
		self:StartDragging()
	end
	
end

function PANEL:OnMouseReleased(mc)
	if mc == MOUSE_LEFT then
		self:StopDragging()
	end
end

function PANEL:MousePos()
	return self:ScreenToLocal(gui.MousePos())
end

function PANEL:StartDragging()
	local mx,my = self:MousePos()
	if not input.IsKeyDown(KEY_SPACE) then return end
	self:MouseCapture(true)
	self:SetMouseOffset({mx,my})
	self.m_ChildrenDragPoses = {}
	for k,v in ipairs(self:GetChildren())do
		local x,y = v:GetPos()
		self.m_ChildrenDragPoses[k] = {x=x,y=y}
	end
	self:SetCursor("sizeall")
	self:SetDragging(true)
end

function PANEL:StopDragging()
	self:MouseCapture(false)
	self:SetCursor("arrow")
	self:SetDragging(false)
	for k,v in ipairs(self:GetChildren())do
		local x,y = v:GetPos()
		self.m_ChildrenDragPoses[k] = {x=0,y=0}
	end
end

function PANEL:JumpToPoint(x,y,mid)
	if mid then
		x=x-self:GetWide()/2
		y=y-self:GetTall()/2
	end
	self.m_ChildrenDragPoses = {}
	for k,v in ipairs(self:GetChildren())do
		local x,y = v:GetPos()
		self.m_ChildrenDragPoses[k] = {x=x,y=y}
	end
	self:SetScrollPos({x, y})
	for k,v in ipairs(self:GetChildren())do
		local pos = self.m_ChildrenDragPoses[k]
		v:SetPos(pos.x-x, pos.y-y)
	end
end	

function PANEL:Think()
	if self:GetDragging() then
		local omx,omy = self:GetMouseOffset()[1], self:GetMouseOffset()[2]
		local mx, my = self:MousePos()
		local sx, sy = omx-mx,omy-my
		self:SetScrollPos({sx, sy})
		for k,v in ipairs(self:GetChildren())do
			local pos = self.m_ChildrenDragPoses[k]
			v:SetPos(pos.x-sx, pos.y-sy)
		end
	end
	if LUABEE.Config.Ruler:GetBool() then
		local mx,my = self:MousePos()
		if mx < 0 or my < 0 then return end
		local sp = self:GetScrollPos()
		local x,y = mx+sp[1], my+sp[2]
		local txt = "x: "..x.."; y: "..y 
		if self.strTooltipText != txt then
			self:SetToolTip(txt)
			ChangeTooltip(self)
		end
	end
end

function PANEL:Paint()
	
	draw.NoTexture()
	surface.SetDrawColor( 0, 0, 0, 255 );
	surface.DrawRect(0,0,self:GetWide(), self:GetTall())
	surface.SetDrawColor( 240, 240, 240, 255 );
	surface.DrawRect(1,1,self:GetWide()-2, self:GetTall()-2)
	
	local x = (self:GetWide()/2)-256
	local y = (self:GetTall()/2)-256
	local w = 512
	local h = 512
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.SetMaterial( Material("VGUI/Luabee/Luabee_BG1.png") );
	surface.DrawTexturedRect( x,y,w,h )
	
end

vgui.Register("BlockBackground", PANEL, "DPanel")