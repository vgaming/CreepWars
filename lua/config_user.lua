-- << config_user

local wesnoth = wesnoth
local creepwars = creepwars
local array_forall = creepwars.array_forall
local show_dialog = creepwars.show_dialog


local offline_game = not wesnoth or array_forall(wesnoth.sides, function(side)
	return side.controller == "human" or side.controller == "ai" or side.controller == "null"
end)

local function ask_mirror_style()
	local options = {
		{ id = "mirror", text = "\nMirror -- Same leaders. Works on any Era.\n" },
		{ id = "manual", text = '\nRandom Downgrade -- Downgrade Leaders for this map. May be unbalanced.\n' },
		{ id = "manual_no_downgrade", text = "\nRandom -- Leave leaders as-is. May be unbalanced.\n" },
		{ id = "same_cost", text = "\nSame cost -- Random leaders of the same cost. May be unbalanced.\n" },
	}
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		options[#options + 1] = {
			text = "\nSame Strength -- Same team strength.\n"
					.. "May still be unbalanced (for example with custom unit abilities).\n",
			id = "same_strength"
		}
	end
	local result = show_dialog {
		label = "\nCreep Wars: Leaders style\n\n",
		options = options
	}
	return options[result.index].id
end

local mirror_style = wesnoth and wesnoth.get_variable("creepwars_mirror_style")
	or (wesnoth and ask_mirror_style() or "manual")


local hide_leaders
if mirror_style == "mirror" then
	hide_leaders = false
elseif wesnoth and wesnoth.get_variable("creepwars_hide_leaders") ~= nil then
	hide_leaders = wesnoth.get_variable("creepwars_hide_leaders")
else
	hide_leaders = true
end


creepwars.hide_leaders = hide_leaders
creepwars.mirror_style = mirror_style


-- >>
