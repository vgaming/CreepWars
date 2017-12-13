-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50
creepwars_creep_lvl_max = 3

creepwars_creep_count = 8

creepwars_default_era_creeps = wesnoth and wesnoth.get_variable("creepwars_default_era_creeps") or false

creepwars_mirror_style = wesnoth and wesnoth.get_variable("creepwars_mirror_style")
	or wesnoth and wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") and "same_strength"
	or "manual"
creepwars_hide_leaders = wesnoth and wesnoth.get_variable("creepwars_hide_leaders") and creepwars_mirror_style ~= "mirror"
	or wesnoth and wesnoth.compare_versions(wesnoth.game_config.version, "<", "1.13.10")

creepwars_guard_hp_for_creep = wesnoth and wesnoth.get_variable("creepwars_guard_hp_for_creep") or 1

creepwars_guard_hp_initial = 50 -- cannot be changed, yet
creepwars_guard_hp_for_kill = function(is_leader) return creepwars_guard_hp_for_creep * (is_leader and 3 or 1) end

creepwars_score_power = 0.6
creepwars_score_multiplier_percent = wesnoth and wesnoth.get_variable("creepwars_score_multiplier_percent") or 50
creepwars_score_multiplier = 0.0013 * creepwars_score_multiplier_percent
local creepwars_score_multiplier = creepwars_score_multiplier
creepwars_score_start = 9
creepwars_score_for_leader_kill = function(unit)
	return math.pow(wesnoth.unit_types[unit.type].cost, 0.6) * creepwars_score_multiplier * 2
end
creepwars_score_for_creep_kill = function(unit)
	return math.pow(wesnoth.unit_types[unit.type].cost, 0.6) * creepwars_score_multiplier
end

creepwars_gold_for_lvl0 = wesnoth and wesnoth.get_variable("creepwars_gold_for_lvl0") or 3
creepwars_gold_per_creep_level = wesnoth and wesnoth.get_variable("creepwars_gold_per_creep_level") or 2
creepwars_gold_for_leaderkill_max = 3 * (creepwars_gold_for_lvl0 + creepwars_creep_lvl_max * creepwars_gold_per_creep_level)
creepwars_gold_for_creep_kill = function(unit)
	return creepwars_gold_for_lvl0 + wesnoth.unit_types[unit.type].level * creepwars_gold_per_creep_level
end

creepwars_color_score_rgb = "255,128,128"
creepwars_color_score_hex = "#FF8080"
creepwars_color_gold_rgb = "255,230,128"
creepwars_color_gold_hex = "#FFE680"
local creepwars_color_gold_hex = creepwars_color_gold_hex
local creepwars_color_score_hex = creepwars_color_score_hex
creepwars_color_span_gold = function(text)
	return "<span color='" .. creepwars_color_gold_hex .. "'>" .. text .. "</span>"
end
creepwars_color_span_score = function(text)
	return "<span color='" .. creepwars_color_score_hex .. "'>" .. text .. "</span>"
end

-- >>
