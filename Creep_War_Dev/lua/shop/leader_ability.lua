--<< leader_ability | Creep_War_Dev
if rawget(_G, "leader_ability | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "leader_ability | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local T = wml.tag
local table = table

local function set_leader_ability(unit)
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
	if vars.creepwars_res_arcane > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_arcane .. "% Arcane vuln" end
	if vars.creepwars_res_blade > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_blade .. "% Blade vuln" end
	if vars.creepwars_res_cold > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_cold .. "% Cold vuln" end
	if vars.creepwars_res_fire > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_fire .. "% Fire vuln" end
	if vars.creepwars_res_impact > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_impact .. "% Impact vuln" end
	if vars.creepwars_res_pierce > 0 then arr[#arr + 1] = "-" .. vars.creepwars_respercent_pierce .. "% Pierce vuln" end
	if unit.level < 1 then arr[#arr + 1] = "ZoC" end
	local ability = T.name_only {
		id = "creepwars_leader",
		cumulative = false,
		name = "<b>leader</b>",
		description = "Upgrades: " .. table.concat(arr, ", ")
	}
	wesnoth.units.add_modification(unit, "object", {
		id = "creepwars_leader_zoc",
		T.effect { apply_to = "zoc", value = true },
	})
	wesnoth.units.add_modification(unit, "object", {
		T.effect { apply_to = "remove_ability", T.abilities { ability } },
		T.effect { apply_to = "new_ability", T.abilities { ability } }
	})
end

creepwars.set_leader_ability = set_leader_ability

-->>
