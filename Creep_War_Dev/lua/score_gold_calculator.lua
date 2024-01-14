-- << score_gold_calculator | Creep_War_Dev
if rawget(_G, "score_gold_calculator | Creep_War_Dev") then
	-- TODO: remove this code once https://github.com/wesnoth/wesnoth/issues/8157 is fixed
	return
else
	rawset(_G, "score_gold_calculator | Creep_War_Dev", true)
end

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs
local wml = wml
local T = wml.tag
local is_ai_array = creepwars.is_ai_array
local side_to_team = creepwars.side_to_team
local team_array = creepwars.team_array

if creepwars.scoreboard_help_label then
	wesnoth.wml_actions.label {
		x = creepwars.scoreboard_help_label.x,
		y = creepwars.scoreboard_help_label.y,
		visible_in_fog = true,
		visible_in_shroud = true,
		text = "<span color='#FFFFFF'>Scoreboard (Ctrl j):</span>"
	}
end


local function display_stats()
	for team, _ in ipairs(team_array) do
		local creepkills = wesnoth.get_variable("creepwars_creepkills_" .. team)
		local leaderkills = wesnoth.get_variable("creepwars_leaderkills_" .. team)
		local gold = wesnoth.get_variable("creepwars_gold_" .. team)
		--local score = string.format("%.2f", wesnoth.get_variable("creepwars_score_" .. team))
		local text = ""
			.. "<span color='#FFFFFF'>" .. creepkills .. " kills</span>\n"
			.. "<span color='#FF8080'>" .. leaderkills .. " leaderkills</span>\n"
			.. "<span color='#FFE680'>" .. gold .. " gold</span>\n"
		--.. "<span color='#FFE680'>" .. score .. " creep cost</span>"  -- 4-line message doesn't work in wesnoth
		wesnoth.wml_actions.label {
			x = creepwars.scoreboard_pos[team].x,
			y = creepwars.scoreboard_pos[team].y,
			visible_in_fog = true,
			visible_in_shroud = true,
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
			note = wesnoth.get_variable("creepwars_objectives")
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

---@param team number, see `side_to_team`
---@param give_gold number
---@return void
function creepwars.increase_gold_for_team(team, give_gold)
	local gold_orig = wesnoth.get_variable("creepwars_gold_" .. team)
	wesnoth.set_variable("creepwars_gold_" .. team, gold_orig + give_gold)
	for _, side in ipairs(wesnoth.sides) do
		if side_to_team[side.side] == team and not is_ai_array[side.side] then
			side.gold = side.gold + give_gold
		end
	end
end

---@param team number, see `side_to_team`
---@param give_score number
---@return void
function creepwars.increase_score_for_team(team, give_score)
	local score = wesnoth.get_variable("creepwars_score_" .. team)
	wesnoth.set_variable("creepwars_score_" .. team, score + give_score)
end

local function unit_kill_event(attacker, defender)
	---@type number
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
	local give_score = creepwars.score_for_another_kill(creepkills + leaderkills)
	creepwars.increase_score_for_team(team, give_score)

	-- guard hp
	local guard_give_hp = (creepwars.guard_health_level_add + defender.level) / 4
	guard_give_hp = guard_give_hp * (wml.variables.lessrandom_multiplier or 1)
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do
		if side_to_team[unit.side] == team and is_ai_array[unit.side] then
			wesnoth.units.add_modification(unit, "object", {
				T.effect {
					apply_to = "hitpoints",
					increase_total = guard_give_hp,
					increase = guard_give_hp
				},
			})
		end
	end

	-- gold
	local leader_multiplier = defender.canrecruit
		and creepwars.gold_leader_multiplier
		or 1

	local guard_multiplier = defender.canrecruit and is_ai_array[defender.side]
		and creepwars.gold_guard_multiplier
		or 1

	local gold_kills = creepkills + 4 * leaderkills
	local give_gold = 0
	for i = 0, leader_multiplier * guard_multiplier - 1 do
		give_gold = give_gold + creepwars.gold_per_kill(gold_kills + i)
	end
	creepwars.increase_gold_for_team(team, give_gold)

	-- Update kill stats
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
