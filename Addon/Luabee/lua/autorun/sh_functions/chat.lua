
LUABEE.AddLibrary("chat", Color(0,190,140))

LUABEE.CatalogFunction({
	name="chat.AddText",
	args = {"info"},
	returns = {},
	realm = "Client",
	expanding = 1,
	desc=[[Puts text into the chat box.
	[info] is a reflexive argument. It functions as such:
		If the argument is a Color:
			Any subsequent text will be that color.
		If the argument is a string:
			Puts the string into the message.
		If the argument is a player:
			Puts the name of the player into the message.
		For all other types:
			The argument is changed to a string and inserted.
	The block expands as you add more arguments.]]
},"chat",_,_)

LUABEE.CatalogFunction({
	name="chat.GetChatBoxPos",
	args = {},
	returns = {"x", "y"},
	realm = "Client",
	desc=[[Returns the chat box's position.
	Useful for attaching elements to the chatbox.]]
},"chat",_,_)

LUABEE.CatalogFunction({
	name="chat.PlaySound",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Plays the chat "tick" sound.
	This sound plays automatically when you do chat.AddText]]
},"chat",_,_)
