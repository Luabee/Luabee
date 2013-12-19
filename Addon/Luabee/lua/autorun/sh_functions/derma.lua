
LUABEE.AddLibrary("derma", Color(114,213,174))

LUABEE.CatalogFunction({
	name="derma.Color",
	args = {"name", "pnl", "def"},
	returns = {},
	realm = "Client",
	desc=[[Gets the color from a derma skin for an element.
	[name] is the name of the color to get. (string)
	[pnl] is the panel to get the color hook from.
	[def] is the default color.
	If no color is found then the color is set to [def].]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.DefineControl",
	args = {"name", "desc", "pnl", "base"},
	returns = {"pnl"},
	realm = "Client",
	desc=[[Registers a derma control. Similar to vgui.Register
	[name] is the string name of the control.
	[desc] is the string description.
	[pnl] is the base panel table.
	[base] is the name of the panel to derive from.
	
	Returns the newly made control.]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.DefineSkin",
	args = {"name", "desc", "skin"},
	returns = {},
	realm = "Client",
	desc=[[Defines a new derma skin.
	[name] is the derma skin's name.
	[desc] is the description for the skin.
	[skin] is the derma skin object to register.]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.GetControlList",
	args = {},
	returns = {"tbl"},
	realm = "Client",
	desc=[[Returns a table of all registered derma controls.]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.GetDefaultSkin",
	args = {},
	returns = {"skin"},
	realm = "Client",
	desc=[[Returns the currently active skin.
	DOES NOT return the default grey derma skin.]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.GetNamedSkin",
	args = {"name"},
	returns = {"skin"},
	realm = "Client",
	desc=[[Returns a skin by its name.
	The default skin's name is "Default".]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.GetSkinTable",
	args = {},
	returns = {"tbl"},
	realm = "Client",
	desc=[[Returns a table of all registered skins.]]
},"derma",_,_)

LUABEE.CatalogFunction({
	name="derma.SkinHook",
	args = {"type", "name", "pnl"},
	returns = {},
	realm = "Client",
	desc=[[Calls the skin hook for a given control.
	Uses built-in information to paint or layout a control.
	[type] and [name] should be strings.
	[pnl] is the panel to apply the hook to.]]
},"derma",_,_)
