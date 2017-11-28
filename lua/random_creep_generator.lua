-- << random_creep_generator.lua

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"
local split_comma = creepwars_split_comma
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier
local creepwars_creep_lvl_max = creepwars_creep_lvl_max

local creep_set = {}
local creep_array = {}
if wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10") then
	creep_array = {
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
	end
else
	-- recruitables
	for multiplayer_side in helper.child_range(wesnoth.game_config.era, "multiplayer_side") do
		local recruit_str = multiplayer_side.recruit or ""
		local leader_str = multiplayer_side.leader or ""
		local all_units_string = recruit_str .. "," .. leader_str
		print("iterating over multiplayer_side, units: " .. all_units_string)
		for unit in string.gmatch(all_units_string, "%s*[^,]+%s*") do
			if unit ~= "null" and unit ~= "" and creep_set[unit] == nil then
				print("importing era unit " .. unit)
				creep_set[unit] = true
				creep_array[#creep_array + 1] = unit
			end
		end
	end

	-- add downgrades
	for _, unit in ipairs(creep_array) do
		for _, down in ipairs(wesnoth.unit_types[unit].advances_from) do
			if creep_set[down] == nil then
				-- print("adding creep downgrade " .. down)
				creep_set[down] = true
				creep_array[#creep_array + 1] = down
			end
		end
	end

	if #creep_array == 0 then error("fail to start game, no creeps found") end
end


-- add advances
for _, unit in ipairs(creep_array) do
	local advances_string = wesnoth.unit_types[unit].__cfg.advances_to
	if advances_string ~= "null" then
		for _, adv in ipairs(split_comma(advances_string)) do
			if creep_set[adv] == nil and wesnoth.unit_types[adv].level <= creepwars_creep_lvl_max then
				-- print("adding creep advance " .. adv)
				creep_set[adv] = true
				creep_array[#creep_array + 1] = adv
			end
		end
	end
end


local creep_rand_string = "1.." .. #creep_array


local function generate(desired_cost)
	local function rand_creep() return creep_array[helper.rand(creep_rand_string)] end
	local creep_type
	local unit
	local iterations = 0
	if desired_cost < creepwars_lvl0_barrier then
		repeat
			iterations = iterations + 1
			creep_type = rand_creep()
			local u = wesnoth.unit_types[creep_type]
		until u.__cfg.level == 0 and u.__cfg.cost < 12
	elseif desired_cost < creepwars_lvl3plus_barrier then
		local desired_closeness = (helper.rand("1..100") + helper.rand("1..100")) / 200
		local closeness_step = 1 / #creep_array / 5 -- widen acceptable range over time
		repeat
			iterations = iterations + 1
			desired_closeness = desired_closeness + closeness_step
			creep_type = rand_creep()
			local creep_cost = wesnoth.unit_types[creep_type].cost
			local absolute_diff = math.abs(creep_cost - desired_cost)
			-- cost 1 : 2  => ratio 1/3 = 0.3333
			-- cost 1 : 1.1 => ratio 0.1/2.1 = 0.047619
			local ratio = math.abs(creep_cost - desired_cost) / (creep_cost + desired_cost)
			local diff = math.min(absolute_diff / 3, ratio / 0.047619) -- 3 gold diff or 10% diff
		until diff < desired_closeness
	else
		repeat
			iterations = iterations + 1
			creep_type = rand_creep()
		until wesnoth.unit_types[creep_type].level >= 3
	end

	unit = wesnoth.create_unit { type = creep_type }
	local boost = math.floor((desired_cost - unit.__cfg.cost) / 14)

	if boost > 0 then
		local ability = {
			"dummy", {
				name = "boost +" .. boost,
				description = "damage +" .. boost * 2 .. " strikes +" .. boost .. " movement +" .. boost
			}
		}
		wesnoth.add_modification(unit, "object", {
			{ "effect", { apply_to = "attack", increase_damage = boost * 2 } },
			{ "effect", { apply_to = "attack", increase_attacks = boost } },
			{ "effect", { apply_to = "movement", increase = boost } },
			{ "effect", { apply_to = "new_ability", { "abilities", { ability } } } },
		})
	end
	wesnoth.add_modification(unit, "object", {
		{ "effect", { apply_to = "zoc", value = false } },
		{ "effect", { apply_to = "loyal" } },
	})
	unit.variables["creepwars_creep"] = true

	print("Good unit for cost " .. math.floor(desired_cost + 0.5) .. " is " ..
		unit.__cfg.cost .. "gold " ..
		"lvl" .. unit.__cfg.level .. " " ..
		"'" .. creep_type .. "', boost: " .. boost .. ". Iterations spent: " .. iterations)
	return unit
end


creepwars_generate_creep = generate


-- >>
