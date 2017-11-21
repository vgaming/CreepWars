-- << documentation

local creepwars_score_scale = creepwars_score_scale
local creepwars_score_power = creepwars_score_power
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier
local creepwars_gold_for_lvl0 = creepwars_gold_for_lvl0
local creepwars_gold_per_creep_level = creepwars_gold_per_creep_level
local creepwars_guard_hp_initial = creepwars_guard_hp_initial
local creepwars_guard_hp_for_kill = creepwars_guard_hp_for_kill
local creepwars_creep_count = creepwars_creep_count
local creepwars_gold_for_leaderkill_max = creepwars_gold_for_leaderkill_max

local note
if wesnoth then
	note = wesnoth.get_variable("creepwars_objectives_note")
else
	note = external_documentation_note
end

note, _ = string.gsub(note, "#creepwars_creep_count", creepwars_creep_count)
note, _ = string.gsub(note, "#creepwars_score_scale", creepwars_score_scale)
note, _ = string.gsub(note, "#creepwars_score_power", creepwars_score_power)
note, _ = string.gsub(note, "#creepwars_lvl0_barrier", creepwars_lvl0_barrier)
note, _ = string.gsub(note, "#creepwars_lvl3plus_barrier", creepwars_lvl3plus_barrier)
note, _ = string.gsub(note, "#creepwars_gold_for_lvl0", creepwars_gold_for_lvl0)
note, _ = string.gsub(note, "#creepwars_gold_per_creep_level", creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#lvl0g", creepwars_gold_for_lvl0 + 0 * creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#lvl1g", creepwars_gold_for_lvl0 + 1 * creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#lvl2g", creepwars_gold_for_lvl0 + 2 * creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#lvl3g", creepwars_gold_for_lvl0 + 3 * creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#lvl4g", creepwars_gold_for_lvl0 + 4 * creepwars_gold_per_creep_level)
note, _ = string.gsub(note, "#creepwars_gold_for_leaderkill_max", creepwars_gold_for_leaderkill_max)
note, _ = string.gsub(note, "#creepwars_guard_hp_initial", creepwars_guard_hp_initial)
note, _ = string.gsub(note, "#guard_creep_hp", creepwars_guard_hp_for_kill(false))
note, _ = string.gsub(note, "#guard_leader_hp", creepwars_guard_hp_for_kill(true))

if wesnoth then
	wesnoth.set_variable("creepwars_objectives_note", note)
	wesnoth.message("Creep Wars", "Recent changes: gold bonus re-designed, creep strength scaling +20%. Please read Scenario Objectives ( Ctrj+J ) !")
else
	external_documentation_note = note
end

--do
--	--wesnoth.wml_actions.label { x = 18, y = 3, text = "Game rules are explained in 'objectives' (Ctrl J)", color = "0,0,255" }
--	local print = { size = 40, duration = 200, text = "To see Game Rules, see objectives (Ctrl J)" }
--	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0") then
--		print.color = "255,255,255"
--	else
--		print.red = 255
--		print.green = 255
--		print.blue = 255
--	end
--	wesnoth.wml_actions.print(print)
--end


-- >>
