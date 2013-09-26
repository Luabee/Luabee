
LUABEE.AddLibrary("table", Color(255,120,120))

table.insert(LUABEE.CatalogedFunctions.Libraries["table"], {

	name = "table.AddItem",
	args = {"tbl", "key", "value"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Adds an item [value] to a table [tbl] at key [key].
	This is the same as [table].[key] = [value] in Lua.
	[key] can be either a number or a string.
	[value] can be anything. Even another table.
	See the tutorial on tables for more info.]],
	func=function(tbl,key,value) tbl[key]=value return tbl end,
	block = {
		GenerateCompileString = function(self)
			return "%s[(%s)] = %s"
		end
	}
	
})

LUABEE.CatalogFunction({
	name = "table.Add",
	args = {"tbl1", "tbl2"},
	returns = {"tbl1"},
	realm = "Shared",
	desc = [[Inserts the contents of a [tabl2] into [tabl1].
	[tabl1] is the destination table, [tabl2] is the source table.
	Both arguments must be tables.
	Returns the destination table after the items are added. ([tabl1])]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.ClearKeys",
	args = {"tbl", "save"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Changes all keys in [tbl] to integers.
	[save] is optional.
	If [save] is true, then each item will have its key saved.
	The keys are saved as a new item in each table in [tbl]
	This item is called __key.
	Don't do [save] if there are any non-table items in [tbl].
	When in doubt, do not save.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.concat",
	args = {"tbl", "str", "start", "end"},
	returns = {"str"},
	realm = "Shared",
	desc = [[Concatenates a table [tbl] into a string.
	Takes each item in the table and attaches it to the next.
	Between each item, however, [str] is inserted.
	[start] and [end] must be numbers. They are optional.
	So if you have a table of "bacon", "eggs", and "cheese",
	and your [str] argument was ":", then
	"bacon:eggs:cheese" would be the return value.
	See the tutorial on tables for more info.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Copy",
	args = {"tbl"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Takes a table [tbl], copies it, and returns the copy.
	Any modifications to the new table will not effect the old table.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.CopyFromTo",
	args = {"from","to"},
	returns = {},
	realm = "Shared",
	desc = [[Deletes all the objects in [to]
	Then, puts all the objects in [from] into [to].
	This allows you to copy the items but still keep the table.
	Essentially turns [to] into [from].]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Count",
	args = {"tbl"},
	returns = {"len"},
	realm = "Shared",
	desc = [[Counts the amount of objects in [tbl].
	This count includes all items, no matter their key.
	This is the most accurate way to check the length of a table.
	This is not the same as the # operator.
	This counts items with strings as keys as well.
	Returns a number [len].]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.DeSanitise",
	args = {"tbl"},
	returns = {},
	realm = "Shared",
	desc = [[Desanitizes a sanitized table.
	table.Sanitize has more info on the subject.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Empty",
	args = {"tbl"},
	returns = {},
	realm = "Shared",
	desc = [[Completely clears out a table.
	This removes all items from the table.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.ForceInsert",
	args = {"tbl", "value"},
	returns = {},
	realm = "Shared",
	desc = [[Inserts [value] into a table [tbl].
	If [tbl] doesn't exist then it will turn [tbl] into an empty table.
	Then it will insert [value].]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.foreach",
	args = {"tbl", "func"},
	returns = {},
	realm = "Shared",
	desc = [[Runs a function [func] once for each item in a table [tbl].
	The function will have arguments key and value.
	The key is the key of the current item.
	The value is the value of that item.
	This function is deprecated. Instead, try using for k,v in pairs.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.foreachi",
	args = {"tbl", "func"},
	returns = {},
	realm = "Shared",
	desc = [[Runs a function [func] once for each item in a table [tbl].
	The function will have arguments key and value.
	The key is the key of the current item.
	The value is the value of that item.
	The difference between this and foreach is that foreachi only does integer keys.
	This function is deprecated. Instead, try using for k,v in ipairs.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetFirstKey",
	args = {"tbl"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Gets the key [key] of the first item in the table [tbl].
	Does not organize the table. The first item is the first one added.
	Returns the key, which is a string or a number.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetLastKey",
	args = {"tbl"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Gets the key [key] of the last item in the table [tbl].
	Does not organize the table. The last item is the last one added.
	Returns the key, which is a string or a number.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetLastKey",
	args = {"tbl"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Gets the key [key] of the last item in the table [tbl].
	Does not organize the table. The last item is the last one added.
	Returns the key, which is a string or a number.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetFirstValue",
	args = {"tbl"},
	returns = {"value"},
	realm = "Shared",
	desc = [[Gets the first item [value] in the table [tbl].
	Does not organize the table. The first item is the first one added.
	Returns the value, which is a string or a number.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetLastValue",
	args = {"tbl"},
	returns = {"value"},
	realm = "Shared",
	desc = [[Gets the last item [value] in the table [tbl].
	Does not organize the table. The last item is the last one added.
	Returns the value, which is a string or a number.]],
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.getn",
	args = {"tbl"},
	returns = {"len"},
	realm = "Shared",
	desc = [[Returns the length of a table [tbl].
	[tbl] must be a table with consecutive numerical keys only.
	This is the same thing as # [tbl]
	If the table has non-consecutive keys or non-numerical keys then use table.Count([tbl]) to find the length.
	Returns a number [len].
	See the tutorial on tables for more info.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.GetWinningKey",
	args = {"tbl"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Returns the key [key] of the greatest value in a table [tbl].
	Checks each value to see which one is the greatest. Then it returns the key.
	Does not compare the size of each key.
	The table can only contain numbers.
    If there is more than one highest value, the first value in the table is returned.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.HasValue",
	args = {"tbl", "value"},
	returns = {"Y/N"},
	realm = "Shared",
	desc = [[Checks to see if a table [tbl] has a value [value].
	Returns true if [tbl] has [value].
	Otherwise, returns false.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Inherit",
	args = {"child", "parent"},
	returns = {"child"},
	realm = "Shared",
	desc = [[Inherets properties from a table [parent] to a table [child].
	Copies and merges anything in the second table into the first one.
	Does not overwrite the [child]'s items.
	If both tables have items with the same key, the [child] will keep its value.
	The [child] gets a new item called BaseClass, which is the [parent] table.
	BaseClass isn't a copy of the [parent]. It IS the [parent].
	Modifying the [child]'s BaseClass will modify the [parent] itself.
	Returns the [child] table after inheritance.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.KeyFromValue",
	args = {"tbl", "value"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Gets the key [key] of a value [value] in a table [tbl].
	If the table doesn't have that [value], then it returns nil.
	If the table has several keys with that [value] then it returns the first one.
	Use table.KeysFromValue to get a table of all keys that have that [value] in a table.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.KeysFromValue",
	args = {"tbl", "value"},
	returns = {"keys"},
	realm = "Shared",
	desc = [[Gets the keys [keys] of a value [value] in a table [tbl].
	If the table doesn't have that [value], then it returns an empty table.
	[keys] will be a table with consecutive numerical keys.
	Each value in [keys] will be the key of the [value] in [tbl].]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.insert",
	args = {"tbl", "value"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Inserts an item [value] into a table [tbl].
	Returns the key [key] that the item now has in the table.
	The new key will be the next open consecutive integer key in the table.
	If you only add items with table.insert, all the items will be in consecutive key order.
	See the tutorial on tables for more info.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.IsSequential",
	args = {"tbl"},
	returns = {"Y/N"},
	realm = "Shared",
	desc = [[Checks if the table is in consecutive numerical order.
	All the keys must be numbers for this to return true.
	If not all the keys are in consecutive numerical order, returns false.
	Otherwise, returns true.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.LowerKeyNames",
	args = {"tbl"},
	returns = {},
	realm = "Shared",
	desc = [[Changes all the keys in a table [tbl] lowercase.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.maxn",
	args = {"tbl"},
	returns = {"key"},
	realm = "Shared",
	desc = [[Returns the highest positive numerical key in a table [tbl].
	Returns 0 if there are no numerical keys (or only negative keys) in the table.
	Ignores strings.
	This is different to table.getn as it gets the largest numerical index of a table,
	instead of the largest consecutive numerical index from 1.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Merge",
	args = {"src, dest"},
	returns = {"dest"},
	realm = "Shared",
	desc = [[Merges a table [src] into a table [dest].
	If an item in [dest] has the same key as an item in [src] then it replaces them.
	Similar to table.Inherit, except it overwrites rather than leaves alone keys.
	Returns [dest] after the merge.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Random",
	args = {"tbl"},
	returns = {"value"},
	realm = "Shared",
	desc = [[Returns a random value [value] from a table [tbl].]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.Sanitise",
	args = {"tbl"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Sanitises a table [tbl].
	Converts a table containing vectors, angles, bools so it can be converted to and from keyvalues.
	This is used with util.TableToKeyValues and util.KeyValuesToTable.
	This does not organize the table or anything like that.
	This is not required unless the table has vectors, trues/falses, or angles.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.sort",
	args = {"tbl", "func"},
	returns = {},
	realm = "Shared",
	desc = [[Sorts a table [tbl].
	[func] is the manner of sorting and is optional.
	If you do not provide a [func] then it will be sorted alphabetically by default.
	[func] has arguments a and b passed to it.
	They are both values in the table.
	Each value is checked with each other value with this function.
	Return true to say a goes before b, return false to say b goes before a.
	Returning a < b, for example, would sort in numerical order.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.SortByKey",
	args = {"tbl", "order"},
	returns = {"tbl"},
	realm = "Shared",
	desc = [[Sorts a table [tbl] by its keys.
	[order] can be true or false and is optional.
	If [order] is true, then it will sort from least to greatest.
	If [order] is false, then it will sort from greatest to least.
	[order] is false, by default.]],
	func = function(tbl,order) return table.SortByKey(tbl,(order or false)) end
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.SortByMember",
	args = {"tbl", "key", "func"},
	returns = {},
	realm = "Shared",
	desc = [[Sorts a table [tbl] by the value of a specific key [key].
	Each item in the table must be a table with a key [key].
	[func] is the manner of sorting and is optional.
	If you do not provide a [func] then it will be sorted alphabetically by default.
	[func] has arguments a and b passed to it.
	They are both values in the table.
	Each value is checked with each other value with this function.
	Return true to say a goes before b, return false to say b goes before a.
	Returning a < b, for example, would sort in numerical order.]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.sortdesc",
	args = {"tbl"},
	returns = {},
	realm = "Shared",
	desc = [[Sorts a table in descending alphabetical order. (Z->A)]]
},"table",_,_,_)

LUABEE.CatalogFunction({
	name = "table.ToString",
	args = {"tbl", "name", "lines"},
	returns = {"str"},
	realm = "Shared",
	desc = [[Returns the string version of a table.
	[name] is the pretty name you want to give to the table. Must be a string.
	[lines] defines whether the string should be one line (false), or multiple lines (true).]]
},"table",_,_,_)

