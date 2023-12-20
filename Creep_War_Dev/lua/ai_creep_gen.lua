-- << ai_creep_gen

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local on_event = wesnoth.require("lua/on_event.lua")
local generate_creep = creepwars.generate_creep
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team
local array_filter = creepwars.array_filter

local function ai_creep_gen(current_side_object)
	local current_side = current_side_object.side or wesnoth.current.side
	print_as_json("current side is", current_side)
	if is_ai_array[current_side] and not wesnoth.sides[current_side].lost then
		for _, unit in ipairs(wesnoth.get_units { side = current_side, canrecruit = true }) do
			wesnoth.add_modification(unit, "object", { T.effect { apply_to = "movement", set = 0 } })
			unit.moves = 0
		end

		local team = side_to_team[current_side]
		local creep_score = wesnoth.get_variable("creepwars_score_" .. team)

		local side_units = wesnoth.get_units { side = current_side, canrecruit = false }
		local creeps_count_before = #array_filter(side_units,
			function(unit) return unit.variables["creepwars_creep"] end)

		local start_loc = wesnoth.get_starting_location(current_side)
		-- print("side", current_side, "loc", creepwars.format(start_loc), "current creeps", creeps_count_before)

		for _ = creeps_count_before + 1, creepwars.creep_count do
			local unit = generate_creep(creep_score)
			unit.side = current_side
			local x, y = wesnoth.find_vacant_tile(start_loc[1], start_loc[2], unit)
			wesnoth.put_unit(unit, x, y)
		end
	end
end

on_event("start", function ()
	ai_creep_gen({ side = 4})
	ai_creep_gen({ side = 8})
end)

--- Give score per turn. It's important that "side 1 turn" is triggered before "turn refresh",
--- as documented here: https://wiki.wesnoth.org/EventWML#side_X_turn
on_event("side 1 turn", function(current_side_object)
	local turn = current_side_object.turn or wesnoth.current.turn
	if turn > 1 then
		for team_id, _ in ipairs(creepwars.team_array) do
			creepwars.increase_score_for_team(team_id, creepwars.score_per_turn)
		end
	end
end)

on_event("turn refresh", ai_creep_gen)

-- Give gold each AI turn
on_event("turn refresh", function(current_side_object)
	local current_side = current_side_object.side or wesnoth.current.side
	if is_ai_array[current_side] and not wesnoth.sides[current_side].lost then
		for team_id, _ in ipairs(creepwars.team_array) do
			creepwars.increase_gold_for_team(team_id, creepwars.gold_per_ai_turn)
		end
	end

end)

-- >>
