-- << documentation

local wesnoth = wesnoth
local creepwars = creepwars
local math = math
local string = string
local creepwars_creep_count = creepwars_creep_count
local creepwars_guard_hp_for_kill = creepwars_guard_hp_for_kill
local creepwars_guard_hp_initial = creepwars_guard_hp_initial
local hide_leaders = creepwars.hide_leaders
local creepwars_lvl0_barrier = creepwars_lvl0_barrier
local creepwars_lvl3plus_barrier = creepwars_lvl3plus_barrier
local mirror_style = creepwars.mirror_style
local creepwars_score_per_kill_increase = creepwars_score_per_kill_increase
local creepwars_score_per_kill_min = creepwars_score_per_kill_min
local creepwars_score_start = creepwars_score_start
local gold_kills_to_increase = creepwars.gold_kills_to_increase
local gold_per_kill_start = creepwars.gold_per_kill_start

local note
if wesnoth then
	note = wesnoth.get_variable("creepwars_about")
else
	note = ... -- lua arguments
end

local function score_sum(count)
	return creepwars_score_start
		+ count * creepwars_score_per_kill_min
		+ count * (count - 1) * creepwars_score_per_kill_increase / 2
end

local function gold_sum(count)
	local result = count * gold_per_kill_start
	for i = 0, count - 1 do result = result + math.floor(i / gold_kills_to_increase) end
	return result
end

local function replace(str, replacement)
	note = string.gsub(note, str, replacement)
end

replace("#creepwars_creep_count", creepwars_creep_count)
replace("#creepwars_lvl0_barrier", creepwars_lvl0_barrier)
replace("#creepwars_lvl3plus_barrier", creepwars_lvl3plus_barrier)
replace("#gold_start_p0", gold_per_kill_start)
replace("#gold_start_p1", gold_per_kill_start + 1)
replace("#gold_start_p2", gold_per_kill_start + 2)
replace("#gold_kills_to_increase", gold_kills_to_increase)
replace("#creepwars_score_start", creepwars_score_start)
replace("#creepwars_guard_hp_initial", creepwars_guard_hp_initial)
replace("#guard_creep_hp", creepwars_guard_hp_for_kill(false))
replace("#guard_leader_hp", creepwars_guard_hp_for_kill(true))

local _, check = string.gsub(note, "[^']#[^w]", "")
assert(check == 0, "Unhandled variable")

if wesnoth then
	wesnoth.set_variable("creepwars_about", note)

	local non_standard = {}
	local guard_hp = creepwars_guard_hp_for_kill(false)
	if guard_hp ~= 1 then non_standard[#non_standard + 1] = "guard HP scaling: " .. guard_hp .. " (default 1)" end
	if hide_leaders then
		non_standard[#non_standard + 1] = "enemy leaders hidden"
	end

	local non_standard_msg
	if wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10") then
		non_standard_msg = ""
	elseif #non_standard ~= 0 then
		non_standard_msg = " Beware, non-standard options are used: " .. table.concat(non_standard, ", ") .. "."
	else
		non_standard_msg = " All options are stadard."
	end

	local show_mirror_style = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10")
		and mirror_style ~= "mirror"
	local mirror_msg = show_mirror_style and " Mirror style: " .. mirror_style .. "." or ""
	local recent = " Recent changes: COMPLETE re-balancing of gold&score."
	wesnoth.message("Creep Wars", "Press Ctrl J to see game rules." .. non_standard_msg .. mirror_msg .. recent)
else
	return note
end


-- >>
