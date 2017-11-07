-- << do_creep_respawn.lua  wesnoth preprocessor escape characters
local wesnoth = wesnoth
local gen_creep = creepwars_generate_creep
local memoize_ai_side_set = creepwars_memoize_ai_side_set
local memoize_starting_positions = creepwars_memoize_starting_positions

local side_number = wesnoth.get_variable("side_number")

if memoize_ai_side_set[side_number] then

	local kills = wesnoth.get_variable("cw_score.kills." .. wesnoth.sides[side_number].team_name)
	--local helper = wesnoth.require "lua/helper.lua"

	local creeps_max = 10
	local creeps_count_before = #wesnoth.get_units { side = side_number } -- wesnoth-1.13+ wesnoth.sides[side].num_units

	print("current creeps: " .. creeps_count_before .. ", max: " .. creeps_max)

	for i = creeps_count_before + 1, creeps_max do
		local unit = gen_creep(7 + kills * 0.75)
		unit.side = side_number
		local x, y = wesnoth.find_vacant_tile(
			memoize_starting_positions[side_number].x,
			memoize_starting_positions[side_number].y, unit
		)
		wesnoth.put_unit(x, y, unit)
	end
end
-- >>
