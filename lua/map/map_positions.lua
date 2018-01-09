-- << map_positions

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs


--- All constants are currently inlined here.
--- In future, the map should be analyzed and those pos should be calculated depending on map.


local spawn_pos = {
	[1] = { x = 4, y = 10 },
	[2] = { x = 32, y = 10 }
}


local scoreboard_y = wesnoth.get_terrain(18, 5) == "Qxua^Xo" and 6 or 10
local scoreboard_pos = { { x = 17, y = scoreboard_y }, { x = 19, y = scoreboard_y } }


local mirror_style_label_pos = { x = 28, y = 17 }


creepwars.mirror_style_label_pos = mirror_style_label_pos
creepwars.scoreboard_pos = scoreboard_pos
creepwars.spawn_pos = spawn_pos


-- >>
