-- << unit_analyze_wesnoth13

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"
local ipairs = ipairs
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local creepwars_default_era_creeps = creepwars_default_era_creeps
local array_filter = creepwars.array_filter
local array_to_set = creepwars.array_to_set
local split_comma = creepwars.split_comma


local function count_specials(unit)
	local result = {}
	for _, attack in ipairs(wesnoth.unit_types[unit].attacks) do
		for _, special in ipairs(attack.specials) do
			local name = special[1]
			if name == "chance_to_hit" then
				result[name] = special[2]["value"]
			else
				result[name] = (result[name] or 0) + 1
			end
		end
	end
	return result
end


local function add_advances(arr, set, filter)
	filter = filter or function(adv) return true end
	for _, unit in ipairs(arr) do
		for _, adv in ipairs(wesnoth.unit_types[unit].advances_to) do
			if set[adv] == nil and wesnoth.unit_types[adv] and filter(adv) then
				set[adv] = true
				arr[#arr + 1] = adv
			end
		end
	end
end

local function add_downgrades(arr, set, filter)
	filter = filter or function(adv) return true end
	for _, unit in ipairs(arr) do
		for _, downgrade in ipairs(wesnoth.unit_types[unit].advances_from) do
			if set[downgrade] == nil and wesnoth.unit_types[downgrade] and filter(downgrade) then
				set[downgrade] = true
				arr[#arr + 1] = downgrade
			end
		end
	end
end


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
add_downgrades(era_array, era_set)

-- only lvl1, no "plague", cannot advance to "berserk"
local leader_array = array_filter(era_array, function(base_unit)
	local arr = { base_unit }
	add_advances(arr, { base_unit = true })
	for _, adv in ipairs(arr) do
		if count_specials(adv)["berserk"] ~= nil then
			return false
		end
	end
	return wesnoth.unit_types[base_unit].level == 1 and count_specials(base_unit)["plague"] == nil
end)


local creep_array
if creepwars_default_era_creeps then
	creep_array = {
		"Peasant", "Woodsman", "Ruffian", "Goblin Spearman", -- lvl0
		"Vampire Bat", -- costy lvl0
		"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
		"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Dwarvish Ulfserker", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
		"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
		"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
		"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
		"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
	}
else
	creep_array = era_array
end


-- add advances
local creep_set = array_to_set(creep_array)
add_advances(creep_array, creep_set, function(adv) return wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max end)


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
	return wesnoth.unit_types[unit].level > 0 or count_specials(unit)["plague"] == nil
end)


local function super_leader_strength(unit_name)
	local type = wesnoth.unit_types[unit_name]
	local specials = count_specials(unit_name)
	local abilities = array_to_set(type.abilities)
	local result = type.cost
	if #type.advances_to > 0 then result = result * 0.001 end
	--result = result / math.sqrt(type.max_hitpoints)
	result = result / (6 + type.max_moves)
	result = result * (1 + type.level)
	if specials["heal_on_hit"] then result = result * 1.20 end
	if specials["slow"] then result = result * 1.25 end
	if specials["poison"] then result = result * 0.80 end
	if specials["firststrike"] then result = result * 0.90 end
	if specials["chance_to_hit"] then result = result * (0.5 + specials["chance_to_hit"] / 100) end
	if specials["damage"] then result = result * 1.40 end
	if specials["plague"] then result = result * 1.00 end
	if abilities["skirmisher"] then result = result * 1.10 end
	if abilities["heals"] then result = result * 0.7 end
	if abilities["regenerate"] then result = result * 0.80 end
	if abilities["leadership"] then result = result * 0.9 end
	if abilities["illuminates"] then result = result * 0.90 end
	if abilities["teleport"] then result = result * 0.85 end
	if abilities["hides"] then result = result * 0.95 end
	return result
end


local function base_leader_strength(unit_name)
	local type = wesnoth.unit_types[unit_name]
	return type.cost * (14 + type.max_hitpoints / 2) / type.max_hitpoints
end


local leader_strength = {}
for _, unit in ipairs(leader_array) do
	local arr = { unit }
	add_advances(arr, { unit = true })
	local maximum = -1
	for _, candidate in ipairs(arr) do
		local candidate_strength = super_leader_strength(candidate)
		if candidate_strength > maximum then maximum = candidate_strength end
	end

	local type = wesnoth.unit_types[unit]
	local hitpoints_multiplier = (14 + type.max_hitpoints / 2) / type.max_hitpoints
	local result = math.pow(hitpoints_multiplier, 1 / 4)
		* math.pow(base_leader_strength(unit), 1 / 4)
		* math.pow(maximum, 1 / 2)
	leader_strength[unit] = result
	-- print("leader " .. unit .. ": " .. result)
end
for _, unit in ipairs(creep_array) do
	-- print("super-leader " .. unit .. ": " .. super_leader_strength(unit))
end


creepwars.creep_array = creep_array
creepwars.leader_strength = leader_strength
creepwars.recruitable_array = leader_array

-- >>
