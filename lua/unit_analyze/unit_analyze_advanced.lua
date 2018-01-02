-- << unit_analyze_advanced

local wesnoth = wesnoth
local creepwars = creepwars
local helper = wesnoth.require "lua/helper.lua"
local ipairs = ipairs
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local creepwars_default_era_creeps = creepwars_default_era_creeps
local array_filter = creepwars.array_filter
local array_to_set = creepwars.array_to_set
local split_comma = creepwars.split_comma
local unit_count_specials = creepwars.unit_count_specials


local era_array = {}
local era_set = {}
for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
	local units = (multiplayer_side.recruit or "") .. "," .. (multiplayer_side.leader or "")
	for _, unit in ipairs(split_comma(units)) do
		if era_set[unit] == nil and wesnoth.unit_types[unit] then
			-- print("importing era unit " .. unit)
			era_set[unit] = true
			era_array[#era_array + 1] = unit
		end
	end
end
creepwars.add_downgrades(era_array, era_set)


-- lvl1, no "plague", cannot advance to "berserk"
local function can_be_a_leader(base_unit, ignore_level)
	local arr = { base_unit }
	creepwars.add_advances(arr)
	for _, adv in ipairs(arr) do
		if unit_count_specials(adv)["berserk"] ~= nil then
			return false
		end
	end
	return unit_count_specials(base_unit)["plague"] == nil
		and (ignore_level or wesnoth.unit_types[base_unit].level == 1)
end


local leader_array = array_filter(era_array, can_be_a_leader)


local creep_array
if creepwars_default_era_creeps then
	creep_array = creepwars.array_copy(creepwars.default_era_creep_base)
else
	creep_array = era_array
end


-- add advances
local creep_set = array_to_set(creep_array)
creepwars.add_advances(creep_array, creep_set, function(adv) return wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max end)


-- make sure lvl0 exists
do
	local lvl0_exists = false
	for _, v in ipairs(creep_array) do
		if wesnoth.unit_types[v].level == 0 then lvl0_exists = true; break end
	end
	if not lvl0_exists then
		wesnoth.message("Creep Wars", "Could not find any lvl0 units in your era, using default lvl0 creeps instead")
		local add_array = { "Peasant", "Woodsman", "Ruffian", "Goblin Spearman" }
		for _, add in ipairs(add_array) do
			creep_set[add] = true
			creep_array[#creep_array + 1] = add
		end
	end
end


creep_array = array_filter(creep_array, function(unit)
	return wesnoth.unit_types[unit].level > 0 or unit_count_specials(unit)["plague"] == nil
end)


creepwars.creep_array = creep_array
creepwars.recruitable_array = leader_array
creepwars.can_be_a_leader = can_be_a_leader

-- >>
