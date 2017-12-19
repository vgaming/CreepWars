-- << config

local wesnoth = wesnoth
local math = math
local creepwars = creepwars

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50
creepwars_creep_lvl_max = 3

creepwars_creep_count = 8

creepwars_default_era_creeps = wesnoth and wesnoth.get_variable("creepwars_default_era_creeps") or false

local mirror_style = wesnoth and wesnoth.get_variable("creepwars_mirror_style")
	or wesnoth and wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") and "same_strength"
	or "manual"
creepwars_hide_leaders = wesnoth and wesnoth.get_variable("creepwars_hide_leaders") and mirror_style ~= "mirror"
	or wesnoth and wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10")

local guard_hp_for_creep = wesnoth and wesnoth.get_variable("creepwars_guard_hp_for_creep") or 1

creepwars_guard_hp_initial = 50
creepwars_guard_hp_for_kill = function(is_leader) return guard_hp_for_creep * (is_leader and 3 or 1) end


local creepwars_expected_total_kills = 80

local gold_per_kill_start = 3
local gold_kills_to_increase = 20
local function gold_per_kill(kills) return gold_per_kill_start + math.floor(kills / gold_kills_to_increase) end

local creepwars_score_scale = 3
creepwars_score_start = 9
-- derived values:
creepwars_score_per_kill_min = 2 * (creepwars_lvl3plus_barrier - creepwars_score_start)
	/ (creepwars_score_scale + 1)
	/ creepwars_expected_total_kills
creepwars_score_per_kill_increase = creepwars_score_per_kill_min * (creepwars_score_scale - 1) / creepwars_expected_total_kills
local function score_per_kill(kills) return creepwars_score_per_kill_min + creepwars_score_per_kill_increase * kills end


creepwars.gold_kills_to_increase = gold_kills_to_increase
creepwars.gold_per_kill = gold_per_kill
creepwars.gold_per_kill_start = gold_per_kill_start
creepwars.mirror_style = mirror_style
creepwars.score_per_kill = score_per_kill


-- >>
