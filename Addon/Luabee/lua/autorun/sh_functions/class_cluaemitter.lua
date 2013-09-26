
LUABEE.AddClass("CLuaEmitter", Color(80,80,255))


table.insert(LUABEE.CatalogedFunctions.Classes["CLuaEmitter"],{
	name="ParticleEmitter",
	args = {"pos"},
	returns = {""},
	realm = "Client",
	Section = "Classes",
	category = "CLuaEmitter",
	desc=[[Creates a CLuaEmitter object and returns it.
	[pos] is the position that the emitter is created.
	[pos] must be a vector.
	Modify the CLuaEmitter with CLuaEmitter class methods.]]
})

LUABEE.CatalogFunction({
	name="CLuaEmitter:Add",
	args = {"emit", "eff", "vect"},
	returns = {"particle"},
	realm = "Client",
	desc=[[Using a CLuaEmitter [emit], creates a CLuaParticle at [vect] with sprite [eff].
	[eff] must be a string which points to a sprite.
	[vect] must be a vector, and represents the origin of the particle.]]
	
},_,"CLuaEmitter",_,_)

LUABEE.CatalogFunction({
	name="CLuaEmitter:Finish",
	args = {"emit"},
	returns = {},
	realm = "Client",
	desc=[[Removes an emitter [emit].]]
	
},_,"CLuaEmitter",_,_)

LUABEE.CatalogFunction({
	name="CLuaEmitter:SetNearClip",
	args = {"emit"},
	returns = {},
	realm = "Client",
	desc=[[Removes an emitter [emit].]]
	
},_,"CLuaEmitter",_,_)

LUABEE.CatalogFunction({
	name="CLuaEmitter:SetPos",
	args = {"emit", "pos"},
	returns = {},
	realm = "Client",
	desc=[[Sets the position of an emitter to [pos].
	[pos] must be a vector.]]
	
},_,"CLuaEmitter",_,_)
