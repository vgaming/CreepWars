-- << unit_analyze_common

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local helper = wesnoth.require("lua/helper.lua")


-- all Default Era units except Ulf
local default_era_leaders = {
	"Vampire Bat", -- costy lvl0
	"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
	"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
	"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
	"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
	"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
	"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
}

local default_era_creep_base = creepwars.array_merge(default_era_leaders,
	{ "Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Dwarvish Ulfserker" })


local function add_advances(arr, set, filter)
	set = set or creepwars.array_to_set(arr)
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


local function unit_count_specials(unit)
	local result = {}
	for attack in helper.child_range(wesnoth.unit_types[unit].__cfg, "attack") do
		for specials in helper.child_range(attack, "specials") do
			for _, special in ipairs(specials) do
				local name = special[1]
				if name == "chance_to_hit" then
					result[name] = special[2]["value"]
				else
					result[name] = (result[name] or 0) + 1
				end
			end
		end
	end
	return result
end


local function unit_count_abilities(unit)
	local result = {}
	for abilities_tag in helper.child_range(wesnoth.unit_types[unit].__cfg, "abilities") do
		for _, ability in ipairs(abilities_tag) do
			result[ability[1]] = true
		end
	end
	return result
end


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


local function add_downgrades(arr, set, filter)
	filter = filter or function(adv) return true end
	for _, unit in ipairs(arr) do
		for _, downgrade in ipairs(unit_downgrades(unit)) do
			if set[downgrade] == nil and wesnoth.unit_types[downgrade] and filter(downgrade) then
				set[downgrade] = true
				arr[#arr + 1] = downgrade
			end
		end
	end
end


creepwars.add_advances = add_advances
creepwars.add_downgrades = add_downgrades
creepwars.default_era_creep_base = default_era_creep_base
creepwars.default_era_leaders = default_era_leaders
creepwars.unit_count_abilities = unit_count_abilities
creepwars.unit_count_specials = unit_count_specials
creepwars.unit_downgrades = unit_downgrades


-- >>
