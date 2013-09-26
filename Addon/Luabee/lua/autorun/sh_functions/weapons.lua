LUABEE.AddLibrary("weapons", Color(255,240,255))

LUABEE.CatalogFunction({
	name="weapons.Get",
	args = {"CName"},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Returns the table(Tbl) of the SWEP associated with the class(CName)
	You should use weapons.GetStored instead.]]
},"weapons",_,_)


LUABEE.CatalogFunction({
	name="weapons.GetList",
	args = {},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Get a list [Tbl] of all the registered SWEP tables. ]]
},"weapons",_,_)



LUABEE.CatalogFunction({
	name="weapons.GetStored",
	args = {"WepC"},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Like weapons.Get, but more reliable.]]
},"weapons",_,_)