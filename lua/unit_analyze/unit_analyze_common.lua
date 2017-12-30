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


creepwars.add_advances = add_advances
creepwars.default_era_leaders = default_era_leaders
creepwars.default_era_creep_base = default_era_creep_base


-- >>
