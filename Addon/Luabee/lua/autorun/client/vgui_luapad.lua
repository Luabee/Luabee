-- LuaPad module cl_luapad_panel.lua: 
surface.CreateFont("LuapadEditor", {
	font = "Courier New",
	size = 16,
	weight = 400
})
surface.CreateFont("LuapadEditor_Bold", {
	font = "Courier New",
	size = 16,
	weight = 800
})

LuaPadEditor = {}
LuaPadEditor.LUA_KEYWORDS = {
	"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"
}

LuaPadEditor.MatchPairs = {
	["\""] = "\"",
	["("] = ")",
	["["] = "]"
}

LuaPadEditor.HOOK_IMPORTANT = 3
LuaPadEditor.HOOK_NORMAL = 2
LuaPadEditor.HOOK_UNIMPORTANT = 1

local function HookTblSorter(a, b)
	return a.priority < b.priority
end

function LuaPadEditor:AddHook( name, id, cb )
	--priority = priority or self.HOOK_NORMAL

	self.Hooks = self.Hooks or {}
	self.Hooks[name] = self.Hooks[name] or {}
	self.Hooks[name][id] = {callback = cb }
	--table.sort(self.Hooks[name], HookTblSorter)
end

function LuaPadEditor:CallHook( name, ... )

	if self.Hooks and self.Hooks[name] then
		for id,val in pairs(self.Hooks[name]) do
			local ret = {val.callback(self, ...)}
			if ret[1] then return unpack(ret) end
		end
	end

	local fn = self[name]
	if not fn then return end
	return fn(self, ...)
end

function LuaPadEditor:Init()
	self:SetCursor("beam");

	surface.SetFont("LuapadEditor");
	self.FontWidth, self.FontHeight = surface.GetTextSize(" ");

	self.Rows = {""};
	self.Caret = {1, 1};
	self.Start = {1, 1};
	self.Scroll = {1, 1};
	self.Size = {1, 1};
	self.PaintRows = {};

	self.Blink = RealTime();

	self.ScrollBar = vgui.Create("DVScrollBar", self);
	self.ScrollBar:SetUp(1, 1);

	self.TextEntry = vgui.Create("TextEntry", self);
	self.TextEntry:SetMultiline(true);
	self.TextEntry:SetSize(0, 0);

	self.TextEntry.OnLoseFocus = function (self) self.Parent:_OnLoseFocus(); end
	self.TextEntry.OnTextChanged = function (self) self.Parent:_OnTextChanged(); end
	self.TextEntry.OnKeyCodeTyped = function (self, code) self.Parent:_OnKeyCodeTyped(code); end

	self.TextEntry.Parent = self;

	self.LastClick = 0;

	self:CallHook("Initialize")

end

function LuaPadEditor:RequestFocus()
	self.TextEntry:RequestFocus();
end

function LuaPadEditor:OnGetFocus()
	self.TextEntry:RequestFocus();
end

function LuaPadEditor:GetValue()
	return string.Implode("\n", self.Rows)
end

function LuaPadEditor:CheckGlobal(func)
	if self.OverrideGlobal then return self.OverrideGlobal[func]
	elseif(_G[func] != nil) then return _G[func]; end

	return false;
end

function LuaPadEditor:SetStatus(status, time)
	time = time or 5

	self.Status = {
		Msg = status,
		Alpha = status == "" and 0 or 1
	}
	timer.Create("LuaPadStatusAlpha", time, 1, function()
		if not self.Status then return end
		self.Status.Alpha = 0
	end)
end

