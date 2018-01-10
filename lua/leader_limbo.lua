-- << leader_limbo

local wesnoth = wesnoth
local creepwars = creepwars
local ipairs = ipairs


local function show_limbo_text(side_number, text)
	local start_loc = wesnoth.get_starting_location(side_number)
	wesnoth.wml_actions.label { x = start_loc[1], y = start_loc[2], text = text }
end


local function leader_died_event(unit)
	unit.hitpoints = unit.max_hitpoints
	unit.status.poisoned = false
	unit.status.slowed = false
	unit.moves = 0
	unit.status.petrified = true
	unit.variables.limbo_turns = 2

	local start_loc = wesnoth.get_starting_location(unit.side)

	show_limbo_text(unit.side, "Limbo 2")

	local x, y = wesnoth.find_vacant_tile(start_loc[1], start_loc[2], unit)
	if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.13.10") then
		wesnoth.put_unit(unit, x, y)
	else
		wesnoth.put_unit(x, y, unit)
	end

	if unit.side == wesnoth.current.side then
		wesnoth.wml_actions.end_turn {}
	end
end


local function leader_restore_limbo()
	local side = wesnoth.current.side
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
		if (unit.variables.limbo_turns or 0) >= 2 then
			unit.moves = 0
			unit.variables.limbo_turns = unit.variables.limbo_turns - 1
			show_limbo_text(side, "Limbo " .. unit.variables.limbo_turns)
			wesnoth.wml_actions.end_turn {}
		elseif (unit.variables.limbo_turns or 0) == 1 then
			unit.variables.limbo_turns = 0
			unit.status.petrified = false
			show_limbo_text(side, "")
		end
	end
end


creepwars.leader_died_event = leader_died_event
creepwars.leader_restore_limbo = leader_restore_limbo


-- >>
