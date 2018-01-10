-- << init_leader_variables

local wesnoth = wesnoth
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}

for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do

	unit.variables.creepwars_res_arcane = 0
	unit.variables.creepwars_res_blade = 0
	unit.variables.creepwars_res_cold = 0
	unit.variables.creepwars_res_fire = 0
	unit.variables.creepwars_res_impact = 0
	unit.variables.creepwars_res_pierce = 0
	unit.variables.creepwars_base_hp = unit.max_hitpoints
	unit.variables.creepwars_health_small = 0
	unit.variables.creepwars_health_big = 0
	unit.variables.creepwars_mp = 0
	unit.variables.creepwars_melee_damage = 0
	unit.variables.creepwars_melee_strikes = 0
	unit.variables.creepwars_ranged_damage = 0
	unit.variables.creepwars_ranged_strikes = 0
	unit.variables.creepwars_damage = 0
	unit.variables.creepwars_strikes = 0
	unit.variables.creepwars_armor_ldc = 0
	unit.variables.creepwars_armor_hdc = 0
	unit.variables.creepwars_armor_hhc = 0
	unit.variables.creepwars_armor_smr = 0
	unit.variables.creepwars_armor_eb = 0
	unit.variables.creepwars_armor_pg = 0

	local ability = T.name_only { id = "creepwars_leader" }
	wesnoth.add_modification(unit, "object", {
		T.effect { apply_to = "remove_ability", T.abilities { ability } },
		T.effect { apply_to = "new_ability", T.abilities { ability } }
	})

end


-- >>
