-- << documentation

local wesnoth = wesnoth
local creepwars = creepwars
local assert = assert
local string = string
local lvl0_barrier = creepwars.lvl0_barrier
local gold_kills_to_increase = creepwars.gold_kills_to_increase
local gold_per_kill_start = creepwars.gold_per_kill_start

local note
if wesnoth then
	note = wesnoth.get_variable("creepwars_game_rules")
else
	note = ... -- lua arguments
end

local function replace(str, replacement)
	note = string.gsub(note, str, replacement)
end

replace("#lvl0_barrier", lvl0_barrier)
replace("#lvl3plus_barrier", creepwars.lvl3plus_barrier)
replace("#gold_start_p0", gold_per_kill_start)
replace("#gold_start_p1", gold_per_kill_start + 1)
replace("#gold_start_p2", gold_per_kill_start + 2)
replace("#gold_guard_multiplier", creepwars.gold_guard_multiplier)
replace("#gold_kills_to_increase", gold_kills_to_increase)

local _, check = string.gsub(note, "[^']#[^w]", "")
assert(check == 0, "Unhandled variable")

if wesnoth then
	replace("''", '"')
	wesnoth.set_variable("creepwars_game_rules", note)

	wesnoth.wml_actions.label {
		x = creepwars.mirror_style_label_pos.x,
		y = creepwars.mirror_style_label_pos.y,
		text = "<span color='#FFFFFF'>Mirror style: " .. creepwars.mirror_style .. "</span>"
	}

	local recent = "Recent changes: slight weapon price changes."
	wesnoth.message("Creep Wars", "Press Ctrl J to see game rules. " .. recent)

	local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
	local objectives = ""
		.. wesnoth.get_variable("creepwars_about") .. "\n"
		.. note .. "\n"
		.. wesnoth.get_variable("creepwars_contacts") .. "\n"
		.. wesnoth.get_variable("creepwars_changelog")
	wesnoth.set_variable("creepwars_objectives", objectives)
	wesnoth.wml_actions.objectives {
		silent = creepwars.is_cli_game,
		T.objective {
			description = "Kill enemy guard",
			condition = "win",
		},
		T.objective {
			description = "Death of your own guard",
			condition = "lose",
		},
		note = objectives
	}
else
	return note
end


-- >>
