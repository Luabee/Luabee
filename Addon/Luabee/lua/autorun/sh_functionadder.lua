--Cataloged Functions
LUABEE = {}
LUABEE.CatalogedFunctions = {}

	LUABEE.CatalogedFunctions.Globals = {}
	LUABEE.CatalogedFunctions.Globals.__Icon = "icon16/world.png"

	LUABEE.CatalogedFunctions.Hooks = {}
	LUABEE.CatalogedFunctions.Hooks.__Icon = "icon16/cog.png"

	LUABEE.CatalogedFunctions.Libraries = {}
	LUABEE.CatalogedFunctions.Libraries.__Icon = "icon16/book_open.png"

	LUABEE.CatalogedFunctions.Classes = {}
	LUABEE.CatalogedFunctions.Classes.__Icon = "icon16/layers.png"


function LUABEE.CatalogFunction(tbl, library, class, Hook, global)
	
	if library then
		tbl.Section = "Libraries"
		if not table.HasValue(LUABEE.CatalogedFunctions.Libraries[library], tbl) then
			table.insert(LUABEE.CatalogedFunctions.Libraries[library], tbl)
		end
	elseif class then
		tbl.Section = "Classes"
		tbl.IsClass = true
		if not table.HasValue(LUABEE.CatalogedFunctions.Classes[class], tbl) then
			table.insert(LUABEE.CatalogedFunctions.Classes[class], tbl)
		end
	elseif Hook then
		tbl.Section = "Hooks"
		if not table.HasValue(LUABEE.CatalogedFunctions.Hooks[Hook], tbl) then
			table.insert(LUABEE.CatalogedFunctions.Hooks[Hook], tbl)
		end
	elseif global then
		tbl.Section = "Globals"
		if not table.HasValue(LUABEE.CatalogedFunctions.Globals, tbl) then
			table.insert(LUABEE.CatalogedFunctions.Globals[global], tbl)
		end
	end
	
end
function LUABEE.AddClass(name, color)
	LUABEE.CatalogedFunctions.Classes[name] = {}
	LUABEE.CatalogedFunctions.Classes[name].__Color = color
end
function LUABEE.AddLibrary(name, color)
	LUABEE.CatalogedFunctions.Libraries[name] = {}
	LUABEE.CatalogedFunctions.Libraries[name].__Color = color
end
function LUABEE.AddHook(name, color)
	LUABEE.CatalogedFunctions.Hooks[name] = {}
	LUABEE.CatalogedFunctions.Hooks[name].__Color = color
end
function LUABEE.AddGlobal(name, color)
	LUABEE.CatalogedFunctions.Globals[name] = {}
	LUABEE.CatalogedFunctions.Globals[name].__Color = color
end

function IncludeSh(f)
	if SERVER then
		AddCSLuaFile(f)
		include(f)
	end
	include(f)
end

