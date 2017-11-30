-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50
creepwars_creep_lvl_max = 3

creepwars_creep_count = 8

creepwars_mirror_style = wesnoth and wesnoth.get_variable("creepwars_mirror_style") or "mirror"
creepwars_hide_leaders = wesnoth and wesnoth.get_variable("creepwars_hide_leaders") and
	creepwars_mirror_style ~= "mirror"

creepwars_guard_hp_for_creep = wesnoth and wesnoth.get_variable("creepwars_guard_hp_for_creep") or 1

creepwars_guard_hp_initial = 50 -- cannot be changed, yet
creepwars_guard_hp_for_kill = function(is_leader) return creepwars_guard_hp_for_creep * (is_leader and 3 or 1) end

creepwars_score_power = 0.6
creepwars_score_multiplier_percent = wesnoth and wesnoth.get_variable("creepwars_score_multiplier_percent") or 50
creepwars_score_multiplier = 0.0013 * creepwars_score_multiplier_percent
creepwars_score_start = 9
creepwars_score_for_kill = function(unit) return math.pow(unit.__cfg.cost, 0.6) * creepwars_score_multiplier end

creepwars_gold_for_lvl0 = wesnoth and wesnoth.get_variable("creepwars_gold_for_lvl0") or 3
creepwars_gold_per_creep_level = wesnoth and wesnoth.get_variable("creepwars_gold_per_creep_level") or 2
creepwars_gold_for_leaderkill_max = 3 * (creepwars_gold_for_lvl0 + creepwars_creep_lvl_max * creepwars_gold_per_creep_level)
creepwars_gold_for_kill = function(team_creep_score, unit)
	if unit.canrecruit == true then
		return math.min(math.floor(team_creep_score), creepwars_gold_for_leaderkill_max)
	else
		return creepwars_gold_for_lvl0 + unit.__cfg.level * creepwars_gold_per_creep_level
	end
end

-- >>
