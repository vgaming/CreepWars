-- << config

local math = math
local creepwars = creepwars

creepwars.lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
local lvl3plus_barrier = 50
creepwars.lvl3plus_barrier = lvl3plus_barrier

creepwars.creep_count = 8


local creepwars_expected_total_kills = 80

local gold_per_kill_start = 4
local gold_kills_to_increase = 20
local function gold_per_kill(kills) return gold_per_kill_start + math.floor(kills / gold_kills_to_increase) end
creepwars.gold_guard_multiplier = 4
creepwars.gold_leader_multiplier = 5


local creepwars_score_scale = 3
creepwars.score_start = 9
-- derived values:
local score_per_kill_min = 2 * (lvl3plus_barrier - creepwars.score_start)
	/ (creepwars_score_scale + 1)
	/ creepwars_expected_total_kills
local score_per_kill_increase = score_per_kill_min
	* (creepwars_score_scale - 1)
	/ creepwars_expected_total_kills
local function score_per_kill(kills)
	return score_per_kill_min + score_per_kill_increase * kills
end


creepwars.gold_kills_to_increase = gold_kills_to_increase
creepwars.gold_per_kill = gold_per_kill
creepwars.gold_per_kill_start = gold_per_kill_start
creepwars.score_per_kill = score_per_kill


-- >>
