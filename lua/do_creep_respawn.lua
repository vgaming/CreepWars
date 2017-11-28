-- << do_creep_respawn

local wesnoth = wesnoth
local gen_creep = creepwars_generate_creep
local memoize_ai_side_set = creepwars_memoize_ai_side_set
local memoize_starting_positions = creepwars_memoize_starting_positions
local creepwars_side_to_team = creepwars_side_to_team
local creepwars_creep_count = creepwars_creep_count

local side_number = wesnoth.get_variable("side_number")

if memoize_ai_side_set[side_number] and not wesnoth.sides[side_number].lost then

	local team = creepwars_side_to_team[side_number]
	local creep_score = wesnoth.get_variable("creepwars_creep_score_" .. team)

	local creeps_count_before = #wesnoth.get_units { side = side_number, canrecruit = false }

	print("current creeps: " .. creeps_count_before .. ", max: " .. creepwars_creep_count)

	for i = creeps_count_before + 1, creepwars_creep_count do
		local unit = gen_creep(creep_score)
		unit.side = side_number
		local x, y = wesnoth.find_vacant_tile(
			memoize_starting_positions[side_number].x,
			memoize_starting_positions[side_number].y, unit
		)
		if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
			wesnoth.put_unit(unit, x, y)
		else
			wesnoth.put_unit(x, y, unit)
		end
	end
end

-- >>
