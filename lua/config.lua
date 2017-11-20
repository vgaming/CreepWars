-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50

creepwars_score_power = 0.6
creepwars_score_scale = 0.065
creepwars_score_start = 9

creepwars_score_for_kill = function(unit) return math.pow(unit.__cfg.cost, 0.6) * creepwars_score_scale end

creepwars_gold_per_kill = function(unit)
	local base = 5 + unit.__cfg.level * 2
	if unit.canrecruit and unit.__cfg.level > 1 then
		return base * 3
	elseif unit.canrecruit then
		return base * 2
	elseif unit.variables["creepwars_creep"] == true then
		return base
	else
		return 0
	end
end

-- >>
