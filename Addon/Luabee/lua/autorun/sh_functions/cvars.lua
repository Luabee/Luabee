
LUABEE.AddLibrary("cvars", Color(255,118,215))

LUABEE.CatalogFunction({
	name="cvars.AddChangeCallback",
	args = {"cvar", "call"},
	returns = {},
	realm = "Shared",
	desc=[[Calls a function when a convar is changed.
	[cvar] is the name of the convar. (string)
	[call] is the callback. (function)
	
	[call] receives three arguments: name, previous, and new.
	Name is the name of the cvar.
	Previous is the old value.
	New is the new value.
	For serverside cvars, the cvar must have the FCVAR_GAMEDLL flag.]]
},"cvars",_,_)