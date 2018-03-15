--<< leader_ability

local wesnoth = wesnoth
local creepwars = creepwars
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local table = table

local function set_leader_ability()
	local side = wesnoth.get_variable("side_number")
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
		local vars = unit.variables
		local arr = {}
		if vars.creepwars_health_small > 0 then arr[#arr + 1] = vars.creepwars_health_small .. " mini hp" end
		if vars.creepwars_health_big > 0 then arr[#arr + 1] = vars.creepwars_health_big .. " HP" end
		if vars.creepwars_mp > 0 then arr[#arr + 1] = vars.creepwars_mp .. " MP" end
		if vars.creepwars_melee_damage > 0 then arr[#arr + 1] = vars.creepwars_melee_damage .. " melee dmg" end
		if vars.creepwars_melee_strikes > 0 then arr[#arr + 1] = vars.creepwars_melee_strikes .. " melee strikes" end
		if vars.creepwars_ranged_damage > 0 then arr[#arr + 1] = vars.creepwars_ranged_damage .. " range dmg" end
		if vars.creepwars_ranged_strikes > 0 then arr[#arr + 1] = vars.creepwars_ranged_strikes .. " range strikes" end
		if vars.creepwars_damage > 0 then arr[#arr + 1] = vars.creepwars_damage .. " combo dmg" end
		if vars.creepwars_strikes > 0 then arr[#arr + 1] = vars.creepwars_strikes .. " combo strikes" end
		if vars.creepwars_armor_ldc > 0 then arr[#arr + 1] = "Light Dwarven Cuirass" end
		if vars.creepwars_armor_hdc > 0 then arr[#arr + 1] = "Heavy Dwarven Cuirass" end
		if vars.creepwars_armor_hhc > 0 then arr[#arr + 1] = "Heavy Human Cuirass" end
		if vars.creepwars_armor_smr > 0 then arr[#arr + 1] = "Silver Mage Robe" end
		if vars.creepwars_armor_eb > 0 then arr[#arr + 1] = "Elven Boots" end
		if vars.creepwars_armor_pg > 0 then arr[#arr + 1] = "Plate Greaves" end
		if vars.creepwars_res_arcane > 0 then arr[#arr + 1] = vars.creepwars_res_arcane .. "0% Arcane Res" end
		if vars.creepwars_res_blade > 0 then arr[#arr + 1] = vars.creepwars_res_blade .. "0% Blade Res" end
		if vars.creepwars_res_cold > 0 then arr[#arr + 1] = vars.creepwars_res_cold .. "0% Cold Res" end
		if vars.creepwars_res_fire > 0 then arr[#arr + 1] = vars.creepwars_res_fire .. "0% Fire Res" end
		if vars.creepwars_res_impact > 0 then arr[#arr + 1] = vars.creepwars_res_impact .. "0% Impact Res" end
		if vars.creepwars_res_pierce > 0 then arr[#arr + 1] = vars.creepwars_res_pierce .. "0% Pierce Res" end
		local ability = T.name_only {
			id = "creepwars_leader",
			cumulative = false,
			name = "<b>leader</b>",
			description = "Upgrades: " .. table.concat(arr, ", ")
		}
		wesnoth.add_modification(unit, "object", {
			T.effect { apply_to = "remove_ability", T.abilities { ability } },
			T.effect { apply_to = "new_ability", T.abilities { ability } }
		})
	end
end

creepwars.set_leader_ability = set_leader_ability

-->>
