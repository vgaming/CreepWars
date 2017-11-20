-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50

creepwars_score_power = 0.6
creepwars_score_scale = 0.065
creepwars_score_start = 9

creepwars_score_for_kill = function(unit) return math.pow(unit.__cfg.cost, 0.6) * creepwars_score_scale end

creepwars_gold_per_kill = function(unit)
	if unit.canrecruit then
		return 20 + unit.__cfg.level * 5
	elseif unit.variables["creepwars_creep"] == true then
		return 5 + unit.__cfg.level * 2
	else
		return 0
	end
end

-- >>
