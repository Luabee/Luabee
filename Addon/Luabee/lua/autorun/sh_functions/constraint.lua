
LUABEE.AddLibrary("constraint", Color(188,255,0))

LUABEE.CatalogFunction({
	name="constraint.AddConstraintTable",
	args = {"ent1", "const", "ent2", "ent3", "ent4"},
	returns = {},
	realm = "Server",
	desc=[[Stores info about a constraint.
	[ent1] and [const] are necessary.
	The other arguments aren't required.
	[const] should be a constraint entity.
	The constraint is deleted when [ent1] is deleted.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.AddConstraintTableNoDelete",
	args = {"ent1", "const", "ent2", "ent3", "ent4"},
	returns = {},
	realm = "Server",
	desc=[[Stores info about a constraint.
	[ent1] and [const] are necessary.
	The other arguments aren't required.
	[const] should be a constraint entity.
	The constraint is deleted when [ent1] is NOT deleted.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.AdvBallSocket",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "maxforce", "maxtorque", "xmin", "ymin", "zmin", "xmax", "ymax", "zmax", "xfric", "yfric", "zfric", "turnonly", "nocollide"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates an advanced ballsocket.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[maxforce] = maximum force before it breaks.
	[maxtorque] = maximum torque before it breaks.
	[xmin] = minimum X. (number)
	[ymin] = minimum Y. (number)
	[zmin] = minimum Z. (number)
	[xmax] = maximum X. (number)
	[ymax] = maximum Y. (number)
	[zmax] = maximum Z. (number)
	[xfric] = X friction. (number)
	[yfric] = Y friction. (number)
	[zfric] = Z friction. (number)
	[turnonly] = only rotate, don't pivot (like an axis.) (1 or 0)
	[nocollide] = collision between props. (1 or 0)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Axis",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "maxforce", "maxtorque", "friction", "nocollide", "axis"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates an axis.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[maxforce] = maximum force before it breaks.
	[maxtorque] = maximum torque before it breaks.
	[xfric] = friction. (number)
	[nocollide] = collision between props. (1 or 0)
	[axis] = local axis. (vector)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Ballsocket",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos", "maxforce", "maxtorque", "nocollide"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates a ballsocket.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos] = Local Pos (vector).
	[maxforce] = maximum force before it breaks.
	[maxtorque] = maximum torque before it breaks.
	[nocollide] = collision between props. (1 or 0)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.CanConstrain",
	args = {"ent", "bone"},
	returns = {"bool"},
	realm = "Server",
	desc=[[Checks to see if an entity and bone are valid.
	[ent] is the entity.
	[bone] is the bone. (number)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.CreateKeyframeRope",
	args = {"pos", "width", "mat", "const", "ent1", "LPos1", "bone1", "ent2", "LPos2", "bone2", "kv"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates a keyframe_rope entity between two points.
	The many arguments are as such:
	[pos] = position (vector).
	[width] = width of rope (number).
	[mat] = material of rope (string).
	[const] = a constraint.
	[ent1] = first entity.
	[LPos1] = first Local Pos (vector).
	[bone1] = first bone (number).
	[ent2] = second entity.
	[LPos2] = second Local Pos (vector).
	[bone2] = second bone (number).
	[kv] = key values. (table)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.CreateStaticAnchorPoint",
	args = {"pos"},
	returns = {"anchor", "phys", "bone", "pos"},
	realm = "Server",
	desc=[[Creates a gmod_anchor entity at a point.
	[pos] (the argument) is the vector to place the anchor.
	The four return values are as such:
	[anchor] is the actual anchor entity that was created.
	[phys] is that anchor's physics object.
	[bone] will always be 0.
	[pos] will always be equal to Vector(0, 0, 0).
	Must be used in Sandbox or a Sandbox-derived gamemode.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Elastic",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "constant", "damp", "rdamp", "mat", "width", "stronly"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates an elastic rope.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[damp] = damping. (number)
	[rdamp] = reverse damping. (number)
	[mat] = material. (string)
	[width] = rope width. (number)
	[stronly] = stretch only. (1 or 0)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.FindConstraint",
	args = {"ent","name"},
	returns = {"tbl"},
	realm = "Server",
	desc=[[Find the first constraint of a type on an entity.
	[ent] is the entity.
	[name] is the type of constraint to find, such as hydraulic.
	[name] must be a string.
	Returns a table [tbl] of info about the constraint.
	The table contains "Constraint" and "Entity".
	"Constraint" is the actual constraint.
	"Entity" is assorted information about the constraint.
	See the wiki page for more info on [tbl]'s contents.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.FindConstraintEntity",
	args = {"ent","name"},
	returns = {"const"},
	realm = "Server",
	desc=[[Find the first constraint of a type on an entity.
	[ent] is the entity.
	[name] is the type of constraint to find, such as hydraulic.
	[name] must be a string.
	Only returns the constraint, unlike constraint.FindConstraint]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.FindConstraints",
	args = {"ent","name"},
	returns = {"tbl"},
	realm = "Server",
	desc=[[Finds all constraints of a type on an entity.
	[ent] is the entity.
	[name] is the type of constraint to find, such as hydraulic.
	[name] must be a string.
	Returns a table [tbl] which contains subtables.
	Each subtable contains information on each constraint.
	These subtables contain "Constraint" and "Entity".
	"Constraint" is the actual constraint.
	"Entity" is assorted information about the constraint.
	See constraint.FindConstraint for more info.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.GetAllConstrainedEntities",
	args = {"ent"},
	returns = {"tbl"},
	realm = "Server",
	desc=[[Finds all constraints on an entity.
	[ent] is the entity.
	Returns a table [tbl] which contains subtables.
	Each subtable contains information on each constraint.
	These subtables contain "Constraint" and "Entity".
	"Constraint" is the actual constraint.
	"Entity" is assorted information about the constraint.
	See constraint.FindConstraint or the wiki for more info.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.HasConstraints",
	args = {"ent"},
	returns = {"bool"},
	realm = "Server",
	desc=[[Returns true if an entity has any constraints.
	Returns false if otherwise.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Hydraulic",
	args = {"ply","ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "len1", "len2", "width", "key", "fixed", "speed"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates a hydraulic.
	The many arguments are as such:
	[ply] = player who owns it. (player)
	[ent1] = first entity. (entity)
	[ent2] = second entity. (entity)
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[len1] = unextended length. (number)
	[len2] = extended length. (number)
	[width] = rope width. (number)
	[key] = key enumeration. (KEY_ENUM/number)
	[fixed] = fixed to each other. (1 or 0)
	[speed] = speed of movement. (number)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Keepupright",
	args = {"ent","ang","bone","limit"},
	returns = {"const"},
	realm = "Server",
	desc=[[Keeps an entity upright.
	The many arguments are as such:
	[ent] = entity to keep up.
	[ang] = angle to force (angle).
	[bone] = bone to hold (number).
	[limit] = angular limit. (number)]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Motor",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "friction", "torque", "time", "nocollide", "toggle", "ply", "maxforce", "key1", "key2"},
	returns = {"const", "axis"},
	realm = "Server",
	desc=[[Creates an advanced ballsocket.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[friction] = friction (number).
	[time] = force time in seconds. (number)
	[nocollide] = nocollide entities. (1 or 0)
	[toggle] = whether or not to toggle activation. (1 or 0)
	[ply] = owner of constraint. (player)
	[maxforce] = maximum force limit. (number)
	[key1] = forward key enumeration. (KEY_ENUM/number)
	[key2] = reverse key enumeration. (KEY_ENUM/number)
	
	Returns both a motor constraint and an axis constraint.
	If the constraint fails then [const] is false.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Muscle",
	args = {"ply","ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "len1", "len2", "width", "key", "fixed", "time", "amp"},
	returns = {"const", "rope", "cont", "slider"},
	realm = "Server",
	desc=[[Creates a muscle constraint.
	The many arguments are as such:
	[ply] = owner of muscle (player).
	[ent1] = first entity (entity).
	[ent2] = second entity (entity).
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[len1] = length at minimum (number).
	[len2] = length at maximum (number).
	[width] = width of rope (number).
	[key] = toggle key enumeration (KEY_ENUM/number).
	[fixed] = fixed to each other (1 or 0).
	[time] = time in seconds to do a cycle. (number)
	[amp] = amplitude of power (number).
	
	Returns:
	[const] = muscle constraint (entity/bool).
	[rope] = rope constraint (entity).
	[cont] = controller (entity/nil).
	[slider] = slider constraint (entity/nil).
	
	[const] is false if the constraint fails.
	[cont] and [slider] might be nil.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.NoCollide",
	args = {"ent1","ent2","bone1","bone2"},
	returns = {"const"},
	realm = "Server",
	desc=[[Disables collision between two entities.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	
	Does not work with players.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Pulley",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "WPos1", "WPos2", "maxforce", "rigid", "width", "mat"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates a pulley constraint.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[WPos1] = first World Pos (vector).
	[WPos2] = second World Pos (vector).
	[maxforce] = max force before it breaks (number).
	[rigid] = no rope slack (1 or 0).
	[width] = rope width (number).
	[mat] = rope material (string).]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.RemoveAll",
	args = {"ent"},
	returns = {},
	realm = "Server",
	desc=[[Removes all constraints from an entity.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.RemoveConstraints",
	args = {"ent", "name"},
	returns = {},
	realm = "Server",
	desc=[[Removes all constraints of a type from an entity.
	[name] must be a string representing the type of constraints.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Rope",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "length", "add", "maxforce", "width", "mat", "rigid"},
	returns = {"const", "rope"},
	realm = "Server",
	desc=[[Creates a rope constraint.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[length] = rope length (number).
	[add] = rope's addlength (number).
	[maxforce] = max force before it breaks (number).
	[width] = rope width (number).
	[mat] = rope material (string).
	[rigid] = no rope slack (1 or 0).
	
	Returns a constraint and a rope.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Slider",
	args = {"ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "width"},
	returns = {"const", "rope"},
	realm = "Server",
	desc=[[Creates a rope constraint.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[width] = rope width (number).
	
	Returns a constraint and a rope.]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Weld",
	args = {"ent1", "ent2", "bone1", "bone2", "maxforce", "nocollide"},
	returns = {"const"},
	realm = "Server",
	desc=[[Creates a weld constraint.
	The many arguments are as such:
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[maxforce] = max force before the weld breaks (number).
	[nocollide] = disable collisions between props (1 or 0).]]
},"constraint",_,_)

LUABEE.CatalogFunction({
	name="constraint.Winch",
	args = {"ply", "ent1", "ent2", "bone1", "bone2", "LPos1", "LPos2", "constant", "damp", "rdamp", "mat", "width", "stronly"},
	returns = {"const", "rope", "cont"},
	realm = "Server",
	desc=[[Creates an elastic rope.
	The many arguments are as such:
	[ply] = winch's owner.
	[ent1] = first entity.
	[ent2] = second entity.
	[bone1] = first bone (number).
	[bone2] = second bone (number).
	[LPos1] = first Local Pos (vector).
	[LPos2] = second Local Pos (vector).
	[width] = rope width (number).
	[fkey] = forward key enumeration (KEY_ENUM/number).
	[rkey] = reverse key enumeration (KEY_ENUM/number).
	[fspd] = forward speed (number).
	[rspd] = reverse speed (number).
	[mat] = material (string).
	[toggle] = toggle on/off (1 or 0).
	
	Returns:
	[const] = constraint.
	[rope] = rope.
	[cont] = controller.]]
},"constraint",_,_)
