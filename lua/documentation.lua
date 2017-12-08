-- << documentation

local wesnoth = wesnoth
local creepwars_score_multiplier = creepwars_score_multiplier
local creepwars_score_power = creepwars_score_power
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier
local creepwars_gold_for_lvl0 = creepwars_gold_for_lvl0
local creepwars_gold_per_creep_level = creepwars_gold_per_creep_level
local creepwars_guard_hp_initial = creepwars_guard_hp_initial
local creepwars_guard_hp_for_kill = creepwars_guard_hp_for_kill
local creepwars_creep_count = creepwars_creep_count
local creepwars_gold_for_leaderkill_max = creepwars_gold_for_leaderkill_max
local creepwars_score_multiplier_percent = creepwars_score_multiplier_percent
local creepwars_mirror_style = creepwars_mirror_style
local creepwars_hide_leaders = creepwars_hide_leaders

local note
if wesnoth then
	note = wesnoth.get_variable("creepwars_objectives_note")
else
	note = ... -- lua arguments
end

note, _ = string.gsub(note, "#creepwars_creep_count", creepwars_creep_count)
note, _ = string.gsub(note, "#creepwars_score_multiplier", creepwars_score_multiplier)
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

	local non_standard = {}
	local guard_hp = creepwars_guard_hp_for_kill(false)
	if guard_hp ~= 1 then non_standard[#non_standard + 1] = "guard HP scaling: " .. guard_hp .. " (default 1)" end
	if creepwars_hide_leaders then
		non_standard[#non_standard + 1] = "enemy leaders hidden"
	end
	if creepwars_gold_for_lvl0 ~= 3 then
		non_standard[#non_standard + 1] = "gold for lvl0 creep: " .. creepwars_gold_for_lvl0
	end
	if creepwars_gold_per_creep_level ~= 2 then
		non_standard[#non_standard + 1] = "gold per creep level: " .. creepwars_gold_per_creep_level
	end
	if creepwars_score_multiplier_percent ~= 50 then
		non_standard[#non_standard + 1] = "creep score multiplier: " .. creepwars_score_multiplier_percent
	end
	--if  ~=  then
	--	non_standard[#non_standard + 1] =
	--end

	local non_standard_msg
	if wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10") then
		non_standard_msg = ""
	elseif #non_standard ~= 0 then
		non_standard_msg = " Beware, non-standard options are used: " .. table.concat(non_standard, ", ") .. "."
	else
		non_standard_msg = " All options are stadard."
	end

	local show_mirror_style = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10")
		and creepwars_mirror_style ~= "mirror"
	local mirror_msg = show_mirror_style and " Mirror style: " .. creepwars_mirror_style or ""
	local recent = " Recent changes: hover Leaders to see their upgrades."
	wesnoth.message("Creep Wars", "Press Ctrl J to see game rules." .. non_standard_msg .. mirror_msg .. recent)
else
	return note
end


-- >>
