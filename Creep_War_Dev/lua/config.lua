-- << config

local creepwars = creepwars

creepwars.lvl0_barrier = 12 -- creep score lower than this value will generate lvl0 creeps
--- Creep score at which units tend to become lvl3 and start getting extra bonuses
creepwars.lvl3plus_barrier = 50

creepwars.creep_count = creepwars.creep_count or 8

creepwars.gold_per_kill_start = 1
creepwars.gold_kills_to_increase = 11
creepwars.gold_per_ai_turn = 2
creepwars.gold_guard_multiplier = 4
creepwars.gold_leader_multiplier = 5

--- also known as "initial creep strength"
creepwars.score_start = 9

local desired_game_turns = 40
--- At `desired_game_turns`, the total creep strength should be `desired_end_game_creep_strength`.
local desired_end_game_creep_strength = 50
local desired_end_game_time_based_strength = 15

--- Statistically, a typical game has ~2 kills per team per turn towards end game
local statistical_average_kills_per_turn = 2.0

-- 80
local desired_kills = desired_game_turns * statistical_average_kills_per_turn

local score_for_first_kill = 0.02

--- At end of game, what should be the total score that the quadratic component gives?
local desired_score_quadratic_component = (desired_end_game_creep_strength
	- desired_end_game_time_based_strength
	- creepwars.score_start
	- desired_kills * score_for_first_kill)

--- The `desired_score_quadratic_component` should be given out gradually
--- over `desired_kills` kills.
--- In total, it is given out 1+(1+1)+(1+1+1)+...(1+1+....+1)=desired_kills*desired_kills/2 times.
--- The quick formula is total=(d*d/2)*coeff, or coeff=total*2/d/d, where by `d` we denote kills.
-- 0.007625
local score_per_kill_square_factor = desired_score_quadratic_component * (2 / desired_kills / desired_kills)

-- 0.1875
creepwars.score_per_turn = desired_end_game_time_based_strength / desired_game_turns

-- To double-check the numbers:
-- At turn 40,
-- there should be around 80 kills,
-- 9 starting strength,
-- 0.375*40 = 15 time-based strength,
-- 0.02*80 = 1.6 linear kill-based strength,
-- 0.007625*80*80/2 = 24.4 quadratic kill-based strength,
-- 9+15+1.2+29.8 = 50 total strength.

function creepwars.score_for_another_kill(kills)
	return score_for_first_kill + score_per_kill_square_factor * kills
end

-- >>
