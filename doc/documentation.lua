-- << documentation

local wesnoth = wesnoth
local creepwars = creepwars
local assert = assert
local string = string
local creepwars_creep_count = creepwars_creep_count
local creepwars_guard_hp_for_kill = creepwars_guard_hp_for_kill
local creepwars_guard_hp_initial = creepwars_guard_hp_initial
local lvl0_barrier = creepwars.lvl0_barrier
local creepwars_score_start = creepwars_score_start
local gold_kills_to_increase = creepwars.gold_kills_to_increase
local gold_per_kill_start = creepwars.gold_per_kill_start

local note
if wesnoth then
	note = wesnoth.get_variable("creepwars_about")
else
	note = ... -- lua arguments
end

local function replace(str, replacement)
	note = string.gsub(note, str, replacement)
end

replace("#creepwars_creep_count", creepwars_creep_count)
replace("#lvl0_barrier", lvl0_barrier)
replace("#lvl3plus_barrier", creepwars.lvl3plus_barrier)
replace("#gold_start_p0", gold_per_kill_start)
replace("#gold_start_p1", gold_per_kill_start + 1)
replace("#gold_start_p2", gold_per_kill_start + 2)
replace("#guard_gold_multiplier", creepwars.guard_gold_multiplier)
replace("#gold_kills_to_increase", gold_kills_to_increase)
replace("#creepwars_score_start", creepwars_score_start)
replace("#creepwars_guard_hp_initial", creepwars_guard_hp_initial)
replace("#guard_creep_hp", creepwars_guard_hp_for_kill(false))
replace("#guard_leader_hp", creepwars_guard_hp_for_kill(true))

local _, check = string.gsub(note, "[^']#[^w]", "")
assert(check == 0, "Unhandled variable")

if wesnoth then
	replace("''", '"')
	wesnoth.set_variable("creepwars_about", note)

	wesnoth.wml_actions.label {
		x = creepwars.mirror_style_label_pos.x,
		y = creepwars.mirror_style_label_pos.y,
		text = "<span color='#FFFFFF'>Mirror style: " .. creepwars.mirror_style .. "</span>"
	}

	local recent = "Recent changes: Mirror mode now has shifted Leader types (thanks to mmmax for suggestion)."
	wesnoth.message("Creep Wars", "Press Ctrl J to see game rules. " .. recent)
else
	return note
end


-- >>
