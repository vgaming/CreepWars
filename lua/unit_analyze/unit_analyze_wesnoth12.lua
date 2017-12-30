-- << unit_analyze_wesnoth12

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local creepwars = creepwars
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local unit_count_specials = creepwars.unit_count_specials


local leader_array = creepwars.default_era_leaders


local creep_array = creepwars.default_era_creep_base

creepwars.add_advances(creep_array, nil, function(adv)
	return wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max
end)


local leader_strength = {}
for _, unit in ipairs(leader_array) do
	local type = wesnoth.unit_types[unit]
	leader_strength[unit] = type.cost * (14 + type.max_hitpoints / 2) / type.max_hitpoints
end


-- lvl1, no "plague", cannot advance to "berserk"
local function can_be_a_leader(base_unit)
	local arr = { base_unit }
	creepwars.add_advances(arr)
	for _, adv in ipairs(arr) do
		if unit_count_specials(adv)["berserk"] ~= nil then
			return false
		end
	end
	return wesnoth.unit_types[base_unit].level == 1 and unit_count_specials(base_unit)["plague"] == nil
end


creepwars.can_be_a_leader = can_be_a_leader
creepwars.creep_array = creep_array
creepwars.leader_strength = leader_strength
creepwars.recruitable_array = leader_array


-- >>
