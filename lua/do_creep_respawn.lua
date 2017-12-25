-- << do_creep_respawn

local wesnoth = wesnoth
local creepwars = creepwars
local gen_creep = creepwars_generate_creep
local ai_side_set = creepwars.ai_side_set
local side_to_team = creepwars.side_to_team
local creepwars_creep_count = creepwars_creep_count
local array_filter = creepwars.array_filter
local spawn_pos = creepwars.spawn_pos

local side_number = wesnoth.get_variable("side_number")

if ai_side_set[side_number] and not wesnoth.sides[side_number].lost then

	local team = side_to_team[side_number]
	local creep_score = wesnoth.get_variable("creepwars_score_" .. team)

	local side_units = wesnoth.get_units { side = side_number, canrecruit = false }
	local creeps_count_before = #array_filter(side_units,
		function(unit) return unit.variables["creepwars_creep"] end)

	-- print("current creeps: " .. creeps_count_before .. ", max: " .. creepwars_creep_count)

	for i = creeps_count_before + 1, creepwars_creep_count do
		local unit = gen_creep(creep_score)
		unit.side = side_number
		local x, y = wesnoth.find_vacant_tile(spawn_pos[team].x, spawn_pos[team].y, unit)
		if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
			wesnoth.put_unit(unit, x, y)
		else
			wesnoth.put_unit(x, y, unit)
		end
	end
end

-- >>
