-- << unit_analyze_common

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local helper = wesnoth.require("lua/helper.lua")
local array_filter = creepwars.array_filter
local array_to_set = creepwars.array_to_set
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local split_comma = creepwars.split_comma
local unit_count_specials = creepwars.unit_count_specials


local function add_advances(arr, set, filter)
	set = set or array_to_set(arr)
	filter = filter or function(adv) return true end
	for _, unit in ipairs(arr) do
		for _, adv in ipairs(creepwars.split_comma(wesnoth.unit_types[unit].__cfg.advances_to)) do
			if set[adv] == nil and wesnoth.unit_types[adv] and filter(adv) then
				set[adv] = true
				arr[#arr + 1] = adv
			end
		end
	end
end


local creep_array = {
	"Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Dwarvish Ulfserker", -- only creeps
	"Vampire Bat", -- costy lvl0, can be leader
	"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
	"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
	"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
	"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
	"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
	"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
}
add_advances(creep_array, nil, function(adv) return wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max end)


local era_array = {}
local era_set = {}
for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
	local units = multiplayer_side.recruit or multiplayer_side.leader or ""
	for _, unit in ipairs(split_comma(units)) do
		if era_set[unit] == nil and wesnoth.unit_types[unit] then
			-- print("importing era unit " .. unit)
			era_set[unit] = true
			era_array[#era_array + 1] = unit
		end
	end
end


local function unit_count_specials(unit)
	local result = {}
	for attack in helper.child_range(wesnoth.unit_types[unit].__cfg, "attack") do
		for specials in helper.child_range(attack, "specials") do
			for _, special in ipairs(specials) do
				local name = special[1]
				result[name] = (result[name] or 0) + 1
			end
		end
	end
	return result
end


-- no "plague", cannot advance to "berserk"
local function can_be_a_leader(base_unit)
	local upgrades_arr = { base_unit }
	add_advances(upgrades_arr)
	for _, adv in ipairs(upgrades_arr) do
		if unit_count_specials(adv)["berserk"] ~= nil then
			return false
		end
	end
	return unit_count_specials(base_unit)["plague"] == nil
end


local recruitable_array = array_filter(era_array, can_be_a_leader)


local downgrade_map = {}
local function unit_downgrades(unit)
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		return wesnoth.unit_types[unit].advances_from
	else
		if not next(downgrade_map) then -- init map
			for unit_name, unit_data in pairs(wesnoth.unit_types) do
				for _, adv in ipairs(creepwars.split_comma(unit_data.__cfg.advances_to)) do
					downgrade_map[adv] = downgrade_map[adv] or {}
					local arr = downgrade_map[adv]
					arr[#arr + 1] = unit_name
				end
			end
		end
		return downgrade_map[unit] or {}
	end
end


creepwars.can_be_a_leader = can_be_a_leader
creepwars.creep_array = creep_array
creepwars.recruitable_array = recruitable_array
creepwars.unit_downgrades = unit_downgrades


-- >>
