

LUABEE.CatalogedFunctions.Globals["Lua Operators"] = {}
LUABEE.CatalogedFunctions.Globals["Lua Operators"].__Color = Color(128,255,0,255)
LUABEE.CatalogedFunctions.Globals["Lua Comparisons"] = {}
LUABEE.CatalogedFunctions.Globals["Lua Comparisons"].__Color = Color(128,255,0,255)
LUABEE.CatalogedFunctions.Globals["Lua Utilities"] = {}
LUABEE.CatalogedFunctions.Globals["Lua Utilities"].__Color = Color(128,255,0,255)

/*
EXAMPLE
table.insert(LUABEE.CatalogedFunctions.Globals["Lua Comparisons"], {
	name = "ents.FindInSphere",
	args = {"Origin", "Radius"},
	returns = {"Ents"},
	realm = "Shared",
	desc = [[Used to get a table of all entities of distance [Radius] from point [Origin].
	Returns a table.]]
})
*/
LUABEE.CatalogFunction({

	name = "if",
	args = {"Test"},
	returns = {},
	realm = "Shared",
	desc = [[Used to check if something [Test] is true.
	If test is true, then it runs the stuff in the middle.]],
	func=function() return end,
	block = { --block is the self.m_Constructor table for each block. Use this to override anything besides init on a specific codeblock type.
		
		Activate = function(self)
			
			self:PerformLayout()
			local inputs, outputs = self:GetInputs(), self:GetOutputs()
			
			local num = #inputs
			local max = (20*num)+(20*math.max(num-1,0))
			local w,h = self:GetSize()
			
			self.m_InputButtons = {}
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w-20,30)
			b:SetType(LUABEE_INPUT)
			self.m_InputButtons[1] = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(self:GetWide()/2-10, 0)
			b:SetType(LUABEE_TOP)
			self.m_TopButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,h-20)
			b:SetType(LUABEE_BOTTOM)
			self.m_BottomButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,60)
			b:SetType(LUABEE_BOTTOM)
			self.m_IfButton = b
			
			self:SetActivated(true)
			
		end,
		
		Run = function(self)
			local args = {}
			local k,v = 1, self.m_InputButtons[1]
			if v:GetInputter() then
				local ParentReturns = {}
				local OutputNum = table.KeyFromValue(v:GetInputter():GetParent().m_OutputButtons, v:GetInputter()) --usually 1, but prepare for anything. 
				ParentReturns[1], ParentReturns[2], ParentReturns[3], ParentReturns[4], ParentReturns[5], ParentReturns[6], ParentReturns[7], ParentReturns[8] = v:GetInputter():GetParent():Run()
				args[1] = ParentReturns[OutputNum]
			end
			
			if args[1] then --the actual if statement
				if self.m_IfButton:GetInputter() then
					local If = self.m_IfButton:GetInputter():GetParent():Run()--Run the next function. Gotta return it or it will just continue on.
				end
			end
			
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():Run()--Run the next function.
			end
		end,
		
		Paint = function(self)
			
			draw.NoTexture()
			local w,h = self:GetSize()
			local x,y = 0,0
			local r,g,b,a = self.m_DrawColor.r, self.m_DrawColor.g, self.m_DrawColor.b, self.m_DrawColor.a
			local inputs = self:GetInputs()
			local outputs = self:GetOutputs()
			
			surface.SetDrawColor(r,g,b,a)
			
			surface.DrawRect(0,0,30,20)--top left
			surface.DrawRect(50,0,30,20)--top right
			surface.DrawRect(0,20,80,10)--Top Midbar
			surface.DrawRect(0,30,60,20)--Center
			surface.DrawRect(0,50,80,10)--Bottom midbar
			surface.DrawRect(0,60,30,120)--Tail
			surface.DrawRect(50,60,30,20)--Bottom Right
			surface.DrawRect(30,150,50,10)--Tail Top Right
			surface.DrawRect(50,160,30,20)--Tail Bottom Right
			
			
			surface.SetFont("DefaultSmall")
			local txtw,txth = surface.GetTextSize("Test")
			local x2,y2 = w-20-txtw-2, 40-(txth/2)
			surface.SetTextColor(self.LabelCol)
			surface.SetTextPos(x2,y2)
			surface.DrawText("Test")--Input Labels
			
			local x2,y2 = self.Label:GetPos()
			local w2,h2 = self.Label:GetSize()
			local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
			draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			
		end,
		
		UpdateSize = function(self)
			self:SetSize(80,180)
		end,
		
		PerformLayout = function(self)
			if self:GetText() then
				self.Label:SetText(self:GetText())
			else
				self.Label:SetText(self:GetText() or "")
			end
			self.Label:SizeToContents()
			self:UpdateSize()
			self.Label:SetPos(15-(self.Label:GetWide()/2)+3,40-(self.Label:GetTall()/2))
		end,
		
		ClearAllLinks = function(self)
			self.m_InputButtons[1]:ClearInputs()
			self.m_InputButtons[1]:ClearOutputs()
			self.m_TopButton:ClearInputs()
			self.m_TopButton:ClearOutputs()
			self.m_BottomButton:ClearInputs()
			self.m_BottomButton:ClearOutputs()
			self.m_IfButton:ClearInputs()
			self.m_IfButton:ClearOutputs()
		end, 
		
		ChainDelete = function(self)
			for k,v in pairs(self.m_InputButtons)do
				if v:GetInputter() then
					v:GetInputter():GetParent():ChainDelete()
				end
			end
			if self.m_IfButton:GetInputter() then
				self.m_IfButton:GetInputter():GetParent():ChainDelete()
			end
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():ChainDelete()
			end
			self:Delete()
		end,
		
		GenerateCompileString = function(self)
			self:SetCompileOrder({self.m_InputButtons[1], self.m_IfButton})
			return "if ( %s ) then\n%s\nend"
		end
		
	}

},_,_,_,"Lua Comparisons")

