-- << score_gold_calculator

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local string = string
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local is_ai_array = creepwars.is_ai_array
local score_per_kill = creepwars.score_per_kill
local side_to_team = creepwars.side_to_team
local team_array = creepwars.team_array

if creepwars.scoreboard_help_label then
	wesnoth.wml_actions.label {
		x = creepwars.scoreboard_help_label.x,
		y = creepwars.scoreboard_help_label.y,
		text = "<span color='#FFFFFF'>Scoreboard (Ctrl i):</span>"
	}
end


local function display_stats()
	for team, _ in ipairs(team_array) do
		local creepkills = wesnoth.get_variable("creepwars_creepkills_" .. team)
		local leaderkills = wesnoth.get_variable("creepwars_leaderkills_" .. team)
		local gold = wesnoth.get_variable("creepwars_gold_" .. team)
		local score = string.format("%.2f", wesnoth.get_variable("creepwars_score_" .. team))
		local text = ""
				.. "<span color='#FF8080'>" .. score .. "  " .. "</span>"
				.. "<span color='#FFE680'>" .. gold .. "</span>\n"
				.. " <span color='#FFFFFF'>"
				.. "(" .. creepkills + leaderkills .. "  "
				.. leaderkills .. ")"
				.. "</span>"
		wesnoth.wml_actions.label {
			x = creepwars.scoreboard_pos[team].x,
			y = creepwars.scoreboard_pos[team].y,
			text = text
		}
	end
end
display_stats()


local function unit_kill_event(attacker, defender)
	local team = side_to_team[attacker.side]

	local creepkills = wesnoth.get_variable("creepwars_creepkills_" .. team)
	local leaderkills = wesnoth.get_variable("creepwars_leaderkills_" .. team)

	-- score
	local score = wesnoth.get_variable("creepwars_score_" .. team)
	score = score + score_per_kill(creepkills + leaderkills)
	wesnoth.set_variable("creepwars_score_" .. team, score)

	-- guard hp
	local guard_give_hp = (creepwars.guard_health_level_add + (defender.__cfg.level or 0)) / 4
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if side_to_team[unit.side] == team and is_ai_array[unit.side] then
			wesnoth.add_modification(unit, "object", {
				T.effect {
					apply_to = "hitpoints",
					increase_total = guard_give_hp,
					increase = guard_give_hp
				},
			})
		end
	end

	-- gold
	local gold_orig = wesnoth.get_variable("creepwars_gold_" .. team)
	local gold_kills = creepkills + 4 * leaderkills

	local leader_multiplier = defender.canrecruit
		and creepwars.gold_leader_multiplier
		or 1

	local guard_multiplier = defender.canrecruit and is_ai_array[defender.side]
		and creepwars.gold_guard_multiplier
		or 1

	local external_multiplier = creepwars.gold_multiplier_func
		and creepwars.gold_multiplier_func(attacker)
		or 1

	local gold = gold_orig
	for i = 0, leader_multiplier * guard_multiplier * external_multiplier - 1 do
		gold = gold + creepwars.gold_per_kill(gold_kills + i)
	end
	wesnoth.set_variable("creepwars_gold_" .. team, gold)
	for _, side in ipairs(wesnoth.sides) do
		if side_to_team[side.side] == team then
			side.gold = side.gold + gold - gold_orig
		end
	end

	if defender.canrecruit then
		wesnoth.set_variable("creepwars_leaderkills_" .. team,
			leaderkills + guard_multiplier * external_multiplier)
	else
		wesnoth.set_variable("creepwars_creepkills_" .. team,
			creepkills + external_multiplier)
	end

	display_stats()
end


creepwars.unit_kill_event = unit_kill_event

-- >>
