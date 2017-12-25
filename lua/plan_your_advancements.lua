-- << plan_your_advancements

local wesnoth = wesnoth
local creepwars = creepwars
local string = string
local array_map = creepwars.array_map
local show_dialog = creepwars.show_dialog
local split_comma = creepwars.split_comma

local advancement_menu = function(unit)
	local advances = wesnoth.unit_types[unit.type].__cfg.advances_to
	return string.match(advances, ",")
end

local function choose_upgrades()
	local x1 = wesnoth.get_variable("x1") or 0
	local y1 = wesnoth.get_variable("y1") or 0
	local unit = wesnoth.get_unit(x1, y1)
	local advances_to = split_comma(wesnoth.unit_types[unit.type].__cfg.advances_to)
	local options = array_map(advances_to, function(adv)
		local ut = wesnoth.unit_types[adv]
		return { text = ut.name, image = ut.__cfg.image }
	end)
	local result = show_dialog { label = "Choose advancement \n(OK=confirm, Cancel=reset to default)\n", options = options }
	if result.is_ok then
		unit.advances_to = { advances_to[result.index] }
	else
		unit.advances_to = advances_to
	end
end


creepwars_advancement_menu = advancement_menu
creepwars.choose_upgrades = choose_upgrades

-- >>
