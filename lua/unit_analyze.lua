-- << unit_analyze

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"
local split_comma = creepwars_split_comma
local creepwars_creep_lvl_max = creepwars_creep_lvl_max
local creepwars_copy_array = creepwars_copy_array
local creepwars_copy_table = creepwars_copy_table
local creepwars_array_to_set = creepwars_array_to_set
local creepwars_set_concat = creepwars_set_concat
local creepwars_array_filter = creepwars_array_filter

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


local function super_leader_strength(unit_name)
	local specials = count_specials(unit_name)
	local type = wesnoth.unit_types[unit_name]
	local abilities = creepwars_array_to_set(type.abilities)
	local result = type.cost * 10
	--result = result / math.sqrt(type.max_hitpoints)
	result = result / (4 + type.max_moves)
	--if #type.advances_to == 0 then result = result * (0.1 + type.level) end
	if specials["heal_on_hit"] then result = result * 1.20 end
	if specials["slow"] then result = result * 1.25 end
	if specials["poison"] then result = result * 0.70 end
	if specials["firststrike"] then result = result * 0.90 end
	if specials["chance_to_hit"] then result = result * (0.5 + specials["chance_to_hit"] / 100) end
	if specials["damage"] then result = result * 1.30 end
	if specials["plague"] then result = result * 1.05 end
	if abilities["skirmisher"] then result = result * 1.15 end
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


local function filter_plague_array(arr)
	return creepwars_array_filter(arr, function(unit) return count_specials(unit)["plague"] == nil end)
end


local recruitable_set = {}
local recruitable_array = {}
if wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10") then
	recruitable_array = {
		"Peasant", "Woodsman", "Ruffian", "Goblin Spearman", "Vampire Bat", -- lvl0 without zombie
		"Drake Burner", "Drake Clasher", "Drake Fighter", "Drake Glider", "Saurian Augur", "Saurian Skirmisher", -- lvl1 drakes
		"Dwarvish Fighter", "Dwarvish Guardsman", "Dwarvish Thunderer", "Dwarvish Ulfserker", "Gryphon Rider", "Footpad", "Poacher", "Thief", -- lvl1 knalgan
		"Bowman", "Cavalryman", "Fencer", "Heavy Infantryman", "Horseman", "Mage", "Merman Fighter", "Spearman", -- lvl1 loyal
		"Naga Fighter", "Orcish Archer", "Orcish Assassin", "Orcish Grunt", "Troll Whelp", "Wolf Rider", -- lvl1 orc
		"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman", "Mage", "Merman Hunter", "Wose", -- lvl1 rebels
		"Dark Adept", "Ghost", "Ghoul", "Skeleton Archer", "Skeleton" -- lvl1 undead
	}
	recruitable_set = creepwars_array_to_set(recruitable_array)
else
	-- recruitables
	for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
		local recruit_str = multiplayer_side.recruit or ""
		local leader_str = "" -- multiplayer_side.leader or ""
		local all_units_string = recruit_str .. "," .. leader_str
		-- print("iterating over multiplayer_side, units: " .. all_units_string)
		for _, unit in ipairs(split_comma(all_units_string)) do
			if recruitable_set[unit] == nil then
				-- print("importing era unit " .. unit)
				recruitable_set[unit] = true
				recruitable_array[#recruitable_array + 1] = unit
			end
		end
	end

	if #recruitable_array == 0 then error("fail to start game, no creeps found") end
end

local creep_array = creepwars_copy_array(recruitable_array)
local creep_set = creepwars_copy_table(recruitable_set)
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
	recruitable_array = creepwars_array_filter(recruitable_array,
		function(unit) return count_specials(unit)["plague"] == nil and count_specials(unit)["berserk"] == nil end)
	recruitable_set = creepwars_array_to_set(recruitable_array)
end

-- add downgrades
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
	for _, unit in ipairs(creep_array) do
		for _, down in ipairs(wesnoth.unit_types[unit].advances_from) do
			if creep_set[down] == nil then
				-- print("adding creep downgrade " .. down)
				creep_set[down] = true
				creep_array[#creep_array + 1] = down
			end
		end
	end
end
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
	creep_array = filter_plague_array(creep_array)
	creep_set = creepwars_array_to_set(creep_array)
end


-- add advances
for _, unit in ipairs(creep_array) do
	for _, adv in ipairs(split_comma(wesnoth.unit_types[unit].__cfg.advances_to)) do
		if creep_set[adv] == nil and wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max then
			-- print("adding creep advance " .. adv)
			creep_set[adv] = true
			creep_array[#creep_array + 1] = adv
		end
	end
end


local leader_strength = {}
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
	for _, unit in ipairs(recruitable_array) do
		local arr = { unit }
		local set = { unit = true }
		local maximum = 0
		for _, candidate in ipairs(arr) do
			local candidate_strength = super_leader_strength(candidate)
			if candidate_strength > maximum then maximum = candidate_strength end
			for _, adv in ipairs(split_comma(wesnoth.unit_types[unit].__cfg.advances_to)) do
				if set[adv] == nil then
					set[adv] = true
					arr[#arr + 1] = adv
				end
			end
		end

		local result = math.pow(base_leader_strength(unit), 1 / 2) * math.pow(maximum, 1 / 2)
		print("leader " .. unit .. ": " .. result)
		leader_strength[unit] = result
	end
	for _, unit in ipairs(creep_array) do
		print("super-leader " .. unit .. ": " .. super_leader_strength(unit))
	end
end


creepwars_creep_array = creep_array
creepwars_recruitable_array = recruitable_array
creepwars_leader_strength = leader_strength

-- >>
