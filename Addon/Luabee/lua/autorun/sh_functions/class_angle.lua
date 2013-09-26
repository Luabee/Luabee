
LUABEE.AddClass("Angle", Color(80,80,255))


table.insert(LUABEE.CatalogedFunctions.Classes["Angle"],{
	name="Angle",
	args = {"p","y","r"},
	returns = {""},
	realm = "Server",
	Section = "Classes",
	category = "Angle",
	desc=[[Creates an angle with three elements.
	[p] is the pitch.
	[y] is the yaw.
	[r] is the roll.
	[p], [y], and [r] must be numbers.]]
})

LUABEE.CatalogFunction({
	name="Angle:Forward",
	args = {"ang"},
	returns = {"vector"},
	realm = "Server",
	desc=[[Returns a normalized vector pointing in the direction the angle is pointing.]]
	
},_,"Angle",_,_)

LUABEE.CatalogFunction({
	name="Angle:Right",
	args = {"ang"},
	returns = {"vector"},
	realm = "Server",
	desc=[[Returns a normalized vector pointing to the right of the direction the angle is pointing.]]
	
},_,"Angle",_,_)

LUABEE.CatalogFunction({
	name="Angle:Up",
	args = {"ang"},
	returns = {"vector"},
	realm = "Server",
	desc=[[Returns a normalized vector pointing upwards from the direction the angle is pointing.]]
	
},_,"Angle",_,_)

LUABEE.CatalogFunction({
	name="Angle:RotateAroundAxis",
	args = {"ang", "axis", "deg"},
	returns = {},
	realm = "Server",
	desc=[[Rotates this angle about the axis formed by [axis] by [deg] degrees (not radians).
	[axis] must be a normalized vector.
	This method will modify the Angle you give and returns nothing.]]
	
},_,"Angle",_,_)
