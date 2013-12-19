
LUABEE.AddLibrary("debug", Color(230,230,230))

LUABEE.CatalogFunction({
	name="debug.debug",
	args = {},
	returns = {},
	realm = "Shared",
	desc=[[Turns the console into a Lua input.
	Anything ran in the console is interpreted as Lua.
	Sending "cont" in a single message will exit this mode.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.getfenv",
	args = {"obj"},
	returns = {"env"},
	realm = "Shared",
	desc=[[Returns the environment of an object.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.gethook",
	args = {"thread"},
	returns = {"hook", "mask", "count"},
	realm = "Shared",
	desc=[[Returns the current hook settings of a thread.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.getregistry",
	args = {},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Returns the LUA_REGISTRYINDEX.
	See the wiki and the Lua documentation manual for more info.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.getupvalue",
	args = {"func", "up"},
	returns = {"name", "data"},
	realm = "Shared",
	desc=[[Gets the name and value of an upvalue.
	The upvalue retrieved is of index [up] from [func].
	See the wiki and the Lua documentation manual for more info.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.setfenv",
	args = {"obj", "tbl"},
	returns = {"obj"},
	realm = "Shared",
	desc=[[Sets the environment of an object to a table.
	Returns that object.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.sethook",
	args = {"thread", "func", "mask", "count"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the debug hook for the specified thread
	If no thread is given then the thread is the current thread.
	See the wiki and the Lua manual for more info.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.setlocal",
	args = {"thread", "level", "local", "value"},
	returns = {"name", "value"},
	realm = "Shared",
	desc=[[Sets the [value] of a [local] variable at a [level] of a [thread].]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.setmetatable",
	args = {"obj", "tbl"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Sets the metatable of an object.
	[tbl] can be nil.]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.setupvalue",
	args = {"func", "up", "data"},
	returns = {"name"},
	realm = "Shared",
	desc=[[Sets an upvalue in index [up] from a function [func].]]
},"debug",_,_)

LUABEE.CatalogFunction({
	name="debug.Trace",
	args = {},
	returns = {},
	realm = "Shared",
	desc=[[Prints the debug trace to the console.
	The trace contains valuable information.
	Mostly used to find errors.]]
},"debug",_,_)


