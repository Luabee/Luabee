
local PANEL = {}

AccessorFunc(PANEL, "m_Toggled", "Toggled")
AccessorFunc(PANEL, "m_ActiveButton", "ActiveButton")

function PANEL:Init()
	self:SetPos(2,22)
	self:SetSize(self:GetParent():GetWide()-4,20)
	self.m_AllButtons = {}
	
	self.Buttons = {}
	self.Menus = {}
	timer.Simple(.1, function()
		for k,v in ipairs(self.Buttons)do
			local b = vgui.Create("DButton", self)
			surface.SetFont(b:GetFont())
			local w,h = surface.GetTextSize(v)
			local x,y = self:GetNextSpot()
			b:SetPos(x-1,y)
			b:SetSize(w+10,20)
			b:SetText(v)
			b:SetSelected(false)
			b.Think = function()
				if b:IsHovered()then
					if b:GetParent():GetToggled() then
						b:GetParent():SetActiveButton(b)
						b:SetSelected(true)
					end
				end
			end
			
			b.mnu = vgui.Create("DMenu")
			x,y = b:GetParent():LocalToScreen(b:GetPos())
			b.mnu:SetPos(x,y+b:GetTall())
			b.mnu:SetDeleteSelf(false)
			for k,v in ipairs(self.Menus[k])do
				b.mnu:AddOption(v[1], function()b:SetSelected(false); self:SetToggled(false); v[2]() end)
			end
			
			b.mnu.Hide = function()
				local openmenu = b.mnu:GetOpenSubMenu()
				if ( openmenu ) then
					openmenu:Hide()
				end
				
				if self:GetActiveButton() then
					self:GetActiveButton():SetSelected(false)
				end

				b.mnu:SetVisible( false )
				b.mnu:SetOpenSubMenu( nil )
			end
			
			b.mnu:Open()
			b.mnu:Hide()
			
			b.OnMousePressed = function(mc)
				b:SetSelected(false)
				b.mnu:Hide()
				b:GetParent():Toggle()
			end	
			
			
			table.insert(self.m_AllButtons, b)
		end
	end)
end

function PANEL:GetNextSpot()
	local x = 0
	for k,v in pairs(self.m_AllButtons)do
		x=x+v:GetWide()
	end
	return x,0
end

function PANEL:SetToggled(b)
	self.m_Toggled = b
end

function PANEL:Toggle()
	self:SetToggled(!self:GetToggled())
end

function PANEL:SetActiveButton(p)
	if self:GetActiveButton() then
		self:GetActiveButton().mnu:Hide()
		self:GetActiveButton():SetSelected(false)
	end
	self.m_ActiveButton = p
	p.mnu:Open()
	local x,y = p:GetParent():LocalToScreen(p:GetPos())
	p:SetSelected(true)
	p.mnu:SetPos(x,y+p:GetTall()-2)
end

vgui.Register("TopDropdowns", PANEL, "DPanel")