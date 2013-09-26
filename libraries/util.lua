LUABEE.AddLibrary("util", Color(190,230,255))



LUABEE.CatalogFunction({
	name="util.AddNetworkString",
	args = {"Str"},
	returns = {},
	realm = "Server",
	desc=[[Precaches the string[Str] for networking.]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.AimVector",
	args = {},
	returns = {},
	realm = "Shared",
	desc=[[]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.Base64Encode",
	args = {"Str"},
	returns = {"Bs64"},
	realm = "Shared",
	desc=[[Encodes the specified string[Str] to base64[Bs64]. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.BlastDamage",
	args = {"Inf","Atkr","Origin","Radius","Dmg"},
	returns = {},
	realm = "Server",
	desc=[[Applies explosion damage to all entities in the specified radius. [Inf] is the inflictor,
	[Atkr] is the attacker, ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.Compress",
	args = {"Str"},
	returns = {"Comp"},
	realm = "Shared",
	desc=[[Compresses the given string[Str] using FastLZ. ]] -- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.CRC",
	args = {"Str2H"},
	returns = {"Us32BH"},
	realm = "Shared",
	desc=[[stringToHash[Str2H] and unsigned32BitHash[Us32BH]. This returns a value that can be used to identify something]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.DateStamp",
	args = {},
	returns = {"Date"},
	realm = "Shared",
	desc=[[Returns the current date formatted like '2012-10-31 18-00-00' ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.Decal",
	args = {"DName","TrSt","TrEn"},
	returns = {},
	realm = "Shared",
	desc=[[Performs a trace[TrSt](Trace start)[TrEn](Trace end) and paints a decal[DName] to the surface hit. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.DecalEx",
	args = {"Mat","Ent","Pos","Nrm","Cl","Wth","Hgt"},
	returns = {},
	realm = "Client",
	desc=[[Performs a trace and paints a decal to the surface hit. " [Mat] Material the name of the decal to paint,[Ent] Entity the start of the trace,
	[Pos](vector) Position of the decal, [Nrm](vector) The normal of the decal,[Cl] Color of the decal ,[Wth](number) The width of the decal, [Hgt](number) Height of the decal. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.DecalMaterial",
	args = {"DName"},
	returns = {"MatP"},
	realm = "Shared",
	desc=[[Gets the full material path[MatP] by the decal name[DName]. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.Decompress",
	args = {"Comp"},
	returns = {"UComp"},
	realm = "Shared",
	desc=[[Decompresses the given string[Comp] using FastLZ. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.DistanceToLine",
	args = {"LnSt","LnEn","PtPos"},
	returns = {"Dist"},
	realm = "Shared",
	desc=[[Gets the distance between a line[LnSt](line start)[LnEn](line end) and a point[PtPos] in 3d space. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.Effect",
	args = {"EfName","EfDat","Y/N","Filt"},
	returns = {},
	realm = "Shared",
	desc=[[ [EfName]The name of the effect to create,[EfDat] The effect data describing the effect,[Y/N]Allow override(optional),
	[Filt]ignorePredictionOrRecipientFilter ignore predicition or recipient filter. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({ e
	name="util.GetModelInfo",
	args = {},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Returns a [Tbl]table containing the number of skins in a model.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.GetPixelVisibleHandle",
	args = {},
	returns = {"PxVi"},
	realm = "Client",
	desc=[[Returns the [PxVi]pixel visible handle to use with util.PixelVisible.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.GetPlayerTrace",
	args = {"Ply","Dir"},
	returns = {},
	realm = "Shared",
	desc=[[Utility function to quickly generate a trace table that starts at the [Ply]players view position, and ends 16384 units along a [Dir]specified direction ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.GetSunInfo",
	args = {},
	returns = {"SnI"},
	realm = "Client",
	desc=[[Gets [SnI]information about the sun position and obstruction or nil if there is no sun. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.GetSurfaceIndex",
	args = {"SrName"},
	returns = {"SrInd"},
	realm = "Shared",
	desc=[[Returns the matching [SrInd]surface index for the [SrName]surface name. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IntersectRayWithOBB",
	args = {"St","Dir","Origin","Angles","Mins","Maxs",},
	returns = {"HPos"},
	realm = "Shared",
	desc=[[Performs a ray box intersection and returns [HPos]position, normal and the fraction.
	[St](rayStart) any position on the ray,[Dir](RayDirection) the direction of the ray, [Origin](boxOrigin) center of the box,
	[Angles](boxAngles) the angles of the box, [Mins](boxMins) the min position of the box, [Maxs] the max position of the box]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IntersectRayWithPlane",
	args = {"Origin","Dir","Pos","Nrm"},
	returns = {"HPos"},
	realm = "Shared",
	desc=[[Performs a ray plane intersection and returns the [HPos]hit position or nil. ]] -- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsInWorld",
	args = {"Pos"},
	returns = {"Y/N"},
	realm = "Server",
	desc=[[Checks if a certain position in within the world bounds. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsModelLoaded",
	args = {"MdlName"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Checks if the model is loaded in the game. [MdlName](modelName) needs name or path to check.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsSkyboxVisibleFromPoint",
	args = {"Pos"},
	returns = {"Y/N"},
	realm = "Client",
	desc=[[Returns whenever the skybox is visibile from the [Pos]point specified. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsValidModel",
	args = {"MdlName"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Checks if the specified model is valid. [MdlName](modelName) needs name or path to check.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsValidPhysicsObject",
	args = {"Ent","PhyOb"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Checks if given numbered [Phyob]physics object of given [Ent]entity is valid or not. Most useful for ragdolls. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsValidProp",
	args = {"MdlName"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Checks if the specified [MdlName]prop is valid. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.IsValidRagdoll",
	args = {"RagName"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Checks if the specified [RagName]model name points to a valid ragdoll. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.JSONToTable",
	args = {"JSONStr"},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Converts a [JSONStr]JSON string to a Lua [Tbl]table. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.KeyValuesToTable",
	args = {"KeyStr"},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Converts a [KeyStr]KeyValue string to a Lua [Tbl]table. ]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.KeyValuesToTablePreserveOrder",
	args = {"KeyStr"},
	returns = {"Tbl"},
	realm = "Shared",
	desc=[[Like KeyValuesToTable, but returns a table of tables, each holding one key and it's associated value.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.LocalToWorld",
	args = {"Ent","LPos","BNum"},
	returns = {"WPos"},
	realm = "Shared",
	desc=[[Returns a [WPos]vector in world coordinates based on an [Ent]entity and [LPos]local coordinates ]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.NetworkIDToString",
	args = {"ID"},
	returns = {"NWStr"},
	realm = "Shared",
	desc=[[Returns the [NWStr]string associated with the given id. ]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.NetworkStringToID",
	args = {"NWStr"},
	returns = {"ID"},
	realm = "Shared",
	desc=[[Returns the [NWStr]string associated with the given id. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.NiceFloat",
	args = {"UForm"},
	returns = {"Form"},
	realm = "Shared",
	desc=[[Formats a [UFor]float by stripping off extra 0's and .'s ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.ParticleTracer",
	args = {"Name","StPos","EnPos","PlayS""},
	returns = {},
	realm = "Shared",
	desc=[[Creates a tracer effect with the given parameters.[PlayS](optional)Play the hit miss(whiz) sound. is optional ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.ParticleTracerEx",
	args = {"Name","StPos","EnPos","EntIdx","PlayS","AtchIdx"},
	returns = {},
	realm = "Shared",
	desc=[[Creates a tracer effect with the given parameters.[Name] will be the name of the effect,[StPos] is the starting position of the tracer,
	[EnPos] is the end position of the tracer,[EntIdx] is the entity index of the emitting entity, [PlayS](optional) play the hit miss(whiz) sound,
	[AtchIdx] is the attachment index to be used as origin.]] -- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.PixelVisible",
	args = {"Pos","Radius","PixV"},
	returns = {"Visi"},
	realm = "Client",
	desc=[[Returns the [Visi]visibility of the [PixV]PixVis with the specified parameters, visibility ranges from 0-1. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.PointContents",
	args = {"Pos"},
	returns = {"CONTENTS_Enums"},
	realm = "Shared",
	desc=[[Checks the contents at the position given, based on a position enumeration]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.PrecacheModel",
	args = {"MdlName"},
	returns = {},
	realm = "Shared",
	desc=[[Precaches a model for later use. Model is cached after being loaded once. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.PrecacheSound",
	args = {"SName"},
	returns = {},
	realm = "Shared",
	desc=[[Precaches a sound for later use. Sound is cached after being loaded once. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.QuickTrace",
	args = {"Origin","Dir","Filt"},
	returns = {"TrRes"},
	realm = "Shared",
	desc=[[Performs a trace with the given origin, [Dir]direction and [Filt]filter.[Filt] is for entity/ies which should be ignored. This will return the [TrRes] trace results.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.RelativePathToFull",
	args = {"File"},
	returns = {"AbsPath"},
	realm = "Shared",
	desc=[[Returns the [AbsPath]absolute system path the file relative to /garrysmod/. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.ScreenShake",
	args = {"Pos","Ampl","Freq","Dur","Radius"},
	returns = {},
	realm = "Shared",
	desc=[[Makes the screen shake,[Pos] is the origin of the effect,[Ampl]Amplitude is the strenght of the effect,
	[Freq]Frequency of the effect in hz(number),[Dur] is the duration in seconds(number),[Radius](number) is the size of the effect.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.SpriteTrail",
	args = {"Ent","AtchID","Cl","Addit","StWth","EnWth","LifeT","TexRes","Tex"},
	returns = {"Ent"},
	realm = "Server",
	desc=[[Adds a trail to the specified [Ent]entity. [AtchID] is the attachment ID of the entitiys model to attach trail to. If you are not sure, set this to 0.
    	[Cl] is the color(r,g,b,a) of the trail,[Addit] is optional, it's if you want your trail to be additive or not,[StWth] is the starting width of the trail.
		[EnWth] is the end width of the trial,[LifeT]Lifetime(number) determines how long it will the transition from [StWth] to [EnWth] takes.
		[TexRes]The resolution of trails texture. A good value can be calculated using this formula: 1 / ( startWidth + endWidth ) * 0.5.
		[Tex]Path to the texture to use as a trail. Note that you should also include the ".vmt" or the game might crash! ]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.Stack",
	args = {},
	returns = {"NStack"},
	realm = "Server",
	desc=[[Returns a [NStack]new Stack object ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.SteamIDFrom64",
	args = {"64ID"},
	returns = {"SteamID"},
	realm = "Shared",
	desc=[[Given a [64ID]64bit SteamID will return a [SteamID]STEAM_0: style Steam ID ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.SteamIDTo64",
	args = {"SteamID"},
	returns = {"64ID"},
	realm = "Shared",
	desc=[[Given a [SteamID]STEAM_0 style Steam ID will return a [64ID]64bit Steam ID ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.StringToType",
	args = {"Str","TpName"},
	returns = {"Var"},
	realm = "Shared",
	desc=[[Convert a string to a certain type. [Str] is the string to convert,
	[TpName] Typename The type to attempt to convert the string to ('vector','angle','float','bool','string'), case insensitive. ]]-- %%%Bobble
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TableToJSON",
	args = {"Tbl"},
	returns = {"JSON"},
	realm = "Shared",
	desc=[[Converts a [Tbl]table to a JSON string. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TableToKeyValues",
	args = {"Tbl"},
	returns = {"KeyStr"},
	realm = "Shared",
	desc=[[Converts the given [Tbl]table into a [KeyStr]key value string. ]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.Timer",
	args = {},
	returns = {},
	realm = "Shared",
	desc=[[]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.TimerCycle",
	args = {},
	returns = {"TimeC"},
	realm = "Shared",
	desc=[[Returns [TimeC]Time since this function has been last called in ms]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.tobool",
	args = {"Input"},
	returns = {"Y/N"},
	realm = "Shared",
	desc=[[Converts string or a number to a bool, if possible. Alias of Global.tobool]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TraceEntity",
	args = {"TrDat","Ent"},
	returns = {"TrRes"},
	realm = "Shared",
	desc=[[Runs a trace using the ent's collisionmodel between two points, returning a TraceRes Structure.[TrDat] is the Trace Structure,
	[Ent] is the entity to use]]
},"util",_,_)

LUABEE.CatalogFunction({-- %%%Bobble
	name="util.TraceEntityHull",
	args = {"Ent","Ent"},
	returns = {"TrRes"},
	realm = "Shared",
	desc=[[Traces from one entity to another.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TraceHull",
	args = {"TrDat"},
	returns = {"TrRes"},
	realm = "Shared",
	desc=[[Performs a hull trace with the given [TrDat]trace data.Returns [TrRes] traceresults in a table. ]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TraceLine",
	args = {"TrDat"},
	returns = {"TrRes"},
	realm = "Shared",
	desc=[[The engine will test for objects that block the path of an imaginary point moving in a straight line from StartPos to EndPos,
	and will return [TrRes]information about said collisions. This is referred to as a trace.]]
},"util",_,_)

LUABEE.CatalogFunction({
	name="util.TypeToString",
	args = {"Input"},
	returns = {"Str"},
	realm = "Shared",
	desc=[[Converts a type to a (nice, but still parsable) [Str]string. ]]
},"util",_,_)
