
local PANEL = {}

AccessorFunc(PANEL, "m_Points", "Points")
AccessorFunc(PANEL, "m_Color", "Color")

function PANEL:Init()
	
	self.m_Points = {}
	self:SendToBack()
	local colors = {}
	colors[1] = Color(0,128,255)
	colors[2] = Color(231,0,62,200)
	colors[3] = Color(94,205,0,200)
	self:SetColor(table.Random(colors))
	self:SetParent(LUABEE.Tabs:GetActiveTab():GetPanel())
	
end

function PANEL:SetPoints(a,b)
	
	self.m_Points.a=a
	self.m_Points.b=b
	
end

function PANEL:OnMousePressed(mc)
	if LUABEE.TopDropdowns:GetActiveButton() then
		local b = LUABEE.TopDropdowns:GetActiveButton()
		b:SetSelected(false)
		b.mnu:Hide()
		b:GetParent():SetToggled(false)
	end
end

function PANEL:Think()
	if self.m_Points.a and (not self.m_Points.b) then
		self:Remove()
		return
	elseif self.m_Points.b and (not self.m_Points.a) then
		self:Remove()
		return
	end
	
	if not self.m_Points.a and self.m_Points.b then return end
	local a,b = self.m_Points.a, self.m_Points.b
	if !IsValid(a) or !IsValid(b) then self:Remove() return end
	local ap,bp = a:GetParent(), b:GetParent()
	-- local ax,ay = ap:LocalToScreen(a:GetPos())
	-- local bx,by = bp:LocalToScreen(b:GetPos())
	local ax,ay = ap:GetParent():ScreenToLocal(ap:LocalToScreen(a:GetPos()))
	local bx,by = bp:GetParent():ScreenToLocal(bp:LocalToScreen(b:GetPos()))
	ax,bx,ay,by=ax+10,bx+10,ay+10,by+10
	local aw,ah = a:GetSize()
	local bw,bh = b:GetSize()
	local x, y, w, h
	x,y = math.min(ax,bx), math.min(ay,by)
	w,h = math.abs(ax-bx), math.abs(ay-by)
	if (a:GetType() == LUABEE_INPUT) or (b:GetType() == LUABEE_INPUT) then
		y=y-1
		h=h+2
	else
		x=x-1
		w=w+2
	end
	self:SetPos(x,y)
	self:SetSize(w,h)
end

function PANEL:Paint()
	draw.NoTexture()
	local w,h = self:GetSize()
	local x,y = 0,0
	local red,green,blue,alpha = self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a
	
	local a,b = self.m_Points.a, self.m_Points.b
	local ap,bp = a:GetParent(), b:GetParent()
	-- local ax,ay = ap:LocalToScreen(a:GetPos())
	-- local bx,by = bp:LocalToScreen(b:GetPos())
	local ax,ay = self:ScreenToLocal(ap:LocalToScreen(a:GetPos()))
	local bx,by = self:ScreenToLocal(bp:LocalToScreen(b:GetPos()))
	ax,bx,ay,by=ax+10,bx+10,ay+10,by+10
	local aw,ah = a:GetSize()
	local bw,bh = b:GetSize()
	
	surface.SetDrawColor(red,green,blue,alpha)
	
	if (a:GetType() == LUABEE_INPUT) or (b:GetType() == LUABEE_INPUT) then
		local w = math.abs(ax-bx)
		surface.DrawLine(ax,ay,w/2,ay)
		surface.DrawLine(w/2,ay,w/2,by)
		surface.DrawLine(w/2,by,bx,by)
	else
		local h = math.abs(ay-by)
		surface.DrawLine(ax,ay,ax, h/2)
		surface.DrawLine(ax,h/2,bx,h/2)
		surface.DrawLine(bx,h/2,bx,by)
	end
	
	
end





function PANEL:SendToBack()
	Z_POS.MIN = Z_POS.MIN - 1
	self:SetZPos(Z_POS.MIN)
end

























vgui.Register("ElbowedLine", PANEL, "DPanel")