-- << legacy_leader_variables

local wesnoth = wesnoth
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}

local function setup(side_number, limbo_x, limbo_y, home_x, home_y)
	for _, unit in ipairs(wesnoth.get_units { side = side_number, canrecruit = true }) do

		unit.variables.location = "limbo"
		unit.variables.limbo_x = limbo_x
		unit.variables.limbo_y = limbo_y
		unit.variables.home_x = home_x
		unit.variables.home_y = home_y

		unit.variables.creepwars_res_arcane = 0
		unit.variables.creepwars_res_blade = 0
		unit.variables.creepwars_res_cold = 0
		unit.variables.creepwars_res_fire = 0
		unit.variables.creepwars_res_impact = 0
		unit.variables.creepwars_res_pierce = 0
		unit.variables.base_hp = unit.max_hitpoints
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
end

setup(1, 4, 2, 11, 9)
setup(2, 28, 2, 25, 12)
setup(3, 6, 2, 11, 11)
setup(5, 30, 2, 25, 10)
setup(6, 8, 2, 11, 12)
setup(7, 32, 2, 25, 9)


-- >>
