-- << parse_user_options

local wesnoth = wesnoth
local creepwars = creepwars
local math = math


-- ugly hack to support wesnoth-1.12
-- (it cannot work with multiple scenarios defining same option id-s)
local scenario_suffix = wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0")
	and ""
	or wesnoth.game_config.mp_settings.mp_scenario


local mirror_style = wesnoth.get_variable("creepwars_mirror_style" .. scenario_suffix) or "manual"


local forbid_berserkers = wesnoth.get_variable("creepwars_forbid_berserkers" .. scenario_suffix) or false


local reveal_leaders
if mirror_style == "mirror" then
	reveal_leaders = true
else
	reveal_leaders = wesnoth.get_variable("creepwars_reveal_leaders" .. scenario_suffix) or true
end


local guard_health_percentage = wesnoth.get_variable("creepwars_guard_health" .. scenario_suffix) or 100
local guard_health_level_add = guard_health_percentage / 25


local gold_multiplier_percent = wesnoth.get_variable("creepwars_gold_multiplier" .. scenario_suffix) or 100
local function gold_per_kill(kills)
	local default = creepwars.gold_per_kill_start + math.floor(kills / creepwars.gold_kills_to_increase)
	return math.floor((default * gold_multiplier_percent + 50) / 100)
end


creepwars.forbid_berserkers = forbid_berserkers
creepwars.gold_multiplier_percent = gold_multiplier_percent
creepwars.gold_per_kill = gold_per_kill
creepwars.guard_health_level_add = guard_health_level_add
creepwars.guard_health_percentage = guard_health_percentage
creepwars.mirror_style = mirror_style
creepwars.reveal_leaders = reveal_leaders


-- >>
