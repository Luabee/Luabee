
LUABEE.AddLibrary("concommand", Color(255,115,0))

LUABEE.CatalogFunction({
	name="concommand.Add",
	args = {"name", "func", "auto", "help"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a console command.
	[name] is the name of the console command. Must be a string.
	[func] is a function with four arguments passed to it.
	The first arg is the player who ran the concommand.
	The second arg is the name of the command ran.
	The third arg is a table containing the args given.
	The fourth arg is the full command ran.
	For instance, if you ran a concommand "slap bobblehead 100"...
	You would be the first argument of your function.
	"ban" would be the second argument of your function.
	The third argument would be a table with "bobblehead" and "100".
	The fourth argument would be "ban bobblehead 100", as typed.
	Not to be confused with a convar, which serves as a variable.
	Clients can call serverside concommands AND clientside concommands.
	See the wiki for more info on the optional [auto] and [help] args.]]
},"concommand",_,_)

LUABEE.CatalogFunction({
	name="concommand.Remove",
	args = {"name"},
	returns = {},
	realm = "Shared",
	desc=[[Removes a console command.
	This only includes console commands that were made in Lua.
	You cannot remove default concommands, such as kill or retry.
	[name] is the name of the console command.]]
},"concommand",_,_)

LUABEE.CatalogFunction({
	name="concommand.GetTable",
	args = {},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Returns a table of all the console commands.
	Only includes concommands added with concommand.Add.
	Does not include non-Lua commands such as kill or retry.]]
},"concommand",_,_)