LUABEE.CatalogFunction({

	name = "if-else",
	args = {"Test"},
	returns = {},
	realm = "Shared",
	desc = [[Used to check if something [Test] is true.
	If test is true, then it runs the stuff in first space.
	If the test is false, it runs the stuff in the second space.
	Using ifelse statements inside each other can check for many things.]],
	func=function() return end,
	block = {
		
		Activate = function(self)
			self.Label:SetText("if")
			if not self.Label1 then
				self.Label1 = vgui.Create( "DLabel", self )
				self.Label1:SetFont( "DermaDefaultBold" )
			end
			
			self:PerformLayout()
			local inputs, outputs = self:GetInputs(), self:GetOutputs()
			
			local num = #inputs
			local max = (20*num)+(20*math.max(num-1,0))
			local w,h = self:GetSize()
			
			self.m_InputButtons = {}
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w-20,30)
			b:SetType(LUABEE_INPUT)
			self.m_InputButtons[1] = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(self:GetWide()/2-10, 0)
			b:SetType(LUABEE_TOP)
			self.m_TopButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,h-20)
			b:SetType(LUABEE_BOTTOM)
			self.m_BottomButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,60)
			b:SetType(LUABEE_BOTTOM)
			self.m_IfButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,180)
			b:SetType(LUABEE_BOTTOM)
			self.m_ElseButton = b
			
			self:SetActivated(true)
			
		end,
		
		Run = function(self)
			local args = {}
			local k,v = 1, self.m_InputButtons[1]
			if v:GetInputter() then
				local ParentReturns = {}
				local OutputNum = table.KeyFromValue(v:GetInputter():GetParent().m_OutputButtons, v:GetInputter()) --usually 1, but prepare for anything. 
				ParentReturns[1], ParentReturns[2], ParentReturns[3], ParentReturns[4], ParentReturns[5], ParentReturns[6], ParentReturns[7], ParentReturns[8] = v:GetInputter():GetParent():Run()
				args[1] = ParentReturns[OutputNum]
			end
			
			if args[1] then --the actual if statement
				if self.m_IfButton:GetInputter() then
					local If = self.m_IfButton:GetInputter():GetParent():Run()--Run the next function. Gotta return it or it will just continue on.
				end
			else
				if self.m_ElseButton:GetInputter() then
					local If = self.m_ElseButton:GetInputter():GetParent():Run()--Run the next function. Gotta return it or it will just continue on.
				end
			end
			
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():Run()--Run the next function.
			end
		end,
		
		Paint = function(self)
			
			draw.NoTexture()
			local w,h = self:GetSize()
			local x,y = 0,0
			local r,g,b,a = self.m_DrawColor.r, self.m_DrawColor.g, self.m_DrawColor.b, self.m_DrawColor.a
			local inputs = self:GetInputs()
			local outputs = self:GetOutputs()
			
			surface.SetDrawColor(r,g,b,a)
			
			surface.DrawRect(0,0,30,20)--top left
			surface.DrawRect(50,0,30,20)--top right
			surface.DrawRect(0,20,80,10)--Top Midbar
			surface.DrawRect(0,30,60,20)--Center
			surface.DrawRect(0,50,80,10)--Bottom midbar
			surface.DrawRect(0,60,30,240)--Tail
			surface.DrawRect(50,60,30,20)--Bottom Right
			surface.DrawRect(30,150,50,30)--Else Top Right
			surface.DrawRect(50,180,30,20)--Else Bottom Right
			surface.DrawRect(30,270,50,10)--End Top Right
			surface.DrawRect(50,280,30,20)--End Bottom Right
			
			
			surface.SetFont("DefaultSmall")
			local txtw,txth = surface.GetTextSize("Test")
			local x2,y2 = w-20-txtw-2, 40-(txth/2)
			surface.SetTextColor(self.LabelCol)
			surface.SetTextPos(x2,y2)
			surface.DrawText("Test")--Input Labels
			
			local x2,y2 = self.Label:GetPos()
			local w2,h2 = self.Label:GetSize()
			local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
			draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			if self.Label1 then
				x2,y2 = self.Label1:GetPos()
				w2,h2 = self.Label1:GetSize()
				draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			end
			
		end,
		
		UpdateSize = function(self)
			self:SetSize(80,300)
		end,
		
		PerformLayout = function(self)
			
			self:UpdateSize()
		
			self.Label:SetText("if")
			self.Label:SizeToContents()
			self.Label:SetPos(15-(self.Label:GetWide()/2)+3,40-(self.Label:GetTall()/2))
			if self.Label1 then
				self.Label1:SetText("else")
				self.Label1:SizeToContents()
				self.Label1:SetTextColor(self.Label:GetTextColor())
				self.Label1:SetPos(15-(self.Label1:GetWide()/2)+4,165-(self.Label1:GetTall()/2))
			end
		end,
		
		SetColor = function(self,c)
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
		end,
		
		ClearAllLinks = function(self)
			self.m_InputButtons[1]:ClearInputs()
			self.m_InputButtons[1]:ClearOutputs()
			self.m_TopButton:ClearInputs()
			self.m_TopButton:ClearOutputs()
			self.m_BottomButton:ClearInputs()
			self.m_BottomButton:ClearOutputs()
			self.m_IfButton:ClearInputs()
			self.m_IfButton:ClearOutputs()
			self.m_ElseButton:ClearInputs()
			self.m_ElseButton:ClearOutputs()
		end,
		
		ChainDelete = function(self)
			for k,v in pairs(self.m_InputButtons)do
				if v:GetInputter() then
					v:GetInputter():GetParent():ChainDelete()
				end
			end
			if self.m_IfButton:GetInputter() then
				self.m_IfButton:GetInputter():GetParent():ChainDelete()
			end
			if self.m_ElseButton:GetInputter() then
				self.m_ElseButton:GetInputter():GetParent():ChainDelete()
			end
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():ChainDelete()
			end
			self:Delete()
		end,
		
		GenerateCompileString = function(self)
			self:SetCompileOrder({self.m_InputButtons[1], self.m_IfButton, self.m_ElseButton})
			return "if ( %s ) then\n%s\nelse\n%s\nend"
		end
		
	}

},_,_,_,"Lua Comparisons")


