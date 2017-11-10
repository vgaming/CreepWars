-- << do_creep_respawn.lua

local wesnoth = wesnoth
local gen_creep = creepwars_generate_creep
local memoize_ai_side_set = creepwars_memoize_ai_side_set
local memoize_starting_positions = creepwars_memoize_starting_positions
local creepwars_kills_to_cost = creepwars_kills_to_cost
local creepwars_side_to_team = creepwars_side_to_team

local side_number = wesnoth.get_variable("side_number")

if memoize_ai_side_set[side_number] and not wesnoth.sides[side_number].lost then

	local team = creepwars_side_to_team[side_number]
	local kills = wesnoth.get_variable("creepwars_kills_" .. team)

	local creeps_max = 10
	local creeps_count_before = #wesnoth.get_units { side = side_number } -- wesnoth-1.13+ wesnoth.sides[side].num_units

	print("current creeps: " .. creeps_count_before .. ", max: " .. creeps_max)

	for i = creeps_count_before + 1, creeps_max do
		local unit = gen_creep(creepwars_kills_to_cost(kills))
		unit.side = side_number
		local x, y = wesnoth.find_vacant_tile(
			memoize_starting_positions[side_number].x,
			memoize_starting_positions[side_number].y, unit
		)
		wesnoth.put_unit(x, y, unit)
	end
end

-- >>
