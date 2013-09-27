
hook.Add("Initialize", "Luabee Config",function()
	
	if LUABEE.Config then return end
	LUABEE.Config = {}

	LUABEE.Config.Ruler = CreateClientConVar("luabee_ruler", 1, true, false)
	LUABEE.Config.Debug = CreateClientConVar("luabee_debugmode", 0, true, false)
	
	LUABEE.Config.Luapad = {}
	LUABEE.Config.Luapad.OpenAfterExport = CreateClientConVar("luabee_luapad_openafterexport", 0, true, false)
	
	--LUABEE.Config.HotkeySpeed = CreateClientConVar("luabee_key_speed", 1, true, false)
	
	LUABEE.Config.Keymapping = {}
	LUABEE.Config.Keymapping.Save = CreateClientConVar("luabee_keymapping_save", KEY_S, true, false)
	LUABEE.Config.Keymapping.Open = CreateClientConVar("luabee_keymapping_open", KEY_O, true, false)
	LUABEE.Config.Keymapping.Close = CreateClientConVar("luabee_keymapping_close", KEY_W, true, false)
	LUABEE.Config.Keymapping.Undo = CreateClientConVar("luabee_keymapping_undo", KEY_Z, true, false)
	LUABEE.Config.Keymapping.Redo = CreateClientConVar("luabee_keymapping_redo", KEY_Y, true, false)
	

end)