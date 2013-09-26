
LUABEE.AddClass("CEffectData", Color(80,80,255))


table.insert(LUABEE.CatalogedFunctions.Classes["CEffectData"],{
	name="EffectData",
	args = {},
	returns = {""},
	realm = "Shared",
	Section = "Classes",
	category = "CEffectData",
	desc=[[Creates an effect data object and returns it.
	Modify the effect data with CEffectData class methods.
	Use this as the second argument of util.Effect]]
})

LUABEE.CatalogFunction({
	name="CEffectData:GetAngle",
	args = {"eff"},
	returns = {"ang"},
	realm = "Shared",
	desc=[[Returns the angle [ang] of the CEffectData [eff].]]
	
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetAttachment",
	args = {"eff"},
	returns = {"ID"},
	realm = "Shared",
	desc=[[Returns the attachment ID [ID] of the CEffectData [eff].
	[ID] will be a number, defined with CEffectData:SetAttachment.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetColor",
	args = {"eff"},
	returns = {"col"},
	realm = "Shared",
	desc=[[Returns the color [col] of the CEffectData [eff].
	[col] will be a color table with keys r, g, b, and a.
	[col] is the color that was defined with CEffectData:SetColor.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetEntity",
	args = {"eff"},
	returns = {"ent"},
	realm = "Shared",
	desc=[[Returns the entity [ent] of the CEffectData [eff].
	[ent] is the entity defined with CEffectData:SetEntity.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetFlags",
	args = {"eff"},
	returns = {"flags"},
	realm = "Shared",
	desc=[[Returns the source engine flags [flags] of the CEffectData [eff].
	[flags] are defined with CEffectData:SetFlags.
	[flags] will be a table.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetMagnitude",
	args = {"eff"},
	returns = {"mag"},
	realm = "Shared",
	desc=[[Returns the magnitude [mag] of the CEffectData [eff].
	[mag] will be a number, defined with CEffectData:SetMagnitude.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetMaterial",
	args = {"eff"},
	returns = {"mat"},
	realm = "Shared",
	desc=[[Returns the material [mat] of the CEffectData [eff].
	[mat] will be a material object, defined with CEffectData:SetMaterial.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetNormal",
	args = {"eff"},
	returns = {"vect"},
	realm = "Shared",
	desc=[[Returns the normal vector [vect] of the CEffectData [eff].
	[vect] will be a normalized vector, defined with CEffectData:SetNormal.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetOrigin",
	args = {"eff"},
	returns = {"vect"},
	realm = "Shared",
	desc=[[Returns the origin [vect] of the CEffectData [eff].
	[vect] will be a vector, defined with CEffectData:SetOrigin.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetRadius",
	args = {"eff"},
	returns = {"r"},
	realm = "Shared",
	desc=[[Returns the radius [r] of the CEffectData [eff].
	[r] will be a number, defined with CEffectData:SetRadius.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetScale",
	args = {"eff"},
	returns = {"scale"},
	realm = "Shared",
	desc=[[Returns the scale [scale] of the CEffectData [eff].
	[scale] will be a number, defined with CEffectData:SetScale.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetStart",
	args = {"eff"},
	returns = {"vect"},
	realm = "Shared",
	desc=[[Returns the start vector [vect] of the CEffectData [eff].
	[vect] will be a vector, defined with CEffectData:SetStart.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:GetSurfaceProp",
	args = {"eff"},
	returns = {"mat"},
	realm = "Shared",
	desc=[[Returns the surface prop [mat] of the CEffectData [eff].
	[mat] will be a material object, defined with CEffectData:SetSurfaceProp.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetAngle",
	args = {"eff", "ang"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the angle [ang] of a CEffectData [eff].
	[ang] must be an angle object.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetAttachment",
	args = {"eff", "ID"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the attachment [ID] of a CEffectData [eff].
	[ID] must be a number which corresponds to an entity's attachment id.
	Entity:GetAttachmentID can retrieve the correct id for you.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetColor",
	args = {"eff", "col"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the color [col] of a CEffectData [eff].
	[col] must be a color object.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetEntity",
	args = {"eff", "ent"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the entity [ent] of a CEffectData [eff].
	[ent] must be an entity.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetFlags",
	args = {"eff", "flags"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the source engine flags [flags] of a CEffectData [eff].
	[flags] must be a table.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetMagnitude",
	args = {"eff", "mag"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the source engine magnitude [mag] of a CEffectData [eff].
	[mag] must be a number.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetMaterial",
	args = {"eff", "mat"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the material [mat] of a CEffectData [eff].
	[mat] must be a material object.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetNormal",
	args = {"eff", "vect"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the normal vector [vect] of a CEffectData [eff].
	[vect] must be a normalized vector.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetOrigin",
	args = {"eff", "vect"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the origin [vect] of a CEffectData [eff].
	[vect] must be a vector.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetRadius",
	args = {"eff", "r"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the radius [r] of a CEffectData [eff].
	[r] must be a number.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetScale",
	args = {"eff", "scale"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the scale [scale] of a CEffectData [eff].
	[scale] must be a number.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetScale",
	args = {"eff", "vect"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the start vector [vect] of a CEffectData [eff].
	[vect] must be a vector.]]
},_,"CEffectData",_,_)

LUABEE.CatalogFunction({
	name="CEffectData:SetSurfaceProp",
	args = {"eff", "mat"},
	returns = {},
	realm = "Shared",
	desc=[[Sets the surface prop [mat] of a CEffectData [eff].
	[mat] must be a material object.]]
},_,"CEffectData",_,_)