LUABEE.CatalogFunction({

	name = "[Run]",
	args = {""},
	returns = {},
	realm = "Shared",
	desc = [[Use this to call a function and ignore its return values.
	Converts any horizontally connectable function to a vertically connectable function.
	You can connect this to any output of a block and the result will be the same.]],
	func = function() end,
	block = {
		GenerateCompileString = function(self)
			return "%s"
		end
	}
	
},_,_,_,"Lua Utilities")

LUABEE.CatalogFunction({

	name = "(Run)",
	args = {},
	returns = {""},
	realm = "Shared",
	desc = [[Use this to call a function without a return value as if it had one.
	Converts any vertically connectable function to a horizontally connectable function.
	This block always returns nil.]],
	func = function() end,
	
	block = {
		Paint = function(self)
			
			draw.NoTexture()
			local w,h = self:GetSize()
			local x,y = 0,0
			local r,g,b,a = self.m_DrawColor.r, self.m_DrawColor.g, self.m_DrawColor.b, self.m_DrawColor.a
			local inputs = self:GetInputs()
			local outputs = self:GetOutputs()
			
			surface.SetDrawColor(r,g,b,a)
			
			surface.DrawRect(x,y,w,20)--top left
			surface.DrawRect(x,h-20,20,20)--bottom left
			surface.DrawRect(w-20,h-20,20,20)--bottom right
			surface.DrawRect(x+20,y+20,w-40,h-40)--Center Square
			
			surface.DrawRect(w-20,y+20,20,h-40) --Gap Closer Right
			
			local max = 40
			surface.DrawRect(x,20,20,(h-max-40)/2)--Gap Closer left top
			surface.DrawRect(x,20+max+(h-max-40)/2,20,(h-max-40)/2)--Gap Closer left bottom
			
			surface.DrawRect(x+20,y,w-40,20)--Top Bar
			surface.DrawRect(x+20,h-20,w/2-30,20)--Bottom Left
			surface.DrawRect(w/2+10,h-20,w-(w/2+10)-20,20)--Bottom Right
			
			
			local x2,y2 = self.Label:GetPos()
			local w2,h2 = self.Label:GetSize()
			local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
			draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			
		end,
		
		Activate = function(self)
			
			self:PerformLayout()
			local inputs, outputs = self:GetInputs(), self:GetOutputs()
			local w,h = self:GetSize()
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos((w/2)-10, h-20)
			b:SetType(LUABEE_BOTTOM)
			self.m_BottomButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(0, (h/2)-10)
			b:SetType(LUABEE_OUTPUT)
			self.m_OutputButtons[1] = b
			
			self:SetActivated(true)
			
		end,
		
		ClearAllLinks = function(self)
			self.m_OutputButtons[1]:ClearInputs()
			self.m_OutputButtons[1]:ClearOutputs()
			self.m_BottomButton:ClearInputs()
			self.m_BottomButton:ClearOutputs()
		end,
		
		Run = function(self)
			
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():Run()--Run the next function.
			end
			return nil
			
		end,
		
		GenerateCompileString = function(self)
			return ""
		end
		
	}
	
},_,_,_,"Lua Utilities")

