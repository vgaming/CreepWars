-- << unit_analyze_wesnoth12

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local creepwars = creepwars
local creepwars_creep_lvl_max = creepwars_creep_lvl_max


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


local function can_be_a_leader(base_unit)
	-- accessing "count_specials" causes OOS, I don't know why
	-- it seems that the code that was previosly located in unit_analyze_common.lua behaves
	-- differently on different 1.12 clients.
	return true
end


creepwars.can_be_a_leader = can_be_a_leader
creepwars.creep_array = creep_array
creepwars.leader_strength = leader_strength
creepwars.recruitable_array = leader_array


-- >>
