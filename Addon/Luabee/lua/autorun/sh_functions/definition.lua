
LUABEE.AddGlobal("Lua Definition", Color(170, 97, 204))

LUABEE.CatalogFunction({

	name = "string",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Returns a user-defined string.
	Will always be text.
	Allows for multiline support. All strings are literal.]],
	func=function() return end,
	block = {
		
		UpdateSize = function(self)
			local w,h
			if self.m_TextBox then
				surface.SetFont("DermaDefault")
				local tw,th = surface.GetTextSize(self.m_TextBox:GetValue() or "")
				self.m_TextBox:SetWide(math.max(55, tw + 10))
				self.m_TextBox:SetTall(th*1.1 + 4)
				self.m_TextBox:Center()
				w = self.m_TextBox:GetWide()+50
				h = self.m_TextBox:GetTall()+50
				
				self.m_OutputButtons[1]:CenterVertical()
				
				if h/2 != math.Round(h/2) then
					h=h+1
				end
			else
				w = 100
				h = 80
			end
			
			self:SetSize(w, h)
		end,
		
		Activate = function(self)
			self:PerformLayout()
			local outputs = self:GetOutputs()
			
			self.m_OutputButtons = {}
			local b = vgui.Create("BlockButton", self)
			b:SetPos(0,(self:GetTall()/2) - 10)
			b:SetType(LUABEE_OUTPUT)
			table.insert(self.m_OutputButtons, b)
			
			self.m_TextBox = vgui.Create("DTextEntry", self)
			self.m_TextBox:SetWide(self:GetWide()-50)
			self.m_TextBox:Center()
			self.m_TextBox:SetAllowNonAsciiCharacters( false )
			self.m_TextBox:SetMultiline( true )
			self.m_TextBox:SetValue("string")
			self.m_TextBox.m_IsInput = true
			self.m_TextBox.OnTextChanged = function(txtbox)
				self:PerformLayout()
			end
			self.m_TextBox.OnMousePressed = function(txtbox, mc)
				if mc == MOUSE_LEFT then
					if self:GetDragging() then
						self:StopDragging()
					end
				end
			end
			
			self:PerformLayout()
			
			self:SetActivated(true)
		end, 
		
		SetActivated = function(self,b)
			self.m_Activated=b
			if b then
				self.m_TextBox:SetValue("")
			else
				self.m_TextBox:SetValue("string")
			end
		end,
		
		GenerateCompileString = function(self)
			return "[["..self.m_TextBox:GetValue().."]]"
		end
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "number",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Returns a user-defined number.
	Will always be a number.]],
	func=function() return end,
	block = {
		
		Activate = function(self)
			self:PerformLayout()
			local outputs = self:GetOutputs()
			
			self.m_OutputButtons = {}
			local b = vgui.Create("BlockButton", self)
			b:SetPos(0,(self:GetTall()/2) - 10)
			b:SetType(LUABEE_OUTPUT)
			table.insert(self.m_OutputButtons, b)
			
			self.m_NumBox = vgui.Create("DNumberWang", self)
			self.m_NumBox:Center()
			self.m_NumBox.m_IsInput = true
			self.m_NumBox:SetDecimals(99)
			self.m_NumBox.OnMousePressed = function(numbox, mc)
				if mc == MOUSE_LEFT then
					if self:GetDragging() then
						self:StopDragging()
					end
				end
			end
			
			self:PerformLayout()
			
			self:SetActivated(true)
		end, 
		
		Run = function(self)
			return self.m_NumBox:GetValue()
		end,
		
		GenerateCompileString = function(self)
			return self.m_NumBox:GetValue()
		end
		
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "nil",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Returns nil.
	Nil isn't 0. It's not an empty string. It's not false. It's nil.
	It is nothing. It doesn't exist. It's a void. It's a lack of existence.]],
	func=function() return end,
	block = {
		Run = function(self)
			return nil
		end,
		
		GenerateCompileString = function(self)
			return "nil"
		end
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "bool",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Returns a user-defined boolean value.
	Will always be either true or false.]],
	func=function() return end,
	block = {
		
		Activate = function(self)
			self:PerformLayout()
			self.m_Value = true
			local outputs = self:GetOutputs()
			
			self.m_OutputButtons = {}
			local b = vgui.Create("BlockButton", self)
			b:SetPos(0,(self:GetTall()/2) - 10)
			b:SetType(LUABEE_OUTPUT)
			table.insert(self.m_OutputButtons, b)
			
			self.m_BoolBox = vgui.Create("DComboBox", self)
			self.m_BoolBox:SetWide(50)
			self.m_BoolBox:Center()
			self.m_BoolBox:SetText("true")
			self.m_BoolBox:AddChoice("true",true)
			self.m_BoolBox:AddChoice("false",false)
			self.m_BoolBox.m_IsInput = true
			self.m_BoolBox.OnSelect = function(self,i,txt,bool)
				self.m_Value = bool
			end
			self.m_BoolBox.OnMousePressed = function(bbox, mc)
				if mc == MOUSE_LEFT then
					if self:GetDragging() then
						self:StopDragging()
					end
				end
			end
			
			self:PerformLayout()
			
			self:SetActivated(true)
		end, 
		
		Run = function(self)
			return self.m_Value
		end,
		
		GenerateCompileString = function(self)
			return self.m_Value
		end
		
		
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "table",
	args = {"item"},
	returns = {""},
	realm = "Shared",
	expanding = 1,
	desc = [[Creates and returns a table.
	You can add items by connecting them to the inputs.
	You can also use table.insert and table.AddItem to add objects.
	See the tutorial on tables for more info.]],
	block = {
		GenerateCompileString = function(self)
			local str = "{"
			for i=1, #self.m_CompileOrder - 1 do
				str = str.."%s, "
			end
			str=str.."}"
			return string.Replace(str, "s, }", "s}")
		end
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "Define Variable",
	args = {"name", "data"},
	returns = {},
	realm = "Shared",
	desc = [[Defines a variable.
	[name] must be a string. 
	If a variable with that name already exists then it will be overwritten.
	[data] can be anything.
	Using a name like "print" will overwrite it, so use unique names.
	You can retrieve the value of this variable with Get Variable.
	See the tutorial on variables for more info.]],
	func=function(name,value)
		if not name then
			return Error("--> LUABEE: <Error> Tried to define a variable without a name.")
		end 
		LUABEE.Tabs:GetActiveTab():GetPanel().m_Variables[name] = value 
	end,
	block = {
		GenerateCompileString = function(self)
			return "_G[(%s)] = (%s)"
		end
	}
	
},_,_,_,"Lua Definition")
LUABEE.CatalogFunction({

	name = "Get Variable",
	args = {"name"},
	returns = {""},
	realm = "Shared",
	desc = [[Returns the information stored in a variable with name [name].
	[name] must be a string.
	See the tutorial on variables for more info.]],
	func=function(name)
		if not name then
			return Error("ERROR: Tried to get a variable without a name.")
		end 
		return LUABEE.Tabs:GetActiveTab():GetPanel().m_Variables[name] 
	end,
	block = {
		GenerateCompileString = function(self)
			return "(_G[(%s)])"
		end
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "Function",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Creates a function.
	To run this function, use the Call function.
	Functions are another type of data. You can assign it to a variable and Call the variable.
	To get an argument passed to the function, use GetArg in the function.
	View the tutorial on functions for more info.]],
	func=function() return end,
	block = {
	
		OnMousePressed = function(self,mc)
			if self:GetActivated() then
				local mx, my = self:ScreenToLocal(gui.MousePos())
				local w,h = self:GetSize()
				h=h-60
				if mx > 20 and my > h then
					self:SendToBack()
					return
				end
				if mc == MOUSE_LEFT then
					if self.m_LastClicked >= (CurTime()-.3) then --double clicked
						self:DoubleClicked()
					else
						self.m_LastClicked = CurTime()
						if input.IsKeyDown(KEY_SPACE) then
							self:GetParent():StartDragging()
						else
							self:StartDragging()
						end
					end
					if LUABEE.TopDropdowns:GetActiveButton() then
						local b = LUABEE.TopDropdowns:GetActiveButton()
						b:SetSelected(false)
						b.mnu:Hide()
						b:GetParent():SetToggled(false)
					end
				else
					if input.IsMouseDown(MOUSE_LEFT) then
						LUABEE.AddHistoryPoint()
						
						self:MouseCapture(true)
						self:ChainDrag()
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
		end,
	
		PerformLayout = function(self)
		
			if self:GetText() then
				self.Label:SetText(self:GetText())
			else
				self.Label:SetText("")
			end
			self.Label:SizeToContents()
			self.Label:SetPos(41,36)
			self:SetSize(130,140)
			
		end,
		
		Paint = function(self)
			
			draw.NoTexture()
			local w,h = self:GetSize()
			h=h-60
			local x,y = 0,0
			local r,g,b,a = self.m_DrawColor.r, self.m_DrawColor.g, self.m_DrawColor.b, self.m_DrawColor.a
			local inputs = self:GetInputs()
			local outputs = self:GetOutputs()
			
			surface.SetDrawColor(r,g,b,a)
			
			surface.DrawRect(x,y,w,30)--top left
			surface.DrawRect(x,h-30,20,30)--bottom left
			surface.DrawRect(w-20,h-20,20,20)--bottom right
			surface.DrawRect(x+20,y+20,w-40,h-40)--Center Square
			
			surface.DrawRect(w-20,y+20,20,h-40) --Gap Closer Right
			
			local max = 40
			surface.DrawRect(x,20,20,(h-max-40)/2)--Gap Closer left top
			surface.DrawRect(x,20+max+(h-max-40)/2,20,(h-max-40)/2)--Gap Closer left bottom
			
			surface.DrawRect(x+20,y,w-40,20)--Top Bar
			surface.DrawRect(x+20,h-20,w/2-30,20)--Bottom Left
			surface.DrawRect(w/2+10,h-20,w-(w/2+10)-20,20)--Bottom Right
			
			
			surface.DrawRect(x,h,20,80)
			
			local x2,y2 = self.Label:GetPos()
			local w2,h2 = self.Label:GetSize()
			local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
			draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			
		end,
		
		Activate = function(self)
			
			self:PerformLayout()
			local inputs, outputs = self:GetInputs(), self:GetOutputs()
			local w,h = self:GetSize()
			h=h-60
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos((w/2)-10, h-20)
			b:SetType(LUABEE_BOTTOM)
			self.m_FuncButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(0, (h/2)-10)
			b:SetType(LUABEE_OUTPUT)
			self.m_OutputButtons[1] = b
			
			self:SetActivated(true)
			
		end,
		
		ClearAllLinks = function(self)
			self.m_OutputButtons[1]:ClearInputs()
			self.m_OutputButtons[1]:ClearOutputs()
			self.m_FuncButton:ClearInputs()
			self.m_FuncButton:ClearOutputs()
		end,
		
		Run = function(self)
			return function() 
				if !LUABEE.Tabs:GetActiveTab() then return end
				LUABEE.Tabs:GetActiveTab().m_ReturnVar = nil
				if !self.m_FuncButton then return end
				if self.m_FuncButton:GetInputter() then
					local useless = self.m_FuncButton:GetInputter():GetParent():Run()--Run the next function.
				end
				return LUABEE.Tabs:GetActiveTab().m_ReturnVar or nil
				
			end
		end,
		
		GenerateCompileString = function(self)
			self:SetCompileOrder({self.m_FuncButton})
			local str = "(function("
			for i=1,20 do
				str = str.."arg"..i..","
			end
			str = str..")\n%s\nend)"
			str = string.Replace(str, ",)", ")")
			return str
		end
		
	}
	
},_,_,_,"Lua Definition")

LUABEE.CatalogFunction({

	name = "Return",
	args = {"var"},
	returns = {},
	realm = "Shared",
	desc = [[Returns [var].
	[var] can be anything.
	This will stop the code.
	If ran in a function, the function's output will be [var].]],
	func = function(a) LUABEE.Tabs:GetActiveTab().m_ReturnVar = a end,
	block = {
		GenerateCompileString = function(self)
			return "return (%s)"
		end
	}
	
},_,_,_,"Lua Definition")
	