-------------------------------------------------------------------------------------------------------

LUABEE.CatalogFunction({ --Still doesn't work.

	name = "Call",
	args = {"func", "arg"},
	returns = {""},
	realm = "Shared",
	expanding = 2,
	desc = [[Calls a user-defined function.
	This function returns whatever that function returns.
	[func] MUST be a user-defined function. Usually stored in a variable.
	[arg] is an argument passed to the function.
	You can retrieve these args with Get Arg.
	[arg] is totally optional. If the function doesn't need args then don't give it args.
	See the tutorial on functions for more info.]],
	func = function() return end,
	block = {
	
		GenerateCompileString = function(self)
			local str = "%s("
			for i=1, #self.m_CompileOrder - 2 do
				str = str.."%s, "
			end
			str=str..")"
			return string.Replace(str, "s, )", "s)")
		end
	}
},_,_,_,"Lua Utilities")
LUABEE.CatalogFunction({

	name = "Get Arg",
	args = {"arg"},
	returns = {""},
	realm = "Shared",
	desc = [[Gets a function argument.
	These are defined when you Call a function with the Call block.
	[arg] must be a number. It is the arg's number as defined in the Call block.
	See the tutorial on functions for more info.]],
	func = function(i) return LUABEE.Tabs:GetActiveTab().m_CurrentArgs[i] end,
	block = {
		GenerateCompileString = function(self)
			self:SetCompileOrder({self.m_InputButtons[1]})
			return "arg%s"
		end
	}
},_,_,_,"Lua Utilities")
-------------------------------------------------------------------------------------------------------

