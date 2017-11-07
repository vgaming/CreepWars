-- << random_creep.lua  wesnoth preprocessor escape characters

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"

local creep_set = {}
--wesnoth-1.13:
--for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
--	local recruits = multiplayer_side.recruit
--	if recruits then
--		for recr in string.gmatch(recruits, "[^,]+") do
--			--print("importing era unit " .. recr)
--			creep_set[recr] = true
--		end
--	end
--end

if next(creep_set) == nil then
	-- wesnoth-1.12 work-around (it gives no access to faction recruits)
	local creep_array = {
		"Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Vampire Bat", -- lvl0 without zombie
		"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
		"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Dwarvish Ulfserker", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
		"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
		"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
		"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
		"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
	}
	for _, v in ipairs(creep_array) do
		creep_set[v] = true
		--print("importing default unit " .. v)
		if wesnoth.unit_types[v] == nil then error("Unit name typo: " .. v) end -- check typos
	end
else
	-- add lvl 0 creeps (downgrades)
	--[[ poor performance
	for unit_name, _ in pairs(wesnoth.unit_types) do
		if wesnoth.unit_types[unit_name].level == 0 then
			for _, adv in pairs(split_comma(wesnoth.unit_types[unit_name].__cfg.advances_to)) do
				if creep_set[adv] then
					creep_set[unit_name] = true
				end
			end
		end
	end
	if not creep_set["Woodsman"] then error("Woodsman not found.") end
	--]]
end


-- helper
local function split_comma(str)
	local result = {}
	local n = 1
	for s in string.gmatch(str, "[^,]+") do
		result[n] = s
		n = n + 1
	end
	return result
end


local function recursive_enrich_creeps(creep_name)
	local advances_string = wesnoth.unit_types[creep_name].__cfg.advances_to
	if advances_string ~= "null" and advances_string ~= creep_name then
		for _, adv in pairs(split_comma(advances_string)) do
			if creep_set[adv] == nil then
				-- print("adding creep advance " .. adv)
				creep_set[adv] = true
				recursive_enrich_creeps(adv)
			end
		end
	end
end

do
	-- we can't iterate over mutable set, so we need to copy it
	local arr = {}
	local n = 1
	for creep_name, _ in pairs(creep_set) do
		arr[n] = creep_name
		n = n + 1
	end
	for _, creep_name in ipairs(arr) do
		recursive_enrich_creeps(creep_name)
	end
end
if not creep_set["Elvish Sylph"] then error("Sylph not found") end
if not creep_set["Cavalier"] then error("Cavalier not found") end


local creep_array = {}
do
	local n = 1
	for creep_name, _ in pairs(creep_set) do
		creep_array[n] = creep_name
		n = n + 1
	end
	creep_set = nil
end
table.sort(creep_array)
local creep_rand_string = "1.." .. #creep_array


local function generate(desired_cost)
	local function rand_creep() return creep_array[helper.rand(creep_rand_string)] end

	local desired_closeness = (helper.rand("1..100") + helper.rand("1..100")) / 1000

	local closeness_step = 1 / 100 -- widen acceptable range over time
	local iterations = 0
	local creep_type
	repeat
		iterations = iterations + 1
		desired_closeness = desired_closeness + closeness_step
		 creep_type = rand_creep()
		local creep_cost = wesnoth.unit_types[creep_type].cost
		local diff = math.abs(creep_cost - desired_cost) / (creep_cost + desired_cost) -- a cost ratio of 1:2 gives diff 0.333333
	-- print("creep type is: " .. creep_type .. " (" .. creep_cost .. "), diff: " .. diff .. ", desired_closeness: " .. desired_closeness)
	until diff < desired_closeness
	local u = wesnoth.create_unit { type = creep_type, upkeep = 0 }

	local boost = math.floor((desired_cost - u.__cfg.cost) / 9)
	if boost > 0 then
		wesnoth.add_modification(u, "object", {
			{ "effect", { apply_to = "attack", increase_damage = boost * 2 } },
			{ "effect", { apply_to = "attack", increase_attacks = boost } },
			{ "effect", { apply_to = "movement", increase = boost } },
		})
	end
	wesnoth.add_modification(u, "object", { { "effect", { apply_to = "zoc", value = false } } })

	print("Good unit for cost " .. math.floor(desired_cost + 0.5) ..
		" is " .. u.__cfg.cost ..
		"g:\"" .. creep_type ..
		"\", boost: " .. boost .. ". Iterations spent: " .. iterations)
	return u
end


creepwars_generate_creep = generate

-- >>
