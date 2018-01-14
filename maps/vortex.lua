-- << vortex

creepwars = {}
local creepwars = creepwars
local wesnoth = wesnoth
local ipairs = ipairs
local helper = wesnoth.require "lua/helper.lua"


creepwars.scoreboard_pos = { { x = 17, y = 1 }, { x = 19, y = 1 } }
creepwars.mirror_style_label_pos = { x = 34, y = 2 }
creepwars.scoreboard_help_label = { x = 34, y = 3 }
creepwars.shop_coordinates = {
	{ { 8, 6 }, { 8, 8 }, },
	{ { 28, 6 }, { 28, 8 }, },
}

creepwars.vortex_event_start = function()
	wesnoth.wml_actions.item { x = 18, y = 7, image = "items/bones.png" }
	--wesnoth.wml_actions.item { x = 18, y = 7, image = "scenery/circle-magic-glow.png~SCALE(72,72)" }

	wesnoth.wml_actions.message {
		speaker = "narrator",
		message = "There is a <b>Vortex</b> on the center of the map.\n\n"
			.. "If you stand on a Vortex at the beginning of your turn, \n"
			.. "all allied sides will get additional <b>gold</b>.\n"
			.. "First turn on a Vortex gives 3 gold, next turn 4 gold, next turn 5 gold, etc.\n\n"
			.. "The Vortex <b>changes terrain</b> when you stand on it. \n"
			.. "There is 30% probability to change to Grassland,\n"
			.. "30% probability to change to Shallow Water,\n"
			.. "30% probability to change to Sand,\n"
			.. "and 10% probability to change to Snow.",
		--		image = "scenery/circle-magic-glow.png",
		image = "terrain/sand/crater.png",
	}
end


local pos = { x = 18, y = 7 }
local previous_side = 0
local turns_on_vortex = 0
creepwars.vortex_side_turn = function()
	local unit = wesnoth.get_unit(pos.x, pos.y)
	local new_side = unit and unit.side or 0
	print("new_side", new_side)

	if wesnoth.current.side == new_side and new_side == previous_side and new_side > 0 then
		for _, ally_side in ipairs(wesnoth.sides) do
			if ally_side.team_name == wesnoth.sides[new_side].team_name then
				ally_side.gold = ally_side.gold + 3 + turns_on_vortex
			end
		end
		turns_on_vortex = turns_on_vortex + 1
	end
end
creepwars.vortex_side_turn_end = function()
	local unit = wesnoth.get_unit(pos.x, pos.y)
	local new_side = unit and unit.side or 0
	if new_side ~= previous_side then
		turns_on_vortex = 0
	end
	if wesnoth.current.side == new_side then
		local rand = helper.rand("1..100")
		if rand > 70 then
			wesnoth.set_terrain(pos.x, pos.y, "Gg")
		elseif rand > 40 then
			wesnoth.set_terrain(pos.x, pos.y, "Ww")
		elseif rand > 10 then
			wesnoth.set_terrain(pos.x, pos.y, "Dd")
		else
			wesnoth.set_terrain(pos.x, pos.y, "Aa")
		end
	end
	wesnoth.wml_actions.label {
		x = pos.x,
		y = pos.y,
		text = "Vortex " .. (turns_on_vortex > 0 and turns_on_vortex or "")
	}
	previous_side = new_side
end


-- >>
