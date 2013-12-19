
LUABEE.AddLibrary("draw", Color(127,219,66))

LUABEE.CatalogFunction({
	name="draw.DrawText",
	args = {"text","font","x","y", "col", "align"},
	returns = {},
	realm = "Client",
	desc=[[Draws simple text with the given arguments.
	[text] is the text to draw.
	[font] is the font to use on the text.
	[x] is the x position.
	[y] is the y position.
	[col] is the color of the text.
	[align] is the align enumeration. (TEXT_ALIGN_ENUM) ]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.GetFontHeight",
	args = {"font"},
	returns = {"h"},
	realm = "Client",
	desc=[[Returns the height of a font.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.NoTexture",
	args = {},
	returns = {},
	realm = "Client",
	desc=[[Clears the texture and color palette.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.RoundedBox",
	args = {"r","x","y","w","h","col"},
	returns = {},
	realm = "Client",
	desc=[[Draws simple text with the given arguments.
	[r] is the radius of the corners. Should be an even number.
	[x] is the x position.
	[y] is the y position.
	[w] is the width.
	[h] is the height.
	[col] is the color of the box.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.RoundedBoxEx",
	args = {"r","x","y","w","h","col","tl","tr", "bl","br"},
	returns = {},
	realm = "Client",
	desc=[[Draws simple text with the given arguments.
	[r] is the radius of the corners. Should be an even number.
	[x] is the x position.
	[y] is the y position.
	[w] is the width.
	[h] is the height.
	[col] is the color of the box.
	
	[tl], [tr], [bl], and [br] are boolean.
	t means top, b means bottom, l means left and r means right.
	If tl is true, for example, then the top left corner will be round.
	If tl is false, however, then it will be squared on the top left.
	With this you can make boxes with 1, 2, and 3 rounded corners.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.SimpleText",
	args = {"text","font","x","y", "col", "xalign", "yalign"},
	returns = {},
	realm = "Client",
	desc=[[Draws simple text with the given arguments.
	[text] is the text to draw.
	[font] is the font to use on the text.
	[x] is the x position.
	[y] is the y position.
	[col] is the color of the text.
	[xalign] is the x align enumeration. (TEXT_ALIGN_ENUM)
	[yalign] is the y align enumeration. (TEXT_ALIGN_ENUM)
	
	The difference between draw.SimpleText and draw.DrawText is yalign.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.Text",
	args = {"tbl"},
	returns = {"w","h"},
	realm = "Client",
	desc=[[Draws simple text based on a table of information.
	
	[tbl] is a table containing several fields:
	tbl.text is the text to draw.
	tbl.font is the font to use on the text.
	
	tbl.pos is a table:
	tbl.pos[1] is the x position.
	tbl.pos[2] is the y position.
	
	tbl.color is the color of the text.
	tbl.xalign is the x align enumeration. (TEXT_ALIGN_ENUM)
	tbl.yalign is the y align enumeration. (TEXT_ALIGN_ENUM)
	
	Create a table, add your keys and values to it, and use it as the arg.
	
	Returns the [w]idth and [h]eight of the text.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.TextShadow",
	args = {"tbl", "dist", "a"},
	returns = {"w", "h"},
	realm = "Client",
	desc=[[Draws shadowed text based on a table of information.
	
	[tbl] is a table containing several fields:
	tbl.text is the text to draw.
	tbl.font is the font to use on the text.
	
	tbl.pos is a table:
	tbl.pos[1] is the x position.
	tbl.pos[2] is the y position.
	
	tbl.color is the color of the text.
	tbl.xalign is the x align enumeration. (TEXT_ALIGN_ENUM)
	tbl.yalign is the y align enumeration. (TEXT_ALIGN_ENUM)
	
	Create a table, add your keys and values to it, and use it as the first arg.
	
	[dist] is the distance to drop the shadow.
	[a] is the transparency (or alpha) of the shadow.
	
	Returns the [w]idth and [h]eight of the text.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.TexturedQuad",
	args = {"tbl"},
	returns = {},
	realm = "Client",
	desc=[[Draws an image based on a table of information.
	
	[tbl] is a table containing several fields:
	tbl.x is the x position.
	tbl.y is the y position.
	tbl.w is the width.
	tbl.h is the height.
	tbl.color is the color.
	tbl.texture is the texture ID to use.
	
	Create a table, add your keys and values to it, and use it as the first arg.]]
},"draw",_,_)

LUABEE.CatalogFunction({
	name="draw.WordBox",
	args = {"border","x","y","text","font","boxcol","textcol"},
	returns = {},
	realm = "Client",
	desc=[[Draws a rounded box with text inside.
	[border] is the size of the box's borders.
	[x] is the x position.
	[y] is the y position.
	[text] is the text to draw.
	[font] is the font to use on the text.
	[boxcol] is the color of the box.
	[textcol] is the color of the text.]]
},"draw",_,_)