LUABEE.CatalogFunction({

	name = "for",
	args = {"i", "til", "by"},
	returns = {},
	realm = "Shared",
	desc = [[A loop that runs the functions in the middle a certain amount of times.
	[i] is the starting number.
	[til] is the ending number.
	[by] is how much to change the starting number by each time the loop is ran. This is optional. It's 1 by default.
	
	When this function is called, a local variable will be set to [i].
	This variable will be changed by [by] until it reaches [til].
	When the variable reaches [til] (or comes as close as possible) the loop will stop and the code will continue.
	View the tutorial on loops for more information.]],
	func=function() return end,
	block = { --block is the self.m_Constructor table for each block. Use this to override anything besides init on a specific codeblock type.
		
		Activate = function(self)
			
			self:PerformLayout()
			local inputs, outputs = self:GetInputs(), self:GetOutputs()
			
			local num = #inputs
			local max = (20*num)+(20*math.max(num-1,0))
			local x2,y2
			local w,h = self:GetSize()
			h=h-100
			
			self.m_InputButtons = {}
			self.m_OutputButtons = {}
			
			for i,v in ipairs(inputs)do
				x2,y2 = w-20, (20*i)+(20*math.max(i-1,0))+((h-max)/2)-20
				local b = vgui.Create("BlockButton", self)
				b:SetPos(x2,y2)
				b:SetType(LUABEE_INPUT)
				table.insert(self.m_InputButtons, b)
			end
				
			local b = vgui.Create("BlockButton", self)
			b:SetPos(self:GetWide()/2-10, 0)
			b:SetType(LUABEE_TOP)
			self.m_TopButton = b
		
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,h-20)
			b:SetType(LUABEE_BOTTOM)
			self.m_ForButton = b
			
			local b = vgui.Create("BlockButton", self)
			b:SetPos(w/2-10,h+80)
			b:SetType(LUABEE_BOTTOM)
			self.m_BottomButton = b
			
			self:SetActivated(true)
			
		end,
		
		Run = function(self)
			local args = {}
			for k,v in ipairs(self.m_InputButtons)do --Run Each Input, save return value.
				if v:GetInputter() then
					local ParentReturns = {}
					local OutputNum = table.KeyFromValue(v:GetInputter():GetParent().m_OutputButtons, v:GetInputter()) --usually 1, but prepare for anything. 
					ParentReturns[1], ParentReturns[2], ParentReturns[3], ParentReturns[4], ParentReturns[5], ParentReturns[6], ParentReturns[7], ParentReturns[8] = v:GetInputter():GetParent():Run()
					table.insert(args, ParentReturns[OutputNum])
				end
			end
			if args[1] and args[2] then --the actual for loop
				if self.m_ForButton:GetInputter() then
					for i=args[1], args[2], (args[3] or 1) do
						self.m_ForButton:GetInputter():GetParent():Run()--Run the next function. Gotta define it or it will just continue on immediately
					end
				end
			else
				Error("For loop is missing first and/or second argument. @ x:"..math.Round(self:GetX())..", y:"..math.Round(self:GetY()))
			end
			
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():Run()--Run the next function.
			end
		end,
		
		Paint = function(self)
			
			draw.NoTexture()
			local w,h = self:GetSize()
			h=h-100
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
			
			surface.DrawRect(x,y+20,20,h-40)--Left Bar
			surface.DrawRect(x+20,y,(w/2)-20-10,20)--Top Left Filler Bar
			surface.DrawRect(x+(w/2)+10,y,(w/2)-20-10,20)--Top Right Filler Bar
			surface.DrawRect(x+20,h-20,(w/2)-20-10,20)--Bottom Left Filler Bar
			surface.DrawRect(x+(w/2)+10,h-20,(w/2)-20-10,20)--Bottom Right Filler Bar
			
			surface.DrawRect(x,y+h,(w/2)-10,100)--Tail bar
			surface.DrawRect(x+(w/2)-10,h+70,w-(x+(w/2)-10),10)--End Top
			surface.DrawRect(x+(w/2)+10,h+80,(w/2)-10,20)--End Bottom Right
			
			local x2,y2 = self.Label:GetPos()
			local w2,h2 = self.Label:GetSize()
			local r2,g2,b2 = self.LabelCol.r, self.LabelCol.g, self.LabelCol.b
			draw.RoundedBox(4, x2-3, y2-2, w2+5, h2+4, Color(r2,g2,b2,150))
			
		end,
		
		UpdateSize = function(self)
			self:SetSize(116,270)
		end,
		
		PerformLayout = function(self)
			if self:GetText() then
				self.Label:SetText("for")
			end
			self.Label:SizeToContents()
			self:UpdateSize()
			self.Label:SetPos(60-(self.Label:GetWide()/2),85-(self.Label:GetTall()/2))
		end,
		
		ClearAllLinks = function(self)
			for k,v in pairs(self.m_InputButtons)do
				v:ClearInputs()
				v:ClearOutputs()
			end
			self.m_TopButton:ClearInputs()
			self.m_TopButton:ClearOutputs()
			self.m_BottomButton:ClearInputs()
			self.m_BottomButton:ClearOutputs()
			self.m_ForButton:ClearInputs()
			self.m_ForButton:ClearOutputs()
		end,
		ChainDelete = function(self)
			for k,v in pairs(self.m_InputButtons)do
				if v:GetInputter() then
					v:GetInputter():GetParent():ChainDelete()
				end
			end
			if self.m_ForButton:GetInputter() then
				self.m_ForButton:GetInputter():GetParent():ChainDelete()
			end
			if self.m_BottomButton:GetInputter() then
				self.m_BottomButton:GetInputter():GetParent():ChainDelete()
			end
			self:Delete()
		end,
		
		GenerateCompileString = function(self)
			local str = "for i=(%s), (%s)"
			if self.m_InputButtons[3]:GetInputter() then
				str = str..", (%s)"
			end
			return str.."do\n%s\nend"
		end
		
	}

},_,_,_,"Lua Utilities")
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
LUABEE.CatalogFunction({

	name = "==",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] and [b] are the same exact thing.
	[a] and [b] don't have to be numbers. They can be anything.
	Returns true or false.
	The difference between "==" and "=" is that "==" is a question, while "=" is a statement.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return a==b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s == %s)"
		end
	}
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = "<",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] is less than [b].
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	Returns true or false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return a<b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s < %s)"
		end
	}
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = "<=",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] is less than or equal to [b].
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	Returns true or false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return a<=b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s <= %s)"
		end
	}
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = ">",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] is greater than [b].
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	Returns true or false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return a>b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s > %s)"
		end
	}
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = ">=",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] is greater than or equal to [b].
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	Returns true or false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return a>=b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s >= %s)"
		end
	}
},_,_,_,"Lua Comparisons")
-------------------------------------------------------------------------------------------------------------
LUABEE.CatalogFunction({

	name = "and",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] AND [b].
	BOTH [a] AND [b] must be true or this will return false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return (a and b) end,
	block = {
		GenerateCompileString = function(self)
			return "(%s and %s)"
		end
	}
	
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = "or",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Checks to see if [a] OR [b].
	Both [a] and [b] must be false for this to return false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return (a or b) end,
	block = {
		GenerateCompileString = function(self)
			return "(%s or %s)"
		end
	}
	
},_,_,_,"Lua Comparisons")
LUABEE.CatalogFunction({

	name = "not",
	args = {""},
	returns = {""},
	realm = "Shared",
	desc = [[Changes true to false and false to true.
	If the input is false or nil it returns true.
	If the input is anything besides false or nil, the input returns false.
	See the tutorial on comparisons for more info.]],
	func=function(a,b) return (a or b) end,
	block = {
		GenerateCompileString = function(self)
			return "(not %s)"
		end
	}
	
},_,_,_,"Lua Comparisons")
------------------------------------------------------------------------------------------------------------
LUABEE.CatalogFunction({

	name = "*",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Multiplies [a] by [b]. ([a]*[b])
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	See the tutorial on arithmetic for more info.]],
	func=function(a,b) return a*b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s * %s)"
		end
	}
	
},_,_,_,"Lua Operators")
LUABEE.CatalogFunction({

	name = "/",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Divides [a] by [b]. ([a]/[b])
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	See the tutorial on arithmetic for more info.]],
	func=function(a,b) return a/b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s / %s)"
		end
	}
	
},_,_,_,"Lua Operators")
LUABEE.CatalogFunction({

	name = "+",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Adds [a] to [b]. ([a]+[b])
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	See the tutorial on arithmetic for more info.]],
	func=function(a,b) return a+b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s + %s)"
		end
	}
	
},_,_,_,"Lua Operators")
LUABEE.CatalogFunction({

	name = "-",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Subtracts [b] from [a]. ([a]-[b])
	[a] and [b] don't have to be numbers. They can be anything.
	Usually, however, a and b must be numbers. Vectors and Angles also work.
	See the tutorial on arithmetic for more info.]],
	func=function(a,b) return a-b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s - %s)"
		end
	}
	
},_,_,_,"Lua Operators")
------------------------------------------------------------------------------------------------------------
LUABEE.CatalogFunction({

	name = ". .",
	args = {"a", "b"},
	returns = {""},
	realm = "Shared",
	desc = [[Attaches [a] to [b].
	[a] and [b] should be strings.
	If [a] is "Hello," and [b] is " World!" then this would return "Hello, World!".
	See the tutorial on strings for more info.]],
	func=function(a,b) return a..b end,
	block = {
		GenerateCompileString = function(self)
			return "(%s .. %s)"
		end
	}
	
},_,_,_,"Lua Operators")
LUABEE.CatalogFunction({
	name = [[ # ]],
	args = {"a"},
	returns = {""},
	realm = "Shared",
	desc = [[Returns the length of a table [a].
	[a] must be a table with consecutive numerical keys only.
	This is the same thing as table.getn([a])
	If the table has non-consecutive keys or non-numerical keys then use table.Count([a]) to find the length.
	Returns a number.
	See the tutorial on tables for more info.]],
	func=function(a) return #a end,
	block = {
		GenerateCompileString = function(self)
			return "(#%s)"
		end
	}
},_,_,_,"Lua Operators")

