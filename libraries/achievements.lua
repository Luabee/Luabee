
LUABEE.AddLibrary("achievements", Color(200,200,0))

LUABEE.CatalogFunction({
	name="achievements.BalloonPopped",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a balloon has popped.
	Running this adds 1 to the "Popper" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.Count",
	args = {},
	returns = {"Amt"},
	realm = "Client",
	desc=[[Returns the amount [Amt] of achievements as a number.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.EatBall",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a ball has been eaten.
	Running this adds 1 to the "Ball Eater" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.GetCount",
	args = {"ID"},
	returns = {"Prog"},
	realm = "Client",
	desc=[[Tells the progress [Prog] of an achievement with id [ID].
	achievements.GetGoal is used to get the needed amount.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.GetGoal",
	args = {"ID"},
	returns = {"Max"},
	realm = "Client",
	desc=[[Tells the needed amount [Max] of an achievement with id [ID].
	achievements.GetCount is used to get the current progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.GetName",
	args = {"ID"},
	returns = {"Name"},
	realm = "Client",
	desc=[[Gives the name of an achievement with id [ID].]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.IncBaddies",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that an enemy NPC has been killed.
	Running this adds 1 to the "War Zone" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.IncBystander",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a neutral NPC has been killed.
	Running this adds 1 to the "Innocent Bystander" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.IncGoodies",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that an ally NPC has been killed.
	Running this adds 1 to the "Bad Friend" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.IsAchieved",
	args = {"ID"},
	returns = {"Y/N"},
	realm = "Client",
	desc=[[Returns true if the achievement with id [ID] has been achieved.
	Returns false if not.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.Remover",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a prop has been removed.
	Running this adds 1 to the "Remover" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.SpawnMenuOpen",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that the spawn menu has been opened.
	Running this adds 1 to the "Menu User" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.SpawnedNPC",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that an NPC has been spawned.
	Running this adds 1 to the "Procreator" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.SpawnedProp",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a prop has been spawned.
	Running this adds 1 to the "Creator" achievement progress.]]
},"achievements",_,_)

LUABEE.CatalogFunction({
	name="achievements.SpawnedRagdoll",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Tells the client that a ragdoll has been spawned.
	Running this adds 1 to the "Dollhouse" achievement progress.]]
},"achievements",_,_)
