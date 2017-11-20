-- << scoreboard

local wesnoth = wesnoth
local creepwars_side_to_team = creepwars_side_to_team
local creepwars_score_for_kill = creepwars_score_for_kill


wesnoth.message("Creep Wars", "Recent changes:")
wesnoth.message("Creep Wars", "1. Game reload possible. Finally!")
wesnoth.message("Creep Wars", "2. Creep spawning changed. More creep types will appear.")
--wesnoth.message("Creep Wars", "2. Creep spawning changed. See game objectives (Ctrl J) for details.")
wesnoth.message("Creep Wars", "3. Your Leader is auto-selected at turn start")
wesnoth.message("Creep Wars", "Addon name is 'Creep War Dev'. Please write feedback & ideas you have.:)")
--wesnoth.message("Creep Wars", "Please read Scenario Objectives (ctrj+j) for more details!")

--do
--	--wesnoth.wml_actions.label { x = 18, y = 3, text = "Game rules are explained in 'objectives' (Ctrl J)", color = "0,0,255" }
--	local print = { size = 50, duration = 200, text = "To see Game Rules, see objectives (Ctrl J)" }
--	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.0") then
--		print.color = "255,255,255"
--	else
--		print.red = 255
--		print.green = 255
--		print.blue = 255
--	end
--	wesnoth.wml_actions.print(print)
--end


local ugly_y_pos
if wesnoth.get_terrain(18, 5) == "Qxua^Xo" then
	ugly_y_pos = 5
else
	ugly_y_pos = 10
end

local display_creep_score
wesnoth.wml_actions.label { x = 18, y = ugly_y_pos - 1, text = "Creep strength:", color = "255,230,128" }
do
	local label_positions = {}
	label_positions[creepwars_side_to_team[1]] = { x = 17, y = 5 } -- UGLY inline HACK
	label_positions[creepwars_side_to_team[2]] = { x = 19, y = 5 } -- UGLY inline HACK

	display_creep_score = function()
		for team, pos in pairs(label_positions) do
			local creep_score = wesnoth.get_variable("creepwars_creep_score_" .. team)
			wesnoth.wml_actions.label {
				x = pos.x,
				y = ugly_y_pos,
				text = math.ceil(creep_score * 100) / 100,
				color = "255,230,128"
			}
		end
	end
end
display_creep_score()


local display_gold
wesnoth.wml_actions.label { x = 18, y = ugly_y_pos, text = "Leader gold:", color = "255,128,128" }
do
	local label_positions = {}
	label_positions[creepwars_side_to_team[1]] = { x = 17, y = 6 } -- UGLY inline HACK
	label_positions[creepwars_side_to_team[2]] = { x = 19, y = 6 } -- UGLY inline HACK
	display_gold = function()
		for team, pos in pairs(label_positions) do
			local gold = wesnoth.get_variable("creepwars_gold_" .. team)
			wesnoth.wml_actions.label { x = pos.x, y = ugly_y_pos + 1, text = gold, color = "255,128,128" }
		end
	end
end
display_gold()


local function creep_kill_event(attacker, defender)
	local team = creepwars_side_to_team[attacker.side]

	do -- creep score
		local score_previous = wesnoth.get_variable("creepwars_creep_score_" .. team)
		local score_add = creepwars_score_for_kill(defender)
		if defender.canrecruit then score_add = score_add * 2 end
		local score_new = score_previous + score_add
		local score_add_text = math.ceil(score_add * 100) / 100
		wesnoth.float_label(attacker.x, attacker.y, "<span color='#FFE680'>" .. score_add_text .. "</span>")
		wesnoth.set_variable("creepwars_creep_score_" .. team, score_new)
	end

	do -- gold
		local give_gold = creepwars_gold_per_kill(defender)
		local give_guard_hitpoints = math.ceil(give_gold / 3)
		for _, unit in ipairs(wesnoth.get_units { canrecruit = true }) do -- guard
			if creepwars_side_to_team[unit.side] == team and unit.max_moves == 0 then
				wesnoth.add_modification(unit, "object", {
					{
						"effect", {
						apply_to = "hitpoints",
						increase_total = give_guard_hitpoints,
						increase = give_guard_hitpoints
					}
					},
				})
			end
		end

		local gold_previous = wesnoth.get_variable("creepwars_gold_" .. team)
		wesnoth.set_variable("creepwars_gold_" .. team, gold_previous + give_gold)
		for _, side in ipairs(wesnoth.sides) do
			if creepwars_side_to_team[side.side] == team then
				side.gold = side.gold + give_gold
			end
		end
	end

	display_creep_score()
	display_gold()
end


creepwars_creep_kill_event = creep_kill_event

-- >>
