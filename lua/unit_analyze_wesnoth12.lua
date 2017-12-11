-- << unit_analyze_wesnoth12

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"
local creepwars_array_merge = creepwars_array_merge
local creepwars_array_to_set = creepwars_array_to_set
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local split_comma = creepwars_split_comma


local leader_array = {
	-- all Default Era units except Ulf
	"Vampire Bat", -- costy lvl0
	"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
	"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
	"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
	"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
	"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
	"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
}
local creep_array = creepwars_array_merge(leader_array,
	{ "Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Dwarvish Ulfserker" })


local function add_advances(arr, set)
	for _, unit in ipairs(arr) do
		for _, adv in ipairs(split_comma(wesnoth.unit_types[unit].__cfg.advances_to)) do
			if set[adv] == nil and wesnoth.unit_types[adv] and wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max then
				-- print("adding creep advance " .. adv)
				set[adv] = true
				arr[#arr + 1] = adv
			end
		end
	end
end

add_advances(creep_array, creepwars_array_to_set(creep_array))


local leader_strength = {}
for _, unit in ipairs(leader_array) do
	local type = wesnoth.unit_types[unit]
	leader_strength[unit] = type.cost * (14 + type.max_hitpoints / 2) / type.max_hitpoints
end


creepwars_creep_array = creep_array
creepwars_recruitable_array = leader_array
creepwars_leader_strength = leader_strength

-- >>
