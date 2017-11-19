-- << config

creepwars_lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
creepwars_lvl3plus_barrier = 50

creepwars_score_power = 0.6
creepwars_score_scale = 0.065
creepwars_score_start = 9

creepwars_score_for_kill = function(unit) return math.pow(unit.__cfg.cost, 0.6) * creepwars_score_scale end


-- >>
