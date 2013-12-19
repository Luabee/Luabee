
LUABEE.AddLibrary("cookie", Color(206,91,152))

LUABEE.CatalogFunction({
	name="cookie.Delete",
	args = {"name"},
	returns = {},
	realm = "Client",
	desc=[[Deletes a previously created cookie.
	[name] is the key under which the cookie is stored.]]
},"cookie",_,_)

LUABEE.CatalogFunction({
	name="cookie.GetNumber",
	args = {"name", "def"},
	returns = {},
	realm = "Client",
	desc=[[Gets a previously created cookie as a number.
	[name] is the key under which the cookie is stored.
	[def] is the default value to return if the cookie doesn't exist.]]
},"cookie",_,_)

LUABEE.CatalogFunction({
	name="cookie.GetString",
	args = {"name", "def"},
	returns = {},
	realm = "Client",
	desc=[[Gets a previously created cookie as a string.
	[name] is the key under which the cookie is stored.
	[def] is the default value to return if the cookie doesn't exist.]]
},"cookie",_,_)

LUABEE.CatalogFunction({
	name="cookie.Set",
	args = {"name", "val"},
	returns = {},
	realm = "Client",
	desc=[[Sets a cookie to a string or a number.
	[name] is the key under which the cookie is stored.
	[val] is the value to save. Must be a number or a string.
	Cookies are just like variables that are saved for long-term.]]
},"cookie",_,_)
