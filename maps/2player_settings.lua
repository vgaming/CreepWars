-- << 2players_settings

local wesnoth = wesnoth
creepwars = {}
local creepwars = creepwars


creepwars.shop_coordinates = {
	{ { 8, 9 }, { 8, 11 }, }, -- { 9, 10 }, { 9, 11 },
	{ { 28, 9 }, { 28, 11 }, }, -- { 27, 10 }, { 27, 11 },
}


creepwars.mirror_style_label_pos = { x = 28, y = 17 }


local scoreboard_y = wesnoth.get_terrain(18, 5) == "Qxua^Xo" and 6 or 10
creepwars.scoreboard_pos = { { x = 17, y = scoreboard_y }, { x = 19, y = scoreboard_y } }


-- >>
