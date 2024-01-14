-- << documentation | Creep_War_Dev
if rawget(_G, "documentation | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "documentation | Creep_War_Dev", true)
end

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
replace("#gold_per_ai_turn", creepwars.gold_per_ai_turn)
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

	-- Recent changes:
	wesnoth.message(
		"Creep Wars December 2023 update",
		"The game is completely re-balanced, it should be easier to make a comeback. "
			.. "A steady income 4g/turn is added, early kill bonus is nerfed."
	)
	wesnoth.message(
		"Creep Wars",
		"Press Ctrl J for details."
	)
	wesnoth.message(
		"Creep Wars",
		"If you create new CW maps, submit them to the forum! https://forums.wesnoth.org/viewtopic.php?t=47655"
	)

	local T = wml.tag
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