function LuaPadEditor:CursorToCaret()
	local x, y = self:CursorPos();

	x = x - (self.FontWidth * 3 + 6);
	if(x < 0) then x = 0; end
	if(y < 0) then y = 0; end

	local line = math.floor(y / self.FontHeight);
	local char = math.floor(x / self.FontWidth + 0.5);

	line = line + self.Scroll[1];
	char = char + self.Scroll[2];

	if(line > #self.Rows) then line = #self.Rows; end
	local length = string.len(self.Rows[line]);
	if(char > length + 1) then char = length + 1; end

	return { line, char };
end

function LuaPadEditor:CaretPos()
	local line, char = self.Caret[1], self.Caret[2]
	if not line or not char then return end

	local y = line * self.FontHeight
	local x = char * self.FontWidth - 0.5 + (self.FontWidth * 3 + 6)

	return x, y
end

function LuaPadEditor:SetText(text)
	self.Rows = string.Explode("\n", text);
	if(self.Rows[#self.Rows] != "") then
		self.Rows[#self.Rows + 1] = "";
	end

	self.Caret = {1, 1};
	self.Start = {1, 1};
	self.Scroll = {1, 1};
	self.Undo = {};
	self.Redo = {};
	self.PaintRows = {};

	self.ScrollBar:SetUp(self.Size[1], #self.Rows - 1);
end

function LuaPadEditor:NextChar()
	if(!self.char) then return end

	self.str = self.str .. self.char
	self.pos = self.pos + 1

	if(self.pos <= string.len(self.line)) then
		self.char = string.sub(self.line, self.pos, self.pos)
	else
		self.char = nil
	end
end

function LuaPadEditor:PerformLayout()
	self.ScrollBar:SetSize(16, self:GetTall())
	self.ScrollBar:SetPos(self:GetWide() - 16, 0)

	self.Size[1] = math.floor(self:GetTall() / self.FontHeight) - 1
	self.Size[2] = math.floor((self:GetWide() - (self.FontWidth * 3 + 6) - 16) / self.FontWidth) - 1

	self.ScrollBar:SetUp(self.Size[1], #self.Rows - 1)
end

function LuaPadEditor:GetCaretMemberGet(stopatperiod)
	local line, char = self.Caret[1], self.Caret[2]
 	local row = self.Rows[line]
 	local lchar, rchar = char-1, char-1 -- we must start at character on left side of caret

 	local function IsValidChar(c)
 		if c == "." then
 			return not stopatperiod
 		end
 		return (c >= "a" and c <= "z") or
 				(c >= "A" and c <= "Z") or
 				(c >= "0" and c <= "9")
 	end

 	-- First traverse left

 	while true do
 		local lower = lchar - 1
 		if lower > 0 and IsValidChar(row:sub(lower, lower)) then
 			lchar = lower
 		else break end
 	end

 	while true do
 		local higher = rchar + 1
 		if higher <= string.len(row) and IsValidChar(row:sub(higher, higher)) then
 			rchar = higher
 		else break end
 	end

 	return row:sub(lchar, rchar), lchar, rchar
 end
 
 function LuaPadEditor:SetCaret(caret)
	self.Caret = self:CopyPosition(caret)
	self.Start = self:CopyPosition(caret)
	self:ScrollCaret()
 end

 function LuaPadEditor:CopyPosition(caret)
	return { caret[1], caret[2] }
 end

 function LuaPadEditor:MovePosition(caret, offset)
	local caret = { caret[1], caret[2] }

	if(offset > 0) then
		while true do
			local length = string.len(self.Rows[caret[1]]) - caret[2] + 2
			if(offset < length) then
				caret[2] = caret[2] + offset
				break
			elseif(caret[1] == #self.Rows) then
				caret[2] = caret[2] + length - 1
				break
			else
				offset = offset - length
				caret[1] = caret[1] + 1
				caret[2] = 1
			end
		end
	elseif(offset < 0) then
		offset = -offset
		
		while true do
			if(offset < caret[2]) then
				caret[2] = caret[2] - offset
				break
			elseif(caret[1] == 1) then
				caret[2] = 1
				break
			else
				offset = offset - caret[2]
				caret[1] = caret[1] - 1
				caret[2] = string.len(self.Rows[caret[1]]) + 1
			end
		end
	end
	
	return caret
 end

 function LuaPadEditor:HasSelection()
	return self.Caret[1] != self.Start[1] || self.Caret[2] != self.Start[2]
 end

 function LuaPadEditor:Selection()
	return { { self.Caret[1], self.Caret[2] }, { self.Start[1], self.Start[2] } }
 end

 function LuaPadEditor:MakeSelection(selection)
	local start, stop = selection[1], selection[2]

	if(start[1] < stop[1] or start[1] == stop[1] and start[2] < stop[2]) then
		return start, stop
	else
		return stop, start
	end
 end

 function LuaPadEditor:GetArea(selection)
	local start, stop = self:MakeSelection(selection)

	if(start[1] == stop[1]) then
		return string.sub(self.Rows[start[1]], start[2], stop[2] - 1)
	else
		local text = string.sub(self.Rows[start[1]], start[2])
		
		for i=start[1]+1,stop[1]-1 do
			text = text .. "\n" .. self.Rows[i]
		end
		
		return text .. "\n" .. string.sub(self.Rows[stop[1]], 1, stop[2] - 1)
	end
 end

 function LuaPadEditor:SetArea(selection, text, isundo, isredo, before, after)
	local start, stop = self:MakeSelection(selection)
	
	local buffer = self:GetArea(selection)
	
	if(start[1] != stop[1] or start[2] != stop[2]) then
		-- clear selection
		self.Rows[start[1]] = string.sub(self.Rows[start[1]], 1, start[2] - 1) .. string.sub(self.Rows[stop[1]], stop[2])
		self.PaintRows[start[1]] = false
		
		for i=start[1]+1,stop[1] do
			table.remove(self.Rows, start[1] + 1)
			table.remove(self.PaintRows, start[1] + 1)
			self.PaintRows = {} -- TODO: fix for cache errors
		end
		
		-- add empty row at end of file (TODO!)
		if(self.Rows[#self.Rows] != "") then
			self.Rows[#self.Rows + 1] = ""
			self.PaintRows[#self.Rows + 1] = false
		end
	end
	
	if(!text or text == "") then
		self.ScrollBar:SetUp(self.Size[1], #self.Rows - 1)
		
		self.PaintRows = {}
	
		self:OnTextChanged()
	
		if(isredo) then
			self.Undo[#self.Undo + 1] = { { self:CopyPosition(start), self:CopyPosition(start) }, buffer, after, before }
			return before
		elseif(isundo) then
			self.Redo[#self.Redo + 1] = { { self:CopyPosition(start), self:CopyPosition(start) }, buffer, after, before }
			return before
		else
			self.Redo = {}
			self.Undo[#self.Undo + 1] = { { self:CopyPosition(start), self:CopyPosition(start) }, buffer, self:CopyPosition(selection[1]), self:CopyPosition(start) }
			return start
		end
	end
	
	-- insert text
	local rows = string.Explode("\n", text)
	
	local remainder = string.sub(self.Rows[start[1]], start[2])
	self.Rows[start[1]] = string.sub(self.Rows[start[1]], 1, start[2] - 1) .. rows[1]
	self.PaintRows[start[1]] = false
	
	for i=2,#rows do
		table.insert(self.Rows, start[1] + i - 1, rows[i])
		table.insert(self.PaintRows, start[1] + i - 1, false)
		self.PaintRows = {} // TODO: fix for cache errors
	end

	local stop = { start[1] + #rows - 1, string.len(self.Rows[start[1] + #rows - 1]) + 1 }
	
	self.Rows[stop[1]] = self.Rows[stop[1]] .. remainder
	self.PaintRows[stop[1]] = false
	
	-- add empty row at end of file (TODO!)
	if(self.Rows[#self.Rows] != "") then
		self.Rows[#self.Rows + 1] = ""
		self.PaintRows[#self.Rows + 1] = false
		self.PaintRows = {} // TODO: fix for cache errors
	end
	
	self.ScrollBar:SetUp(self.Size[1], #self.Rows - 1)
	
	self.PaintRows = {}
	
	self:OnTextChanged()
	
	if(isredo) then
		self.Undo[#self.Undo + 1] = { { self:CopyPosition(start), self:CopyPosition(stop) }, buffer, after, before }
		return before
	elseif(isundo) then
		self.Redo[#self.Redo + 1] = { { self:CopyPosition(start), self:CopyPosition(stop) }, buffer, after, before }
		return before
	else
		self.Redo = {}
		self.Undo[#self.Undo + 1] = { { self:CopyPosition(start), self:CopyPosition(stop) }, buffer, self:CopyPosition(selection[1]), self:CopyPosition(stop) }
		return stop
	end
 end

 function LuaPadEditor:GetSelection()
	return self:GetArea(self:Selection())
 end

 function LuaPadEditor:SetSelection(text)
	self:SetCaret(self:SetArea(self:Selection(), text))
 end

 function LuaPadEditor:_OnLoseFocus()
	if(self.TabFocus) then
		self:RequestFocus()
		self.TabFocus = nil
	end
 end

 function LuaPadEditor:_OnTextChanged()
	local ctrlv = false
	local text = self.TextEntry:GetValue()
	self.TextEntry:SetText("")

	if input.IsKeyDown(KEY_BACKQUOTE) and IgnoreConsoleOpen then return end
	
	if((input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)) and not (input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT))) then
		-- ctrl+[shift+]key
		if(input.IsKeyDown(KEY_V)) then
			-- ctrl+[shift+]V
			ctrlv = true
		else
			-- ctrl+[shift+]key with key ~= V
			return
		end
	end
	
	if(text == "") then return end
	if(not ctrlv) then
		if(text == "\n") then return end
		if(text == "end") then
			local row = self.Rows[self.Caret[1]]
		end
	end
	
	self:SetSelection(text)
	if self.MatchPairs[text] then
		local cchar = self.Caret[2]
		self:SetSelection(self.MatchPairs[text])
		self:SetCaret({self.Caret[1], cchar})
	end

	self:CallHook("TextChanged", text, self:GetValue())
 end

 function LuaPadEditor:ScrollCaret()
	if(self.Caret[1] - self.Scroll[1] < 2) then
		self.Scroll[1] = self.Caret[1] - 2
		if(self.Scroll[1] < 1) then self.Scroll[1] = 1 end
	end

	if(self.Caret[1] - self.Scroll[1] > self.Size[1] - 2) then
		self.Scroll[1] = self.Caret[1] - self.Size[1] + 2
		if(self.Scroll[1] < 1) then self.Scroll[1] = 1 end
	end
	
	if(self.Caret[2] - self.Scroll[2] < 4) then
		self.Scroll[2] = self.Caret[2] - 4
		if(self.Scroll[2] < 1) then self.Scroll[2] = 1 end
	end
	
	if(self.Caret[2] - 1 - self.Scroll[2] > self.Size[2] - 4) then
		self.Scroll[2] = self.Caret[2] - 1 - self.Size[2] + 4
		if(self.Scroll[2] < 1) then self.Scroll[2] = 1 end
	end
	
	self.ScrollBar:SetScroll(self.Scroll[1] - 1)
 end

 function unindent(line)
	local i = line:find("%S")
	if(i == nil or i > 5) then i = 5 end
	return line:sub(i)
 end

 function LuaPadEditor:GetWordStart(caret)
	local line = string.ToTable(self.Rows[caret[1]])

	local caret1, caret2 = caret[1], caret[2]

	if #line == caret2 - 1 then caret2 = caret2 - 1 end
	if #line < caret2 then return caret end

	for i=0,caret2 do
		if(!line[caret2-i]) then return {caret1,caret2-i+1} end
		if(line[caret2-i] >= "a" and line[caret2-i] <= "z" or line[caret2-i] >= "A" and line[caret2-i] <= "Z" or line[caret2-i] >= "0" and line[caret2-i] <= "9" or line[caret2-i] == ")" --[[ HACK HACK HACK]]) then else return {caret1,caret2-i+1} end
	end
	return {caret1,1}
 end

 function LuaPadEditor:GetWordEnd(caret)
	local line = string.ToTable(self.Rows[caret[1]])
	if(#line < caret[2]) then return caret end
	for i=caret[2],#line do
		if(!line[i]) then return {caret[1],i} end
		if(line[i] >= "a" and line[i] <= "z" or line[i] >= "A" and line[i] <= "Z" or line[i] >= "0" and line[i] <= "9") then else return {caret[1],i} end
	end
	return {caret[1],#line+1}
 end
 
 function LuaPadEditor:Indent(shift)
	local tab_scroll = self:CopyPosition(self.Scroll)
	local tab_start, tab_caret = self:MakeSelection(self:Selection())
	tab_start[2] = 1

	if(tab_caret[2] ~= 1) then
		tab_caret[1] = tab_caret[1] + 1
		tab_caret[2] = 1
	end

	self.Caret = self:CopyPosition(tab_caret)
	self.Start = self:CopyPosition(tab_start)

	if (self.Caret[2] == 1) then
		self.Caret = self:MovePosition(self.Caret, -1)
	end
	
	if(shift) then
		local tmp = self:GetSelection():gsub("\n ? ? ? ?", "\n")
		self:SetSelection(unindent(tmp))
	else
		self:SetSelection("    " .. self:GetSelection():gsub("\n", "\n    "))
	end
	
	self.Caret = self:CopyPosition(tab_caret)
	self.Start = self:CopyPosition(tab_start)
	self.Scroll = self:CopyPosition(tab_scroll)
	self:ScrollCaret()
 end
 
 function LuaPadEditor:OnTextChanged()
	self:CallHook("TextChanged", "", self:GetValue())
 end
 
 function LuaPadEditor:OnShortcut()
 end

-- LuaPad module cl_luapad_panel_autocompl.lua: 

LuaPadEditor:AddHook("SetupKeys", "AutoCompletion", function(self)

	local function SelectAutoCompl(self, isTab)
		local sugg = self:GetSuggestions()
		if self.SuggestionsVisible and sugg and #sugg > 0 then
			local hovered = sugg[self.HoveredSuggestion or 1]
			if hovered then
				local line = self.Caret[1]
				--local cword, lchar, rchar = self:GetCaretWord(true)

				--self:SetCaret(self:SetArea({self.Caret, self:MovePosition(self.Caret, -string.len(cword))}))
				--self:SetCaret(self:SetArea({ {line, lchar}, {line, rchar+1} }))

				self.Start = self:GetWordStart(self.Caret)
				self.Caret = self:GetWordEnd(self.Caret)
				self:SetSelection(hovered.name)

				local cchar = self.Caret[2]

				self.SuggestionsVisible = false

				if hovered.atype == "function" then
					self:SetArea({ {line, cchar}, {line, cchar+2} }, "()")
					self:SetCaret({line, cchar+1})
				elseif hovered.atype == "table" then
					self:SetArea({ {line, cchar}, {line, cchar+1} }, ".")
					self:SetCaret({line, cchar+1})
					self.SuggestionsVisible = true
				end

				self:_OnTextChanged()

			end

			if isTab then
				self.TabFocus = true
			end

			return true
		end
	end

	self:SetupKey("Select Auto-Completion", "ENTER", SelectAutoCompl)
	self:SetupKey("Select Auto-Completion (alt)", "TAB", function(self)
		return SelectAutoCompl(self, true)
	end)

	self:SetupKey("Move Down In Auto-Completion List", "DOWN", function(self)
		if self.SuggestionsVisible then
			self.HoveredSuggestion = (self.HoveredSuggestion or 0) + 1
			return true
		end
	end)
	self:SetupKey("Move Up In Auto-Completion List", "UP", function(self)
		if self.SuggestionsVisible then
			self.HoveredSuggestion = (self.HoveredSuggestion or 0) - 1
			return true
		end
	end)
end)

LuaPadEditor.AutoComplVariableColors = {
	string = Color(0, 0, 127),
	table = Color(127, 0, 127),
	Other = Color(0, 0, 0)
}

LuaPadEditor:AddHook("PostPaint", "AutoCompletion", function(self)
	local sugg = self:GetSuggestions()
	if sugg and self.SuggestionsVisible then
		local cx, cy = self:CaretPos()

		if #sugg == 0 then
			--self.SuggestionsVisible = false
		end

		surface.SetFont("LuapadEditor")

		local eah = draw.GetFontHeight("LuapadEditor") * 1.7
		local cw, ch = 150, 0

		local suggs = 0
		for k,v in pairs(sugg) do
			if suggs > 15 then break end
			local tw, th = surface.GetTextSize(v.name)
			cw = math.max(tw + 14, cw)
			suggs = suggs + 1
		end

		ch = math.min(#sugg, 16) * eah

		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawRect(cx, cy, cw, ch)
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawOutlinedRect(cx, cy, cw, ch)

		if not self.HoveredSuggestion or not self.SuggestionsVisible then
			self.HoveredSuggestion = 1
		end

		do
			if self.HoveredSuggestion < 1 then
				self.HoveredSuggestion = #sugg
			elseif self.HoveredSuggestion > #sugg then
				self.HoveredSuggestion = 1
			end
		end

		local suggs = 0
		for k,v in ipairs(sugg) do
			if suggs > 15 then break end

			local clr = self.AutoComplVariableColors[v.atype] or self.AutoComplVariableColors.Other

			if self.HoveredSuggestion == k then
				surface.SetDrawColor(Color(0, 127, 0, 100))
				surface.DrawRect(cx + 2, cy + 2 + (k-1)*eah, cw - 4, eah-4)
			end

			draw.DrawText(v.name, "LuapadEditor", cx + 5, cy + 5 + (k-1)*eah, clr, TEXT_ALIGN_LEFT)
			suggs = suggs + 1
		end
	end
end)

function LuaPadEditor:FindVar(var)
	local loc = var:Split(".")
	local x = self.OverrideGlobal or _G
	for _, v in ipairs( loc ) do
		x = x[ v ]
		if not x then return end
	end
	return x
end

function LuaPadEditor:FindVarParent(var)
	local loc = var:Split(".")
	local x = self.OverrideGlobal or _G
	if #loc > 1 and not x[loc[1]] then
		return nil -- it's not in _G, we can give up
	end
	local par
	for _, v in ipairs( loc ) do
		par = x
		if type(x) ~= "table" then return nil end -- We shouldnt have a suggestions at all (except metatable?) if indexing nontable
		x = x[ v ]
		if not x then return par end
	end
	return par
end

function LuaPadEditor:FindPossibleVars(var)
	local last = var:Split(".")
	last = last[#last]
	local par = self:FindVarParent(var)
	if par then
		local r = {}
		for name,value in SortedPairs(par) do
			if name:StartWith(last) and name ~= last then
				table.insert(r, {name = name, atype = type(value)})
			end
		end
		return r
	end
	return nil
end

function LuaPadEditor:FindPossibleKeyWords(var)
	for _,kw in pairs(self.LUA_KEYWORDS) do
		if kw:StartWith(var) then
			return kw
		end
	end
end

function LuaPadEditor:GetSuggestions()
	local cword = self:GetCaretMemberGet()

	if cword == "" then return end
	local sugg = {}

	local var = self:FindPossibleVars(cword)
	table.Add(sugg, var)

	local kw = self:FindPossibleKeyWords(cword)
	if kw then
		table.insert(sugg, {name = kw, atype = "string"})
	end

	for _,su in pairs(sugg) do
		if su.name == cword then
			table.RemoveByValue(sugg, su)
		end
	end

	return #sugg > 0 and sugg or nil
end

-- LuaPad module cl_luapad_panel_errchck.lua: 
LuaPadEditor:AddHook("PaintRowGutter", "ErrorChecker", function(self, row, width, height)
	if self.ErrorLine and self.ErrorLine.line == row then
		surface.DrawCircle(width+7, height+7, 5, Color(255, 0, 0))
	end
end)

LuaPadEditor:AddHook("TextChanged", "ErrorChecker", function(self, inserted, fulltext)

	local func = fulltext:len() > 0 and CompileString( fulltext, "TestCode", false ) or false

	if type(func) == "string" and not func:StartWith("Invali") then
		local line, msg = string.match(func, "%a+:(%d+):(.+)")
		self.ErrorLine = {
			line = tonumber(line),
			err = msg
		}
		self:SetStatus("Error on #" .. tostring(line) .. ": " .. msg)
		--MsgN(line, ": ", msg)
	else
		self:SetStatus("")
		self.ErrorLine = nil
	end
end)

-- LuaPad module cl_luapad_panel_exec.lua: 
--[[

local function FindPlys(pattern)
	pattern = pattern:Replace("*", ".-")
	local plys = {}
	for _,ply in pairs(player.GetAll()) do
		if ply:Nick():match(pattern) then
			table.insert(plys, ply)
		end
	end
	return plys
end

local function RunClCode(code)
	local func = CompileString( code, "TestCode", false )
	if type(func) == "function" then
		local env = {
			me = LocalPlayer(),
			plys = FindPlys
		}
		setmetatable(env, {__index = _G})
		setfenv(func, env)
		MsgN("== EXECUTING CODE ==")
		local time = RealTime()
		func()
		MsgN("== CODE EXECUTION FINISHED ==")
		MsgN("== Execution Time: " .. tostring(RealTime() - time) .. " ==")
	else
		MsgN("Error: ", func)
	end
end

LuaPadEditor:AddHook("SetupKeys", "ExecCode", function(self)
	self:SetupKey("Run Code", "CTRL S", function(self)
		RunClCode(self:GetValue())
	end)
end)
]]

-- LuaPad module cl_luapad_panel_fixindent.lua: 

local IndentCharacters = {" ", "	"}

local function TrimIndentations(line)
	local fi = 1
	for i=1,line:len() do
		if not table.HasValue(IndentCharacters, line:sub(i, i)) then fi = i break end
	end
	return line:sub(fi)
end

local function EndWithKeyword(line, keyword)
	local len = line:len()
	local klen = keyword:len()

	local lsoff = 1
	if line:sub(len, len) == ";" then lsoff = lsoff - 2 end
	if line:sub(len, len) == ")" then lsoff = lsoff - 2 end

	local nl = len-klen+lsoff

	if line:sub(nl, nl + klen) == keyword then
		return true
	end
	return false
end

local function Finds(string, pattern)
	local count = 0
	for i in string.gmatch(string, pattern) do
	   count = count + 1
	end
	return count
end

local function CheckEnds(row)
	local thens = Finds(row, "then")
	local ends = Finds(row, "end")
	if thens == ends then return false end

	return EndWithKeyword(row, "end")
end

local function CheckBrackets(row)
	local l = Finds(row, "{")
	local r = Finds(row, "}")
	return l ~= r
end

function LuaPadEditor:FixLuaIndentation(spacesPerIndent)
	spacesPerIndent = spacesPerIndent or 4

	local indentlevel = 0
	for ln,row in pairs(self.Rows) do
		local trimmedrow = row:Trim()
		if trimmedrow:StartWith("until") or CheckEnds(trimmedrow) or (EndWithKeyword(trimmedrow, "}") and CheckBrackets(trimmedrow)) then
			indentlevel = indentlevel - 1
		end

		if Finds(row, "elseif") > 0 or Finds(row, "else") > 0 then indentlevel = indentlevel - 1 end

		self.Rows[ln] = string.rep(" ", indentlevel*spacesPerIndent) .. trimmedrow

		if EndWithKeyword(trimmedrow, "do") or EndWithKeyword(trimmedrow, "then") or EndWithKeyword(trimmedrow, "else") or (CheckBrackets(row) or EndWithKeyword(row, "{")) or trimmedrow:find("function(.*)%)") then
			indentlevel = indentlevel + 1
		end
		indentlevel = math.max(indentlevel, 0)
	end
end

-- LuaPad module cl_luapad_panel_history.lua: 

LuaPadEditor:AddHook("Initialize", "History", function(self)
	self.Undo = {}
	self.Redo = {}
end)

LuaPadEditor:AddHook("SetupKeys", "History", function(self)
	self:SetupKey("Undo", "CTRL Z", self.DoUndo)
	self:SetupKey("Redo", "CTRL SHIFT Z", self.DoRedo)
end)

LuaPadEditor:AddHook("RightMouseMenu", "History", function(self, menu)
	if(self:CanUndo()) then
		menu:AddOption("Undo", function()
			self:DoUndo()
		end)
	end
	if(self:CanRedo()) then
		menu:AddOption("Redo", function()
			self:DoRedo()
		end)
	end
	if self:CanUndo() or self:CanRedo() then
		menu:AddSpacer()
	end
end)

function LuaPadEditor:CanUndo()
	return #self.Undo > 0
end

function LuaPadEditor:DoUndo()
	if(#self.Undo > 0) then
		local undo = self.Undo[#self.Undo]
		self.Undo[#self.Undo] = nil
		
		self:SetCaret(self:SetArea(undo[1], undo[2], true, false, undo[3], undo[4]))
	end
end

function LuaPadEditor:CanRedo()
	return #self.Redo > 0
end

function LuaPadEditor:DoRedo()
	if(#self.Redo > 0) then
		local redo = self.Redo[#self.Redo]
		self.Redo[#self.Redo] = nil
		
		self:SetCaret(self:SetArea(redo[1], redo[2], false, true, redo[3], redo[4]))
	end
end

-- LuaPad module cl_luapad_panel_keys.lua: 

LuaPadEditor:AddHook("Initialize", "Keys", function(self)
	self.Shortcuts = {}

	self:CallHook("SetupKeys")
end)

local function FunctionCaller(fn, bool)
	return function(self)
		return fn(self, bool)
	end
end

LuaPadEditor:AddHook("SetupKeys", "DefaultKeys", function(self)
	--[[ Not sure these do anything

	self:SetupKey("Scroll Up", "CTRL UP", function(self)
		self.Scroll[1] = self.Scroll[1] - 1
		if(self.Scroll[1] < 1) then self.Scroll[1] = 1 end
	end)
	self:SetupKey("Scroll Down", "CTRL DOWN", function(self)
		self.Scroll[1] = self.Scroll[1] + 1
	end)
	self:SetupKey("Scroll Left", "CTRL LEFT", function(self)
		if self:HasSelection() then -- ?
			self.Start = self:CopyPosition(self.Caret)
		end
		self:ScrollCaret()
		self.Start = self:CopyPosition(self.Caret)
	end)
	self:SetupKey("Scroll Right", "CTRL RIGHT", function(self)
		if self:HasSelection() then -- ?
			self.Start = self:CopyPosition(self.Caret)
		end
		self:ScrollCaret()
		self.Start = self:CopyPosition(self.Caret)
	end)
	]]
	self:SetupDefKey("Select To Word Start", "CTRL SHIFT LEFT", function(self)
		self.Caret = self:GetWordStart(self:MovePosition(self.Caret, -2))
		self:ScrollCaret()
	end)
	self:SetupDefKey("Select To Word End", "CTRL SHIFT RIGHT", function(self)
		self.Caret = self:GetWordEnd(self:MovePosition(self.Caret, 1))
		self:ScrollCaret()
	end)

	local function MoveToHome(self, shift)
		self.Caret[1] = 1
		self.Caret[2] = 1
		
		self:ScrollCaret()

		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end
	local function MoveToEnd(self, shift)
		self.Caret[1] = #self.Rows
		self.Caret[2] = 1
		
		self:ScrollCaret()

		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Move To Page Start", "CTRL HOME", FunctionCaller(MoveToHome, false))
	self:SetupDefKey("Select To Page Start", "CTRL SHIFT HOME", FunctionCaller(MoveToHome, true))

	self:SetupDefKey("Move To Page End", "CTRL END", FunctionCaller(MoveToEnd, false))
	self:SetupDefKey("Select To Page End", "CTRL SHIFT END", FunctionCaller(MoveToEnd, true))

	self:SetupDefKey("New Line", "ENTER", function(self)
		local row = self.Rows[self.Caret[1]]:sub(1,self.Caret[2]-1)
		local rowt = row:Trim()
		local diff = (row:find("%S") or (row:len()+1))-1
		local tabcount = math.floor(diff / 4)

		if rowt:EndsWith("then") or rowt:EndsWith("do") or rowt:EndsWith("until") or rowt:EndsWith("{") then
			tabcount = tabcount + 1
		end

		local tabs = string.rep("    ", tabcount)
		self:SetSelection("\n" .. tabs)
	end)

	local function MoveUp(self, shift)
		if(self.Caret[1] > 1) then
			self.Caret[1] = self.Caret[1] - 1
			
			local length = string.len(self.Rows[self.Caret[1]])
			if(self.Caret[2] > length + 1) then
				self.Caret[2] = length + 1
			end
		end
		
		self:ScrollCaret()
		
		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Move Up", "UP", FunctionCaller(MoveUp, false))
	self:SetupDefKey("Select Up", "SHIFT UP", FunctionCaller(MoveUp, true))

	local function MoveDown(self, shift)
		if(self.Caret[1] < #self.Rows) then
			self.Caret[1] = self.Caret[1] + 1
			
			local length = string.len(self.Rows[self.Caret[1]])
			if(self.Caret[2] > length + 1) then
				self.Caret[2] = length + 1
			end
		end
		
		self:ScrollCaret()
		
		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Move Down", "DOWN", FunctionCaller(MoveDown, false))
	self:SetupDefKey("Select Down", "SHIFT DOWN", FunctionCaller(MoveDown, true))

	local function MoveLeft(self, shift)
		if self:HasSelection() and not shift then
			self.Start = self:CopyPosition(self.Caret)
		else
			self.Caret = self:MovePosition(self.Caret, -1)
		end
		
		self:ScrollCaret()
		
		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Move Left", "LEFT", FunctionCaller(MoveLeft, false))
	self:SetupDefKey("Select Left", "SHIFT LEFT", FunctionCaller(MoveLeft, true))

	local function MoveRight(self, shift)
		if self:HasSelection() and not shift then
			self.Start = self:CopyPosition(self.Caret)
		else
			self.Caret = self:MovePosition(self.Caret, 1)
		end
		
		self:ScrollCaret()
		
		if not shift then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Move Right", "RIGHT", FunctionCaller(MoveRight, false))
	self:SetupDefKey("Select Right", "SHIFT RIGHT", FunctionCaller(MoveRight, false))

	self:SetupDefKey("Backspace", "BACKSPACE", function(self)
		if(self:HasSelection()) then
			self:SetSelection()
		else
			local buffer = self:GetArea({self.Caret, {self.Caret[1], 1}})
			if(self.Caret[2] % 4 == 1 and string.len(buffer) > 0 and string.rep(" ", string.len(buffer)) == buffer) then
				self:SetCaret(self:SetArea({self.Caret, self:MovePosition(self.Caret, -4)}))
			else
				local prevcaret, nextcaret = {self.Caret[1], self.Caret[2]-1}, {self.Caret[1], self.Caret[2]+1}
				local prevbuff, nextbuff = self:GetArea({self.Caret, prevcaret}), self:GetArea({self.Caret, nextcaret})
				if self.MatchPairs[prevbuff] and self.MatchPairs[prevbuff] == nextbuff then -- if two quotations or (matching) brackets in a row and removing first one, we should rm 2nd one which is what this does
					self:SetCaret(self:SetArea({prevcaret, nextcaret}))
				else
					self:SetCaret(self:SetArea({self.Caret, self:MovePosition(self.Caret, -1)}))
				end
			end
		end
	end)
	self:SetupDefKey("Delete", "DELETE", function(self)
		if(self:HasSelection()) then
			self:SetSelection()
		else
			local buffer = self:GetArea({{self.Caret[1], self.Caret[2] + 4}, {self.Caret[1], 1}})
			if(self.Caret[2] % 4 == 1 and string.rep(" ", string.len(buffer)) == buffer and string.len(self.Rows[self.Caret[1]]) >= self.Caret[2] + 4 - 1) then
				self:SetCaret(self:SetArea({self.Caret, self:MovePosition(self.Caret, 4)}))
			else
				self:SetCaret(self:SetArea({self.Caret, self:MovePosition(self.Caret, 1)}))
			end
		end
	end)
	self:SetupDefKey("Go To Start Of Line", "HOME", function(self)
		local row = self.Rows[self.Caret[1]]
		local first_char = row:find("%S") or row:len()+1
		if(self.Caret[2] == first_char) then
			self.Caret[2] = 1
		else
			self.Caret[2] = first_char
		end
		
		self:ScrollCaret()
		
		if(!shift) then
			self.Start = self:CopyPosition(self.Caret)
		end
	end)
	self:SetupDefKey("Go To End Of Line", "END", function(self)
		local length = string.len(self.Rows[self.Caret[1]])
		self.Caret[2] = length + 1
		
		self:ScrollCaret()
		
		if(!shift) then
			self.Start = self:CopyPosition(self.Caret)
		end
	end)
	self:SetupDefKey("Indent", "TAB", function(self)
		if(self:HasSelection()) then
			self:Indent(shift)
		else
			if(shift) then
				local newpos = self.Caret[2]-4
				if(newpos < 1) then newpos = 1 end
				self.Start = { self.Caret[1], newpos }
				if(self:GetSelection():find("%S")) then 
					self.Start = self:CopyPosition(self.Caret)
				else
					self:SetSelection("")
				end
			else
				local count = (self.Caret[2] + 2) % 4 + 1
				self:SetSelection(string.rep(" ", count))
			end
		end
		self.TabFocus = true
	end)

	local function MovePageDown(self, shift)
		self.Caret[1] = self.Caret[1] + math.ceil(self.Size[1] / 2)
		self.Scroll[1] = self.Scroll[1] + math.ceil(self.Size[1] / 2)
		if(self.Caret[1] > #self.Rows) then self.Caret[1] = #self.Rows end
		if(self.Caret[1] == #self.Rows) then self.Caret[2] = 1 end
		
		local length = string.len(self.Rows[self.Caret[1]])
		if(self.Caret[2] > length + 1) then self.Caret[2] = length + 1 end
		
		self:ScrollCaret()
		
		if(!shift) then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Go Down By One Page", "PAGEDOWN", FunctionCaller(MovePageDown, false))
	self:SetupDefKey("Select Down By One Page", "SHIFT PAGEDOWN", FunctionCaller(MovePageDown, true))

	local function MovePageUp(self, shift)
		self.Caret[1] = self.Caret[1] - math.ceil(self.Size[1] / 2)
		self.Scroll[1] = self.Scroll[1] - math.ceil(self.Size[1] / 2)
		if(self.Caret[1] < 1) then self.Caret[1] = 1 end
		
		local length = string.len(self.Rows[self.Caret[1]])
		if(self.Caret[2] > length + 1) then self.Caret[2] = length + 1 end
		if(self.Scroll[1] < 1) then self.Scroll[1] = 1 end
		
		self:ScrollCaret()
		
		if(!shift) then
			self.Start = self:CopyPosition(self.Caret)
		end
	end

	self:SetupDefKey("Go Up By One Page", "PAGEUP", FunctionCaller(MovePageUp, false))
	self:SetupDefKey("Select Up By One Page", "SHIFT PAGEUP", FunctionCaller(MovePageUp, true))
end)

function LuaPadEditor:SetupDefKey(name, defshortcut, callback, priority)
	self:SetupKey(name, defshortcut, callback, priority or self.HOOK_UNIMPORTANT)
end
function LuaPadEditor:SetupKey(name, defshortcut, callback, priority)
	priority = priority or self.HOOK_NORMAL

	self.Shortcuts[defshortcut] = self.Shortcuts[defshortcut] or {}
	local tbl = self.Shortcuts[defshortcut]

	tbl[name] = {callback = callback, priority = priority}
end

function LuaPadEditor:_OnKeyCodeTyped(code)
	self.Blink = RealTime()

	local control = input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)
	local alt = input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT)
	local shift = input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)

	local searchString = ""
	if control then searchString = searchString .. "CTRL " end
	if alt then searchString = searchString .. "ALT " end
	if shift then searchString = searchString .. "SHIFT " end

	local keyTyped
	for k,v in pairs(_G) do
		if v == code and k:StartWith("KEY_") and not k:find("SHIFT", _, true) and not k:find("CONTROL", _, true) and not k:find("ALT", _, true) then
			keyTyped = k:sub(5)
			searchString = searchString .. keyTyped
			break
		end
	end

	searchString = searchString:Trim()

	local shortcuts = self.Shortcuts[searchString]
	if not shortcuts then 

		if not alt and not control and not shift then
			self.SuggestionsVisible = true -- I dont even know what doing atm
		end

		return
	end

	local nscs = {}
	table.foreach(shortcuts, function(k,v) table.insert(nscs, v) end)
	table.sort(nscs, function(a, b)
		return a.priority > b.priority
	end)

	for _,sc in ipairs(nscs) do
		if sc.callback(self) then
			break
		end
	end

end

-- LuaPad module cl_luapad_panel_mouse.lua: 

function LuaPadEditor:OnMousePressed(code)
	if self:CallHook("MousePressed", code) then
		return
	end
	if(code == MOUSE_LEFT) then
		if((CurTime() - self.LastClick) < 1 and self.tmp and self:CursorToCaret()[1] == self.Caret[1] and self:CursorToCaret()[2] == self.Caret[2]) then
			self.Start = self:GetWordStart(self.Caret)
			self.Caret = self:GetWordEnd(self.Caret)
			self.tmp = false
			return
		end
		
		self.tmp = true
		
		self.LastClick = CurTime()
		self:RequestFocus()
		self.Blink = RealTime()
		self.MouseDown = true

		self.SuggestionsVisible = false
		
		self.Caret = self:CursorToCaret()
		if(!input.IsKeyDown(KEY_LSHIFT) and !input.IsKeyDown(KEY_RSHIFT)) then
			self.Start = self:CursorToCaret()
		end
	elseif(code == MOUSE_RIGHT) then
		local menu = DermaMenu()

		self:CallHook("RightMouseMenu", menu)

		menu:Open()
	end
end

function LuaPadEditor:OnMouseReleased(code)
	if(!self.MouseDown) then return end

	if(code == MOUSE_LEFT) then
		self.MouseDown = nil
		if(!self.tmp) then return end
		self.Caret = self:CursorToCaret()
	end
end

function LuaPadEditor:OnMouseWheeled(delta)
	self.Scroll[1] = self.Scroll[1] - 4 * delta
	if(self.Scroll[1] < 1) then self.Scroll[1] = 1 end
	if(self.Scroll[1] > #self.Rows) then self.Scroll[1] = #self.Rows end
	self.ScrollBar:SetScroll(self.Scroll[1] - 1)
end

-- LuaPad module cl_luapad_panel_render.lua: 
function LuaPadEditor:PaintRelatedRows(row, cc)
	local cols, cc = self:SyntaxColorLine(row, cc)
	self.PaintRows[row] = cols
	if cc then
		local nr = row+1
		if not self.Rows[nr] then return end -- TODO comment ends prematurely
		self:PaintRelatedRows(nr, cc)
	end
end

function LuaPadEditor:PaintLine(row)
	if(row > #self.Rows) then return end

	if(!self.PaintRows[row]) then
		self:PaintRelatedRows(row)
	end

	local width, height = self.FontWidth, self.FontHeight

	if(row == self.Caret[1] and self.TextEntry:HasFocus()) then
		surface.SetDrawColor(self:CallHook("ThemeColor", "SelectedRow") or Color(220, 220, 220, 255))
		surface.DrawRect(width * 3 + 5, (row - self.Scroll[1]) * height, self:GetWide() - (width * 3 + 5), height)
	end

	if(self:HasSelection()) then
		local start, stop = self:MakeSelection(self:Selection())
		local line, char = start[1], start[2]
		local endline, endchar = stop[1], stop[2]
		
		surface.SetDrawColor(self:CallHook("ThemeColor", "Selection") or Color(170, 170, 170, 255))
		local length = string.len(self.Rows[row]) - self.Scroll[2] + 1
		
		char = char - self.Scroll[2]
		endchar = endchar - self.Scroll[2]
		if(char < 0) then char = 0 end
		if(endchar < 0) then endchar = 0 end
		
		if(row == line and line == endline) then
			surface.DrawRect(char * width + width * 3 + 6, (row - self.Scroll[1]) * height, width * (endchar - char), height)
		elseif(row == line) then
			surface.DrawRect(char * width + width * 3 + 6, (row - self.Scroll[1]) * height, width * (length - char + 1), height)
		elseif(row == endline) then
			surface.DrawRect(width * 3 + 6, (row - self.Scroll[1]) * height, width * endchar, height)
		elseif(row > line and row < endline) then
			surface.DrawRect(width * 3 + 6, (row - self.Scroll[1]) * height, width * (length + 1), height)
		end
	end

	draw.SimpleText(tostring(row), "LuapadEditor", width * 3, (row - self.Scroll[1]) * height, Color(128, 128, 128, 255), TEXT_ALIGN_RIGHT)
	self:CallHook("PaintRowGutter", row, 0, (row - self.Scroll[1]) * height)

	local offset = -self.Scroll[2] + 1
	for i,cell in ipairs(self.PaintRows[row]) do
		if(offset < 0) then
			if(string.len(cell[1]) > -offset) then
				line = string.sub(cell[1], -offset + 1)
				offset = string.len(line)
				
				if(cell[2][2]) then
					draw.SimpleText(line, "LuapadEditorBold", width * 3 + 6, (row - self.Scroll[1]) * height, cell[2][1])
				else
					draw.SimpleText(line, "LuapadEditor", width * 3 + 6, (row - self.Scroll[1]) * height, cell[2][1])
				end
			else
				offset = offset + string.len(cell[1])
			end
		else
			if(cell[2][2]) then
				draw.SimpleText(cell[1], "LuapadEditorBold", offset * width + width * 3 + 6, (row - self.Scroll[1]) * height, cell[2][1])
			else
				draw.SimpleText(cell[1], "LuapadEditor", offset * width + width * 3 + 6, (row - self.Scroll[1]) * height, cell[2][1])
			end
			
			offset = offset + string.len(cell[1])
		end
	end

	if(row == self.Caret[1] and self.TextEntry:HasFocus()) then
		if((RealTime() - self.Blink) % 0.8 < 0.4) then
			if(self.Caret[2] - self.Scroll[2] >= 0) then
				surface.SetDrawColor(self:CallHook("ThemeColor", "Cursor") or Color(72, 61, 139, 255))
				surface.DrawRect((self.Caret[2] - self.Scroll[2]) * width + width * 3 + 6, (self.Caret[1] - self.Scroll[1]) * height, 1, height)
			end
		end
	end
end


function LuaPadEditor:Paint()
	if(!input.IsMouseDown(MOUSE_LEFT)) then
		self:OnMouseReleased(MOUSE_LEFT)
	end

	if(!self.PaintRows) then
		self.PaintRows = {}
	end

	if(self.MouseDown) then
		self.Caret = self:CursorToCaret()
	end

	surface.SetDrawColor(self:CallHook("ThemeColor", "Gutter") or Color(200, 200, 200, 255))
	surface.DrawRect(0, 0, self.FontWidth * 3 + 4, self:GetTall())

	surface.SetDrawColor(self:CallHook("ThemeColor", "Background") or Color(230, 230, 230, 255))
	surface.DrawRect(self.FontWidth * 3 + 5, 0, self:GetWide() - (self.FontWidth * 3 + 5), self:GetTall())

	if self.Status then
		self.StatusTrail = math.Approach((self.StatusTrail or 0), self.Status.Alpha or 0, 0.04)

		local statusBaseClr = self:CallHook("ThemeColor", "StatusBar") or Color(200, 200, 200, 255)
		surface.SetDrawColor(ColorAlpha(statusBaseClr, self.StatusTrail))
		surface.DrawRect(self.FontWidth * 3 + 10, self:GetTall()-28, self:GetWide() - (self.FontWidth * 3 + 15), 23)

		surface.SetTextColor(Color(255, 0, 0, 255 * self.StatusTrail))
		surface.SetFont("Trebuchet24")
		surface.SetTextPos(self.FontWidth * 3 + 15, self:GetTall()-28)
		surface.DrawText(self.Status.Msg)
	end

	self.Scroll[1] = math.floor(self.ScrollBar:GetScroll() + 1)

	for i=self.Scroll[1],self.Scroll[1]+self.Size[1]+1 do
		self:PaintLine(i)
	end

	self:CallHook("PostPaint")

	return true
end


-- LuaPad module cl_luapad_panel_syntax.lua: 

function LuaPadEditor:SyntaxColorLine(row, coloringcomment)
	local cols = {}
	local lasttable;
	self.line = self.Rows[row]
	self.pos = 0
	self.char = ""
	self.str = ""

	local CheckGlobal = function(...) -- a quick helper function
		self:CheckGlobal(...)
	end

	-- TODO: Color customization?
	colors = {
		["none"] =  { self:CallHook("ThemeColor", "Syntax_none") or Color(0, 0, 0, 255), false},
		["number"] =    { self:CallHook("ThemeColor", "Syntax_number") or Color(218, 165, 32, 255), false},
		["function"] =  { self:CallHook("ThemeColor", "Syntax_function") or Color(100, 100, 255, 255), false},
		["enumeration"] =  { self:CallHook("ThemeColor", "Syntax_enum") or Color(184, 134, 11, 255), false},
		["metatable"] =  { self:CallHook("ThemeColor", "Syntax_metatable") or Color(140, 100, 90, 255), false},
		["table"] =  { self:CallHook("ThemeColor", "Syntax_table") or Color(140, 100, 90, 255), false}, -- TODO other color than metatable
		["string"] =    { self:CallHook("ThemeColor", "Syntax_string") or Color(120, 120, 120, 255), false},
		["expression"] =    { self:CallHook("ThemeColor", "Syntax_expression") or Color(0, 0, 255, 255), false},
		["operator"] =  { self:CallHook("ThemeColor", "Syntax_operator") or Color(0, 0, 128, 255), false},
		["comment"] =   { self:CallHook("ThemeColor", "Syntax_comment") or Color(0, 120, 0, 255), false},
	}

	colors["string2"] = colors["string"];

	self:NextChar();

	while self.char do
		token = "";
		self.str = "";
		
		while self.char and self.char == " " do self:NextChar() end
		if(!self.char) then break end
		
		if coloringcomment then
			if coloringcomment == "]]" then
				local endingml = false
				while self.char do
					if self.char == "]" then
						if endingml then self:NextChar() coloringcomment = nil break end
						endingml = true
					else
						endingml = false
					end
					self:NextChar()
				end
			elseif coloringcomment == "*/" then
				local endingml = false
				while self.char do
					if endingml and self.char == "/" then self:NextChar() coloringcomment = nil break
					elseif not endingml and self.char == "*" then endingml = true
					else endingml = false end
					self:NextChar()
				end
			else
				ErrorNoHalt("Unknown coloring comment style " .. tostring(coloringcomment))
			end
			token = "comment"
		elseif(self.char >= "0" and self.char <= "9") then
			while self.char and (self.char >= "0" and self.char <= "9" or self.char == "." or self.char == "_") do self:NextChar() end
			
			token = "number"
		elseif(self.char >= "a" and self.char <= "z" or self.char >= "A" and self.char <= "Z") then
			
			while self.char and (self.char >= "a" and self.char <= "z" or self.char >= "A" and self.char <= "Z" or
			self.char >= "0" and self.char <= "9" or self.char == "_" or self.char == ".") do self:NextChar(); end
			
			local sstr = string.Trim(self.str)

			local var = self:FindVar(sstr)

			if(table.HasValue(self.LUA_KEYWORDS, sstr)) then
				
				token = "expression"
				
			elseif( var ) then

				--if((CheckGlobal(sstr) == "e") && sstr == string.upper(sstr)) then
				--	token = "enumeration";
				--elseif(CheckGlobal(sstr) == "m") then
				if type(var) == "table" then
					token = "metatable";
				elseif type(var) == "number" then
					token = "number"
				elseif type(var) == "string" then
					token = "string"
				elseif type(var) == "function" then
					token = "function"
				else
					token = "none"
				end
				
			else
				token = "none"
				
			end
		elseif(self.char == "\"") then -- TODO: Fix multiline strings, and add support for [[stuff]]!
		
			self:NextChar()
			while self.char and self.char != "\"" do
				if(self.char == "\\") then self:NextChar() end
				self:NextChar()
			end
			self:NextChar()
			
			token = "string"
		elseif(self.char == "'") then
		
			self:NextChar()
			while self.char and self.char != "'" do
				if(self.char == "\\") then self:NextChar() end
				self:NextChar()
			end
			self:NextChar()
			
			token = "string2"
		elseif(self.char == "/" or self.char == "-") then -- TODO: Multiline comments work on single lines, need multiline integration!
		
			local lastchar = self.char;
			self:NextChar()
			
			if(self.char == lastchar or (lastchar == "/" and self.char == "*")) then
				if self.char == "-" then
					local startpos, sbrackets = self.pos, 0
					local multiline, endingml = false, false

					while self.char do
						self:NextChar()
						if self.char == "[" then sbrackets = sbrackets + 1 end
						if multiline and self.char == "]" then
							if endingml then self:NextChar() break end
							endingml = true
						elseif not multiline and (self.pos-startpos) == 2 and sbrackets == 2 then
							multiline = true
						else
							endingml = false
						end
					end

					if multiline and not self.char then -- multiline comment didnt end
						coloringcomment = "]]"
					end

				elseif self.char == "*" then
					local endingml = false
					local needcontinue = false
					while self.char do
						self:NextChar()
						if endingml and self.char == "/" then self:NextChar() break
						elseif not endingml and self.char == "*" then endingml = true
						else endingml = false end
					end

					if not self.char then -- multiline comment didnt end
						coloringcomment = "*/"
					end

				else -- One line //
					while self.char do
						self:NextChar()
					end
				end
				
				token = "comment"

			else
				token = "none";
			end
		elseif(self.char == "[") then
		
			local lastchar = self.char;
			self:NextChar()
			
			if(self.char == "[") then

				local lasttoken = token

				local closingbracket = false
				while self.char do
					self:NextChar()
					if self.char == "]" then
						if closingbracket then break end
						closingbracket = true
					else
						closingbracket = false
					end
				end
				
				if lasttoken == "comment" then
					token = "comment"
				else
					token = "none" -- TODO array selector could have its own token?
				end
			else
				token = "none";
			end
		else
		
			self:NextChar()
			
			token = "operator"
			
		end
		
		color = colors[token]
		if(#cols > 1 and color == cols[#cols][2]) then
			cols[#cols][1] = cols[#cols][1] .. self.str
		else
			cols[#cols + 1] = {self.str, color}
		end
	end

	return cols, coloringcomment
end

-- LuaPad module cl_luapad_panel_textcmds.lua: 

LuaPadEditor:AddHook("SetupKeys", "TextCmds", function(self)
	self:SetupKey("Select All", "CTRL A", self.SelectAll)
	self:SetupKey("Cut", "CTRL X", self.DoCut)
	self:SetupKey("Copy", "CTRL C", self.DoCopy)
end)

LuaPadEditor:AddHook("RightMouseMenu", "TextCmds", function(self, menu)
	
	if(self:HasSelection()) then
		menu:AddOption("Cut",  function()
			if(self:HasSelection()) then
				self.clipboard = self:GetSelection()
				self.clipboard = string.Replace(self.clipboard, "\n", "\r\n")
				SetClipboardText(self.clipboard)
				self:SetSelection()
			end
		end)
		menu:AddOption("Copy",  function()
			if(self:HasSelection()) then
				self.clipboard = self:GetSelection()
				self.clipboard = string.Replace(self.clipboard, "\n", "\r\n")
				SetClipboardText(self.clipboard)
			end
		end)
	end
	
	menu:AddOption("Paste",  function()
		if(self.clipboard) then
			self:SetSelection(self.clipboard)
		else
			self:SetSelection()
		end
	end)
	
	if(self:HasSelection()) then
		menu:AddOption("Delete",  function()
			self:SetSelection()
		end)
	end

	menu:AddSpacer()
	
	menu:AddOption("Select all",  function()
		self:SelectAll()
	end)
end)

function LuaPadEditor:DoCut()
	if(self:HasSelection()) then
		self.clipboard = self:GetSelection()
		self.clipboard = string.Replace(self.clipboard, "\n", "\r\n")
		SetClipboardText(self.clipboard)
		self:SetSelection()
	end
end

function LuaPadEditor:DoCopy()
	if(self:HasSelection()) then
		self.clipboard = self:GetSelection()
		self.clipboard = string.Replace(self.clipboard, "\n", "\r\n")
		SetClipboardText(self.clipboard)
	end
end

function LuaPadEditor:SelectAll()
	self.Caret = {#self.Rows, string.len(self.Rows[#self.Rows]) + 1}
	self.Start = {1, 1}
	self:ScrollCaret()
end

-- LuaPad module cl_luapad_panel_theme_night.lua: 

local function ReverseColor(r, g, b, a)
	return Color(255 - r, 255 - g, 255 - b, a)
end

local colors = {
	Gutter = Color(55, 55, 55, 255),
	StatusBar = Color(65, 65, 65, 255),
	Background = Color(25, 25, 25, 255),
	Selection = Color(85, 85, 85, 255),
	SelectedRow = Color(25, 25, 25, 255),
	Cursor = ReverseColor(72, 61, 139),

	-- Syntax

	Syntax_none = ReverseColor(0, 0, 0),
	Syntax_number = ReverseColor(218, 165, 32),
	Syntax_function = ReverseColor(100, 100, 255),
	Syntax_enum = ReverseColor(184, 134, 11),
	Syntax_metatable = ReverseColor(140, 100, 90),
	Syntax_table = ReverseColor(140, 100, 90),
	Syntax_string = ReverseColor(120, 120, 120),
	Syntax_expression = ReverseColor(0, 0, 255),
	Syntax_operator = ReverseColor(0, 0, 128),
	Syntax_comment = ReverseColor(0, 120, 0)
}

LuaPadEditor:AddHook("ThemeColor", "Theme_NightShade", function(self, name)
	return colors[name]
end)

-- LuaPad module cl_luapad_register.lua: 
vgui.Register("LuapadEditor", LuaPadEditor, "Panel")

LuaPadEditor = nil -- Stop polluting global namespace