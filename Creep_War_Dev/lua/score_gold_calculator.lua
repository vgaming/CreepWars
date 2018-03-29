-- << score_gold_calculator

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local string = string
local tostring = tostring
local T = wesnoth.require("lua/helper.lua").set_wml_tag_metatable {}
local is_ai_array = creepwars.is_ai_array
local score_per_kill = creepwars.score_per_kill
local side_to_team = creepwars.side_to_team
local team_array = creepwars.team_array

if creepwars.scoreboard_help_label then
	wesnoth.wml_actions.label {
		x = creepwars.scoreboard_help_label.x,
		y = creepwars.scoreboard_help_label.y,
		text = "<span color='#FFFFFF'>Scoreboard (Ctrl j):</span>"
	}
end


local function info_message()
	local msg = ""
		.. "Mirror style : " .. creepwars.mirror_style .. "\n"
		.. "Over-powered leaders : " .. (creepwars.allow_overpowered and "allowed" or "forbidden") .. "\n"
		.. "Gold multiplier : " .. creepwars.gold_multiplier_percent .. "%\n"
		.. "Guard health : " .. creepwars.guard_health_percentage .. "%\n"
		.. "Reveal leaders : " .. tostring(creepwars.reveal_leaders) .. ""

	for team, team_sides in ipairs(creepwars.team_array) do
		local creepkills = wesnoth.get_variable("creepwars_creepkills_" .. team)
		local leaderkills = wesnoth.get_variable("creepwars_leaderkills_" .. team)
		local gold = wesnoth.get_variable("creepwars_gold_" .. team)
		local score = string.format("%.2f", wesnoth.get_variable("creepwars_score_" .. team))
		local text = "\n" .. wesnoth.sides[team_sides[1]].user_team_name
			.. ": <span color='#FF8080'>" .. score .. " score</span>, "
			.. "<span color='#FFE680'>" .. gold .. " gold</span>"
			.. "<span color='#FFFFFF'>, " .. creepkills + leaderkills .. " total kills, "
			.. leaderkills .. " leader kills."
			.. "</span>"
		msg = msg .. text
	end
	return msg .. "\n\n"
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
				.. "</span>\n"
		wesnoth.wml_actions.label {
			x = creepwars.scoreboard_pos[team].x,
			y = creepwars.scoreboard_pos[team].y,
			text = text
		}
		wesnoth.wml_actions.objectives {
			silent = true,
			T.objective {
				description = "Kill enemy guard",
				condition = "win",
			},
			T.objective {
				description = "Death of your own guard",
				condition = "lose",
			},
			note = "<span size='x-large' underline='low'>This game statistics</span>\n"
				.. info_message()
				.. wesnoth.get_variable("creepwars_objectives") .. "\n"
		}

	end
end
wesnoth.wml_actions.event {
	name = "start",
	T.lua { code = "creepwars.display_stats()" }
}


local function get_opposite_team(team)
	local result_team = {}
	for _, side in ipairs(wesnoth.sides) do
		if side_to_team[side.side] ~= team
			and side_to_team[side.side] ~= result_team[#result_team] then
			result_team[#result_team + 1] = side_to_team[side.side]
		end
	end
	if #result_team ~= 1 then
		return nil
	else
		return result_team[1]
	end
end


local function unit_kill_event(attacker, defender)
	local team = attacker and side_to_team[attacker.side] or get_opposite_team(side_to_team[defender.side])
	if team == nil then
		local msg = "Warning: Unit died without attacker. This is unexpected. " ..
			"No creep score or gold bonus will be generated. " ..
			"This is probably because of a conflicting addon/modification. " ..
			"If the host has no modifications, please report the issue."
		print(msg)
		wesnoth.message("Creep Wars", msg)
		return
	end

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

	local gold = gold_orig
	for i = 0, leader_multiplier * guard_multiplier - 1 do
		gold = gold + creepwars.gold_per_kill(gold_kills + i)
	end
	wesnoth.set_variable("creepwars_gold_" .. team, gold)
	for _, side in ipairs(wesnoth.sides) do
		if side_to_team[side.side] == team then
			side.gold = side.gold + gold - gold_orig
		end
	end

	if defender.canrecruit then
		wesnoth.set_variable("creepwars_leaderkills_" .. team, leaderkills + guard_multiplier)
	else
		wesnoth.set_variable("creepwars_creepkills_" .. team, creepkills + 1)
	end

	display_stats()
end


creepwars.unit_kill_event = unit_kill_event
creepwars.display_stats = display_stats

-- >>
