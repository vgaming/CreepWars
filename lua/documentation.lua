-- << documentation

local wesnoth = wesnoth
local creepwars_score_scale = creepwars_score_scale
local creepwars_score_power = creepwars_score_power
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier


local note = wesnoth.get_variable("creepwars_objectives_note")
note, _ = string.gsub(note, "#creepwars_score_scale", creepwars_score_scale)
note, _ = string.gsub(note, "#creepwars_score_power", creepwars_score_power)
note, _ = string.gsub(note, "#creepwars_lvl0_barrier", creepwars_lvl0_barrier)
note, _ = string.gsub(note, "#creepwars_lvl3plus_barrier", creepwars_lvl3plus_barrier)
wesnoth.set_variable("creepwars_objectives_note", note)


wesnoth.message("Creep Wars", "Recent changes: more gold for creep kills, creep strength scaling +20%. Please read Scenario Objectives (ctrj+j) for more details.")

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
