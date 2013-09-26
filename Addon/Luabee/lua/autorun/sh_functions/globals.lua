
LUABEE.AddGlobal("Global Functions", Color(0,128,255))
LUABEE.AddGlobal("Console Functions", Color(0,128,255))
LUABEE.CatalogFunction({

	name = "print",
	args = {"msg"},
	returns = {},
	realm = "Shared",
	desc = [[Prints [msg] to the console.
	[msg] can be anything, not just a string.
	If it isn't a string it will likely not be pretty.]],
	
},_,_,_,"Console Functions")
LUABEE.CatalogFunction({

	name = "MsgN",
	args = {"msg"},
	returns = {},
	realm = "Shared",
	desc = [[Prints [msg] to the console.
	[msg] can be anything, not just a string.
	If it isn't a string it will likely not be pretty.]],
	
},_,_,_, "Console Functions")
LUABEE.CatalogFunction({

	name = "Msg",
	args = {"msg"},
	returns = {},
	realm = "Shared",
	desc = [[Prints [msg] to the console.
	Does not add a line break after the message.
	[msg] can be anything, not just a string.
	If it isn't a string it will likely not be pretty.]],
	
},_,_,_,"Console Functions")
LUABEE.CatalogFunction({

	name = "PrintTable",
	args = {"tbl"},
	returns = {},
	realm = "Shared",
	desc = [[Prints a table [tbl] to the console.
	The table will be in a neat format.
	[tbl] MUST be a table. Empty tables will print nothing.]],
	
},_,_,_,"Console Functions")

LUABEE.CatalogFunction({

	name = "FindMetaTable",
	args = {"type"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Finds a metatable with name [type]. 
	[type] must be a string and must be a metatable.
	[tbl] will be a table containing functions for a class [type].
	Metatables are the first argument to a class function.
	Here is a list of default metatables:
	"NPC", "Player", "Entity", "Panel", "CLuaEmitter",
	"CLuaParticle", "Weapon", "CTakeDamageInfo", "ISave"
	"VMatrix", "Angle", "IRestore", "CSENT_vehicle"
	"CRecipientFilter", "Vector", "CMoveData", "CUserCmd"
	"ConVar", "CSoundPatch", "PhysObj", "_LOADLIB"
	"Vehicle", "CEffectData"]],
	
},_,_,_,"Global Functions")