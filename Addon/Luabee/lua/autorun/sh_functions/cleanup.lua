
LUABEE.AddLibrary("cleanup", Color(0,190,0))

LUABEE.CatalogFunction({
	name="cleanup.Add",
	args = {"ply", "type", "ent"},
	returns = {},
	realm = "Server",
	desc=[[Adds an entity [ent] to a player [ply]'s cleanup list.
	[type] is a string defined by cleanup.Register
	Only available in sandbox and sandbox-derived gamemodes.]]
},"cleanup",_,_)

LUABEE.CatalogFunction({
	name="cleanup.ReplaceEntity",
	args = {"from", "to"},
	returns = {"b"},
	realm = "Server",
	desc=[[Replaces one entity in the cleanup module with another.
	Doing a cleanup that would remove [from] instead removes [to].
	[from] is the old entity.
	[to] is the new entity.
	[b] is a bool signifying whether an action was taken.
	Only available in sandbox and sandbox-derived gamemodes.
	See undo.ReplaceEntity for more info.]]
},"cleanup",_,_)

LUABEE.CatalogFunction({
	name="cleanup.GetTable",
	args = {},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Returns the table [tbl] of registered cleanups.
	Only available in sandbox and sandbox-derived gamemodes.]]
},"cleanup",_,_)

LUABEE.CatalogFunction({
	name="cleanup.Register",
	args = {"type"},
	returns = {},
	realm = "Shared",
	desc=[[Makes a new cleanup type and adds it to the cleanup menu.
	[type] is a string of the category to clean up.
	Add items to the category with cleanup.Add
	Make sure to run this function on BOTH the client AND the server.
	Only available in sandbox and sandbox-derived gamemodes.]]
},"cleanup",_,_)
