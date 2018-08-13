-- << ai_turn_refresh_creep_gen

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local generate_creep = creepwars.generate_creep
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team
local array_filter = creepwars.array_filter

local side_number = wesnoth.get_variable("side_number")

if is_ai_array[side_number] and not wesnoth.sides[side_number].lost then

	for _, unit in ipairs(wesnoth.get_units { side = side_number, canrecruit = true }) do
		wesnoth.add_modification(unit, "object", { T.effect { apply_to = "movement", set = 0 } })
		unit.moves = 0
	end

	local team = side_to_team[side_number]
	local creep_score = wesnoth.get_variable("creepwars_score_" .. team)

	local side_units = wesnoth.get_units { side = side_number, canrecruit = false }
	local creeps_count_before = #array_filter(side_units,
		function(unit) return unit.variables["creepwars_creep"] end)

	local start_loc = wesnoth.get_starting_location(side_number)
	-- print("side", side_number, "loc", creepwars.format(start_loc), "current creeps", creeps_count_before)

	for _ = creeps_count_before + 1, creepwars.creep_count do
		local unit = generate_creep(creep_score)
		unit.side = side_number
		local x, y = wesnoth.find_vacant_tile(start_loc[1], start_loc[2], unit)
		wesnoth.put_unit(unit, x, y)
	end
end

-- >>