--Catalogs files from http://wiki.garrysmod.com
function LUABEE.AddWikiCategory(type, pagename)
	http.Fetch( "http://wiki.garrysmod.com/page/Category:"..pagename,
		function( body, len, headers, code )
			-- The first argument is the HTML we asked for.
			
			for w in string.gfind(body, [[title="]]..pagename..[[/([%a_]+)]])do
				LUABEE.AddWikiPage(type, pagename ,w)
				if CLIENT then
					if LUABEE.Config.Debug:GetBool() then
						print("Added Category:", type, pagename)
					end
				end
			end
		end,
		function( err )
			MsgC(Color(230,0,0),"--> LUABEE failed to fetch \""..pagename.."\" from the wiki. Received error: "..err.."\n") 
		end
	)
	
end

function LUABEE.AddWikiPage(type, cat, name)
	local url = "http://wiki.garrysmod.com/page/"..cat.."/"..name
	http.Fetch( url,
		function( body, len, headers, code )
			-- The first argument is the HTML we asked for.
			if not string.find(body, "There is currently no text in this page.") then
				if LUABEE.CatalogedFunctions[type][cat][name] then
					LUABEE.CatalogedFunctions[type][cat][name].wiki = body
				else
					local l,c,h,g
					if type == "Libraries" then
						l = cat
					elseif type == "Classes" then
						c = cat
					elseif type == "Hooks" then
						h = cat
					else
						g = cat
					end
					
					LUABEE.CatalogFunction(LUABEE.ReadWiki(body, url),l,c,h,g)
					if CLIENT then
						if LUABEE.Config.Debug:GetBool() then
							print("Added Function:", cat, name)
						end
					end
				end
			end
		end,
		function( err )
			MsgC(Color(230,0,0),"--> LUABEE failed to fetch \""..cat.."/"..name.."\" from the wiki. Received error: "..err.."\n") 
		end
	)
	
end

function LUABEE.ReadWiki(html, url)
	local rtrn = {
		name = string.match(html, [[<div class="function_line">([%w_%:%.]+)]]),
		args = {},
		returns = {},
		realm = "",
		desc = [[description]],
		wiki = url
	}
	for w in string.gfind(html, [[<span class="arg_chunk">.-</a> ([%w_%s]+)</span>]])do --5 letter arguments or less.
		table.insert(rtrn.args, w)
	end
	for w in string.gfind(html, [[<span class="ret_chunk">.-">%s?([%w_%s]+)<]])do --5 letter arguments or less.
		table.insert(rtrn.returns, w)
	end
	return rtrn
	
	
end

--Add Function files here:---------------------------
local files, folders = file.Find("autorun/sh_functions/*.lua", "LUA")
for k,fil in pairs(files)do
	IncludeSh("sh_functions/"..fil)
end
timer.Simple(.5, function()
	print("--> LUABEE: Included "..#files.." function category files.")
end)
-----------------------------------------------------

/*
	First, THANK YOU FOR HELPING WITH LUABEE. Your time is greatly appreciated and your name will be in some form of credits.
	
	A few resources:
	The First wiki: 
	http://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index3d2e.html (Click Functions in the lefthand side and go from there.)
	
	The Second Wiki:
	http://gmodwiki.net/ (Click Libraries, Hooks, or Classes. Events can be considered classes as well.)
	
	The New/Stupid Wiki:
	http://wiki.garrysmod.com/page/Main_Page (Use the sidebar to browse. If it isn't visible there is an arrow in the bottom right.)
	
	Keep in mind that the new stupid wiki has many missing functions.
	Keep in mind that the First wiki has many outdated functions, but they're all documented somehow.
	Keep in mind that the Second wiki may have more functions than the new one, but fewer than the first. The functions on the second wiki are up to date.
	
	
	Ok, so now onto how to actually catalog some functions.
	
	LUABEE.CatalogFunction(tbl,[library],[class],[Hook]) is the function you will be using to add a new function.
	tbl is a special table of arguments. I will give an example in a minute.
	The other three arguments are optional. If the function has a library, give the library name as a string. More info in a minute.
	
	tbl should be a table, or {}, which contains info about the function.
	Here is an example tbl:
	
	{
		name = "ents.FindInSphere",
		args = {"Origin", "Radius"},
		returns = {"Ents"},
		realm = "Shared",
		desc = [[Used to get a table of all entities of distance [Radius] from point [Origin].
		Returns a table.]]
	}
	The first one, name, is the function name with all the extensions. That means GM:, player:, ents. whatever. The name of the function is how you would call it. Capitalization and spelling is important.
	The second is a table containing all the parameters for the function. Make them pretty, but not too long and only one word.
	The third one is a table containing all the return values. Most functions return only one thing, but some, like Panel:GetSize(), return two or more. Treat it like the args.
	The fourth describes where this function is available. This info is usually on the wiki page. Capitalize the first letter.
	The fifth is a short description (1-5 lines (or more)) that tells what the function does, describes the args, and tells the return value. Feel free to be very descriptive.
	For the fifth argument, the double square brackets act as quotations, and you can put quotes, line returns, and whatever without needing \n or \".
	
	
	So essentially, define and describe the function in a table format, then put that table into LUABEE.CatalogFunction().
	If that function is a global function (not part of a library, class, or hook), leave the other arguments blank.
	If that function is part of something, however, fill in all the arguments with an _ except for the thing that it is a part of.
	Mark the thing that it is a part of with the name of that thing.
	For example:
	(the function is player:SetHealth(). Pretend tbl is a table.)
	LUABEE.CatalogFunction(tbl, _, "Player", _)
	
	Before cataloging a function that is part of something for the first time, make sure to catalog that hook/library/class.
	Use LUABEE.AddClass/LUABEE.AddHook/LUABEE.AddLibrary to define an object.
	The arguments for these functions are name and color. The name is the actual name of the object, such as GAMEMODE, timer, or Entity.
	The color is the color that the blocks of this category will be. Don't worry about duplicate colors.
	
	If you do not know about a function or there is not enough info, mark it with "-- %%%Bobble" (anywhere) and I will find research it and fill it in myself.
	
	That's it! Below are some examples I did.
*/

--you may want to make use of ctrl+d if you are using Notepad++. Select the lines you want then use Ctrl+D to duplicate them.
LUABEE.AddLibrary("hook", Color(190,0,0))--don't worry about alpha. Leave it blank or set it to 255.
LUABEE.CatalogFunction({
	name="hook.Add",
	args = {"Hook", "ID", "Func"},
	returns = {}, --no return values.
	realm = "Shared",
	desc=[[Adds a hook to [Hook] which calls [Func] whenever that hook is called.
	Whenever a gamemode hook, like GM:Think() or GM:PlayerSpawn(ply) is called,
	it also calls all the functions added with this hook.
	[Hook] is a string that has the same name as the hook to attach to. (e.g. GM:Initialize() = "Initialize")
	[ID] can be any string, as long as it is unique.
	[Func] has the same arguments passed to it as the hook. (e.g. GM:PlayerSpawn() passes the argument ply.)
	Can only be used for gamemode hooks. More information is available in the tutorial regarding hooks.]] --long description, but much needed.
},"hook",_,_)
LUABEE.CatalogFunction({
	name="hook.Run",
	args = {"Hook", "Args"},
	returns = {},
	realm = "Shared",
	desc=[[Calls all hooks linked to [Hook] and passes [Args] to them.
	[Args] is the args to be passed to the hook. This argument is optional.
	Currently Luabee only supports one arg, which might be a problem.
	Can only be used for gamemode hooks. More information is available in the tutorial regarding hooks.]]
},"hook",_,_)
LUABEE.CatalogFunction({
	name="hook.Remove",
	args = {"Hook", "ID"},
	returns = {},
	realm = "Shared",
	desc=[[Removes a linked hook from a hook. Essentially a reverse hook.Add().
	[Hook] is the gamemode hook to remove the hook from.
	[ID] is the unique id given for the hook when you linked it.
	Can only be used for gamemode hooks. More information is available in the tutorial regarding hooks.]]
},"hook",_,_)
LUABEE.CatalogFunction({
	name="hook.GetTable",
	args = {},
	returns = {"Hooks"},
	realm = "Shared",
	desc=[[Returns a table, [Hooks], containing subtables which contain all hooks.
	Can only be used for gamemode hooks. More information is available in the tutorial regarding hooks.]]
},"hook",_,_)

--Add your own below:



















































