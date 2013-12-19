
LUABEE.AddLibrary("debugoverlay", Color(208,208,208))

LUABEE.CatalogFunction({
	name="debugoverlay.Box",
	args = {"origin", "mins", "maxs", "dur", "col", "ignorez"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a box at a point in 3D space.
	[origin] is the origin of the box. (vector)
	[mins] is a vector localized to the [origin]. Should be negative.
	[maxs] is a vector localized to the [origin]. Should be positive.
	
	OPTIONAL ARGS:
	[dur] = seconds before it disappears. Default: 1
	[col] = color of the box. Default: White
	[ignorez] = Whether to draw OVER everything. Default: false]]
},"debugoverlay",_,_)

LUABEE.CatalogFunction({
	name="debugoverlay.Cross",
	args = {"origin", "size", "dur", "col", "ignorez"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a cross at a point in 3D space.
	[origin] is the origin of the cross. (vector)
	[size] is the size of the cross. (number)
	
	OPTIONAL ARGS:
	[dur] = seconds before it disappears. Default: 1
	[col] = color of the cross. Default: White
	[ignorez] = Whether to draw OVER everything. Default: false]]
},"debugoverlay",_,_)

LUABEE.CatalogFunction({
	name="debugoverlay.Line",
	args = {"pos1", "pos2", "dur", "col", "ignorez"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a line between two points in 3D space.
	[pos1] is the first point. (vector)
	[pos2] is the second point. (vector)
	
	OPTIONAL ARGS:
	[dur] = seconds before it disappears. Default: 1
	[col] = color of the line. Default: White
	[ignorez] = Whether to draw OVER everything. Default: false]]
},"debugoverlay",_,_)

LUABEE.CatalogFunction({
	name="debugoverlay.Sphere",
	args = {"origin", "r", "dur", "col", "ignorez"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a sphere at a point in 3D space.
	[origin] is the origin of the sphere. (vector)
	[r] is the radius. (number)
	
	OPTIONAL ARGS:
	[dur] = seconds before it disappears. Default: 1
	[col] = color of the sphere. Default: White
	[ignorez] = Whether to draw OVER everything. Default: false]]
},"debugoverlay",_,_)

LUABEE.CatalogFunction({
	name="debugoverlay.Text",
	args = {"origin", "text", "dur"},
	returns = {},
	realm = "Shared",
	desc=[[Creates text at a point in 3D space.
	[origin] is the origin of the box. (vector)
	[text] is the text to display. (string)
	
	OPTIONAL:
	[dur] = seconds before it disappears. Default: 1]]
},"debugoverlay",_,_)