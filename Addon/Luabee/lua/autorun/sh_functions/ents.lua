
LUABEE.AddLibrary("ents", Color(127,219,66))

LUABEE.CatalogFunction({
	name="ents.FindByName",
	args = {"name"},
	returns = {"tbl"},
	realm = "Server",
	desc=[[Finds and returns all entities that are named [name].
	This does not find players by their names.
	It searches entities by their "name" keyvalue.]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindByModel",
	args = {"mdl"},
	returns = {"tbl"},
	realm = "Server",
	desc=[[Finds and returns all entities with a given model.
	[mdl] should be a string ending with .mdl
	Example: "models/props_animated_breakable/Smokestack.mdl"]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.Create",
	args = {"class"},
	returns = {"ent"},
	realm = "Shared",
	desc=[[Creates a new entity and returns it.
	[class] is a string such as "prop_physics" or "npc_zombie".
	This entity can be modified with the Entity class methods.
	Make sure to Entity:Spawn it when you're finished.
	
	Usually only ran serverside, but can also be ran clientside.
	If ran clientside the entity will only be visible to the client.
	If it can't be ran clientside for a given entity you'll get an error:
	"Can't find factory for entity: <[class]>"]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindByClass",
	args = {"class"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Finds all the entities with a given class.
	[class] should be a string such as "prop_physics".
	If you're trying to find players, do player.GetAll]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindByClass",
	args = {"class"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Finds all the entities with a given class.
	[class] should be a string such as "prop_physics".
	You can use wildcards (*), like "npc_*".
	If you're trying to find players, do player.GetAll]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindByClass",
	args = {"min", "max"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Finds all the entities within a bounding box.
	[min] and [max] are two vectors.
	Each one stands for an opposite corner of the box.]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindInCone",
	args = {"pos", "dir", "dist", "r"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Finds all the entities within a cone.
	[pos] is the position of the cone's vertex. (vector)
	[dir] is the place to point the cone's axis. (vector)
	[dist] is the length of the axis. (number)
	[r] is the radius of the cone's base.]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.FindInSphere",
	args = {"pos", "r"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Finds all entities within a sphere.
	[pos] is a vector of the origin.
	[r] is the radius.]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.GetAll",
	args = {"pos", "r"},
	returns = {"tbl"},
	realm = "Shared",
	desc=[[Returns a table of all entities.]]
},"ents",_,_)

LUABEE.CatalogFunction({
	name="ents.GetByIndex",
	args = {"i"},
	returns = {"ent"},
	realm = "Shared",
	desc=[[Returns an entity by its index.
	To get an index, do Entity:GetIndex.
	The same thing as the global Entity function.]]
},"ents",_,_)
