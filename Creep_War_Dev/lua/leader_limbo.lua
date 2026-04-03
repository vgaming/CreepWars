-- << leader_limbo | Creep_War_Dev

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
	wesnoth.put_unit(unit, x, y)

	if unit.side == wesnoth.current.side then
		wesnoth.wml_actions.end_turn {}
	end
end


local function leader_restore_limbo()
	local side = wesnoth.current.side
	for _, unit in ipairs(wesnoth.get_units { canrecruit = true, side = side }) do
		if (unit.variables.limbo_turns or 0) >= 2 then
			unit.moves = 0
			unit.status.petrified = true
			unit.variables.limbo_turns = unit.variables.limbo_turns - 1
			show_limbo_text(side, "Limbo " .. unit.variables.limbo_turns)
			wesnoth.wml_actions.end_turn {}
		elseif (unit.variables.limbo_turns or 0) == 1 then
			unit.variables.limbo_turns = 0
			unit.status.petrified = false
			show_limbo_text(side, "")
            move_ai_to_shop()
		end
	end
end

local function move_ai_to_shop()
    -- if setting to ai after game start, use droid full
    if wesnoth.sides[wesnoth.current.side].controller ~= "ai" then
        return
    end
    local current_side_shops = creepwars.team_shop_array[creepwars.side_to_team[wesnoth.current.side]]
    for _, loc in ipairs(current_side_shops) do
        if not wesnoth.units.get(loc) then
            local unit = wesnoth.units.find{side=wesnoth.current.side, canrecruit=true}[1]
            -- Ideally unit should go to closest shop, not just first
            -- AI teleports to shop with single movement point, bug of wesnoth engine, but for this use case it is suitable
            wesnoth.wml_actions.do_command{
                wml.tag.move{
                    x=unit.x .. "," .. loc.x,
                    y=unit.y .. "," .. loc.y
                }
            }
            return
        end
    end
end


creepwars.leader_died_event = leader_died_event
creepwars.leader_restore_limbo = leader_restore_limbo
creepwars.move_ai_to_shop = move_ai_to_shop


-- >>
