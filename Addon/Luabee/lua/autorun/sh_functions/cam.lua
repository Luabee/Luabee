
LUABEE.AddLibrary("cam", Color(200,200,0))

LUABEE.CatalogFunction({
	name="cam.ApplyShake",
	args = {"vect", "ang", "factor"},
	returns = {},
	realm = "Client",
	desc=[[Shakes the player's camera.
	Rotates it on an axis vector [origin] at an angle [ang].
	The shake's intensity is defined by [factor]. This should be a number.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.Start2D",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Starts 2D rendering.
	Make sure to use cam.End2D after cam.Start2D or bad things happen.
	Code between cam.Start2D and cam.End2D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.End2D",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Finishes 2D rendering.
	Use this after cam.Start2D or GMod will crash.
	Code between cam.Start2D and cam.End2D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.Start3D2D",
	args = {"pos", "ang", "scale"},
	returns = {},
	realm = "Client",
	desc=[[Starts 3D-2D rendering.
	3D-2D rendering is like a virtual screen at a position in the world.
	The things you draw are 2D, but they have a position in the world.
	This is mostly used for displays attached to entities.
	[pos] is a vector that represents the draw position.
	[ang] is an angle that represents the angle to draw.
	[scale] is a number which represents the draw scale. Use 1 for normal size.
	Make sure to use cam.End3D2D after cam.Start3D2D or bad things happen.
	Code between cam.Start3D2D and cam.End3D2D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work correctly.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.End3D2D",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Finishes 3D-2D rendering.
	Use this after cam.Start3D2D or GMod will crash.
	Code between cam.Start3D2D and cam.End3D2D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work.
	See cam.Start3D2D for more info.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.Start3D",
	args = {"pos", "ang", "scale"},
	returns = {},
	realm = "Client",
	desc=[[Starts 3D rendering.
	3D rendering is like a virtual screen at a position in the world.
	The things you draw are 2D, but they have a position in the world.
	This is mostly used for displays attached to entities.
	[pos] is a vector that represents the draw position.
	[ang] is an angle that represents the angle to draw.
	[scale] is a number which represents the draw scale. Use 1 for normal size.
	Make sure to use cam.End3D after cam.Start3D or bad things happen.
	Code between cam.Start3D and cam.End3D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work correctly.]]
},"cam",_,_)

LUABEE.CatalogFunction({
	name="cam.End3D2D",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Finishes 3D rendering.
	Use this after cam.Start3D or GMod will crash.
	Code between cam.Start3D and cam.End3D can be used like a paint hook.
	This means that draw.RoundedBox and surface.DrawPoly will work.
	See cam.Start3D for more info.]]
},"cam",_,_)




