
hook.Add("Initialize", "Luabee Hotkeys Init", function()
	
	
	function LUABEE.HotkeyThink()
		if LUABEE.WINDOW:IsVisible() then
			
			if input.IsKeyDown(KEY_LCONTROL) then
				if input.IsKeyDown(LUABEE.Config.Keymapping.Save:GetInt()) then
					LUABEE.SaveThis()
					LUABEE.DisableHotkeyThink(LUABEE.Config.Keymapping.Save:GetInt())
					
				elseif input.IsKeyDown(LUABEE.Config.Keymapping.Open:GetInt()) then
					LUABEE.OpenFileWithBrowser()
					LUABEE.DisableHotkeyThink(LUABEE.Config.Keymapping.Open:GetInt())
					
				elseif input.IsKeyDown(LUABEE.Config.Keymapping.Close:GetInt()) then
					LUABEE.Tabs:CloseTab(LUABEE.Tabs:GetActiveTab(),true)
					LUABEE.DisableHotkeyThink(LUABEE.Config.Keymapping.Close:GetInt())
					
				elseif input.IsKeyDown(LUABEE.Config.Keymapping.Undo:GetInt()) then
					LUABEE.Undo()--Undefined.
					LUABEE.DisableHotkeyThink(LUABEE.Config.Keymapping.Undo:GetInt())
					
				elseif input.IsKeyDown(LUABEE.Config.Keymapping.Redo:GetInt()) then
					LUABEE.Redo()--Undefined.
					LUABEE.DisableHotkeyThink(LUABEE.Config.Keymapping.Redo:GetInt())
					
				end
			end
			
		end
	end
	hook.Add("Think", "Luabee Button Input", LUABEE.HotkeyThink)
	function LUABEE.DisableHotkeyThink(key)
		hook.Add("Think", "Luabee Button Input", function()
			if not input.IsKeyDown(key) then
				hook.Add("Think", "Luabee Button Input", LUABEE.HotkeyThink)
			end
		end)
	end
	
	function LUABEE.WINDOW:Think()
		if input.IsKeyDown(KEY_TAB) or self.Minim then
			local x,y = LUABEE.WINDOW:GetPos()
			y=math.Clamp(y+80,0,ScrH()-22)
			LUABEE.WINDOW:SetPos(x,y)
		elseif !input.IsKeyDown(KEY_TAB) or !self.Minim then
			local x,y = LUABEE.WINDOW:GetPos()
			y=math.Clamp(y-80,0,ScrH()-22)
			LUABEE.WINDOW:SetPos(x,y)
		end
	end
	
	
end)