-- << random_creep_generator

-- This file provides function to generate Creeps with expected cost.
-- See end of file for the function itself, `creepwars_generate_creep`

local wesnoth = wesnoth
local creepwars = creepwars
local helper = wesnoth.require("lua/helper.lua")
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier
local creep_array = creepwars.creep_array


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
		until u.level == 0 and u.__cfg.cost < 12
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
	local boost = math.floor((desired_cost + 7 - unit.__cfg.cost) / 14)

	if boost > 0 then
		local boost_ability = T.name_only {
			name = "boost +" .. boost,
			description = "+" .. boost .. " movement, +" .. boost .. " strikes, +" .. boost * 2 .. " damage"
		}
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "attack", increase_damage = boost * 2 },
			T.effect { apply_to = "attack", increase_attacks = boost },
			T.effect { apply_to = "movement", increase = boost },
			T.effect { apply_to = "new_ability", T.abilities { boost_ability } },
		})
	end
	local creep_ability = T.name_only {
		name = "creep",
		description = "This is a creep unit. It has no ZoC."
			.. "Creeps are very aggressive, they only care about inflicting damage."
	}
	wesnoth.add_modification(unit, "object", {
		T.effect { apply_to = "zoc", value = false },
		T.effect { apply_to = "loyal" },
		T.effect { apply_to = "new_ability", T.abilities { creep_ability } },
	})
	unit.variables["creepwars_creep"] = true

	--print("Good unit for cost " .. math.floor(desired_cost + 0.5) .. " is " ..
	--	unit.__cfg.cost .. "gold " ..
	--	"lvl" .. unit.__cfg.level .. " " ..
	--	"'" .. creep_type .. "', boost: " .. boost .. ". Iterations spent: " .. iterations)
	return unit
end


creepwars_generate_creep = generate


-- >>
