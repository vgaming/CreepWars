--<< leader_ability

local wesnoth = wesnoth
local helper = wesnoth.require "lua/helper.lua"

local side = wesnoth.get_variable("side_number")
for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
	local inventory = helper.get_child(wesnoth.get_variable("cw_inventory"), tostring(side))
	local items = helper.get_child(inventory, "item")
	local msg = {}
	if items.lhu > 0 then msg[#msg + 1] = items.lhu .. " HP bottle" end
	if items.shu > 0 then msg[#msg + 1] = items.shu .. " hp bottle" end
	if items.mvu > 0 then msg[#msg + 1] = items.mvu .. " MP" end
	if items.mdu > 0 then msg[#msg + 1] = items.mdu .. " melee dmg" end
	if items.msu > 0 then msg[#msg + 1] = items.msu .. " melee strikes" end
	if items.rdu > 0 then msg[#msg + 1] = items.rdu .. " range dmg" end
	if items.rsu > 0 then msg[#msg + 1] = items.rsu .. " range strikes" end
	if items.cdu > 0 then msg[#msg + 1] = items.cdu .. " combo dmg" end
	if items.csu > 0 then msg[#msg + 1] = items.csu .. " combo strikes" end
	if items.ldc > 0 then msg[#msg + 1] = "Light Dwarven Cuirass" end
	if items.hdc > 0 then msg[#msg + 1] = "Heavy Dwarven Cuirass" end
	if items.hhc > 0 then msg[#msg + 1] = "Heavy Human Cuirass" end
	if items.smr > 0 then msg[#msg + 1] = "Silver Mage Robe" end
	if items.exb > 0 then msg[#msg + 1] = "Elven Boots" end
	if items.axb > 0 then msg[#msg + 1] = "Armoured Boots" end
	if items.rba > 0 then msg[#msg + 1] = items.rba .. "0% Arcane Res" end
	if items.rbb > 0 then msg[#msg + 1] = items.rbb .. "0% Blade Res" end
	if items.rbc > 0 then msg[#msg + 1] = items.rbc .. "0% Cold Res" end
	if items.rbf > 0 then msg[#msg + 1] = items.rbf .. "0% Fire Res" end
	if items.rbi > 0 then msg[#msg + 1] = items.rbi .. "0% Impact Res" end
	if items.rbp > 0 then msg[#msg + 1] = items.rbp .. "0% Pierce Res" end
	local ability = T.name_only {
		id = "creepwars_leader",
		cumulative = false,
		name = "leader",
		description = "<b>Upgrades:</b> " .. table.concat(msg, ", ")
	}
	wesnoth.add_modification(unit, "object", {
		T.effect { apply_to = "new_ability", T.abilities { ability } }
	})
end

-->>
