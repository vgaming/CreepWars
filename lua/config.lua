-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50

creepwars_score_power = 0.6
creepwars_score_scale = 0.065
creepwars_score_start = 9

creepwars_gold_for_lvl0 = 3
creepwars_gold_per_creep_level = 2

creepwars_score_for_kill = function(unit) return math.pow(unit.__cfg.cost, 0.6) * creepwars_score_scale end

creepwars_gold_for_kill = function(team_creep_score, unit)
	if unit.canrecruit == true then
		return math.floor(team_creep_score)
	else
		return creepwars_gold_for_lvl0 + unit.__cfg.level * creepwars_gold_per_creep_level
	end
end

-- >>
