-- << pick_your_advancements

local wesnoth = wesnoth
local creepwars = creepwars
local tostring = tostring
local array_map = creepwars.array_map
local show_dialog = creepwars.show_dialog
local split_comma = creepwars.split_comma

local function advance_array(unit_type)
	local raw = split_comma(wesnoth.unit_types[unit_type].__cfg.advances_to)
	return array_map(raw, function(adv)
		return wesnoth.unit_types[adv] and adv
	end)
end

local unit_can_advance = function(unit)
	return #advance_array(unit.type) > 1
end

local function pick_advancement_menu()
	local x1 = wesnoth.get_variable("x1") or 0
	local y1 = wesnoth.get_variable("y1") or 0
	local unit = wesnoth.get_unit(x1, y1)
	local advances_to = advance_array(unit.type)
	local options = array_map(advances_to, function(adv)
		local ut = wesnoth.unit_types[adv]
		return { text = tostring(ut.name), image = ut.__cfg.image }
	end)
	local result = show_dialog {
		label = "Choose advancement \n(OK=confirm, Cancel=reset to default)\n",
		options = options
	}
	if result.is_ok then
		unit.advances_to = { advances_to[result.index] }
	else
		unit.advances_to = advances_to
	end
	print("set advances_to to", creepwars.format(unit.advances_to))
end


creepwars_unit_can_advance = unit_can_advance
creepwars.pick_advancement_menu = pick_advancement_menu

-- >>
