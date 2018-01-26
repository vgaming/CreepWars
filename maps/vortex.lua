-- << vortex

creepwars = {}
local creepwars = creepwars
local wesnoth = wesnoth
local helper = wesnoth.require("lua/helper.lua")


creepwars.scoreboard_pos = { { x = 17, y = 1 }, { x = 19, y = 1 } }
creepwars.mirror_style_label_pos = { x = 34, y = 2 }
creepwars.shop_coordinates = {
	{ { 8, 6 }, { 8, 8 }, },
	{ { 28, 6 }, { 28, 8 }, },
}


local vortex_chance = 25
local pos = { x = 18, y = 7 }


creepwars.vortex_start = function()
	wesnoth.wml_actions.item { x = 18, y = 7, image = "items/bones.png" }

	wesnoth.wml_actions.message {
		speaker = "narrator",
		message = "There is a <b>Vortex</b> on the center of the map.\n\n"
			.. "Holding Vortex gives " .. vortex_chance .. "% chance to double gold bonus for each kill by allied sides.\n"
			.. "This is roughly equivalent of " .. vortex_chance .. " increase in gold.\n\n"
			.. "The Vortex <b>changes terrain</b> when you stand on it. \n"
			.. "There is 25% probability to change to Grassland,\n"
			.. "25% probability to change to Shallow Water,\n"
			.. "25% probability to change to Sand,\n"
			.. "25% probability to change to Snow.",
		image = "terrain/sand/crater.png",
	}
	wesnoth.wml_actions.label {
		x = pos.x,
		y = pos.y,
		text = "Vortex"
	}
end


creepwars.gold_multiplier_func = function(attacker)
	local unit = wesnoth.get_unit(pos.x, pos.y)
	return unit
		and wesnoth.sides[unit.side].team_name == wesnoth.sides[attacker.side].team_name
		and helper.rand("1..100") <= vortex_chance
		and 2 or 1
end


creepwars.vortex_side_turn_end = function()
	local unit = wesnoth.get_unit(pos.x, pos.y)
	if unit and wesnoth.current.side == unit.side then
		local rand = helper.rand("1..100")
		if rand > 75 then
			wesnoth.set_terrain(pos.x, pos.y, "Gg")
		elseif rand > 50 then
			wesnoth.set_terrain(pos.x, pos.y, "Ww")
		elseif rand > 25 then
			wesnoth.set_terrain(pos.x, pos.y, "Dd")
		else
			wesnoth.set_terrain(pos.x, pos.y, "Aa")
		end
		wesnoth.wml_actions.remove_item { x = 18, y = 7, image = "items/bones.png" }
	end
end


-- >>
